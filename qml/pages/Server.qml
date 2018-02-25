import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
//import io.thp.pyotherside 1.4
//import QtQuick.Layouts 1.1


Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

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
                enabled: snapcastCtl.connected
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: snapcastCtl.server.getStatus()
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
}

