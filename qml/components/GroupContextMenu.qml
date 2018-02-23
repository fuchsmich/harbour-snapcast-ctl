import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    Repeater {
        model: 3
        TextSwitch {
            text: "Option 1"
            onClicked: console.log("Clicked Option 1")
        }
    }
}
