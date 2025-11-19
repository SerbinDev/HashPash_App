#include "EncryptFile.h"
#include <QFile>
#include <openssl/aes.h>
#include <openssl/rand.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/sha.h>
#include <vector>
#include <QByteArray>
#include <QString>
#include <iostream>
#include <QFileInfo>
#include "backend/StandardTemplate.h"
#include <QDir>
#include <QThreadPool>
#include <QtConcurrent>
EncryptFile::EncryptFile(QObject *parent) : QObject(parent)
{
}

void EncryptFile::logErrors() {
    ERR_print_errors_fp(stderr);
}

void EncryptFile::encryptFile(const QString &filePath)
{
    qDebug() << filePath;
    QString correctedFilePath = filePath;
    if (correctedFilePath.startsWith("file:///")) {
        correctedFilePath = correctedFilePath.remove(0, 7);
    }

    qDebug() << "[DEBUG] corrected file path: " << correctedFilePath;

    QByteArray fileData = convertFileToBinary(correctedFilePath);
    if (!fileData.isEmpty()) {
        qDebug() << "File successfully converted to binary";

        QByteArray key = generateRandomAESKey(16);
        encryptedData = encryptAES(fileData, key , filePath);
        // qDebug() << "[DEBUG] fileData: " << fileData;

        if (!encryptedData.isEmpty()) {
            qDebug() << "[DEBUG] File successfully encrypted";

            emit fileEncrypted(correctedFilePath);
        } else {
            qDebug() << "[ERROR] Failed to encrypt file";
        }
    } else {
        qDebug() << "[ERROR] Failed to convert file to binary";
    }
}

QString EncryptFile::encryptRSA(const QString &filePath, const QString &publicKey)
{


    this->filePath = filePath;
    encryptFile(filePath);

    QByteArray keyData = publicKey.toUtf8();
    BIO *bio = BIO_new_mem_buf(keyData.data(), -1);
    EVP_PKEY *evpPublicKey = PEM_read_bio_PUBKEY(bio, nullptr, nullptr, nullptr);
    BIO_free(bio);

    if (!evpPublicKey) {
        std::cerr << "Error reading public key" << std::endl;
        logErrors();
        return "";
    }

    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(evpPublicKey, nullptr);
    if (!ctx) {
        std::cerr << "Error creating context" << std::endl;
        logErrors();
        EVP_PKEY_free(evpPublicKey);
        return "";
    }

    if (EVP_PKEY_encrypt_init(ctx) <= 0) {
        std::cerr << "Error initializing encryption" << std::endl;
        logErrors();
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(evpPublicKey);
        return "";
    }

    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0) {
        std::cerr << "Error setting padding" << std::endl;
        logErrors();
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(evpPublicKey);
        return "";
    }

    QByteArray messageBytes = encryptedData;
    size_t messageSize = messageBytes.size();
    std::vector<unsigned char> encryptedData;

    for (size_t i = 0; i < messageSize; i += 245) {
        size_t len = std::min(static_cast<size_t>(245), messageSize - i);
        std::vector<unsigned char> chunk(len);
        memcpy(chunk.data(), messageBytes.data() + i, len);

        size_t outlen;
        if (EVP_PKEY_encrypt(ctx, nullptr, &outlen, chunk.data(), len) <= 0) {
            std::cerr << "Error determining encrypted length" << std::endl;
            logErrors();
            EVP_PKEY_CTX_free(ctx);
            EVP_PKEY_free(evpPublicKey);
            return "";
        }

        encryptedData.resize(encryptedData.size() + outlen);
        if (EVP_PKEY_encrypt(ctx, encryptedData.data() + encryptedData.size() - outlen, &outlen, chunk.data(), len) <= 0) {
            std::cerr << "Error encrypting message chunk" << std::endl;
            logErrors();
            EVP_PKEY_CTX_free(ctx);
            EVP_PKEY_free(evpPublicKey);
            return "";
        }
    }

    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(evpPublicKey);

    QByteArray encryptedMessage(reinterpret_cast<const char*>(encryptedData.data()), encryptedData.size());
    return encryptedMessage.toBase64();
}

QByteArray readFilePart(const QString &filePath, qint64 startPos, qint64 size) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "[ERROR] Failed to open file:" << filePath;
        return QByteArray();
    }
    file.seek(startPos);
    return file.read(size);
}

