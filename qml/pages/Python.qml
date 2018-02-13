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
                text: "Test Request"
                onClicked: python.testRequest()
            }

            Button {
                width: Theme.buttonWidthLarge
                text: "Server.GetStatus"
                onClicked: python.sendRequest()
            }

            TextArea {
                id: ta
                width: parent.width
            }
        }
    }

    Python {
        id: python
        property var request: {
            "id": 1,
                    "jsonrpc": "2.0",
                    "method": "Server.GetStatus"
        }

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            setHandler('response', function(response){
                console.log(response);
                console.log(JSON.parse(response));

            });
            importModule('testClient', function() {});
//            call('testClient.init', function() {})
        }

        Component.onDestruction: {
            call('testClient.dest', function() {})
        }

        onReceived: { console.log("Event: " + data) }

        onError: console.log('Python error: ' + traceback)

        function sendRequest() {
            console.log(JSON.stringify(request))
            call('testClient.doRequest', [JSON.stringify(request)] , function() {});
            request.id += 1;
        }

        function testRequest() {
            call('testClient.test', function() {});
        }
    }
}

