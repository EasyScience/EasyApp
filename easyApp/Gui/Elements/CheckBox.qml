import QtQuick
import QtQuick.Templates as T

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.CheckBox {
    id: control

    property color color: EaStyle.Colors.themeAccent

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: EaStyle.Sizes.fontPixelSize * 0.5
    padding: EaStyle.Sizes.fontPixelSize * 0.5
    verticalPadding: padding + EaStyle.Sizes.fontPixelSize * 0.5

    tristate: false

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    indicator: EaElements.CheckIndicator {
        x: control.text ?
               (control.mirrored ?
                    control.width - width - control.rightPadding :
                    control.leftPadding) :
               control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: control
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ?
                         control.indicator.width + control.spacing :
                         0
        rightPadding: control.indicator && control.mirrored ?
                          control.indicator.width + control.spacing :
                          0

        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        color: control.enabled ?
                   EaStyle.Colors.themeForeground :
                   EaStyle.Colors.themeForegroundDisabled
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: control.hovered && EaGlobals.Variables.showToolTips && text !== ""
    }
}
