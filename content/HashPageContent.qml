
import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Dialogs
import Test_1

Item {
    id: root
    width: parent.width
    height: parent.height
    property string selectedFilePath: ""
    property string pathFileDatabase: ""


    CustomTextField {
        id: publicKey
        width: parent.width - 40
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 60
        }

        textInput {
            id: publicKeyText


        }
        placeholderText: qsTr("Public Key")
    }

    CustomTextArea {
        id: messages
        width: parent.width - 50
        height: 100
        anchors {
            top: publicKey.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 30
        }

        textInput {
            id: messagesText
            text: EncryptImage.imagePath
        }

        placeholderText: qsTr("messages")
    }


    CustomPressEffectButton {
        id: selectButton
        text: "Select File"

        width: 90
        height: 30
        anchors {
            top: messages.bottom
            topMargin: 15
            rightMargin: 25
            right: parent.right
        }

        property string selectedFilePath: ""

        buttonMouseArea {
            onClicked: {
                var filePath = FolderSelector.selectFile();
                if (filePath) {

                    selectButton.selectedFilePath = filePath;
                    console.log("Selected file: " + filePath);
                    checkIcon.visible = true;
                    selectButton.color="#52b788"
                } else {
                    console.log("No file selected");
                }
            }
        }

        Image {
            id: checkIcon
            width: 18
            height: 18
            source: "images/success.svg"
            visible: false
            anchors.right: selectButton.right
            anchors.verticalCenter: selectButton.verticalCenter
        }
    }

    CustomPressEffectButton {
        id: encryptTheMessage
        property string pathFileHped: ""

        text: "Encrypt"
        anchors {
            top: messages.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 50
        }

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
                hashOutput.text = "";

                handleSendButtonClicked()

                if (notification.visible && (messagesText.text === "" || publicKeyText.text === "")) {
                    // در صورت وجود ارور، لرزش را فعال کنید
                    shakeAnimation.start()
                } else {
                    // عملیات موفقیت‌آمیز بود، نوتیفیکیشن نمایش داده شود و صفحه نلرزد
                    var hash = SignVerify.encryptMessage(messages.text, publicKey.text)
                    hash += "---"
                    hashOutput.text = hash
                    historyDialog.updateHistoryModel()
                }
                if(publicKeyText.text !== "" & selectButton.selectedFilePath !== "" ){
                    loadingPage.visible = true;z
                    customMenuBar.visible = false
                    indicator.visible = false
                    buttomSwipe.visible = false
                    delayTimer.start()
            }



        }
    }
    // تایمر برای صبر 3 ثانیه‌ای
    Timer {
        id: delayTimer
        interval: 1000 // 3 ثانیه
        onTriggered: {
            if (selectButton.selectedFilePath.length !== 0) {
                var hash2 = EncryptImage.encryptRSA(selectButton.selectedFilePath, publicKey.text);
                encryptTheMessage.pathFileHped = hash2;
                if (hashOutput.text.indexOf("---") === -1) {
                    hashOutput.text += "---";
                }

                hashOutput.text += hash2;
                var pathFile = EncryptImage.pathFile();
                pathFileDatabase = pathFile
                console.log("pathFile----------: " + pathFile);


                notification.show("Save in " + pathFile);
            }
            sqliteDb.insertData(publicKey.text, messages.text, hash2 , selectButton.selectedFilePath)

            historyDialog.updateHistoryModel();

        }
        }
    }



    CustomTextField {
        id: hashOutput
        width: parent.width - 40
        textInput {
            id: textInput
            readOnly: true
        }

        anchors {
            top: encryptTheMessage.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 15
        }
        placeholderText: qsTr("Hash Code")
        onTextChanged: {
                if (hashOutput.text !== "") {
                    loadingPage.visible = false;
                    customMenuBar.visible = true
                    indicator.visible = true
                    buttomSwipe.visible = true
                }
            }
        Item {
            anchors.fill: parent

            Rectangle {
                id: tooltip
                width: 150
                height: 40
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
                    verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    clipboardHelper.copyText(textInput.text);
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


    Rectangle {
        id: notification
        width: parent.width
        height: 50
        color: encryptTheMessage.pathFileHped !== "" ? "green" : "red"
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
            notification.show("Public Key and messages or Select File cannot be empty.")
        } else if (publicKeyText.text === "") {
            notification.show("Public Key cannot be empty.")
        } else if (messagesText.text === "" && selectButton.selectedFilePath.length === 0) {
            notification.show("Messages or Select File cannot be empty.")
        } else if (!publicKeyText.text.includes("-----BEGIN PUBLIC KEY-----") ||
                   !publicKeyText.text.includes("-----END PUBLIC KEY-----")) {
            notification.show("Public key syntax is not correct.")
        }else if (encryptTheMessage.pathFileHped !== ""){
            notification.show("Save in " + EncryptImage.pathFile())
        }


    }

    LoadingPage{
        id:loadingPage
        visible: false
    }

}

