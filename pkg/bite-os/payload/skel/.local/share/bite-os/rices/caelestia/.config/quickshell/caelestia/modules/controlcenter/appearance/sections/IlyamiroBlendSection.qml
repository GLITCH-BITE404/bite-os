pragma ComponentBehavior: Bound

import ".."
import "../../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Caelestia.Config
import qs.components
import qs.components.containers
import qs.components.controls
import qs.services

CollapsibleSection {
    id: root

    required property var rootPane

    title: qsTr("Ilyamiro Blend")
    showBackground: true

    // ── state, read from disk; user-initiated changes set this guard so
    //    the SwitchRow onToggled handler can distinguish "user clicked"
    //    from "external state arrived" (which is what was wiping config).
    property bool initialised: false
    property string activeRice: "caelestia"
    readonly property bool ilyamiroMode: activeRice === "ilyamiro"
    property bool animationsEnabled: false
    property bool rofiEnabled: false
    property bool cavaEnabled: false

    function refresh() {
        statusReader.running = true;
        activeReader.running = true;
    }

    Process {
        id: activeReader
        running: true
        command: ["sh", "-c", "cat ~/.local/share/bite-os/rices/.active 2>/dev/null || echo caelestia"]
        stdout: StdioCollector {
            onStreamFinished: { root.activeRice = text.trim() || "caelestia"; }
        }
    }

    Process {
        id: statusReader
        running: true
        command: ["sh", "-c", "~/.config/glitch/bin/blend-toggle.sh status"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                for (const ln of lines) {
                    const m = ln.match(/^(\w+)\s+(on|off)$/);
                    if (!m) continue;
                    const val = m[2] === "on";
                    if      (m[1] === "animations") root.animationsEnabled = val;
                    else if (m[1] === "rofi")       root.rofiEnabled = val;
                    else if (m[1] === "cava")       root.cavaEnabled = val;
                }
                root.initialised = true;
            }
        }
    }
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
    Timer {
        id: refreshDelay
        interval: 900
        repeat: false
        onTriggered: root.refresh()
    }

    function setComponent(comp, on) {
        if (!root.initialised) return;
        Quickshell.execDetached([
            "sh", "-c",
            "~/.config/glitch/bin/blend-toggle.sh " + (on ? "on " : "off ") + comp
        ]);
        refreshDelay.restart();
    }

    function switchRice(toIlyamiro) {
        if (!root.initialised) return;
        const target = toIlyamiro ? "ilyamiro" : "caelestia";
        Quickshell.execDetached([
            "sh", "-c",
            "~/.config/glitch/bin/rice load " + target +
            " && hyprctl reload && pkill -x qs; sleep 1; nohup caelestia shell -d >/tmp/caelestia.log 2>&1 &"
        ]);
        refreshDelay.restart();
    }

    SectionContainer {
        contentSpacing: Tokens.spacing.normal

        // Master full-rice swap was removed — it left the desktop in a broken
        // half-state (his hyprland + caelestia shell). Use the per-component
        // options below, or run `rice load ilyamiro` from a TTY when there's a
        // proper launcher wrapper for it.
        StyledText {
            Layout.fillWidth: true
            text: qsTr("Cherry-pick pieces from ilyamiro/nixos-configuration. Each option is independent — caelestia stays caelestia, only that one program's config is swapped. Disabling restores your previous config from autobackup.")
            wrapMode: Text.WordWrap
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: Tokens.font.size.small
        }

        SwitchRow {
            label: qsTr("Window animations")
            checked: root.animationsEnabled
            onToggled: checked => root.setComponent("animations", checked)
        }

        SwitchRow {
            label: qsTr("Rofi launcher theme")
            checked: root.rofiEnabled
            onToggled: checked => root.setComponent("rofi", checked)
        }

        SwitchRow {
            label: qsTr("Cava audio visualiser")
            checked: root.cavaEnabled
            onToggled: checked => root.setComponent("cava", checked)
        }

        StyledText {
            Layout.fillWidth: true
            Layout.topMargin: Tokens.spacing.small
            text: qsTr("Revert: flip off, or run `rice rollback` in a terminal. Backups never deleted.")
            wrapMode: Text.WordWrap
            color: Colours.palette.m3onSurfaceVariant
            opacity: 0.7
            font.pointSize: Tokens.font.size.small
        }
    }
}
