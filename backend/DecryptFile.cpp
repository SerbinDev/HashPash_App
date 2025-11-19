#include "DecryptFile.h"
#include <QFile>
#include <QBuffer>
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
#include <QDir>
#include "backend/StandardTemplate.h"

DecryptFile::DecryptFile(QObject *parent) : QObject(parent)
{
}

void DecryptFile::logErrors() {
    ERR_print_errors_fp(stderr);
}

QString DecryptFile::decryptFinalImage(const QString &encryptedBase64, const QString &privateKey, const QString &hpedFile) {

    std::cerr << "Decrypting message in memory..." << std::endl;

    QByteArray keyData = privateKey.toUtf8();
    BIO *bio = BIO_new_mem_buf(keyData.data(), -1);
    EVP_PKEY *evpPrivateKey = PEM_read_bio_PrivateKey(bio, nullptr, nullptr, nullptr);
    BIO_free(bio);

    if (!evpPrivateKey) {
        std::cerr << "Error reading private key" << std::endl;
        logErrors();
        return "";
    }

    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new(evpPrivateKey, nullptr);
    if (!ctx) {
        std::cerr << "Error creating context" << std::endl;
        logErrors();
        EVP_PKEY_free(evpPrivateKey);
        return "";
    }

    if (EVP_PKEY_decrypt_init(ctx) <= 0) {
        std::cerr << "Error initializing decryption" << std::endl;
        logErrors();
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(evpPrivateKey);
        return "";
    }

    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0) {
        std::cerr << "Error setting padding" << std::endl;
        logErrors();
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(evpPrivateKey);
        return "";
    }

    QString correctedFilePath = hpedFile;
    if (correctedFilePath.startsWith("file:///")) {
        correctedFilePath = correctedFilePath.remove(0, 7);
    }
    QFile file(correctedFilePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "[ERROR] Failed to open file:" << correctedFilePath;
        return "";
    }

    QByteArray compressedContent = file.readAll();
    file.close();

    QByteArray fileContent = qUncompress(compressedContent);
    if (fileContent.isEmpty()) {
        qDebug() << "[ERROR] Failed to uncompress file content";
        return "";
    }

    QStringList lines = QString::fromUtf8(fileContent).split("\n");
    QString fileExtensionBase64 = lines.last();
    lines.removeLast();

    QString fileExtension = QString(QByteArray::fromBase64(fileExtensionBase64.toUtf8()));

    QByteArray revealedData = reveal(lines.join("\n"));
    if (revealedData.isEmpty()) {
        qDebug() << "[ERROR] Failed to reveal data";
        return "";
    }

    QString hashCode = encryptedBase64;
    int position = hashCode.indexOf("---");
    if (position != -1) {
        hashCode = hashCode.mid(position + 3);
    }

    QByteArray encryptedBytes = QByteArray::fromBase64(hashCode.toUtf8());

    size_t rsaBlockSize = EVP_PKEY_size(evpPrivateKey);
    size_t maxChunkSize = rsaBlockSize;

    std::vector<unsigned char> decryptedData;

    for (size_t i = 0; i < encryptedBytes.size(); i += maxChunkSize) {
        size_t len = std::min(maxChunkSize, static_cast<size_t>(encryptedBytes.size() - i));
        size_t outlen = rsaBlockSize;

        std::vector<unsigned char> decryptedChunk(outlen);
        if (EVP_PKEY_decrypt(ctx, decryptedChunk.data(), &outlen,
                             reinterpret_cast<const unsigned char*>(encryptedBytes.data() + i), len) <= 0) {
            std::cerr << "Error decrypting message chunk" << std::endl;
            logErrors();
            EVP_PKEY_CTX_free(ctx);
            EVP_PKEY_free(evpPrivateKey);
            return "";
        }

        decryptedData.insert(decryptedData.end(), decryptedChunk.begin(), decryptedChunk.begin() + outlen);
    }

    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(evpPrivateKey);

    QByteArray decryptedKey(reinterpret_cast<const char*>(decryptedData.data()), decryptedData.size());

    decryptImage(revealedData, fileExtension, decryptedKey);

    return "";
}


