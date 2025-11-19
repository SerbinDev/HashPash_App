#ifndef CLIPBOARDHELPER_H
#define CLIPBOARDHELPER_H

#include <QObject>
#include <QClipboard>
#include <QGuiApplication>


class ClipboardHelper : public QObject
{
    Q_OBJECT
public:
    explicit ClipboardHelper(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void copyText(const QString &text) {
        QClipboard *clipboard = QGuiApplication::clipboard();
        clipboard->setText(text);
    }
};

#endif // CLIPBOARDHELPER_H
