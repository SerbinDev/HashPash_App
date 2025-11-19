import QtQuick 6.2

Item {
    width: parent.width
    height: parent.height

    Rectangle{
        width: parent.width
        height: parent.height
        color: "#333333"

        Text{
            id:textLoding
            text: "Loading ..."
            color: "#ffffff"
            font.pixelSize: 30
            anchors{
                horizontalCenter:parent.horizontalCenter
                verticalCenter:parent.verticalCenter
            }
        }
    }
}