QByteArray DecryptFile::removePadding(const QByteArray &data) {
    int paddingLength = static_cast<int>(data[data.size() - 1]);
    return data.left(data.size() - paddingLength);
}

QByteArray DecryptFile::decryptAES(const QByteArray &data, const QByteArray &key) {
    AES_KEY aesKey;
    QByteArray encryptedData = QByteArray::fromBase64(data);
    QByteArray decryptedData(encryptedData.size(), 0);

    AES_set_decrypt_key(reinterpret_cast<const unsigned char *>(key.data()), 128, &aesKey);

    for (int i = 0; i < encryptedData.size(); i += AES_BLOCK_SIZE) {
        AES_decrypt(reinterpret_cast<const unsigned char *>(encryptedData.data()) + i,
                    reinterpret_cast<unsigned char *>(decryptedData.data()) + i, &aesKey);
    }

    return removePadding(decryptedData);
}

QByteArray DecryptFile::reveal(const QString &concealedData) {

    QString modifiedData = concealedData;
    StandardTemplate standardTemplate;
    modifiedData = standardTemplate.revealData(modifiedData);

    QByteArray binaryData = modifiedData.toUtf8();
    return binaryData;
}

void DecryptFile::decryptImage(const QByteArray &filePath, const QString &fileExtension , QByteArray &decryptedKey) {
    QByteArray encryptedData = filePath;
    QByteArray key = decryptedKey;

    QByteArray decryptedData = decryptAES(encryptedData, key);
    if (!decryptedData.isEmpty()) {
        qDebug() << "[DEBUG] Image successfully decrypted";

        qDebug() << "[DEBUG] folderPathG_Decrypt: " << folderPathG;

        if (folderPathG.isEmpty()){
            folderPathG=QDir::homePath();
        }
        QString correctedFilePath = folderPathG;

        QString outputFileName = correctedFilePath + "/output." + fileExtension;
        QFile outputFile(outputFileName);
        if (outputFile.open(QIODevice::WriteOnly)) {
            outputFile.write(decryptedData);
            outputFile.close();
            qDebug() << "[DEBUG] Image saved as " << outputFileName;
            emit imageDecrypted(outputFileName);
        } else {
            qDebug() << "[ERROR] Failed to save decrypted image";
        }
    } else {
        qDebug() << "[ERROR] Failed to decrypt image";
    }
}

bool DecryptFile::verifySignature(const QString &message, const QString &signature, const QString &publicKey) {
    QByteArray keyData = publicKey.toUtf8();
    BIO *bio = BIO_new_mem_buf(keyData.data(), -1);
    EVP_PKEY *evpPublicKey = PEM_read_bio_PUBKEY(bio, nullptr, nullptr, nullptr);
    BIO_free(bio);

    if (!evpPublicKey) {
        std::cerr << "Error reading public key" << std::endl;
        logErrors();
        return false;
    }

    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (!mdctx) {
        std::cerr << "Error creating context" << std::endl;
        logErrors();
        EVP_PKEY_free(evpPublicKey);
        return false;
    }

    if (EVP_DigestVerifyInit(mdctx, nullptr, EVP_sha256(), nullptr, evpPublicKey) <= 0) {
        std::cerr << "Error initializing verification" << std::endl;
        logErrors();
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(evpPublicKey);
        return false;
    }

    if (EVP_DigestVerifyUpdate(mdctx, message.toUtf8().data(), message.size()) <= 0) {
        std::cerr << "Error updating verification" << std::endl;
        logErrors();
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(evpPublicKey);
        return false;
    }

    QByteArray sigBytes = QByteArray::fromBase64(signature.toUtf8());
    if (EVP_DigestVerifyFinal(mdctx, reinterpret_cast<const unsigned char*>(sigBytes.data()), sigBytes.size()) <= 0) {
        std::cerr << "Signature verification failed" << std::endl;
        logErrors();
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(evpPublicKey);
        return false;
    }

    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(evpPublicKey);

    return true;
}
