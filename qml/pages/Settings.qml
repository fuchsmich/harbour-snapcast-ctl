import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Settings")
            }
            TextField {
                id: hostTxt
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                text: settings.host
                label: qsTr("Hostname")
            }
            TextField {
                id: streamTxt
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                text: settings.streamPort
                label: qsTr("Stream-Port")
            }
            TextField {
                id: controlTxt
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                text: settings.controlPort
                label: qsTr("Control-Port")
            }
            TextSwitch {
                id: autostartSwitch
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                checked: settings.autostartClient
                text: qsTr("Autostart Snapclient")
            }
        }
    }
    Component.onDestruction: {
        settings.host = hostTxt.text
        settings.streamPort = streamTxt.text
        settings.controlPort = controlTxt.text
        settings.autostartClient = autostartSwitch.checked
    }
}
