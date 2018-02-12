import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"
import io.thp.pyotherside 1.4


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
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader { title: qsTr("Snapcast") }

            Button {
                width: Theme.buttonWidthLarge
                text: "POST"
                onClicked: python.request()
            }

            TextArea {
                id: ta
                width: parent.width
            }
        }
    }

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            setHandler('response', function(response){
                console.log(response);
            });
            importModule('testClient', function() {});
        }

        function request() {
            call('testClient.test', function() {});
        }
    }
}

