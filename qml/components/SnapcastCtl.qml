import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property bool connected: false
    property var serverStatus: false
    property string serverString:
        (connected ? serverStatus.server.server.host.name : "")

    property var groups: (connected ? serverStatus.server.groups : [])

    property string log: ""

    function getServerStatus() {
        call('snapcontroller.serverStatus', function() {});
    }

    function connect() {
        call('snapcontroller.mon', function() {});
    }

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('serverStatus', function(status){
            console.log(JSON.stringify(status))
            py.serverStatus = status;
        });
        setHandler('connected', function(status){
            py.connected = status;
        });
        importModule('snapcontroller', function() {});
    }

    onReceived: {
        console.log("Event: " + data);
        log = data.toString();
    }

    onError: console.log('Python error: ' + traceback)
}
