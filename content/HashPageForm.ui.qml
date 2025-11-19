import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

Page {
    id: root

    Rectangle {
        id: background
        color: "#333333"
        anchors.fill: parent
        z: -1
    }

    width: parent.width
    height: parent.height

    property int selectedIndex: 0

    SwipeView {
        id: view
        anchors.fill: parent

        onCurrentIndexChanged: {
            selectedIndex = view.currentIndex
        }

        Loader {
            id: firstPageLoader
            source: Qt.resolvedUrl("HashPageContent.qml")
        }

        Loader {
            id: secondPageLoader
            source: Qt.resolvedUrl("PashPageContent.qml")
        }
    }

    PageIndicator {
        id: indicator
        count: view.count
        currentIndex: view.currentIndex
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 50
    }

    Row {
        id:buttomSwipe
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 10


        CustomJumpButton {
            id: buttonHash
            text: "HashPage"
            color: selectedIndex === 0 ? "#505860" : "#404048"
            buttonMouseArea.onClicked: {
                view.currentIndex = 0
            }
        }


        CustomJumpButton {
            id: buttonPash
            text: "PashPage"
            color: selectedIndex === 1 ? "#505860" : "#404048"
            buttonMouseArea.onClicked: {
                view.currentIndex = 1
            }
        }
    }
}
