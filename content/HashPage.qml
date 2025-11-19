import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

HashPageForm {
    property alias customMenuBar: customMenuBar

    CustomMenuBar {
        id: customMenuBar
        Item {
            anchors.fill: parent

            Rectangle {
                id: tooltipHistory
                width: 60
                height: 40
                color: "#333333"
                radius: 5
                opacity: 0.8
                visible: false
                z: 1

                Text {
                    id: tooltipTextHistory
                    anchors.centerIn: parent
                    color: "white"
                    text: "History"
                }

            }

            ToolButton {
                id: history
                anchors.left: parent.left
                anchors.leftMargin: 5
                icon.source: "images/history.svg"
                icon.color: "#ffffff"
                onClicked: {
                    historyDialog.visible = true
                }
            }

            MouseArea {
                id: hoverAreaHistory
                anchors.fill: history
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onEntered: {
                    if (!tooltipHistory.visible) {
                        tooltipHistory.visible = true
                        tooltipHistory.x = history.x + history.width / 2 - tooltipHistory.width / 2
                        tooltipHistory.y = history.y - tooltipHistory.height + 90
                    }
                }

                onExited: {
                    tooltipHistory.visible = false
                }

                onClicked: {
                    history.clicked()
                }
            }
        }


         Rectangle {
             id: tooltipEncryption
             width: 100
             height: 40
             color: "#333333"
             radius: 5
             opacity: 0.8
             visible: false
             z: 1

             Text {
                 id: tooltipTextEncryption
                 anchors.centerIn: parent
                 color: "white"
                 text: "Generate Key"
             }

         }

         ToolButton {
             id: encryption
             anchors.left: parent.left
             anchors.leftMargin: 60
             icon.source: "images/encryption4.svg"
             icon.color: "#ffffff"
             onClicked: {
                 encryptionDialog.visible = true
             }
         }

         MouseArea {
             id: hoverAreaEncryption
             anchors.fill: encryption
             cursorShape: Qt.PointingHandCursor
             hoverEnabled: true

             onEntered: {
                 if (!tooltipEncryption.visible) {
                     tooltipEncryption.visible = true
                     tooltipEncryption.x = encryption.x + encryption.width / 2 - tooltipEncryption.width / 1.5
                     tooltipEncryption.y = encryption.y - tooltipEncryption.height + 90

                 }
             }

             onExited: {
                 tooltipEncryption.visible = false
             }

             onClicked: {
                 encryption.clicked()
             }
         }

         Rectangle {
             id: tooltipSetting
             width: 60
             height: 40
             color: "#333333"
             radius: 5
             opacity: 0.8
             visible: false
             z: 1

             Text {
                 id: tooltipTextSetting
                 anchors.centerIn: parent
                 color: "white"
                 text: "Setting"
             }

         }

         ToolButton {
             id: setting
             anchors.right: parent.right
             anchors.rightMargin: 5
             icon.source: "images/Settings.svg"
             icon.color: "#ffffff"
             onClicked: {
                 settingDialog.visible = true
             }
         }

         MouseArea {
             id: hoverAreaSetting
             anchors.fill: setting
             cursorShape: Qt.PointingHandCursor
             hoverEnabled: true

             onEntered: {
                 if (!tooltipSetting.visible) {
                     tooltipSetting.visible = true
                     tooltipSetting.x = setting.x + setting.width / 2 - tooltipSetting.width / 1.5
                     tooltipSetting.y = setting.y - tooltipSetting.height + 90

                 }
             }

             onExited: {
                 tooltipSetting.visible = false
             }

             onClicked: {
                 setting.clicked()
             }
         }

    }

    SettingDialog{
        id:settingDialog
    }


    EncryptionDialog {
        id: encryptionDialog
    }

    HistoryDialog {
        id: historyDialog
    }

}
