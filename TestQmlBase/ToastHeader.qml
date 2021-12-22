import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

RowLayout { //header
    id: root
    implicitHeight: 32

    signal close(int value)
    signal positionChanged(real dx, real dy)

    spacing: 99

    Text {
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: 101
        Layout.leftMargin: 12
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Firmware update")
        color: "white"
        font.pixelSize: 12
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        property point clickPos: "0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            root.positionChanged(mouse.x - clickPos.x, mouse.y - clickPos.y)
        }
    }

    Rectangle {
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: 40
        //Layout.alignment: Qt.AlignRight
        color: "red"
        Image {
            anchors.centerIn: parent
            source: "qrc:/close_window_image.png"
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: root.close(1)
        }
    }
}
