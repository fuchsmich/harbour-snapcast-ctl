import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All
    property var groups: snapcastCtl.serverStatus.server.groups
    property int gIndex

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Group")
            }
            SectionHeader {
                text: qsTr("Stream")
            }
            ListItem {
                width: parent.width
                Label {
                    x: Theme.horizontalPageMargin
                    text: groups[gIndex].stream_id
                }
                menu: ContextMenu {
                    Repeater {
                        model: groups
                        MenuItem {
                            text: groups[model.index].stream_id
                        }
                    }
                }
            }

            SectionHeader {
                text: qsTr("Clients")
            }
            Repeater {
                model: groups
                Column {
                    property int curGroupIndex: model.index
                    width: column.width
                    Repeater {
                        model: groups[gIndex].clients
                        TextSwitch {
                            property var client: groups[gIndex].clients[model.index]
                            text: client.host.name
                            checked: gIndex === curGroupIndex
                        }
                    }
                }
            }
        }
    }
}

