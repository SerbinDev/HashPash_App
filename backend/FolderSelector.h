#include <QObject>
#include <QFileDialog>
#include <QDebug>

class FolderSelector : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString selectFolder() {
        QString folderPath = QFileDialog::getExistingDirectory(
            nullptr,
            "Select save location",
            QString(),
            QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks
            );

        if (!folderPath.isEmpty()) {
            qDebug() << "Selected folder:" << folderPath;
            return folderPath;
        } else {
            qDebug() << "No folder selected";
            return QString();
        }
    }

    Q_INVOKABLE QString selectFile() {
        QString filePath = QFileDialog::getOpenFileName(
            nullptr,
            "Select a File",
            QString(),
            "All Files (*.*)"  // انتخاب همه نوع فایل
            );

        if (!filePath.isEmpty()) {
            qDebug() << "Selected file:" << filePath;
            return filePath;
        } else {
            qDebug() << "No file selected";
            return QString();
        }
    }
};
