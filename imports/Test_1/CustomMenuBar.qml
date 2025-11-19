
import QtQuick 6.2
import QtQuick.Controls 6.2

Rectangle {

    id: menuButton
    width: parent.width
    height: 48
    color: "#292929"
    radius: 5
    property alias label: label
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("HashPash")
        font.family: "Times New Roman"
        font.bold: true
        font.pointSize: 20
        color: "white"
    }

}
