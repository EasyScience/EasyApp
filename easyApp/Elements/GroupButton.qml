import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

import easyAppGui.Style 1.0 as EaStyle

Button {
    implicitWidth: (parent.width - parent.spacing) * 0.5 - 1

    topInset: 0
    bottomInset: 0
    padding: 0

    icon.height: 18
    icon.width: 18

    font.capitalization: Font.MixedCase

    flat: true
    Material.elevation: 0
    Material.background: EaStyle.Colors.statusBarBackground

    ToolTip.visible: hovered && ToolTip.text

    // Background for disabled buttons
    Rectangle {
        anchors.fill: parent
        color: enabled ? "transparent" : Material.background
    }
}
