import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property var server: {
        "status": false,
        "getRPCVersion": function () {
            var r = request;
            r.method = "Server.GetRPCVersion"
            doRequest(r);
        },
        "getStatus": function () {
            var r = request;
            r.method = "Server.GetStatus"
            doRequest(r);
        },
        "deleteClient": function (id) {
            var r = request;
            r.method = "Server.DeleteClient"
            r['params'] = {
                "id": id
            }
            doRequest(r);
        }
    }

    property var client: {
        "getStatus": function (client) {
            var r = request;
            r.method = "Client.GetStatus"
            r['params'] = {
                "id": client.id
            }
            doRequest(r);
        },
        "setVolume": function (client, muted, vol) {
            var r = request;
            r.method = "Client.SetVolume"
            var newVolume = client.config.volume;
            newVolume.percent = vol;
            newVolume.muted = muted;
            r['params'] = {
                "id": client.id,
                "volume": newVolume
            }
            doRequest(r);
        },
        "setMuted": function (client, muted) {
            var vol = client.config.volume.percent;
            py.client.setVolume(client, muted, vol)
        },
        "setLatency": function (client, latency) {
            var r = request;
            r.method = "Client.SetLatency";
            var l = Number.fromLocaleString(Qt.locale(), latency)
            r['params'] = {
                "id": client.id,
                "latency": l
            }
            doRequest(r);
        },
        "setName": function (client, name) {
            var r = request;
            r.method = "Client.SetName"
            r['params'] = {
                "id": client.id,
                "name": name
            }
            doRequest(r);
        },
        "getFriendlyName": function (client) {
            return (client.config.name === "" ? client.host.name : client.config.name)
        }
    }


    property var group: {
        "getStatus": function (group) {
            var r = request;
            r.method = "Group.GetStatus"
            r['params'] = {
                "id": group.id
            }
            doRequest(r);
        },
        "volume": function (group) {
            var gvol = 0;
            for (var i = 0; i < group.clients.length; i++) {
                gvol += group.clients[i].config.volume.percent;
            }
            return gvol/group.clients.length;
        },
        "setVolume": function (group, vol) {
            var oldvol = py.group.volume(group);
            for (var i = 0; i < group.clients.length; i++) {
                var newvol = Math.floor(group.clients[i].config.volume.percent/oldvol*vol);
                py.client.setVolume(group.clients[i], group.clients[i].config.volume.muted, newvol)
            }
        },
        "setMuted": function (group, muted) {
            var r = request;
            r.method = "Group.SetMute"
            r['params'] = {
                "id": group.id,
                "mute": muted
            }
            doRequest(r);
        },
        "setStream": function (group, stream_id) {
            var r = request;
            r.method = "Group.SetStream"
            r['params'] = {
                "id": group.id,
                "stream_id": stream_id
            }
            doRequest(r);
        },
        "setClients": function (group, clients) {
            var r = request;
            r.method = "Group.SetClients"
            r['params'] = {
                "id": group.id,
                "clients": clients
            }
            doRequest(r);
        }
    }

    property bool connected: false
    onConnectedChanged: {
        if (connected) server.getStatus();
        else server.status = false;
    }

    property var serverStatus: false
    property string serverString:
        (connected  ? serverStatus.server.server.host.name : "")

    function getClient(id, status) {
        var groups = serverStatus.server.groups;
        console.log(id);
        for (var i=0; i < groups.length; i++) {
            for (var j=0; j < groups[i].clients.length; j++) {
                if (groups[i].clients[j].id === id) return groups[i].clients[j];
            }
        }
        return false;
    }

    property string log: ""

    property var request: {
        "id": 0,
                "jsonrpc":"2.0",
                "method":""
    }

    property var responseHandler: {
        "Server.GetStatus": function (status) {
            server.status = status;
            serverStatus = status;
        } ,
        "Client.SetVolume": function () {
            py.server.getStatus();
        }
    }

    property var requestQueue: []



    function connect() {
        call('snapcontroller.connect', [settings.host, settings.controlPort], function() {});
    }
    
    function doRequest(request) {
        requestQueue[request.id] = request;
        call('snapcontroller.doRequest', [JSON.stringify(request)], function() {});
        py.request['id'] = py.request['id'] + 1;
    }


    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('response', function(response){
            //console.log(response);
            var jresponse = JSON.parse(response);
            //responses to requests
            if (jresponse.result && jresponse.id in requestQueue) {
                var requestedMethod = requestQueue[jresponse.id].method
                console.log("Got response to " + requestedMethod)
                if (typeof responseHandler[requestedMethod] == "function")
                    responseHandler[requestedMethod](jresponse.result);
                else {
                    console.log("no responseHandler function for " + requestedMethod)
                    //remove request from queue
                    py.server.getStatus();
                }
            }
            //notifications
            if (jresponse.method) {
                py.server.getStatus();
            }
        });
        setHandler('connected', function(status){
            py.connected = status;
        });
        importModule('snapcontroller', function() {});
        connect();
    }

    onReceived: {
        console.log("Event: " + data);
        log = data.toString();
    }

    onError: console.log('Python error: ' + traceback)
}
