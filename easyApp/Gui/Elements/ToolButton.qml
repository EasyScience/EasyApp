import QtQuick
import QtQuick.Templates 2.13 as T
import QtQuick.Controls
import QtQuick.Controls.impl 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.ToolButton {
    id: control

    property string fontIcon: ""
    property bool showBackground: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    /*
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    */

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: control.hovered && EaGlobals.Variables.showToolTips && text !== ""
    }

    // Icon label
    contentItem: IconLabel {
        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: control.font.pixelSize * 1.25

        text: control.fontIcon

        color: foregroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // Background
    background: Rectangle {
        visible: showBackground

        implicitWidth: EaStyle.Sizes.toolButtonHeight
        implicitHeight: EaStyle.Sizes.toolButtonHeight

        radius: EaStyle.Sizes.toolButtonHeight * 0.5

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: parent
        hoverEnabled: true
        //onClicked: control.clicked()
        onPressed: mouse.accepted = false
    }

    // Logic

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeBackgroundHovered2
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (!highlighted) {
            if (control.checked || rippleArea.containsMouse)
                return EaStyle.Colors.themeForegroundHovered
            return EaStyle.Colors.themeForeground
        }
        return EaStyle.Colors.themeForegroundHighlight
    }
}
