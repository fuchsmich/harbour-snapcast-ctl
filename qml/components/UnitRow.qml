import QtQuick 2.0
import Sailfish.Silica 1.0


Column {
x: Theme.horizontalPageMargin
property SystemdUnit unit

Label {
    text: unit.path.split("/")[unit.path.split("/").length - 1]
    anchors.right: parent.right
    font.pixelSize: Theme.fontSizeSmall
    color: Theme.highlightColor
}

Row {
    spacing: Theme.paddingLarge
    IconButton {
        anchors.verticalCenter: parent.verticalCenter
        icon.source: "image://theme/icon-l-" +
                     (unit.activeState === "active" ?
                          "pause" : "play")
        onClicked: unit.toggleUnit()
        enabled: unit.bus === 1
    }

    GlassItem {
        id: indicator
        property bool checked: unit.activeState === "active"
        property bool busy: unit.activeState === "activating" ||  unit.activeState === "deactivating"
//                    anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: parent.enabled ? 1.0 : 0.4
        dimmed: !checked
        falloffRadius: checked ? defaultFalloffRadius : 0.075
        Behavior on falloffRadius {
            NumberAnimation { duration: indicator.busy ? 450 : 50; easing.type: Easing.InOutQuad }
        }
        // KLUDGE: Behavior and State don't play well together
        // http://qt-project.org/doc/qt-5/qtquick-statesanimations-behaviors.html
        // force re-evaluation of brightness when returning to default state
        brightness: { return 1.0 }
        Behavior on brightness {
            NumberAnimation { duration: indicator.busy ? 450 : 50; easing.type: Easing.InOutQuad }
        }
        color: checked ? "green" : "red"
    }

    Label {
        anchors.verticalCenter: parent.verticalCenter
        text: unit.activeState + " (" + unit.subState + ")"
    }
}
}
