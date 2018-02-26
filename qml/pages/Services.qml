import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
//        PullDownMenu {
//            MenuItem {
//                text: qsTr("Show Page 2")
//                onClicked: pageStack.push(Qt.resolvedUrl("Python.qml"))
//            }
//        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader { title: qsTr("Snapcast") }

            SectionHeader { text: qsTr("Snapclient") }
            UnitRow { unit: snapclientUserService }

            SectionHeader { text: qsTr("Snapserver (User)") }
            UnitRow { unit: snapserverUserService }
            UnitRow { unit: snapserverUserSocket }

//            SectionHeader { text: qsTr("Snapserver (System)") }
//            UnitRow { unit: snapserverSystemService }
//            UnitRow { unit: snapserverSystemSocket }

            SectionHeader { text: qsTr("Avhai") }
            UnitRow { unit: avahiService }
            UnitRow { unit: avahiSocket }

        }
    }
}

