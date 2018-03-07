import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    property var client
    function remove() {
        remorseAction(qsTr("Deleting"), function() { snapcastCtl.removeClient()})
    }
    MenuItem {
        text: qsTr("Details")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/ClientDetails.qml" ), {"clientID": client.id })
    }
    MenuItem {
        visible: !client.connected
        text: qsTr("Delete")
        onClicked: remove()
    }
}
