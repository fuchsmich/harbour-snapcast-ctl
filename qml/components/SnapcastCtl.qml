import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property var serverStatus: {}

    property string sn: ""

    property var request: {
        "id": 1,
                "jsonrpc": "2.0",
                "method": "Server.GetRPCVersion"
    }

    property var responseFunc: []


    function reqServerStatus() {
        request.method = "Server.GetStatus";
        doRequest(JSON.stringify(request));
        responseFunc[request.id] =  parseStatus;
    }

    function parseStatus(json) {
        serverStatus = json;
        sn = json.result.server.server.host.name
    }

    function doRequest(json) {
        call('mysnapctl.controller.doRequest', [json], function() {});
        request.id += 1;
    }

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('response', function(response){
            console.log(response);
            var respObj = JSON.parse(response);
            console.log(respObj.id)
            responseFunc[respObj.id](respObj);
        });
        importModule('mysnapctl', function() {});
        //        call('mysnapctl.controller.status', function() {})

        doRequest(JSON.stringify(request));
        serverStatus();
    }

    onReceived: { console.log("Event: " + data) }

    onError: console.log('Python error: ' + traceback)
}
