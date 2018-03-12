//TODO Coverpage!!

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    //text should be separated from the cover edges with Theme.paddingLarge on the left and right sides
    //and Theme.paddingMedium on the top and bottom.
    Image {
        id: icon
        source: "cover-icon.png"
        anchors.centerIn: parent
        opacity: 0.2
        scale: 1.0
    }
    Column {
        anchors{
            fill: parent
            topMargin: Theme.paddingMedium
            bottomMargin: Theme.paddingMedium
            leftMargin: Theme.paddingLarge
            rightMargin: Theme.paddingLarge
        }
        Label {
            text: qsTr("snapcast")
//            font.bold: true
        }
        Row {
            Label {
                text: qsTr("Server") + ": "
            }
            Label {
                text: snapcastCtl.serverString
                color: Theme.highlightColor
            }
        }
        Row {
            Label {
                text: qsTr("State") + ": "
            }
            Label {
                text: snapcastCtl.connected ? qsTr("connected") : qsTr("disconnected")
                color: Theme.highlightColor
            }
        }
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

