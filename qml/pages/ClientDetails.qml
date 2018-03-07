import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

//TODO refresh after update

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
                description: qsTr("Hostname: %1").arg(client.host.name)
            }

            //Name
            EditableDetailItem {
                label: qsTr("Name")
                value: client.config.name
                onValueSubmitted: {
                    console.log(value);
                    snapcastCtl.client.setName(client, value);
                }
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
            }

            //Latenz
            EditableDetailItem {
                label: qsTr("Latency")
                value: client.config.latency
                onValueSubmitted: {
                    console.log(value);
                    snapcastCtl.client.setLatency(client, value);
                }
                inputMethodHints: Qt.ImhDigitsOnly
            }
            //MAC
            DetailItem {
                label: qsTr("MAC")
                value: client.host.mac
            }
            //ID
            DetailItem {
                label: qsTr("ID")
                value: client.id
            }
            //IP
            DetailItem {
                label: qsTr("IP-Address")
                value: client.host.ip
            }
            //Host
            //DetailItem {
            //    label: qsTr("Host")
            //    value: client.host.name
            //}
            //Betriebssystem
            DetailItem {
                label: qsTr("OS")
                value: client.host.os
            }
            //Version
            DetailItem {
                label: qsTr("Version")
                value: client.snapclient.version
            }
            //Zuletzt gesehen
            DetailItem {
                label: qsTr("Host")
                value: client.connected ? qsTr("connected") :
                                                 Date(client.lastSeen.sec*1000).toLocaleString()
            }

        }
    }
}
