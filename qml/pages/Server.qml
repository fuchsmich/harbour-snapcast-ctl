import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
//import io.thp.pyotherside 1.4
import QtQuick.Layouts 1.1


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
                id: gRep
                property var groups: (snapcastCtl.serverStatus ? snapcastCtl.serverStatus.server.groups : [])
                model: groups
                Column {
                    id: gCol
                    property var group: gRep.groups[model.index]
                    width: column.width
                    Row {
                        id: gItem
                        x: Theme.horizontalPageMargin
                        width: column.width - 2*Theme.horizontalPageMargin
                        Label {
                            id: gLbl
                            width: gItem.width - gSetBtn.width
                            text: "Group: " +
                                  group.stream_id
                            truncationMode: TruncationMode.Elide
                        }
                        IconButton {
                            id: gSetBtn
                            icon.source: "image://theme/icon-m-developer-mode"
                        }
                    }
                    Repeater {
                        model: group.clients
                        Item {
                            id: cItem
                            property var client: group.clients[model.index]
                            x: Theme.horizontalPageMargin
                            width: column.width - 2*Theme.horizontalPageMargin
                            height: cLbl.height + cRow.height
                            Label {
                                id: cLbl
                                anchors.top: cItem.top
                                text: "Client: " + client.host.name
                                color: client.connected ? Theme.primaryColor : Theme.secondaryColor
                            }
                            IconButton {
                                id: cSetBtn
                                anchors.top: cItem.top
                                anchors.right: cItem.right
                                icon.source: "image://theme/icon-m-developer-mode"
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
                                    onClicked: snapcastCtl.setClientMute(client, !client.config.volume.muted)
                                }
                                Slider {
                                    width: cRow.width - spkrBtn.width
                                    minimumValue: 0
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
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
            }
        }
    }
}

