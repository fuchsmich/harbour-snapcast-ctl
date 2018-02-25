import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

//    acceptDestinationAction: PageStackAction.Pop

    allowedOrientations: Orientation.All
    property var groups: snapcastCtl.serverStatus.server.groups
    property var streams: snapcastCtl.serverStatus.server.streams
    property int gIndex
    property var clientList: []

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
                        model: streams
                        MenuItem {
                            text: streams[model.index].id
                            onClicked: snapcastCtl.group.setStream(groups[gIndex], streams[model.index].id)
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
                        model: groups[curGroupIndex].clients
                        TextSwitch {
                            property var client: groups[curGroupIndex].clients[model.index]
                            text: client.host.name
                            checked: gIndex === curGroupIndex
                            onCheckedChanged: {
                                var clientListIndex = clientList.indexOf(client.id)
                                if (checked) {
                                    if ( clientListIndex === -1) clientList.push(client.id);
                                } else clientList.splice(clientListIndex, 1);
                            }

                            onClicked: {
                                console.log("sending client list", clientList)
                                snapcastCtl.group.setClients(groups[gIndex], clientList)
                            }
                        }
                    }
                }
            }
        }
    }
}

