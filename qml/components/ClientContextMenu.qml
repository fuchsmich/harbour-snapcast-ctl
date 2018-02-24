import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    function remove() {
        remorseAction(qsTr("Deleting"), function() { snapcastCtl.removeClient()})
    }
    MenuItem {
        text: qsTr("Details")
        onClicked: pageStack.push(Qt.resolvedUrl("ClientDetails.qml"))
    }
    MenuItem {
        text: qsTr("Delete")
        onClicked: remove()
    }
}
