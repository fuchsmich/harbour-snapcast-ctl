import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    allowedOrientations: Orientation.All

    property var client

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Details")
            }

            Item {
                id: cItem
                width: column.width
                height: content.height
                property Component content: detComp

                Loader {
                    width: parent.width
                    sourceComponent: cItem.content
                }

                Component{
                    id: detComp
                    BackgroundItem {
                        width: cItem.width
                        DetailItem {
                            anchors.verticalCenter: cItem.verticalCenter
                            label: qsTr("Name")
                            value: client.host.name
                        }
                        onClicked: cItem.state = "edit"
                    }
                }
                Component {
                    id: editComp
                    TextField {
                        width: parent.width
                    }
                }

                states: [
                    State {
                        name: "show"
                        PropertyChanges {
                            target: cItem
                            content: detComp
                        }
                    },
                    State {
                        name: "edit"
                        PropertyChanges {
                            target: cItem
                            content: editComp
                        }
                    }
                ]
            }
            DetailItem {
                label: qsTr("Volume")
                value: client.config.volume.percent
            }
            DetailItem {
                label: qsTr("Muted")
                value: client.config.volume.muted ? qsTr("Yes") : qsTr("No")
            }
            DetailItem {
                label: qsTr("Connected")
                value: client.config.connected ? qsTr("Yes") : qsTr("No")
            }
            DetailItem {
                label: qsTr("IP-Address")
                value: client.host.ip
            }
            DetailItem {
                label: qsTr("MAC-Address")
                value: client.host.mac
            }
            DetailItem {
                label: qsTr("Snapclient-Version")
                value: client.snapclient.version
            }
        }
    }
}
