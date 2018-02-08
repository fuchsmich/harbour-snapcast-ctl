import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nemomobile.configuration 1.0

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

}

