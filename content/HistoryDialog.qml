import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import Test_1

CustomDialog {
    id: historyDialog
    width: parent ? parent.width * 0.6 : 320
    height: parent ? parent.height * 0.9 : 240
    anchors.centerIn: parent

    ListModel {
        id: historyModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors {
            bottomMargin: 75
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "History"
            font.bold: true
            font.pointSize: 18
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            padding: 10
            anchors.leftMargin: 20
            anchors.rightMargin: 20
        }

        ListView {
            id: historyListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.margins: 10
            model: historyModel
            clip: true

            delegate: Item {
                width: historyListView.width
                height: 120

                Rectangle {
                    width: parent.width/1.1
                    height: parent.height
                    radius: 8
                    color: "#3d3d3d"
                    border.color: "#bdbdbd"
                    border.width: 1
                    clip: true
                    anchors{
                        horizontalCenter:parent.horizontalCenter
                    }

                    Row {
                        spacing: 8
                        width: parent.width
                        height: parent.height
                        padding: 8

                        Column {
                            width: historyListView.width * 0.6
                            spacing: 5

                            Text {
                                text: "Public Key"
                                font.bold: true
                                font.pointSize: 16
                                color: "#ffffff"
                                padding: 2
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                            }

                            Text {
                                text: publicKey.length > 40 ? publicKey.substring(0, 40) + "..." : publicKey
                                font.pointSize: 14
                                color: "#cccccc"
                                padding: 2
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                            }

                            Text {
                                text: message.length > 20 ? message.substring(0, 20) + "..." : message
                                font.pointSize: 14
                                color: "#cccccc"
                                padding: 2
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                            }
                        }

                        Column {
                            width: 30
                            height: parent.height
                            spacing: 10
                            anchors.right: parent.right

                            ToolButton {
                                id: detailsButton
                                icon.source: "images/about2.svg"
                                icon.color: "#ffffff"
                                width: 30
                                height: 30
                                onClicked: {
                                    detailDialog.itemData = {
                                        publicKey: publicKey,
                                        message: message,
                                        hash: hash,
                                        pathFile: pathFile,
                                        dateTime: dateTime
                                    };
                                    detailDialog.visible = true
                                }
                            }

                            ToolButton {
                                id: deleteButton
                                icon.source: "images/trash.svg"
                                icon.color: "#ffffff"
                                width: 30
                                height: 30
                                onClicked: {
                                    console.log("Deleting item with ID:", id);
                                    if (sqliteDb) {
                                        sqliteDb.deleteData(id);
                                    } else {
                                        console.error("SQLite database not defined");
                                    }
                                    historyModel.remove(historyListView.currentIndex);
                                }
                            }
                        }

                        Text {
                            text: dateTime
                            font.pointSize: 10
                            color: "#cccccc"
                            anchors {
                                bottom: parent.bottom
                                right: parent.right
                                bottomMargin: 8
                                rightMargin: 8
                            }
                        }
                    }
                }
            }
        }
    }

    function updateHistoryModel() {
        historyModel.clear();
        const data = sqliteDb.fetchData();
        for (var i = 0; i < data.length; i++) {
            historyModel.append(data[i]);
        }
    }

    Component.onCompleted: updateHistoryModel()

    DetailDialog {
        id: detailDialog
    }
}
