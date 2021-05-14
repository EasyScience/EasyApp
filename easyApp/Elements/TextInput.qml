import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

TextInput {
    id: control

    selectByMouse: true

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize
    font.bold: control.activeFocus ? true : false

    color: !enabled ? EaStyle.Colors.themeForegroundDisabled :
                     rippleArea.containsMouse || control.activeFocus ? EaStyle.Colors.themeForegroundHovered :
                                                                       EaStyle.Colors.themeForeground
    Behavior on color { EaAnimations.ThemeChange {} }

    selectionColor: EaStyle.Colors.themeAccent
    Behavior on selectionColor { EaAnimations.ThemeChange {} }

    selectedTextColor: EaStyle.Colors.themeBackground
    Behavior on selectedTextColor { EaAnimations.ThemeChange {} }

    cursorDelegate: EaElements.CursorDelegate { }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: control
        hoverEnabled: true
        onPressed: mouse.accepted = false
    }

}
