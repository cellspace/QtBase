import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import ToDo 1.0

ColumnLayout {
    Frame {
        Layout.fillWidth: true

        ListView {
            id: id_listview
            implicitWidth: 250
            implicitHeight: 250
            clip: true //any item outside of the viewwill not be visible
            anchors.fill: parent

            //        model: ListModel { //100 //cache count
            //            ListElement {
            //                description: "first item"
            //                selected : true
            //            }
            //            ListElement {
            //                description: "second item"
            //                selected : false
            //            }
            //        }
            //use c++ model to replace origin model
            model: ToDoModel {
                list: toDoList
            }

            delegate:  RowLayout {
                width: id_listview.width
                TextField {
                    Layout.fillWidth: true
                    text: model.description
                    onEditingFinished: model.description = text
                }
                CheckBox {
                    checked: model.selected //connected model info to this checkbox
                    onClicked: model.selected = checked
                }
            }

        }
    }
    RowLayout {
        Button {
            text: qsTr("Add new item")
            onClicked: toDoList.appendItem()
            Layout.fillWidth: true
        }
        Button {
            text: qsTr("Remove Completed")
            onClicked: toDoList.removeCompletedItems()
            Layout.fillWidth: true
        }
        Button {
            text: qsTr(toDoList.btnText)
            onClicked: toDoList.selDeselButtonClicked(text.toString())
            Layout.fillWidth: true
        }

    }
}
