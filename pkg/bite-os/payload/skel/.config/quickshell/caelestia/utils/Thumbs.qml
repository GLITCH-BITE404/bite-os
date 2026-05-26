pragma Singleton

import QtQuick
import Quickshell
import qs.utils

Singleton {
    id: root

    readonly property var videoExts: [".mp4", ".webm", ".mkv", ".mov", ".avi", ".gif"]
    readonly property string thumbDir: `${Paths.cache}/wall-thumbs`

    function isVideo(p: string): bool {
        if (!p)
            return false;
        const lower = p.toLowerCase();
        for (let i = 0; i < videoExts.length; i++)
            if (lower.endsWith(videoExts[i]))
                return true;
        return false;
    }

    function basenameNoExt(p: string): string {
        const slash = p.lastIndexOf("/");
        let name = slash >= 0 ? p.substring(slash + 1) : p;
        const dot = name.lastIndexOf(".");
        return dot > 0 ? name.substring(0, dot) : name;
    }

    function path(p: string): string {
        if (!p)
            return "";
        return isVideo(p) ? `${thumbDir}/${basenameNoExt(p)}.png` : p;
    }
}
