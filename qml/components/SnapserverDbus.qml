import QtQuick 2.0
import org.nemomobile.dbus 2.0
// http://nemo-qml-plugin-dbus.readthedocs.io/en/latest/

DBusInterface {
    id: iface

    service: "org.freedesktop.systemd1"
    path: "/org/freedesktop/systemd1/unit/snapserver_2eservice"
    iface: "org.freedesktop.systemd1.Unit"
    bus: DBus.SessionBus
//    signalsEnabled: true

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
