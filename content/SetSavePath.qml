import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import Test_1

CustomDialog {
    id: settingDialog
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    showCloseButton: false

    Column {
        anchors.fill: parent
        spacing: 60
        Rectangle {
            width: parent.width
            height: 50
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            color: "#333333"
            radius: 8

            Text {
                text: "Set Save Path"
                font.bold: true
                font.pointSize: 18
                color: "#ffffff"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    centerIn: parent
                }
            }

            ToolButton {
                icon.source: "images/back.svg"
                icon.color: "#ffffff"
                anchors {
                    left: parent.left
                }
                text: "back"
                onClicked: {
                    settingDialog.visible = false


                }
            }
        }

        ColumnLayout {
              width: parent.width / 1.1
              height: parent.height /5
              // spacing: 10
              anchors {
                  horizontalCenter: parent.horizontalCenter
              }


            // Path .hped section
            Text {
                id: pathHped
                text: qsTr("Path .hped:")
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
            }

            CustomTextField {
                id: pathHpedField
                Layout.fillWidth: true
                placeholderText: "Path"
                textInput {
                    text: "~"
                    readOnly: pathHpedField
                }

            }
            CustomPressEffectButton {
                id: chosePathHped
                width: 90
                anchors{
                    right: parent.rightt
                }
                text: qsTr("Chose")
                Layout.alignment: Qt.AlignRight

                buttonMouseArea {
                    onClicked: {
                        var folderPathHped = FolderSelector.selectFolder();
                        pathHpedField.text = folderPathHped
                        sqliteDb.insertHpedPath(pathHpedField.text)
                        EncryptImage.setFolderPathG(pathHpedField.text)


                    }
                }
            }
        }


        ColumnLayout {
              width: parent.width /1.1
              height: parent.height /5
              // spacing: 10
              anchors {
                  horizontalCenter: parent.horizontalCenter
              }

            // Path OutputFile section
            Text {
                id: pathOutputFile
                text: qsTr("Path OutputFile:")
                color: "#ffffff"
                Layout.alignment: Qt.AlignLeft
            }

            CustomTextField {
                id: pathFieldOutPutFile
                Layout.fillWidth: true
                placeholderText: "Path"
                textInput {
                    text: "~"
                    readOnly: pathFieldOutPutFile
                }

            }

            CustomPressEffectButton {
                width: 90
                id: chosePathOutput
                text: qsTr("Chose")
                Layout.alignment: Qt.AlignRight

                buttonMouseArea {
                    onClicked: {
                        var folderPathHped = FolderSelector.selectFolder();
                        pathFieldOutPutFile.text = folderPathHped
                        sqliteDb.insertOutputPath(pathFieldOutPutFile.text)
                        DecryptImage.setFolderPathG(pathFieldOutPutFile.text)


                    }
                }
            }

        }
        ColumnLayout {
              width: parent.width /1.1
              height: parent.height /5
              anchors {
                  horizontalCenter: parent.horizontalCenter
              }

            Text {
                id: tip
                color: "#f42b03"
                text:("Tip: If you don't select a path in the two fields above and leave it as the\ndefault \"~\", it will save in your system's home directory.")
                font.pixelSize: 15
            }
        }
    }

    Component.onCompleted: {
        var hpedPath = sqliteDb.getHpedPath();
        if (hpedPath) {
            pathHpedField.text = hpedPath;
            // اعمال مقدار به EncryptImage بعد از به روزرسانی فیلد
            EncryptImage.setFolderPathG(pathHpedField.text);
        }

        var outputPath = sqliteDb.getOutputPath();
        if (outputPath) {
            pathFieldOutPutFile.text = outputPath;
            // اعمال مقدار به DecryptImage بعد از به روزرسانی فیلد
            DecryptImage.setFolderPathG(pathFieldOutPutFile.text);
        }
    }


}
