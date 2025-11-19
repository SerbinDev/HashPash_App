import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

CustomDialog {
    id: settingDialog
    width: parent.width
    height: parent.height
    anchors.centerIn: parent
    showCloseButton: false



    Column {
        anchors.fill: parent


    Rectangle {
        width: parent.width
        height: 50
        anchors{
            horizontalCenter: parent.horizontalCenter
        }


        color: "#333333"
        radius: 8

        Text {
            text: "About"
            font.bold: true
            font.pointSize: 18
            color: "#ffffff"
            anchors{
                horizontalCenter: parent.horizontalCenter
                centerIn: parent

            }
        }


        ToolButton{
            icon.source: "images/back.svg"
            icon.color: "#ffffff"
            anchors{
                left:parent.left
            }
            text: "back"
            onClicked: {
                settingDialog.visible = false
            }
        }
    }

    CustomTextArea {
        id:about_1
        width: parent.width - 50
        height: 200
        color:"#364156"
        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 40
        }
        textInput {
            readOnly: true

            text:"This program is under development.\nWe are continuously working to provide users with good security applications.\n
The foundation of this program is open source, and developers who are interested can use and contribute to its development.\n
Thank you for using this program."
        }

    }


    CustomTextArea {
        width: parent.width - 50
        height: 140
        color:"#364156"
        anchors {
            horizontalCenter: parent.horizontalCenter
            topMargin: 1

        }
        textInput {
            readOnly: true

            text:"For contact, please email us at afsel443t@protonmail.com.\n
version: 2.0.0\n
From: zz6 "
            }
    }
    }
}
