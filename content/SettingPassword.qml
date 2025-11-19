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
        // spacing: 5
        Rectangle {
            width: parent.width
            height: 50
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            color: "#333333"
            radius: 8

            Text {
                text: "Set Password"
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
          height: parent.height /7
          anchors {
              horizontalCenter: parent.horizontalCenter
          }
    Rectangle {
        id: customSwitch
        width: 55
        height: 25
        radius: height / 2
        color: passwordSwitch.checked ? "#0077b6" : "#9e9e9e"
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 20
            leftMargin: 20
        }

        Rectangle {
            id: handle
            width: 25
            height: 25
            radius: height / 2
            color: "white"
            x: passwordSwitch.checked ? parent.width - width : 0
            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }

            MouseArea {
                id: handleMouseArea
                anchors.fill: parent
                drag.target: parent
                onReleased: {
                    passwordSwitch.checked = !passwordSwitch.checked
                }
            }

            Drag.active: handleMouseArea.drag.active
            Drag.hotSpot.x: handle.width / 2
            Drag.hotSpot.y: handle.height / 2
            Drag.source: handleMouseArea
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                passwordSwitch.checked = !passwordSwitch.checked
            }
        }
    }

    Switch {
        id: passwordSwitch
        visible: false
        checked: appSettings.isPasswordSwitchChecked
        onCheckedChanged: {
            appSettings.isPasswordSwitchChecked = checked

            if (checked) {
                console.log("Enabling password in the database");
                if (passwordDb) {
                    currentPassword.visible = passwordDb.getUserPassword() !== "";
                }
            } else {
                console.log("Disabling password in the database");
                if (passwordDb) {
                    passwordDb.saveUserPassword("");
                    currentPassword.visible = false;
                }
            }
        }
    }

    }
    ColumnLayout {
          width: parent.width / 1.1
          height: parent.height /5
          spacing: 20
          anchors {
              horizontalCenter: parent.horizontalCenter
          }

        CustomTextField {
            id: currentPassword
            width: settingPasswordDialog.width / 1.2
            placeholderText: "Enter current password"
            textInput {
                echoMode: TextInput.Password
                readOnly: !passwordSwitch.checked
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
            visible: false
        }

        CustomTextField {
            id: newPassword
            width: settingPasswordDialog.width / 1.2
            placeholderText: "Enter new password"
            textInput {
                echoMode: TextInput.Password
                readOnly: !passwordSwitch.checked
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        CustomTextField {
            id: repeatPassword
            width: settingPasswordDialog.width / 1.2
            placeholderText: "Repeat new password"
            textInput {
                echoMode: TextInput.Password
                readOnly: !passwordSwitch.checked
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        CustomTextField {
            id: passwordHint
            width: settingPasswordDialog.width / 1.2
            placeholderText: "Password hint (optional)"
            textInput {
                readOnly: !passwordSwitch.checked
            }
            anchors {
                horizontalCenter: parent.horizontalCenter
            }
        }

        CustomPressEffectButton {
            text: "Save Password"
            anchors {
                horizontalCenter: parent.horizontalCenter

            }
            enabled: passwordSwitch.checked
            color: passwordSwitch.checked ? "#404048" : "#757575"
            buttonMouseArea {
                onClicked: {
                    if (!validatePasswords()) {
                        return
                    }

                    if (currentPassword.visible && currentPassword.text.length === 0) {
                        notification.show("Current password cannot be empty")
                        return
                    }

                    if (currentPassword.visible) {
                        var currentHashedPassword = Qt.md5(currentPassword.text)
                        var storedPassword = passwordDb.getUserPassword()

                        if (currentHashedPassword !== storedPassword) {
                            notification.show("Current password is incorrect")
                            return
                        }
                    }

                    var hashedPassword = newPassword.text.length > 0 ? Qt.md5(newPassword.text) : ""
                    var storedPassword = passwordDb.getUserPassword()

                    if (hashedPassword === storedPassword) {
                        notification.show("This password has already been registered.")
                        return
                    }

                    console.log("Hashed password: " + hashedPassword)

                    if (passwordDb) {
                        var result = passwordDb.saveUserPassword(hashedPassword)
                        if (result) {
                            console.log("Password saved successfully in the database")
                        } else {
                            console.log("Failed to save password in the database")
                        }
                    } else {
                        console.log("Database object is null")
                    }

                    settingPasswordDialog.visible = false
                }
            }
        }
    }
}
    Rectangle {
        id: notification
        width: settingPasswordDialog.width
        height: 50
        color: "red"
        radius: 5
        anchors {
            top: parent.top

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

    function validatePasswords() {
        if (newPassword.text.length === 0) {
            notification.show("New password cannot be empty.")
            return false
        }
        if (repeatPassword.text.length === 0) {
            notification.show("Repeat password cannot be empty.")
            return false
        }
        if (newPassword.text !== repeatPassword.text) {
            notification.show("Passwords do not match.")
            return false
        }
        return true
    }

    Component.onCompleted: {
        if (passwordDb) {
            var storedPassword = passwordDb.getUserPassword()
            if (storedPassword !== "") {
                currentPassword.visible = true
                passwordSwitch.checked = true
            } else {
                currentPassword.visible = false
                passwordSwitch.checked = false
            }
        } else {
            console.log("Database object is null")
            currentPassword.visible = false
            passwordSwitch.checked = false
        }
    }
}
