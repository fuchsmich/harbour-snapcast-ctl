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
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: snapcastCtl.call('snapcontroller.mon', function() {})
            }
            Button {
                text: "status"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: snapcastCtl.getServerStatus()
            }
            TextArea {
                readOnly: true
                text: snapcastCtl.log
                width: parent.width
            }
        }
    }
}

