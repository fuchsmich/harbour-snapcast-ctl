import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.configuration 1.0
import org.nemomobile.dbus 2.0

import "pages"
import "components"

ApplicationWindow
{
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ConfigurationGroup {
        id: settings
        path: '/apps/harbour-snapcast-ctl'
    }

    SnapclientDbus {
        id: snapclientDbus
    }

    SnapserverDbus {
        id: snapserverDbus
    }

    AvahiDbus {
        id: avahiDbus
    }

    Timer {
        interval: 1000;
        running: true;
        repeat: true;
        onTriggered: {
//            snapclientDbus.getProps();
            snapserverDbus.getProps();
        }
    }

    DBusInterface {

        service: "org.freedesktop.systemd1"
        path: "/org/freedesktop/systemd1/unit/snapclient_2eservice"
        iface: "org.freedesktop.DBus.Properties"
        signalsEnabled: true

        function propertiesChanged( _interface, changed_properties, invalidated_properties) {
            console.debug("propertiesChanged!")
//            getProps();
        }
    }


}

