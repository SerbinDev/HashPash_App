
import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Dialogs

import Test_1

Item {
    width: parent.width
    height: parent.height

    CustomTextField {
        id: privateKey
        width: parent.width - 40
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 60
        }

        textInput{
            id:privateKeyText
        }
        placeholderText: qsTr("Private Key")
        Connections {
                target: encryptionDialog
                onPrivateKeyUpdated: privateKeyText.text = newPrivateKey
        }
    }

    CustomTextField {
        id: hashCode
        width: parent.width - 40
        anchors {
            top: privateKey.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 15
        }

        textInput{
            id:hashCodeText
        }

        placeholderText: qsTr("Enter Hash Code")
    }

    CustomTextArea {
        id: messages
        width: parent.width - 50
        height: 100

        anchors {
            top: hashCode.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 30
        }
        textInput{
            readOnly:true
        }

        placeholderText: qsTr("Decrypted Message")
    }

    CustomPressEffectButton {
        id: selectButton
        text: "Select File"
        width: 90
        height:30
        anchors {
            top: messages.bottom
            topMargin: 15
            rightMargin:25
            right:parent.right
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
        id: verifyTheMessage
        property string pathFileOutPut: ""

        text: "Decrypt"

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
        }

        buttonMouseArea{
            onClicked: {
                handleSendButtonClicked()



                if (notification.visible && (hashCodeText.text === "" || privateKeyText.text === "")) {

                    shakeAnimation.start()
                } else {

                var decryptedMessage = SignVerify.decryptMessage(hashCode.text, privateKey.text);
                messages.text = decryptedMessage;


                sqliteDb.insertDecryptionData(privateKey.text, decryptedMessage, hashCode.text);


                }
                if(selectButton.selectedFilePath !== ""){
                    loadingPage.visible = true;z
                    customMenuBar.visible = false
                    indicator.visible = false
                    buttomSwipe.visible = false
                    delayTimer.start()
                }

            }
        }
    }

    Timer {
        id: delayTimer
        interval: 1000 // 3 ثانیه
        onTriggered: {
            if (selectButton.selectedFilePath.length !== 0) {
                var decryptfile = DecryptImage.decryptFinalImage(hashCode.text, privateKey.text ,selectButton.selectedFilePath);

                var pathFile = DecryptImage.pathFile();
                verifyTheMessage.pathFileOutPut = pathFile;

                notification.show("Save in " + pathFile);

            }
            if(verifyTheMessage.pathFileOutPut !== ""){
                loadingPage.visible = false;
                customMenuBar.visible = true
                indicator.visible = true
                buttomSwipe.visible = true
            }
        }
        }



    Rectangle {
        id: notification
        width: parent.width
        height: 50
        color: verifyTheMessage.pathFileOutPut !== "" ? "green" : "red"
        radius: 5
        anchors {
            top: parent.top
            topMargin:50
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
        if (hashCodeText.text === "" && privateKeyText.text === "") {
            notification.show("Private Key and Encrypted Message cannot be empty.")
        } else if (privateKeyText.text === "") {
            notification.show("Private Key cannot be empty.")
        } else if (hashCodeText.text === "") {
            notification.show("Encrypted Message cannot be empty.")
        } else if (!privateKeyText.text.includes("-----BEGIN PRIVATE KEY-----") ||
                   !privateKeyText.text.includes("-----END PRIVATE KEY-----")) {

            notification.show("Public key syntax is not correct.")
        }else if (verifyTheMessage.pathFileOutPut !== ""){
            notification.show("Save in " + EncryptImage.pathFile())
        }
    }

    LoadingPage{
        id:loadingPage
        visible: false
    }

}

