import QtQuick 6.2
import QtQuick.Controls 6.2


Rectangle {
       width: 200
       height: 50
       color: "#404048"
       radius: 10
       border.color: "#505860"
       border.width: 2

       property alias text:text.text
       property alias buttonMouseArea:buttonMouseArea

       SequentialAnimation {
           id: bounceAnimation
           NumberAnimation {
               target: parent
               property: "scale"
               from: 1.0
               to: 0.9
               duration: 100
               easing.type: Easing.InOutQuad
           }
           NumberAnimation {
               target: parent
               property: "scale"
               from: 0.9
               to: 1.0
               duration: 100
               easing.type: Easing.InOutQuad
           }
       }

       MouseArea {
           id: buttonMouseArea
           anchors.fill: parent
           cursorShape: Qt.PointingHandCursor
           onClicked: {
           }
           onPressed: {
               bounceAnimation.start()
           }
       }

       Text {
           id:text
           text: "Bounce Button"
           anchors.centerIn: parent
           color: "#ffffff"
           font.bold: true
       }
   }
