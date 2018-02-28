import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

//Name
//Latenz
//MAC
//ID
//IP
//Host
//Betriebssystem
//Version
//Zuletzt gesehen

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

            EditableDetailItem {
                label: qsTr("Name")
                value: client.config.name
                onValueSubmitted: {
                    console.log(value);
                    snapcastCtl.client.setName(client, value);
                }
                inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
            }

            EditableDetailItem {
                label: qsTr("Latency")
                value: client.config.latency
                onValueSubmitted: {
                    console.log(value);
                    snapcastCtl.client.setLatency(client, value);
                }
                inputMethodHints: Qt.ImhDigitsOnly
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
