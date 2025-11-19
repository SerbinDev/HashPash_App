import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Dialogs
import Test_1

Item {
    id: root
    property alias filePath: fileDialog
    signal fileSelected(string filePath)
    property alias selectButton: selectButton

    CustomJumpButton {
        id: selectButton
        text: "Select Image"
        anchors.centerIn: parent
        onClicked: fileDialog.open()

        Image {
            id: checkIcon
            width:25
            height:25
            source: "images/success.svg"
            visible: false
            anchors.right: selectButton.right
            anchors.verticalCenter: selectButton.verticalCenter
        }


    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        onAccepted: {
            selectButton.text = "Image Selected"
            selectButton.color = "green"
            checkIcon.visible = true
            fileSelected(fileDialog.fileUrl)
        }
    }
}
