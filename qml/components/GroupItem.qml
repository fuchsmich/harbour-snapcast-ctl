import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: gItem
    property var group
    property int gIndex
    property Item contextMenu
    property bool menuOpen: contextMenu != null && contextMenu.parent === gItem
    height: gLbl.height + cRow.height + (menuOpen ? contextMenu.height : 0)
    Label {
        id: gLbl
        anchors {
            left: parent.left
            verticalCenter: gSetBtn.verticalCenter
            right: gSetBtn.left
        }
        //width: gItem.width - gSetBtn.width
        text: (group.name === "" ? group.stream_id : group.name)
        truncationMode: TruncationMode.Elide
        color: Theme.highlightColor
    }
    IconButton {
        id: gSetBtn
        anchors.right: parent.right
        icon.source: "image://theme/icon-m-developer-mode"
        onClicked: pageStack.push(Qt.resolvedUrl("GroupConfig.qml"), {gIndex: gItem.gIndex})
    }
    Row{
        id: cRow
        anchors.top: gLbl.bottom
        anchors.left: parent.left
        anchors.right: gSetBtn.left
        IconButton {
            id: spkrBtn
            icon.source: "image://theme/icon-m-speaker" +
                         (group.muted ? "-mute" : "")
            onClicked: snapcastCtl.group.setMuted(group, !group.muted);
        }
        Slider {
            width: cRow.width - spkrBtn.width
            minimumValue: 0
            maximumValue: 100
            stepSize: 1
            value: snapcastCtl.group.volume(group)
            onDownChanged: {
                if (!down) snapcastCtl.group.setVolume(group, value);
            }
        }
    }
}
