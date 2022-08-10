import QtQuick
import QtQuick.Templates 2.13 as T
import QtQuick.Controls
import QtQuick.Controls.impl 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: EaStyle.Sizes.fontPixelSize * 0.5 + 1
    topInset: 0
    bottomInset: 0

    verticalAlignment: TextInput.AlignVCenter
    horizontalAlignment: TextInput.AlignRight

    selectByMouse: true

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize
    //font.bold: control.activeFocus ? true : false

    color: !enabled ? EaStyle.Colors.themeForegroundDisabled :
                     rippleArea.containsMouse || control.activeFocus ?
                          EaStyle.Colors.themeForegroundHovered :
                          EaStyle.Colors.themeForeground
    Behavior on color { EaAnimations.ThemeChange {} }

    selectionColor: EaStyle.Colors.themeAccent
    Behavior on selectionColor { EaAnimations.ThemeChange {} }

    selectedTextColor: EaStyle.Colors.themeBackground
    Behavior on selectedTextColor { EaAnimations.ThemeChange {} }

    placeholderTextColor: EaStyle.Colors.themeForegroundDisabled
    Behavior on placeholderTextColor { EaAnimations.ThemeChange {} }

    cursorDelegate: EaElements.CursorDelegate { }

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
    }

    background: Rectangle {
        color: control.activeFocus ?
                   EaStyle.Colors.appBarComboBoxBackgroundHovered :
                        control.hovered ?
                            EaStyle.Colors.appBarComboBoxBackgroundHovered :
                            EaStyle.Colors.appBarComboBoxBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: control.activeFocus ?
                          EaStyle.Colors.themeForegroundHovered :
                                control.hovered ?
                                    EaStyle.Colors.themeForegroundHovered :
                                    EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: control
        hoverEnabled: true
        onPressed: mouse.accepted = false
    }
}
