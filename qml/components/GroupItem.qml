import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: gItem
    property var group
    property Item contextMenu
    property bool menuOpen: contextMenu != null && contextMenu.parent === gItem
    height: Math.max(gLbl.height, gSetBtn.height) + (menuOpen ? contextMenu.height : 0)
    Label {
        id: gLbl
        anchors {
            left: parent.left
            verticalCenter: gSetBtn.verticalCenter
            right: gSetBtn.left
        }
        //width: gItem.width - gSetBtn.width
        text: (group.name !== "" ? group.stream_id : group.name)
        truncationMode: TruncationMode.Elide
        color: Theme.highlightColor
    }
    IconButton {
        id: gSetBtn
        anchors.right: parent.right
        icon.source: "image://theme/icon-m-developer-mode"
        onClicked: {
            if (!contextMenu) {
                var contextMenuComp = Qt.createComponent("GroupContextMenu.qml");
                contextMenu = contextMenuComp.createObject(column);
            }
            contextMenu.show(gItem)
        }
    }
}
