import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
//import io.thp.pyotherside 1.4


Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Services")
                onClicked: pageStack.push(Qt.resolvedUrl("Services.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Snapcast")
                description: qsTr("Server: ") + snapcastCtl.serverString

            }

            SectionHeader {
                text: qsTr("Server")
            }
            Button {
                text: "connect"
                enabled: !snapcastCtl.connected
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: snapcastCtl.connect()
            }
            Button {
                text: "get status"
//                enabled: snapcastCtl.connected
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: snapcastCtl.getServerStatus()
            }
            SectionHeader {
                text: "Groups"
            }
            Repeater {
                model: snapcastCtl.groups
                Column {
                    id: gCol
                    property var group: snapcastCtl.groups[model.index]
                    width: column.width
                    BackgroundItem {
                        width: column.width
                        Label {
                            text: "Group: " +
                                  group.stream_id
                        }
                    }
                    Repeater {
                        model: group.clients
                        BackgroundItem {
                            id: cItem
                            property var client: group.clients[model.index]
                            width: column.width
                            Row {
                                Label {
                                    text: "Client: " + client.host.name
                                    color: client.connected ? Theme.primaryColor : Theme.secondaryColor
                                }
                                IconButton {
                                    icon.source: "image://theme/icon-m-speaker" +
                                                 (client.config.volume.muted ? "mute" : "")
                                    onClicked: snapcastCtl.setClientMute(client, !client.config.volume.muted)
                                }
                                Slider {
                                    width: cItem.width/4
                                    maximumValue: 100
                                    value: client.config.volume.percent
                                }
                            }
                        }
                    }
                }
            }

            SectionHeader {
                text: "log"
            }
            TextArea {
                readOnly: true
                text: snapcastCtl.log
                width: parent.width
            }
        }
    }
}

