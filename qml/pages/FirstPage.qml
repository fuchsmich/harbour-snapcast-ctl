import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Snapcast")
            }
            SectionHeader {
                text: qsTr("Snapclient")
            }

            Row {
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingLarge
                IconButton {
                    icon.source: "image://theme/icon-l-" +
                                 (snapclientDbus.activeState == "active" ?
                                      "pause" : "play")
                    onClicked: snapclientDbus.toggleUnit()
                }

                Label {
                    text: snapclientDbus.activeState + "(" + snapclientDbus.subState + ")"
                }
            }
            SectionHeader {
                text: qsTr("Snapserver")
            }
            Row {
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingLarge
                IconButton {
                    icon.source: "image://theme/icon-l-" +
                                 (snapserverDbus.activeState == "active" ?
                                      "pause" : "play")
                    onClicked: snapserverDbus.toggleUnit()
                }

                Label {
                    text: snapserverDbus.activeState + "(" + snapserverDbus.subState + ")"
                }
            }
            SectionHeader {
                text: qsTr("Avhai")
            }

            Row {
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingLarge

                GlassItem {
                    id: indicator
                    property bool checked: avahiDbus.activeState == "active"
                    property bool busy: avahiDbus.activeState === "activating" ||  avahiDbus.activeState === "deactivating"
//                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: parent.enabled ? 1.0 : 0.4
                    dimmed: !checked
                    falloffRadius: checked ? defaultFalloffRadius : 0.075
                    Behavior on falloffRadius {
                        NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
                    }
                    // KLUDGE: Behavior and State don't play well together
                    // http://qt-project.org/doc/qt-5/qtquick-statesanimations-behaviors.html
                    // force re-evaluation of brightness when returning to default state
                    brightness: { return 1.0 }
                    Behavior on brightness {
                        NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
                    }
                    color: checked ? "green" : "red"
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: avahiDbus.activeState + "(" + avahiDbus.subState + ")"
                }
            }
        }
    }
}

