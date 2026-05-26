pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Caelestia.Config
import qs.components
import qs.components.effects
import qs.services
import qs.utils

ColumnLayout {
    id: root

    anchors.fill: parent
    anchors.margins: Tokens.padding.large * 2
    anchors.topMargin: Tokens.padding.large

    spacing: Tokens.spacing.small

    readonly property string hostName: Quickshell.env("HOSTNAME") || "chomp"

    // ── Rotating header lines (cursed motivational / glitch flavor) ───────
    readonly property var quotes: [
        "stay hungry. stay cursed.",
        "wake up. rice the world.",
        "root is a state of mind.",
        "we are the ghost in the shell.",
        "404: conformity not found.",
        "compile the void.",
        "bite first. ask never.",
        "the machine is awake. are you?",
        "born to chomp. forged in glitch.",
        "panic() is a feature.",
        "trust no daemon you didn't fork.",
        "low battery, high stakes.",
        "the kernel dreams in violet.",
        "you are the exception.",
        "segfault gracefully.",
        "rm -rf /doubts",
        "grep your reality.",
        "stay weird. stay rooted."
    ]
    property int quoteIndex: Math.floor(Math.random() * quotes.length)

    Timer {
        interval: 7000
        running: true
        repeat: true
        onTriggered: quoteSwap.start()
    }

    SequentialAnimation {
        id: quoteSwap
        PropertyAnimation { target: quoteText; property: "opacity"; to: 0; duration: 180; easing.type: Easing.InOutQuad }
        ScriptAction {
            script: {
                let next = root.quoteIndex;
                while (next === root.quoteIndex && root.quotes.length > 1)
                    next = Math.floor(Math.random() * root.quotes.length);
                root.quoteIndex = next;
            }
        }
        PropertyAnimation { target: quoteText; property: "opacity"; to: 1; duration: 220; easing.type: Easing.InOutQuad }
    }

    // ── Header row 1: user@host chip + distro icon ─────────────────
    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        spacing: Tokens.spacing.normal

        StyledRect {
            implicitWidth: userHost.implicitWidth + Tokens.padding.normal * 2
            implicitHeight: userHost.implicitHeight + Tokens.padding.small * 2

            color: Colours.palette.m3primary
            radius: Tokens.rounding.small

            MonoText {
                id: userHost

                anchors.centerIn: parent
                text: `${SysInfo.user}@${root.hostName}`
                font.pointSize: Tokens.font.size.small
                font.bold: true
                color: Colours.palette.m3onPrimary
            }
        }

        Item { Layout.fillWidth: true }   // spacer

        WrappedLoader {
            Layout.fillHeight: true
            Layout.maximumHeight: userHost.implicitHeight + Tokens.padding.small * 2
            active: !iconLoader.active

            sourceComponent: SysInfo.isDefaultLogo ? caelestiaLogo : distroIcon
        }
    }

    // ── Header row 2: full-width quote prompt with caret ───────────
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: Tokens.spacing.small / 2
        spacing: 0

        MonoText {
            text: "~$ "
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: Tokens.font.size.normal
        }

        MonoText {
            id: quoteText
            Layout.fillWidth: true
            text: root.quotes[root.quoteIndex]
            color: Colours.palette.m3primary
            font.pointSize: Tokens.font.size.normal
            font.italic: true
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }

        // blinking block caret
        Rectangle {
            implicitWidth: Tokens.font.size.normal * 0.55
            implicitHeight: Tokens.font.size.normal * 1.15
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 2
            color: Colours.palette.m3primary
            radius: 1

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: true
                PropertyAnimation { to: 1; duration: 0 }
                PauseAnimation { duration: 520 }
                PropertyAnimation { to: 0; duration: 0 }
                PauseAnimation { duration: 520 }
            }
        }
    }

    // ── Thin separator ─────────────────────────────────────────────
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: Tokens.spacing.small / 2
        Layout.bottomMargin: Tokens.spacing.small / 2
        implicitHeight: 1
        color: Qt.alpha(Colours.palette.m3outline, 0.45)
    }

    // ── Body: icon + key/value rows ────────────────────────────────
    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        spacing: height * 0.15

        WrappedLoader {
            id: iconLoader

            Layout.fillHeight: true
            active: root.width > 320

            sourceComponent: SysInfo.isDefaultLogo ? caelestiaLogo : distroIcon
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: Tokens.padding.normal
            Layout.bottomMargin: Tokens.padding.normal
            Layout.leftMargin: iconLoader.active ? 0 : width * 0.1
            spacing: Tokens.spacing.small

            WrappedLoader {
                Layout.fillWidth: true
                active: root.height > 140

                sourceComponent: FetchRow {
                    label: "OS"
                    value: "BITE-OS"
                }
            }

            WrappedLoader {
                Layout.fillWidth: true
                active: root.height > (batLoader.active ? 200 : 110)

                sourceComponent: FetchRow {
                    label: "WM"
                    value: SysInfo.wm
                }
            }

            WrappedLoader {
                Layout.fillWidth: true
                active: !batLoader.active || root.height > 110

                sourceComponent: FetchRow {
                    label: "USR"
                    value: `${SysInfo.user}@${root.hostName}`
                }
            }

            WrappedLoader {
                Layout.fillWidth: true
                active: root.height > 230

                sourceComponent: FetchRow {
                    label: "SH"
                    value: SysInfo.shell
                }
            }

            FetchRow {
                label: "UP"
                value: SysInfo.uptime
            }

            WrappedLoader {
                id: batLoader

                Layout.fillWidth: true
                active: UPower.displayDevice.isLaptopBattery

                sourceComponent: FetchRow {
                    label: "BAT"
                    value: `${[UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state) ? "(+) " : ""}${Math.round(UPower.displayDevice.percentage * 100)}%`
                }
            }
        }
    }

    // ── Tightened color swatches ───────────────────────────────────
    WrappedLoader {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Tokens.spacing.small
        active: root.height > 180

        sourceComponent: RowLayout {
            spacing: Tokens.spacing.small

            Repeater {
                model: Math.max(0, Math.min(8, root.width / (Tokens.font.size.larger * 1.5 + Tokens.spacing.small)))

                StyledRect {
                    required property int index

                    implicitWidth: implicitHeight
                    implicitHeight: Tokens.font.size.larger * 1.4
                    color: Colours.palette[`term${index}`]
                    radius: Tokens.rounding.small / 2
                    border.width: 1
                    border.color: Qt.alpha(Colours.palette.m3outline, 0.35)
                }
            }
        }
    }

    Component {
        id: caelestiaLogo

        Logo {
            width: height
        }
    }

    Component {
        id: distroIcon

        Image {
            source: "file:///home/glitchbite404/.config/glitch/icons/logo-hero.png"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: height
            sourceSize.height: height
        }
    }

    component WrappedLoader: Loader {
        asynchronous: true
        visible: active
    }

    // Two-tone row: accent label + onSurface value, colon-aligned.
    component FetchRow: RowLayout {
        property string label
        property string value

        Layout.fillWidth: true
        spacing: 0

        MonoText {
            // 4-char fixed slot keeps colons aligned across rows.
            text: (label + "    ").substring(0, 4)
            color: Colours.palette.m3primary
            font.pointSize: root.width > 400 ? Tokens.font.size.larger : Tokens.font.size.normal
            font.bold: true
        }

        MonoText {
            text: ": "
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: root.width > 400 ? Tokens.font.size.larger : Tokens.font.size.normal
        }

        MonoText {
            Layout.fillWidth: true
            text: value
            color: Colours.palette.m3onSurface
            font.pointSize: root.width > 400 ? Tokens.font.size.larger : Tokens.font.size.normal
            font.bold: !Colours.transparency.enabled
            elide: Text.ElideRight
        }
    }

    component MonoText: StyledText {
        font.family: Tokens.font.family.mono
    }
}
