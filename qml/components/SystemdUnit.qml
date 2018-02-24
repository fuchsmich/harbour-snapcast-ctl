import QtQuick 2.0
//import Nemo.DBus 2.0
import org.nemomobile.dbus 2.0

DBusInterface {
// http://nemo-qml-plugin-dbus.readthedocs.io/en/latest/
    id: iface

    property Timer timer: Timer {
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered: {
            iface.getProps();
        }
    }
    service: "org.freedesktop.systemd1"
    path: "/org/freedesktop/systemd1/unit/avahi_2ddaemon_2esocket"
    iface: "org.freedesktop.systemd1.Unit"
    bus: DBus.SessionBus

    property string activeState: getProperty("ActiveState")
    property string subState: getProperty("SubState")

    function getProps() {
        //        console.debug("getProps")
        activeState = getProperty("ActiveState")
        subState = getProperty("SubState")
    }

    function toggleUnit() {
        getProps();
        if (activeState == "active") call("Stop", ["replace"]);
        if (activeState == "inactive") call("Start", ["replace"]);
    }
}
