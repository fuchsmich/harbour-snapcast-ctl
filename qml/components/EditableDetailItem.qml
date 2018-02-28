import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: edi
    width: column.width
    height: Theme.itemSizeLarge
    property Component content: detailItemComp

    property string label: ""
    property string value: ""
    property int inputMethodHints: 0

    signal valueSubmitted(string value);

    Loader {
        id: loader
        width: parent.width
        height: parent.height
        sourceComponent: edi.content
    }

    Component{
        id: detailItemComp
        BackgroundItem {
            DetailItem {
                anchors.verticalCenter: parent.verticalCenter
                label: edi.label
                value: edi.value
            }
            onClicked: edi.state = "edit"
        }
    }
    Component {
        id: editComp
        TextField {
            id: tf
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
            }
        },
        State {
            name: "edit"
            PropertyChanges {
                target: edi
                content: editComp
            }
            StateChangeScript {
                script: {
                    loader.item.forceActiveFocus()
                }
            }
        }
    ]
    Component.onCompleted: console.log(typeof Qt.ImhDigitsOnly)
}
