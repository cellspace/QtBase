import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

import QmlTest 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qml Test")

    Rectangle {
        id: child
        color: "black"
        //binding loop issue when the width/height of parent and child are interdependent
        //use implicitWith and implicitHeigt
        anchors.fill: parent //1.
        Rectangle {
            id: test_anchor
            color: "green"
            width: 50; height: 50
            anchors {
                  //2.
                  //centerIn: parent
                  //3.
//                horizontalCenter: parent.horizontalCenter
//                verticalCenter: parent.verticalCenter

                  //4.
                left: parent.left
                leftMargin: 20
                top: parent.top
                topMargin: 20
                margins: 20
            }
        }


        //Three different ways that the color can be specified
        //1.Using SVG names(string)
        //"red", "green", "blue", ...
        //2.With color components in a string: #<aa><rr><gg><bb>(alpha optional)
        //"#ff000000", "#00ff00"
        //3.Using a built-in function(red, green, blue, alpha):
        //Qt.rgba(0, 0.75, 0, 1)
        Rectangle {
            id:test_color
            width: 100; height: 100
            anchors {
                top: test_anchor.bottom
                topMargin: 20
            }
            rotation: 45 //旋转45°
            scale:0.5 //缩小为原来的0.5倍
            gradient: Gradient { //渐变色
                //orientation: Gradient.Horizontal
                //orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0; color: "red"
                }
                GradientStop {
                    position: 0.5; color: "yellow"
                }
                GradientStop {
                    position: 1.0; color: "blue"
                }
            }
        }



        Rectangle {
            id: test_transform
            width: 100; height: 100
            radius: 50
            anchors {
                top: test_color.bottom
                topMargin: 20
            }
            color: "lightblue"
            Rectangle {
                id: id_center
                width: 4; height: 4
                radius: 2
                color: "black"
                anchors.centerIn: parent
            }
            transformOrigin: Item.TopLeft
            Rectangle {
                id: hour_hand
                width: 2; height:32
                x: id_center.x + 1
                y: id_center.y - height + 8
                color: "black"
                transform: Rotation {
                    origin.x: 1
                    origin.y: 26
                    RotationAnimation on angle {
                        from: 0
                        to: 360*2
                        duration: 60000
                        loops: Animation.Infinite
                    }
                }
            }
            Rectangle {
                id: minute_hand
                x: id_center.x + 1.5
                y: id_center.y - height + 10
                width: 1; height:46
                color: "black"
                transform: Rotation {
                    origin.x: 0.5
                    origin.y: 38
                    RotationAnimation on angle {
                        from: 0
                        to: 360*24
                        duration: 60000
                        loops: Animation.Infinite
                    }
                }
            }
        }


        Rectangle {
            id: test_mouse_area
            width: 78
            height: 28
            radius: 16
//            anchors {
//                top: test_transform.bottom
//                topMargin: 20
//            }

            color: id_mouse_area.pressed ? "gray" : "white"
            border.width: 1
            border.color: "gray"
            property bool isActive: false
            Text {
                id: id_text
                anchors.centerIn: parent
                text: qsTr("Deselect all")
                font.pixelSize: 14
                color: test_mouse_area.isActive ? "green" : "black"
            }
            MouseArea {
                id: id_mouse_area
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                //hoverEnabled: true
                onClicked: {
                    if(id_text.text === qsTr("Deselect all"))
                        id_text.text = qsTr("Select all")
                    else
                        id_text.text = qsTr("Deselect all")
                }

                property point clickPos: "0,0"
                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                }
                onPositionChanged: {
                    test_mouse_area.x += mouse.x - clickPos.x
                    test_mouse_area.y += mouse.y - clickPos.y
                }
//                onPressed: parent.color="gray"
//                onReleased: parent.color="white"
                onPressAndHold:  test_mouse_area.isActive = !test_mouse_area.isActive
            }
        }


        //keyboard_test
        Keys.onPressed: {
            console.log(event.key)
            switch(event.key)
            {
                case Qt.Key_Left:
                    test_mouse_area.x -=10
                    break;
                case Qt.Key_Right:
                    test_mouse_area.x += 10
                    break;
                case Qt.Key_Up:
                    test_mouse_area.y -=10
                    break;
                case Qt.Key_Down:
                    test_mouse_area.y += 10
                    break;
                case Qt.Key_A:
                    test_color.rotation = (test_color.rotation-10)%360
                    break;
                case Qt.Key_D:
                    test_color.rotation = (test_color.rotation+10)%360
                    break;
                case Qt.Key_W:
                    break;
                case Qt.Key_S:
                    break;
            }
        }
        focus: true


        //Note: the assignment will overwrite the property binding
        //implicitWidth/implicitHeight 在width/height没有被指定时生效
        //制作通用类型时，总是指定其implicitWidth和implicitHeight
        //Loader
        Component {
            id: line_edit
            Rectangle {
                //property string text: "Enter text ..."
                property alias text: text_input.text
                width: 150
                height: 30

                clip: true //截断，修剪，不允许内部控件超出父控件的范围
                border.color: "green"
                TextInput {
                    id: text_input
                    anchors {
                        fill: parent
                        margins: 2
                    }
                    text: "Enter text ..."
                    color: focus ? "black" : "gray"
                    font.pixelSize: parent.height - 4
                }
            }
        }
        Loader {
            id: loader_test
            anchors {
                right: parent.right
                rightMargin: 10
                top: parent.top
                topMargin: 10
            }
            //source: "xxx.qml"
            sourceComponent: line_edit
            asynchronous: true
        }
