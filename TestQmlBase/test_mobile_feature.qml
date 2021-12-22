import QtQuick 2.0

Item {
    //Flickable for mobile device
    Flickable { //滑动
        id: test_flick
        anchors {
            top: test_transform.bottom
            topMargin: 20
        }
        visible: true
        width: 100
        height: 100
        contentWidth: 200
        contentHeight: 200

        PinchArea { //缩放
            //anchors.fill: parent
            width: Math.max(test_flick.width, test_flick.contentWidth)
            height: Math.max(test_flick.width, test_flick.contentHeight)

            //pinch.target: id_image
            Image {
                id: id_image
                width: parent.contentWidth
                height: parent.contentHeight
                source:"qrc:/sk_730.png"
            }

//                pinch.maximumScale: 1.0
//                pinch.minimumScale: 0.1
//                pinch.dragAxis: Pinch.XAndYAxis
            property real initialWidth
            property real initialHeight
            onPinchStarted:  {
                initialWidth = test_flick.contentWidth
                initialHeight = test_flick.contentHeight
            }
            onPinchUpdated: {
                test_flick.resizeContent(initialWidth*pinch.scale, initialHeight*pinch.scale, pinch.center)
            }
            onPinchFinished: test_flick.returnToBounds()
        }

    }


    MultiPointTouchArea { //多点触控
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 3
        touchPoints: [
            TouchPoint {id: touch1},
            TouchPoint {id: touch2},
            TouchPoint {id: touch3}
        ]
        Rectangle {
            width:50; height: 50; radius: 25
            x:touch1.x-width/2; y:touch1.y-height/2
            visible: touch1.pressed
            color: "cyan"
        }
        Rectangle {
            width:100; height: 100
            x:touch2.x-width/2; y:touch2.y-height/2
            color: "red"
        }
        Rectangle {
            width:200; height: 200
            x:touch3.x-width/2; y:touch3.y-height/2
            color: "green"
        }
    }

}
