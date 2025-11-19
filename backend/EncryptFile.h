#ifndef ENCRYPTFILE_H
#define ENCRYPTFILE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <openssl/aes.h>
#include <openssl/rand.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/sha.h>

class EncryptFile : public QObject
{
    Q_OBJECT
public:
    explicit EncryptFile(QObject *parent = nullptr);

    Q_INVOKABLE QString encryptRSA(const QString &filePath, const QString &publicKey);
    QString filePath;
    QByteArray encryptedData;
    QByteArray fileEncryptedData;
    QString folderPathG;
    Q_INVOKABLE void setFolderPathG(const QString &path) {
        folderPathG = path;
    }

    Q_INVOKABLE QString pathFile(){
        return folderPathG;
    }


signals:
    void fileEncrypted(const QString &filePath);

private:
    void encryptFile(const QString &filePath);
    QByteArray convertFileToBinary(const QString &filePath);
    QByteArray encryptAES(const QByteArray &data, const QByteArray &key, const QString &filePath);
    QByteArray applyPadding(const QByteArray &data, int blockSize);
    QByteArray generateAESKey();
    QByteArray generateRandomAESKey(int keyLength);
    void logErrors();

    QString obfuscate(const QString &base64Data);
};

#endif // ENCRYPTFILE_H
