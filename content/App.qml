import QtQuick 6.2
import QtQuick.Controls 6.2
import Test_1

ApplicationWindow {
    id: root

    width: 900
    height: 600
    minimumHeight: 600
    maximumHeight: 600
    minimumWidth: 900
    maximumWidth: 900
    visible: true
    flags: Qt.Window | Qt.WindowTitleHint
    property var builtInStyles

    color: "Black"

    Item {
        id: container
        width: root.width
        height: root.height

        AnimatedImage {
            id: animatedImage
            source: "animation/ZZ6.gif"
            anchors.fill: parent
            opacity: 0

            Behavior on opacity {
                NumberAnimation { from: 0; to: 1; duration: 1000 }
            }
        }

        Timer {
            id: transitionTimer
            interval: 3000
            running: true
            repeat: false
            onTriggered: {
                animatedImage.opacity = 0
                if (passwordDb.getUserPassword() !== "") {
                    loginPage.visible = true;
                    animatedImage.visible = false
                } else {
                    mainContent.visible = true;
                }
            }
        }

        Component.onCompleted: {
            animatedImage.opacity = 1
        }

        LoginUser {
            id: loginPage
            visible: false
            anchors.fill: parent
            onLoginSuccess: {
                loginPage.visible = false;
                mainContent.visible = true;
            }
        }

        HashPage {
            id: mainContent
            visible: false
            anchors.fill: parent
        }
    }
}