QByteArray EncryptFile::convertFileToBinary(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "[ERROR] Failed to open file:" << filePath;
        return QByteArray();
    }

    qint64 fileSize = file.size();
    qint64 partSize = fileSize / QThreadPool::globalInstance()->maxThreadCount();

    QVector<QFuture<QByteArray>> futures;

    // تقسیم فایل به تکه‌های کوچک‌تر و پردازش هر تکه در یک ترد موازی
    for (qint64 i = 0; i < fileSize; i += partSize) {
        qint64 currentPartSize = qMin(partSize, fileSize - i);
        futures.append(QtConcurrent::run(readFilePart, filePath, i, currentPartSize));
    }

    // ترکیب کردن همه بخش‌های خوانده شده
    QByteArray result;
    for (auto &future : futures) {
        result.append(future.result());
    }

    return result;
}
QByteArray EncryptFile::applyPadding(const QByteArray &data, int blockSize)
{
    int paddingLength = blockSize - (data.size() % blockSize);
    QByteArray paddedData = data;
    paddedData.append(QByteArray(paddingLength, static_cast<char>(paddingLength)));
    return paddedData;
}

QByteArray encryptAESBlock(const QByteArray &paddedData, const AES_KEY &aesKey, int start) {
    QByteArray encryptedBlock(AES_BLOCK_SIZE, 0);
    AES_encrypt(reinterpret_cast<const unsigned char *>(paddedData.data()) + start,
                reinterpret_cast<unsigned char *>(encryptedBlock.data()), &aesKey);
    return encryptedBlock;
}

QByteArray EncryptFile::encryptAES(const QByteArray &data, const QByteArray &key, const QString &filePath) {
    AES_KEY aesKey;
    QByteArray paddedData = applyPadding(data, AES_BLOCK_SIZE);
    encryptedData.resize(paddedData.size());

    AES_set_encrypt_key(reinterpret_cast<const unsigned char *>(key.data()), 128, &aesKey);

    QVector<QFuture<QByteArray>> futures;

    // تقسیم داده‌ها به بخش‌های مختلف و رمزنگاری هر بخش به صورت موازی
    for (int i = 0; i < paddedData.size(); i += AES_BLOCK_SIZE) {
        futures.append(QtConcurrent::run(encryptAESBlock, paddedData, aesKey, i));
    }

    // ترکیب کردن بخش‌های رمزنگاری‌شده
    for (int i = 0; i < futures.size(); ++i) {
        encryptedData.replace(i * AES_BLOCK_SIZE, AES_BLOCK_SIZE, futures[i].result());
    }

    // تبدیل داده‌های رمزنگاری‌شده به Base64
    fileEncryptedData = encryptedData.toBase64();

    StandardTemplate standardTemplate;
    fileEncryptedData = standardTemplate.hideData(fileEncryptedData);

    // استخراج پسوند فایل
    QFileInfo fileInfo(filePath);
    QString fileExtension = fileInfo.suffix();  // استخراج پسوند
    QByteArray base64Extension = fileExtension.toUtf8().toBase64();  // تبدیل به base64

    // اضافه کردن پسوند base64 به فایل رمزنگاری‌شده
    fileEncryptedData.append("\n");  // جداکننده
    fileEncryptedData.append(base64Extension);

    // فشرده‌سازی داده‌ها
    QByteArray compressedData = qCompress(fileEncryptedData);

    // ذخیره کردن فایل .hped
    qDebug() << folderPathG;
    if (folderPathG.isEmpty()) {
        folderPathG = QDir::homePath();
    }
    QString correctedFilePath = folderPathG;
    if (correctedFilePath.startsWith("file:///")) {
        correctedFilePath = correctedFilePath.remove(0, 7);
    }

    qDebug() << "[DEBUG] corrected file path: " << correctedFilePath;
    QString finalPath = correctedFilePath + "/output.hped";
    QFile outputFile(finalPath);
    if (outputFile.open(QIODevice::WriteOnly)) {
        outputFile.write(compressedData);
        outputFile.close();
    } else {
        qDebug() << "[ERROR] Failed to save .hped: " << outputFile.errorString();
    }

    QByteArray keyArray(reinterpret_cast<const char*>(&aesKey), sizeof(AES_KEY));
    return keyArray;
}


QByteArray EncryptFile::generateRandomAESKey(int keyLength) {
    QByteArray key(keyLength, 0);
    if (!RAND_bytes(reinterpret_cast<unsigned char*>(key.data()), keyLength)) {
        qDebug() << "[ERROR] Failed to generate random AES key";
        logErrors();
        return QByteArray();
    }

    return key;
}
