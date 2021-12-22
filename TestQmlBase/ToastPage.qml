import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Window {
    id: root
    visible: true
    color: "black"
    //flags: Qt.FramelessWindowHint | Qt.Window
    width: 332; height:202
    ColumnLayout {
        ToastHeader {
            id: header
        }
    }
    Connections {
        target: header
        function onClose(value) {
            console.log("[header::onClose]", value)
            root.close()
        }
        function onPositionChanged(dx, dy) {
            root.x += dx
            root.y += dy
        }
    }

    Component.onCompleted: {
        console.log(Screen.width, Screen.height)
        setX(Screen.width - width - 60)
        setY(Screen.height)
    }
    ParallelAnimation {
        NumberAnimation {
            target: root
            properties: "opacity"
            from: 0.0; to: 1.0
            duration: 1000
        }
        NumberAnimation {
            target: root
            properties: "y"
            from: Screen.height
            to: Screen.height - root.height - 56
            duration: 1000
        }
        running: true
    }
}
