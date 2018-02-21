import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property bool connected: false
    property var serverStatus: false
    property string serverString:
        (snapcastCtl.serverStatus ? snapcastCtl.serverStatus.server.server.host.name : "")


    property string log: ""

    function getServerStatus() {
        call('snapcontroller.serverStatus', function() {});
    }

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('serverStatus', function(status){
            console.log(JSON.stringify(status))
            py.serverStatus = status;
        });
        importModule('snapcontroller', function() {});
    }

    onReceived: {
        console.log("Event: " + data);
        log = data.toString();
    }

    onError: console.log('Python error: ' + traceback)
}
