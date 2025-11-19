#ifndef SQLITEDATABASE_H
#define SQLITEDATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QVariantList>

class SQLiteDatabase : public QObject
{
    Q_OBJECT
public:
    explicit SQLiteDatabase(QObject *parent = nullptr);
    ~SQLiteDatabase();

    Q_INVOKABLE bool insertData(const QString &publicKey, const QString &message, const QString &hash , const QString &pathFile);
    Q_INVOKABLE bool insertDecryptionData(const QString &privateKey, const QString &decryptedMessage, const QString &hash);
    Q_INVOKABLE QVariantList fetchData() const;
    Q_INVOKABLE bool deleteData(int id);
    Q_INVOKABLE bool saveKeys(const QString &publicKey, const QString &privateKey);
    Q_INVOKABLE QVariantMap getLastKeys() const;
    Q_INVOKABLE bool saveUserPassword(const QString &hashedPassword);
    Q_INVOKABLE QString getUserPassword() const;
    Q_INVOKABLE bool insertHpedPath(const QString &hpedPath);
    Q_INVOKABLE bool insertOutputPath(const QString &outputPath);
    Q_INVOKABLE QString getHpedPath() const;
    Q_INVOKABLE QString getOutputPath() const;

private:
    QSqlDatabase db;
    bool createTable();
};

#endif // SQLITEDATABASE_H
