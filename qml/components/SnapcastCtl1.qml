import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property bool connected: false
    onConnectedChanged: {
        if (connected) getServerStatus();
        else serverStatus = false;
    }

    property var serverStatus: false
    property string serverString:
        (connected && serverStatus.server ? serverStatus.server.server.host.name : "")

    property string log: ""

    property var request: {
        "id": 0,
                "jsonrpc":"2.0",
                "method":""
    }

    property var responseHandler: {
        "Server.GetStatus": function (status) {
            serverStatus = status;
        } ,
        "Client.SetVolume": function () {
            getServerStatus();
        }
    }

    property var requestQueue: []

    function getServerStatus() {
        var r = request;
        r.method = "Server.GetStatus"
        doRequest(r);
    }

    function connect() {
        call('snapcontroller1.connect', function() {});
    }
    
    function setClientMute(client, value) {
        var r = request;
        r['method'] = "Client.SetVolume";
        var id = client.id;
        var newVolume = client.config.volume;
        newVolume.muted = value;
        var p = {
            "id": id,
            "volume": newVolume
        };
        r['params'] = p;
        doRequest(r);
    }

    function setClientVolume(client, value) {
        var r = request;
        r['method'] = "Client.SetVolume";
        var id = client.id;
        var newVolume = client.config.volume;
        newVolume.percent = value;
        var p = {
            "id": id,
            "volume": newVolume
        };
        r['params'] = p;
        doRequest(r);
    }

    function doRequest(request) {
        requestQueue[request.id] = request;
        call('snapcontroller1.doRequest', [JSON.stringify(request)], function() {});
        py.request['id'] = py.request['id'] + 1;
    }


    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('response', function(response){
            var jresponse = JSON.parse(response);
            if (jresponse.result) {
                var requestedMethod = requestQueue[jresponse.id].method
                console.log("Got response to " + requestedMethod)
                responseHandler[requestedMethod](jresponse.result);
            }
        });
        setHandler('connected', function(status){
            py.connected = status;
        });
        importModule('snapcontroller1', function() {});
    }

    onReceived: {
        console.log("Event: " + data);
        log = data.toString();
    }

    onError: console.log('Python error: ' + traceback)
}
