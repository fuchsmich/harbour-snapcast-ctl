import QtQuick 2.0
import Sailfish.Silica 1.0

import Nemo.Configuration 1.0
import org.nemomobile.dbus 2.0

import "pages"
import "components"

ApplicationWindow
{
    initialPage: Component { Server { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ConfigurationGroup {
        id: settings
        path: '/apps/harbour-snapcast-ctl'
        property string host: "127.0.0.1"
        property int streamPort: 1704
        property int controlPort: 1705
        property bool autostartClient: false
    }

    SystemdUnit {
        id: snapclientUserService
        path: "/org/freedesktop/systemd1/unit/snapclient_2eservice"
    }

    SystemdUnit {
        id: snapserverUserService
        path: "/org/freedesktop/systemd1/unit/snapserver_2eservice"
    }

    SystemdUnit {
        id: snapserverUserSocket
        path: "/org/freedesktop/systemd1/unit/snapserver_2esocket"
    }

    SystemdUnit {
        id: snapserverSystemService
        path: "/org/freedesktop/systemd1/unit/snapserver_2eservice"
        bus: DBus.SystemBus
    }

    SystemdUnit {
        id: snapserverSystemSocket
        path: "/org/freedesktop/systemd1/unit/snapserver_2esocket"
        bus: DBus.SystemBus
    }

    SystemdUnit {
        id: avahiService
        path: "/org/freedesktop/systemd1/unit/avahi_2ddaemon_2eservice"
        bus: DBus.SystemBus
    }

    SystemdUnit {
        id: avahiSocket
        path: "/org/freedesktop/systemd1/unit/avahi_2ddaemon_2esocket"
        bus: DBus.SystemBus
    }

    SnapcastCtl {
        id: snapcastCtl
    }

}

