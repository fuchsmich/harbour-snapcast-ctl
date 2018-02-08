import QtQuick 2.0
import org.nemomobile.dbus 2.0
// http://nemo-qml-plugin-dbus.readthedocs.io/en/latest/

Item {
    property alias activeState: iface.activeState
    property alias subState: iface.subState

    Timer {
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered: {
            iface.getProps();
        }
    }

    DBusInterface {
        id: iface

        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1/unit/avahi_2ddaemon_2esocket"
        iface: "org.freedesktop.systemd1.Unit"
        bus: DBus.SystemBus
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
}
