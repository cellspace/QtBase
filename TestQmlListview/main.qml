import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello Qml")

    ToDoList {
        anchors.centerIn: parent
    }
}
