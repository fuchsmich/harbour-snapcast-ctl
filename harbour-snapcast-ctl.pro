# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-snapcast-ctl

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-snapcast-ctl.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-snapcast-ctl.changes.run.in \
    rpm/harbour-snapcast-ctl.spec \
    rpm/harbour-snapcast-ctl.yaml \
    translations/*.ts \
    harbour-snapcast-ctl.desktop \
    qml/components/SystemdUnit.qml \
    qml/components/UnitRow.qml \
    qml/pages/Services.qml \
    qml/pages/Server.qml \
    qml/pages/Settings.qml \
    qml/components/ClientItem.qml \
    qml/pages/GroupConfig.qml \
    qml/python/snapcontroller.py \
    qml/components/SnapcastCtl.qml \
    qml/pages/ClientDetails.qml \
    qml/components/EditableDetailItem.qml \
    rpm/harbour-snapcast-ctl.changes

SAILFISHAPP_ICONS = 86x86 108x108 128x128

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/harbour-snapcast-ctl-de.ts
