import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 1.15

Rectangle {
    id: customDialog
    property color backgroundColor: "#333333"
    property bool showCloseButton: true
    width: parent ? parent.width * 1.0 : 320
    height: parent ? parent.height * 0.9 : 240
    visible: false
    radius: 20
    color: backgroundColor
    border.color: "#bdbdbd"
    border.width: 1
    clip: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        Layout.margins: 10

        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                spacing: 10
                width: customDialog.width - 20
                Layout.alignment: Qt.AlignLeft
            }
        }

              RowLayout {
                  width: customDialog.width
                  height: 40
                  visible: customDialog.showCloseButton
                  Layout.alignment: Qt.AlignHCenter
                  anchors{
                      bottomMargin:10
                  }

                  CustomJumpButton {
                      text: qsTr("Close")
                      color: "#ba181b"
                      width: customDialog.width / 1.5
                      Layout.alignment: Qt.AlignHCenter

                      buttonMouseArea.onClicked: customDialog.visible = false
                  }
              }

    }
}
