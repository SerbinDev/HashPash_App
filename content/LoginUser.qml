// LoginUser.qml

import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import Test_1

Item {
    id: loginPage
    width: 1024
    height: 768

    signal loginSuccess()

    Image {
        id: background
        anchors.fill: parent
        source: "images/background.png"
        fillMode: Image.PreserveAspectCrop
        cache: false
        smooth: true
    }

    Rectangle {
        id: loginBox
        width: parent.width * 0.3
        height: parent.height * 0.35
        anchors.centerIn: parent
        radius: 10
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 35

            Rectangle {
                id: userIconContainer
                width: 125
                height: 125
                radius: 60
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#3d3d3d"
                border.color: "#bdbdbd"
                clip: true

                Image {
                    id: userIcon
                    source: "images/User.png"
                    anchors.fill: parent
                    anchors.margins: 18
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                }
            }


            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true

                CustomTextField {
                    id: passwordField
                    placeholderText: "Enter Password"
                    textInput {
                        id: publicKeyText
                        echoMode: TextInput.Password
                        focus: true


                        Keys.onReturnPressed: {

                            var enteredPassword = passwordField.text
                            var hashedPassword = Qt.md5(enteredPassword)

                            if (passwordDb) {
                                var storedPassword = passwordDb.getUserPassword()

                                if (hashedPassword === storedPassword) {
                                    console.log("Login successful")
                                    loginSuccess()
                                } else {
                                    shakeAnimation.start()
                                    notification.show("Incorrect password. Please try again.")
                                }
                            } else {
                                console.log("Database object is null")
                                notification.show("Database connection error.")
                            }
                        }
                    }
                    Layout.fillWidth: true
                }

                CustomPressEffectButton {
                    text: "→"
                    Layout.minimumWidth: 50
                    Layout.preferredWidth: 50
                    Layout.alignment: Qt.AlignRight
                    enabled: !shakeAnimation.running

                    SequentialAnimation {
                        id: shakeAnimation
                        loops: 2
                        running: false
                        NumberAnimation { target: parent; property: "x"; from: parent.x; to: parent.x + 10; duration: 50 }
                        NumberAnimation { target: parent; property: "x"; from: parent.x + 10; to: parent.x - 10; duration: 50 }
                        NumberAnimation { target: parent; property: "x"; from: parent.x - 10; to: parent.x; duration: 50 }
                        onStopped: {
                            parent.x = 0
                        }
                    }

                    buttonMouseArea {
                        onClicked: {
                            var enteredPassword = passwordField.text
                            var hashedPassword = Qt.md5(enteredPassword)

                            if (passwordDb) {
                                var storedPassword = passwordDb.getUserPassword()

                                if (hashedPassword === storedPassword) {
                                    console.log("Login successful")
                                    loginSuccess()
                                } else {
                                    shakeAnimation.start()
                                    notification.show("Incorrect password. Please try again.")
                                }
                            } else {
                                console.log("Database object is null")
                                notification.show("Database connection error.")
                            }
                        }
                    }
                }

            }

        }
    }

    Rectangle {
        id: notification
        width: parent.width
        height: 50
        color: "red"
        radius: 5
        anchors {
            top: parent.top
            topMargin: 50
        }
        visible: false
        opacity: 0.0

        Text {
            id: notificationText
            anchors.centerIn: parent
            color: "white"
            text: ""
            font.pixelSize: 16
        }

        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }

        Timer {
            id: hideNotificationTimer
            interval: 3000
            repeat: false
            onTriggered: notification.hide()
        }

        function show(message) {
            notificationText.text = message
            notification.visible = true
            notification.opacity = 1.0
            hideNotificationTimer.start()
        }

        function hide() {
            notification.opacity = 0.0
            notification.visible = false
        }
    }

    function handleSendButtonClicked() {
        if (messagesText.text === "" && publicKeyText.text === "") {
            notification.show("Public Key and messages cannot be empty.")
        } else if (publicKeyText.text === "") {
            notification.show("Public Key cannot be empty.")
        } else if (messagesText.text === "") {
            notification.show("messages cannot be empty.")
        }
    }
}