//        Binding {
//            target: loader_test.item
//            property: "text"
//            value: qsTr("Enter text ...")
//        }
        Text {
            id: id_text_show
            height: 30
            width: 200
            anchors{
                top: loader_test.bottom
                right: parent.right
            }
            text: "<b>Input: </b>" + (loader_test.item ? loader_test.item.text : "")
            font.pixelSize: 18
            color:"white"
        }

        Button {
            id: id_clear_btn
            anchors {
                top: id_text_show.bottom
                right: parent.right
            }

            text: qsTr("Clear")
            font.capitalization: Font.MixedCase
            onClicked: {
                loader_test.item.text = ""
            }
        }

        //property 可以直接绑定
        //function 可以直接被调用
        //singal 函数使用Connections接收或使用connect连接槽函数

        Test {
            id: id_test
            onStrTestChanged: {
                console.log("Test::onStrTestChanged")
            }
        }
        Text {
            id: test_connect
            width: 200
            height: 32
            anchors {
                top: id_clear_btn.bottom
                topMargin: 10
                right: parent.right
            }
            color: "red"
            font.pixelSize: 20
            Connections {
                target: id_test
                function onStrTestChanged() {
                    console.log("Text::onStrTestChanged", id_test.strTest)
                }
                function onStrMemberTestChange() {
                    console.log("Text::onStrMemberTestChange", id_test.strMemberTest)
                }
            }
            text: id_test.strTest
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                property string tmp
                onClicked: {
                    tmp = id_test.strMemberTest
                    id_test.strMemberTest = id_test.strTest //用MEMBER关键字声明的变量，改变时，会自动调用NOTIFY函数
                    id_test.strTest = tmp //用READ,WRITE声明的变量，需要在WRITE函数里面手动调用NOTIFY函数，qml中才能收到更新
                    //id_test.setStrTest(tmp)
                }
            }
        }


        //Animation
        Rectangle {
            id: test_animation
            visible: false
            anchors {
                right: parent.right
                top: test_connect.bottom
                topMargin: 20
            }
            width: 200; height: 200
            Image {
                id: sunkist
                anchors.fill: parent
                source: "qrc:/sk_730.png"
            }
//            SequentialAnimation {
//                NumberAnimation {
//                    target: sunkist; properties: "scale"
//                    from: 0.0; to: 1.0; duration: 1000
//                }
//                PauseAnimation {
//                    duration: 1000
//                }
//                NumberAnimation {
//                    target: sunkist; properties: "scale"
//                    from: 1.0; to: 0.5; duration: 1000
//                }
//                NumberAnimation {
//                    target: sunkist; property: "scale"
//                    from: 0.5; to: 0.0; duration: 1000
//                    //easing.type: Easing.InOutQuad
//                }
//                running: true
//            }
            ParallelAnimation {
                NumberAnimation {
                    target: sunkist; properties: "scale"
                    from: 0.5; to: 1.0; duration: 1000
                }
                NumberAnimation {
                    target: sunkist; property: "opacity" //不透明度
                    from: 0.0; to: 1.0; duration: 1000
                    //easing.type: Easing.InOutQuad
                }
                running: test_animation.visible
            }
        }


        //Toast
//        ToastPage {
//        }
    }
}
