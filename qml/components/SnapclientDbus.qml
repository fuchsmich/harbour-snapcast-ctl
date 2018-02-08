import QtQuick 2.0
import org.nemomobile.dbus 2.0

DBusInterface {
    id: iface

    service: "org.freedesktop.systemd1"
    path: "/org/freedesktop/systemd1/unit/syncthing_2eservice"
    iface: "org.freedesktop.systemd1.Unit"

    property string unitState: getProperty("ActiveState")

    onPropertiesChanged: {
        unitState = getProperty("ActiveState")
    }
}
