import QtQuick 6.2
import QtQuick.Controls 6.2


Rectangle {
        width: 200
        height: 50
        color: "#404048"
        radius: 20
        border.color: "#505860"
        border.width: 2
        property alias text:text.text
        property alias buttonMouseArea:buttonMouseArea
        property alias jumpAnimation:jumpAnimation


        MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                jumpAnimation.start()
            }
        }

        SequentialAnimation {
            id: jumpAnimation
            NumberAnimation {
                target: parent
                property: "y"
                from: parent.y
                to: parent.y - 20
                duration: 150
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                target: parent
                property: "y"
                from: parent.y - 20
                to: parent.y
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        Text {
            id:text
            text: "Jump Button"
            anchors.centerIn: parent
            color: "#ffffff"
            font.bold: true
        }
    }
