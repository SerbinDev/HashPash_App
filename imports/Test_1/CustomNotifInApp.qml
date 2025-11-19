import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import CustomControls


Rectangle {
    id: undoNotification
    width: parent.width * 0.9
    height: 50
    color: "#333"
    border.color: "#222"
    border.width: 1
    radius: 5
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 20
    visible: false
    opacity: 0
    z: 1000

    property int noteId: -1
    property string noteTitle: ""
    property string noteText: ""

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            text: "Note deleted"
            color: "white"
            Layout.alignment: Qt.AlignVCenter


        }

        Button {
            text: "Undo"
            width: 80
            height: 30
            onClicked: {
                noteManager.restoreNoteFromTrashSlot(undoNotification.noteId);
                noteListModel.append({
                    id: undoNotification.noteId,
                    title: undoNotification.noteTitle,
                    note: undoNotification.noteText,
                    timestamp: new Date().toISOString()
                });
                undoNotification.visible = false;
                undoNotification.opacity = 0;
                timer.stop();
            }
            Layout.alignment: Qt.AlignVCenter

        }

        Canvas {
            id: progressCanvas
            width: 30
            height: 30
            Layout.alignment: Qt.AlignVCenter
            onPaint: {
                var ctx = progressCanvas.getContext("2d");
                ctx.clearRect(0, 0, progressCanvas.width, progressCanvas.height);

                ctx.beginPath();
                ctx.arc(progressCanvas.width / 2, progressCanvas.height / 2, 15, 0, 2 * Math.PI);
                ctx.strokeStyle = "white";
                ctx.lineWidth = 3;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(progressCanvas.width / 2, progressCanvas.height / 2, 15, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * timer.remainingTime / 5000, false);
                ctx.strokeStyle = "red";
                ctx.lineWidth = 3;
                ctx.stroke();
            }


        }

        SequentialAnimation {
            id: showHideAnimation
            NumberAnimation { target: undoNotification; property: "opacity"; from: 0; to: 1; duration: 500 }
            PauseAnimation { duration: 5000 }
            NumberAnimation { target: undoNotification; property: "opacity"; from: 1; to: 0; duration: 500 }
            ScriptAction {
                script: {
                    undoNotification.visible = false;
                }
            }
        }

        Timer {
            id: timer
            interval: 16
            repeat: true
            running: false
            property int remainingTime: 5000

            onTriggered: {
                remainingTime -= interval;
                progressCanvas.requestPaint();

                if (remainingTime <= 0) {
                    undoNotification.visible = false;
                    undoNotification.opacity = 0;
                    timer.stop();
                }
            }
        }
    }
}
