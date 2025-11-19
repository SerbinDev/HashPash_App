import QtQuick 6.2
import QtQuick.Controls 6.2

Rectangle {
    id: container
    width: parent.width - 40
    color: "#3d3d3d"
    radius: 10
    border.color: textInput.focus ? "#cccccc" : "#1f1f1f"
    border.width: 1

    property alias text: textInput.text
    property alias placeholderText: placeholderText.text
    property alias textInput: textInput

    Flickable {
        id: flickable
        width: parent.width - 20
        height: parent.height
        contentWidth: textInput.width
        contentHeight: textInput.height
        clip: true
        interactive: true
        flickableDirection: Flickable.VerticalFlick

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOff
        }

        TextEdit {
            id: textInput
            width: flickable.width
            height: Math.max(implicitHeight, flickable.height)
            font.pixelSize: 16
            padding: 10
            verticalAlignment: TextInput.AlignTop
            horizontalAlignment: TextInput.AlignLeft
            wrapMode: TextEdit.Wrap
            color: "#edede9"
            cursorVisible: true

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

                flickable.contentHeight = textInput.height

                updateScrollPosition()
            }

            function updateScrollPosition() {
                var lineHeight = textInput.font.pixelSize * 1.5;
                var cursorY = textInput.cursorRectangle.y
                var visibleHeight = flickable.height

                if (cursorY < flickable.contentY) {
                    flickable.contentY = Math.max(cursorY - lineHeight, 0);
                } else if (cursorY > flickable.contentY + visibleHeight) {
                    flickable.contentY = Math.min(cursorY - visibleHeight + lineHeight, textInput.height - visibleHeight);
                }
            }
        }

        Behavior on contentY {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        Text {
            id: placeholderText
            text: "Placeholder"
            color: "Gray"
            anchors {
                top: textInput.top
                left: textInput.left
                leftMargin: 12
                topMargin: 10
            }
            font.pixelSize: 16
            visible: textInput.text.length === 0
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                textInput.forceActiveFocus();
            }
        }
    }
}
