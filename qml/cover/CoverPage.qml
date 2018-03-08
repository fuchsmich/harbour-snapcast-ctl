//TODO Coverpage!!

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    //    CoverPlaceholder {
    //        icon.source: "cover-icon.png"
    //        text: "snapcast"
    //    }
    //text should be separated from the cover edges with Theme.paddingLarge on the left and right sides
    //and Theme.paddingMedium on the top and bottom.
    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        text: qsTr("snapcast")
    }
    Image {
        id: icon
        source: "cover-icon.png"
        anchors.centerIn: parent
        opacity: 0.2
        scale: 1.0
    }

    //    CoverActionList {
    //        id: coverAction

    //        CoverAction {
    //            iconSource: "image://theme/icon-cover-next"
    //        }

    //        CoverAction {
    //            iconSource: "image://theme/icon-cover-pause"
    //        }
    //    }
}

