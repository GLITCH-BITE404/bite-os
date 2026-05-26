import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.services

RowLayout {
    id: root

    required property var lock

    spacing: Tokens.spacing.large * 2

    // In leaf (PowerSaver) mode, transparency is forced off and animations
    // are killed. The 0.85-alpha panels disappear into the dark-on-dark
    // background, which made caelestiafetch.sh effectively invisible. Bump
    // panels to near-opaque whenever transparency is disabled so the lock
    // screen — and especially the Fetch panel — stays readable.
    readonly property real panelAlpha: Colours.transparency.enabled ? 0.55 : 0.92
    readonly property color panelBorder: Qt.alpha(Colours.palette.m3outlineVariant, 0.40)

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.normal

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: weather.implicitHeight

            topLeftRadius: Tokens.rounding.large
            radius: Tokens.rounding.small
            color: Qt.alpha(Colours.palette.m3surfaceContainer, root.panelAlpha)
            border.width: 1
            border.color: root.panelBorder

            WeatherInfo {
                id: weather

                rootHeight: root.height
            }
        }

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: Tokens.rounding.small
            // Fetch panel: pinned to a high alpha in leaf mode so the glyphs
            // (OS / WM / USER / UP / BATT) read clearly without blur backing.
            color: Qt.alpha(Colours.palette.m3surfaceContainerHigh, root.panelAlpha)
            border.width: 1
            border.color: root.panelBorder

            Fetch {}
        }

        StyledClippingRect {
            Layout.fillWidth: true
            implicitHeight: media.implicitHeight

            bottomLeftRadius: Tokens.rounding.large
            radius: Tokens.rounding.small
            color: Qt.alpha(Colours.palette.m3surfaceContainer, root.panelAlpha)
            border.width: 1
            border.color: root.panelBorder

            Media {
                id: media

                lock: root.lock
            }
        }
    }

    Center {
        lock: root.lock
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.normal

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: resources.implicitHeight

            topRightRadius: Tokens.rounding.large
            radius: Tokens.rounding.small
            color: Qt.alpha(Colours.palette.m3surfaceContainer, root.panelAlpha)
            border.width: 1
            border.color: root.panelBorder

            Resources {
                id: resources
            }
        }

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true

            bottomRightRadius: Tokens.rounding.large
            radius: Tokens.rounding.small
            color: Qt.alpha(Colours.palette.m3surfaceContainer, root.panelAlpha)
            border.width: 1
            border.color: root.panelBorder

            NotifDock {
                lock: root.lock
            }
        }
    }
}
