import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

CustomDialog {
    id: settingDialog
    width: parent ? parent.width * 0.6 : 320
    height: parent ? parent.height * 0.9 : 240
    anchors.centerIn: parent

    Column {
        spacing: 10
        padding: 20
        width: settingDialog.width


        Rectangle {
            width: parent.width/1.1
            height: 35
            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            color: "#333333"
            radius: 8

            Text {
                text: "Setting"
                font.bold: true
                font.pointSize: 18
                color: "#ffffff"
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    centerIn: parent

                }
            }
        }

        CustomPressEffectButton {
            text: "Set Password"
            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            width: settingDialog.width/1.2
            buttonMouseArea.onClicked: {
                settingPasswordDialog.visible = true
            }
        }

        CustomPressEffectButton {
            text: "Set Save Path"
            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            width: settingDialog.width/1.2
            buttonMouseArea.onClicked: {
                setSavePath.visible = true
            }
        }

        CustomPressEffectButton {
            text: "About"
            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            width: settingDialog.width/1.2
            buttonMouseArea.onClicked: {
                aboutPage.visible = true
            }
        }

    }

    AboutPage{
        id:aboutPage
    }

    SettingPassword {
        id: settingPasswordDialog
    }
    SetSavePath{
        id:setSavePath
    }
}
