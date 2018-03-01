import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: edi
    width: parent.width
    height: loader.height //Theme.itemSizeLarge
    property Component content: detailItemComp

    property string label: ""
    property string value: ""
    property int inputMethodHints: 0

    signal valueSubmitted(string value);

    Loader {
        id: loader
//        width: parent.width
//        height: parent.height
        sourceComponent: edi.content
    }

    Component{
        id: detailItemComp
        BackgroundItem {
            width: edi.width
            height: detailItem.height
            MyDetailItem {
                id: detailItem
                anchors.verticalCenter: parent.verticalCenter
                label: edi.label
                value: edi.value
                valueColor: Theme.primaryColor
            }
            onClicked: edi.state = "edit"
        }
    }
    Component {
        id: editComp
        TextField {
            id: tf
            width: edi.width
            text: edi.value
            label: edi.label
            focus: true
            EnterKey.onClicked:  {
                valueSubmitted(tf.text);
                edi.state = "show";
            }
            onActiveFocusChanged: {
                if (!activeFocus) edi.state = "show";
            }

            inputMethodHints: edi.inputMethodHints

//            property Timer focusTimer: Timer {
//                                interval: 200
//                                repeat: false
//                                onTriggered: {
//                                    tf.forceActiveFocus();
//                                }
//            }
            Component.onCompleted: console.log(typeof inputMethodHints, inputMethodHints)
        }
    }

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: edi
                content: detailItemComp
                height: loader.item.height
            }
        },
        State {
            name: "edit"
            PropertyChanges {
                target: edi
                content: editComp
                height: loader.item.height
            }
            StateChangeScript {
                script: {
                    loader.item.forceActiveFocus()
                }
            }
        }
    ]
}
