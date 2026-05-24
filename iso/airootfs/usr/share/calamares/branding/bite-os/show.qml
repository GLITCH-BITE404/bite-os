/* BITE-OS — Calamares install slideshow (slideshowAPI 2) */
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 8000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#0a0710"
            Column {
                anchors.centerIn: parent
                spacing: 18
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "BITE-OS"
                    color: "#bd46dc"
                    font.pixelSize: 52
                    font.family: "JetBrains Mono"
                    font.bold: true
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "// THE SYSTEM BIT YOU"
                    color: "#3cc8eb"
                    font.pixelSize: 20
                    font.family: "JetBrains Mono"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.7
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: "Installing your glitch-themed, performance-obsessed desktop. Two complete riced desktops, self-repair, and a watchdog that won't let you lock yourself out."
                    color: "#e6e6f0"
                    font.pixelSize: 15
                    font.family: "JetBrains Mono"
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#0a0710"
            Column {
                anchors.centerIn: parent
                spacing: 18
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Almost there"
                    color: "#bd46dc"
                    font.pixelSize: 40
                    font.family: "JetBrains Mono"
                    font.bold: true
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.7
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: "When this finishes, reboot and log in as the user you just created. Press SUPER+H any time for the in-system guide."
                    color: "#e6e6f0"
                    font.pixelSize: 15
                    font.family: "JetBrains Mono"
                }
            }
        }
    }

    function onActivate() { presentation.currentSlide = 0; }
    function onLeave() {}
}
