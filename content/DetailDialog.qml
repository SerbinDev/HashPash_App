import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import Test_1

CustomDialog {
    id: detailDialog
    backgroundColor: "#333333"
    property var itemData: {}
    showCloseButton: false
    anchors.centerIn: parent
    height: parent.height

    Rectangle {
        id: rec
        width: parent.width
        height: parent.height / 1.1
        radius: 20
        color: "#333333"
        border.color: "#333333"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 10


            Rectangle {
                width: parent.width
                height: 40
                anchors{
                    horizontalCenter: parent.horizontalCenter
                }

                color: "#333333"
                radius: 20

                Text {
                    text: "Details"
                    font.bold: true
                    font.pointSize: 18
                    color: "#ffffff"
                    anchors.centerIn: parent
                }

                ToolButton{
                    icon.source: "images/back.svg"
                    icon.color: "#ffffff"
                    anchors{
                        left:parent.left
                    }
                    text: "back"
                    onClicked: {
                        detailDialog.visible = false
                    }
                }
            }

            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                // ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    spacing: 10
                    width: rec.width - 20
                    Layout.alignment: Qt.AlignLeft

                    Text {
                        text: "Public Key:"
                        font.bold: true
                        font.pointSize: 16
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        padding: 5
                    }
                    CustomTextArea {
                        width: parent.width - 50
                        height: 200
                        color:"#3d3d3d"
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 40
                        }
                        textInput {
                            text: itemData ? itemData.publicKey : ""
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            color: "#cccccc"
                            readOnly: true
                        }

                    }


                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#757575"
                        opacity: 0.5
                    }


                    Text {
                        text: "Message:"
                        font.bold: true
                        font.pointSize: 16
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        padding: 5

                    }
                    CustomTextArea {
                        width: parent.width - 50
                        height: 80
                        color:"#3d3d3d"
                        placeholderText: ""

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 40
                        }
                        textInput {

                            text: itemData ? itemData.message : ""
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            color: "#cccccc"
                            readOnly: true
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#757575"
                        opacity: 0.5
                    }

                    Text {
                        text: "Hash:"
                        font.bold: true
                        font.pointSize: 16
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        padding: 5

                    }
                    CustomTextArea {
                        width: parent.width - 50
                        height: 200
                        color:"#3d3d3d"
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 40
                        }
                        textInput {
                            text: itemData ? itemData.hash : ""
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            color: "#cccccc"
                            readOnly: true
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#757575"
                        opacity: 0.5
                    }

                    Text {
                        text: "pathFiles:"
                        font.bold: true
                        font.pointSize: 16
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        padding: 5

                    }

                    CustomTextArea {
                        width: parent.width - 50
                        height: 35
                        color:"#3d3d3d"
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 40
                        }
                        textInput {
                            text: itemData ? itemData.pathFile : ""
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            color: "#cccccc"
                            readOnly: true
                        }
                    }



                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#757575"
                        opacity: 0.5
                    }

                    Text {
                        text: "Date:"
                        font.bold: true
                        font.pointSize: 16
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        padding: 5

                    }
                    CustomTextArea {
                        width: parent.width - 50
                        height: 35
                        color:"#3d3d3d"
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 40
                        }
                        textInput {
                            text: itemData ? itemData.dateTime : ""
                            wrapMode: Text.WordWrap
                            font.pointSize: 14
                            color: "#cccccc"
                            readOnly: true
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#757575"
                        opacity: 0.5
                    }
                }
            }
        }
    }


}
