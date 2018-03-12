import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

//TODO client start/stop?

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: flick
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Services")
                onClicked: pageStack.push(Qt.resolvedUrl("Services.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Connect")
                visible: !snapcastCtl.connected
                onClicked: snapcastCtl.connect()
            }
        }

//        contentHeight: column.height
        Loader {
            id: contentLoader
//            width: parent.width
        }

        Component {
            id: placeholderComp
            ViewPlaceholder {
                enabled: true
                text: "not connected"
                hintText: "set the server address and/or connect."
            }
        }

        Component {
            id: connectingComp
            BusyIndicator {
                    size: BusyIndicatorSize.Large
                    anchors.centerIn: parent
                    running: true
                }
        }

        Component {
            id: contentComp
        Column {
            id: column
//            visible: snapcastCtl.connected
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Snapcast")
                description: qsTr("Server: ") + snapcastCtl.serverString

            }

//            SectionHeader {
//                text: qsTr("Server")
//            }
//            Button {
//                text: "connect"
//                enabled: !snapcastCtl.connected
//                anchors.horizontalCenter: parent.horizontalCenter
//                onClicked: snapcastCtl.connect()
//            }
//            Button {
//                text: "get status"
//                enabled: snapcastCtl.connected
//                anchors.horizontalCenter: parent.horizontalCenter
//                onClicked: snapcastCtl.server.getStatus()
//            }
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
                    GroupItem {
                        group: parent.group
                        gIndex: model.index
                        x: Theme.horizontalPageMargin
                        width: column.width - 2*Theme.horizontalPageMargin
                    }

                    Repeater {
                        model: group.clients
                        ClientItem {
                            client: group.clients[model.index]
                            width: column.width
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

        states: [
            State {
                name: "notConnected"
                when: !snapcastCtl.connected && !snapcastCtl.connecting
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: placeholderComp
                }
            },
            State {
                name: "connecting"
                when: snapcastCtl.connecting
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: contentComp
                }
            },
            State {
                name: "connected"
                when: snapcastCtl.connected && !snapcastCtl.connecting
                PropertyChanges {
                    target: contentLoader
                    sourceComponent: contentComp
                }
                PropertyChanges {
                    target: flick
                    contentHeight: contentLoader.item.height
                }
            }
        ]
    }
}

