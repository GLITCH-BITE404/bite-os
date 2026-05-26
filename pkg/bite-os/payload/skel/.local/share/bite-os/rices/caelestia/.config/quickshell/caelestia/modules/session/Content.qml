pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

Column {
    id: root

    required property DrawerVisibilities visibilities

    padding: Tokens.padding.large
    spacing: Tokens.spacing.large

    SessionButton {
        id: logout

        icon: Config.session.icons.logout
        // Default loginctl terminate-user kills the compositor mid-frame and
        // can leave the session frozen — ask Hyprland to exit cleanly instead.
        command: ["hyprctl", "dispatch", "exit"]

        KeyNavigation.down: shutdown

        Component.onCompleted: forceActiveFocus()

        Connections {
            function onLauncherChanged(): void {
                if (!root.visibilities.launcher)
                    logout.forceActiveFocus();
            }

            target: root.visibilities
        }
    }

    SessionButton {
        id: shutdown

        icon: Config.session.icons.shutdown
        command: ["systemctl", "poweroff"]

        KeyNavigation.up: logout
        KeyNavigation.down: update
    }

    AnimatedImage {
        width: Tokens.sizes.session.button
        height: Tokens.sizes.session.button
        sourceSize.width: width

        playing: visible
        asynchronous: true
        speed: Config.general.sessionGifSpeed
        source: Paths.absolutePath(Config.paths.sessionGif)
        fillMode: AnimatedImage.PreserveAspectFit
    }

    SessionButton {
        id: update

        icon: "system_update"
        command: ["sh", "-c", Paths.home + "/.config/glitch/bin/glitch-update.sh"]

        KeyNavigation.up: shutdown
        KeyNavigation.down: reboot
    }

    SessionButton {
        id: reboot

        icon: Config.session.icons.reboot
        command: ["systemctl", "reboot"]

        KeyNavigation.up: update
    }

    component SessionButton: StyledRect {
        id: button

        required property string icon
        required property list<string> command

        implicitWidth: Tokens.sizes.session.button
        implicitHeight: Tokens.sizes.session.button

        radius: Tokens.rounding.large
        color: button.activeFocus ? Colours.palette.m3secondaryContainer : Colours.tPalette.m3surfaceContainer

        Keys.onEnterPressed: Quickshell.execDetached(button.command)
        Keys.onReturnPressed: Quickshell.execDetached(button.command)
        Keys.onEscapePressed: root.visibilities.session = false
        Keys.onPressed: event => {
            if (!Config.session.vimKeybinds)
                return;

            if (event.modifiers & Qt.ControlModifier) {
                if ((event.key === Qt.Key_J || event.key === Qt.Key_N) && KeyNavigation.down) {
                    KeyNavigation.down.focus = true;
                    event.accepted = true;
                } else if ((event.key === Qt.Key_K || event.key === Qt.Key_P) && KeyNavigation.up) {
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            } else if (event.key === Qt.Key_Tab && KeyNavigation.down) {
                KeyNavigation.down.focus = true;
                event.accepted = true;
            } else if (event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))) {
                if (KeyNavigation.up) {
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            }
        }

        StateLayer {
            radius: parent.radius
            color: button.activeFocus ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
            onClicked: {
                Quickshell.execDetached(button.command);
                root.visibilities.session = false;
            }
        }

        MaterialIcon {
            anchors.centerIn: parent

            text: button.icon
            color: button.activeFocus ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
            font.pointSize: Tokens.font.size.extraLarge
            font.weight: 500
        }
    }
}
