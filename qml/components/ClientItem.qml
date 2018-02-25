import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: litem
    property var client: group.clients[model.index]
    property Item contextMenu
    property bool menuOpen: contextMenu != null && contextMenu.parent === item
    enabled: false
    contentHeight: item.height
    Item {
        id: item
        x: Theme.horizontalPageMargin
        width: parent.width - 2*Theme.horizontalPageMargin
        height: cLbl.height + cRow.height + (menuOpen ? contextMenu.height : 0)
        Label {
            id: cLbl
            anchors.top: item.top
            text: client.host.name
            truncationMode: TruncationMode.Elide
            color: client.connected ? Theme.primaryColor : Theme.secondaryColor
        }
        IconButton {
            id: cSetBtn
            //anchors.top: item.top
            anchors.verticalCenter: cRow.verticalCenter
            anchors.right: item.right
            icon.source: "image://theme/icon-m-developer-mode"
            onClicked: {
                if (!contextMenu) {
                    var contextMenuComp = Qt.createComponent("ClientContextMenu.qml");
                    contextMenu = contextMenuComp.createObject(litem);
                }
                contextMenu.show(item)
            }
        }

        Row{
            id: cRow
            anchors.top: cLbl.bottom
            anchors.left: parent.left
            anchors.right: cSetBtn.left
            IconButton {
                id: spkrBtn
                icon.source: "image://theme/icon-m-speaker" +
                             (client.config.volume.muted ? "-mute" : "")
                onClicked: snapcastCtl.client.setMuted(client, !client.config.volume.muted);//setClientMute(client, !client.config.volume.muted)
            }
            Slider {
                width: cRow.width - spkrBtn.width
                minimumValue: 0
                maximumValue: 100
                stepSize: 1
                value: client.config.volume.percent
                onDownChanged: {
                    if (!down) snapcastCtl.client.setVolume(client, client.config.volume.muted, value);//setClientVolume(client, value)
                }
            }
        }
    }
}
