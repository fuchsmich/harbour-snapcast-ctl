import QtQuick 2.0
import io.thp.pyotherside 1.4

Python {
    id: py

    property bool connected: false

    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('../python'));
        setHandler('response', function(response){
            console.log(response);
        });
        importModule('mysnapctl', function() {});
    }

    onReceived: { console.log("Event: " + data) }

    onError: console.log('Python error: ' + traceback)
}
