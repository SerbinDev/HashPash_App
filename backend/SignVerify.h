#ifndef SIGNVERIFY_H
#define SIGNVERIFY_H

#include <QObject>
#include <QString>
#include <QVariantMap>

class SignVerify : public QObject
{
    Q_OBJECT
public:
    explicit SignVerify(QObject *parent = nullptr);

    Q_INVOKABLE QString encryptMessage(const QString &message, const QString &publicKey);
    Q_INVOKABLE QString decryptMessage(const QString &encryptedMessage, const QString &privateKey);
    Q_INVOKABLE QVariantMap generateKeys();
    Q_INVOKABLE QString signMessage(const QString &message, const QString &privateKey);
    Q_INVOKABLE bool verifySignature(const QString &message, const QString &signature, const QString &publicKey);

private:
    void logErrors();
};

#endif // SIGNVERIFY_H
