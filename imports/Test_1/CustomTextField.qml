import QtQuick 6.2
import QtQuick.Controls 6.2

Rectangle {
    id: container
    height: 50
    color: "#3d3d3d"
    radius: 10
    border.color: textInput.focus ? "#cccccc" : "#1f1f1f"
    border.width: 1

    property alias text: textInput.text
    property alias placeholderText: placeholderText.text
    property alias textInput: textInput

    TextInput {
        id: textInput
        width: parent.width - 20
        height: parent.height
        color: "#edede9"

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: 16
        padding: 10
        verticalAlignment: TextInput.AlignVCenter
        horizontalAlignment: TextInput.AlignLeft

        clip: true

        onTextChanged: {
            placeholderText.visible = text.length === 0
            if (text.length > 0) {
                var firstChar = text[0];
                if (firstChar >= "\u0600" && firstChar <= "\u06FF" || firstChar >= "\u0750" && firstChar <= "\u077F" || firstChar >= "\u08A0" && firstChar <= "\u08FF") {
                    textInput.horizontalAlignment = TextInput.AlignRight
                } else {
                    textInput.horizontalAlignment = TextInput.AlignLeft
                }
            }
        }
    }

    Text {
        id: placeholderText
        text: "Placeholder"
        color: "Gray"
        anchors {
            verticalCenter: textInput.verticalCenter
            left: textInput.left
            leftMargin: 12
            right: textInput.right
            rightMargin: 12
        }
        font.pixelSize: 16
        visible: textInput.text.length === 0
        elide: Text.ElideRight
        clip: true
    }
}
