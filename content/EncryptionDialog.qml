import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

CustomDialog {
    id: encryptionDialog
    width: parent ? parent.width * 0.6 : 320
    height: parent ? parent.height * 0.9 : 240
    anchors.centerIn: parent

    signal privateKeyUpdated(string newPrivateKey)

    Component.onCompleted: {
        var keys = database.getLastKeys();
        publicKeyField.text = keys.publicKey || "";
        privateKeyField.text = keys.privateKey || "";
    }

    Column {
        anchors.fill: parent
        padding: 10
        spacing: 10

        Rectangle {
            width: parent.width/1.1
            height: 40
            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            color: "#333333"
            radius: 8

            Text {
                text: "Generate Keys"
                font.bold: true
                font.pointSize: 18
                color: "#ffffff"
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    centerIn: parent

                }
            }
        }

        CustomTextArea {
            id: publicKeyFieldTextArea
            width: parent.width - 50
            height: 150
            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: 30
            }
            textInput {
                id: publicKeyField
                readOnly: true
            }
            placeholderText: qsTr("Public Key")
            Item {
                anchors.fill: parent

                Rectangle {
                    id: tooltip
                    width: 80
                    height: 35
                    color: "#333333"
                    radius: 5
                    opacity: 0.8
                    visible: false
                    z: 1

                    Text {

                        id: tooltipText
                        anchors.centerIn: parent
                        color: "white"
                        text: "Copy Code"
                    }
                }

                ToolButton {
                    id: copyButton
                    icon.source: "images/copy.svg"
                    icon.color: "#ffffff"
                    anchors {
                        right: parent.right
                    }
                    onClicked: {
                        clipboardHelper.copyText(publicKeyField.text);
                        tooltipText.text = "Copied!"
                        tooltip.visible = true
                        hideTooltipTimer.start()
                    }
                    clip:true
                }

                Timer {
                    id: hideTooltipTimer
                    interval: 1000
                    running: false
                    repeat: false
                    onTriggered: {
                        tooltipText.text = "Copy Code"
                        tooltip.visible = false
                    }
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: copyButton
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        if (!tooltip.visible && tooltipText.text !== "Copied!") {
                            tooltip.visible = true
                            tooltip.x = copyButton.x + copyButton.width / 2 - tooltip.width / 2
                            tooltip.y = copyButton.y - tooltip.height - 5
                        }
                    }

                    onExited: {
                        if (tooltipText.text !== "Copied!") {
                            tooltip.visible = false
                        }
                    }

                    onClicked: {
                        copyButton.clicked()
                    }
                }
            }
        }

        CustomTextArea {
            id: privateKeyFieldTextArea
            width: parent.width - 50
            height: 150
            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: 30
            }
            textInput {
                id: privateKeyField
                readOnly: true
            }
            placeholderText: qsTr("Private Key")

            onTextChanged: {
                encryptionDialog.privateKeyUpdated(privateKeyField.text)
            }
        }

        CustomJumpButton {
            text: "Generate Keys"
            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: 50
            }
            buttonMouseArea.onClicked: {
                var keys = SignVerify.generateKeys();
                publicKeyField.text = keys.publicKey;
                privateKeyField.text = keys.privateKey;
                database.saveKeys(keys.publicKey, keys.privateKey);
            }
        }
    }
}
