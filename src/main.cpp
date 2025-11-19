// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QApplication>
#include <QQmlApplicationEngine>

#include "app_environment.h"
#include "import_qml_components_plugins.h"
#include "import_qml_plugins.h"
#include <QQmlContext>

#include "backend/SignVerify.h"
#include "backend/SQLiteDatabase.h"
#include "backend/ClipboardHelper.h"
#include "backend/EncryptFile.h"
#include "backend/DecryptFile.h"
#include "backend/FolderSelector.h"

#include <QClipboard>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    set_qt_environment();

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    FolderSelector folderSelector;
    engine.rootContext()->setContextProperty("FolderSelector", &folderSelector);

    EncryptFile encryptFile;
    engine.rootContext()->setContextProperty("EncryptImage", &encryptFile);

    DecryptFile decryptFile;
    engine.rootContext()->setContextProperty("DecryptImage", &decryptFile);

    SignVerify signVerify;
    SQLiteDatabase database;
    engine.rootContext()->setContextProperty("SignVerify", &signVerify);
    engine.rootContext()->setContextProperty("database", &database);
    SQLiteDatabase sqliteDb;
    engine.rootContext()->setContextProperty("sqliteDb", &sqliteDb);

    SQLiteDatabase passwordDb;
    engine.rootContext()->setContextProperty("passwordDb", &passwordDb);



    ClipboardHelper clipboardHelper;
    engine.rootContext()->setContextProperty("clipboardHelper", &clipboardHelper);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    const QUrl url(u"qrc:/qt/qml/Main/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
    engine.addImportPath(":/");

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
