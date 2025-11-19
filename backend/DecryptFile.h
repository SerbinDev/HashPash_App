#ifndef DECRYPTFILE_H
#define DECRYPTFILE_H

#include <QObject>
#include <QDebug>
#include <QByteArray>
#include <backend/EncryptFile.h>

class DecryptFile : public QObject
{
    Q_OBJECT
public:
    explicit DecryptFile(QObject *parent = nullptr);

    Q_INVOKABLE QString decryptFinalImage(const QString &encryptedBase64, const QString &privateKey, const QString &hpedFile);
    Q_INVOKABLE bool verifySignature(const QString &message, const QString &signature, const QString &publicKey);
    QByteArray encryptedData;
    QString folderPathG;
    Q_INVOKABLE void setFolderPathG(const QString &path) {
        folderPathG = path;
    }


    Q_INVOKABLE QString pathFile(){
        return folderPathG;
    }


signals:
    void imageDecrypted(const QString &filePath);

private:
    void decryptImage(const QByteArray &filePath, const QString &fileExtension, QByteArray &decryptedKey);
    QByteArray decryptAES(const QByteArray &data, const QByteArray &key);
    QByteArray removePadding(const QByteArray &data);
    void saveImageFromBinary(const QByteArray &binaryData, const QString &outputFilePath);
    QByteArray reveal(const QString &concealedData);
    void logErrors();
    QString deobfuscate(const QString &obfuscatedData);

};

#endif // DECRYPTFILE_H
