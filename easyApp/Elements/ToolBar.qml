import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

T.ToolBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: EaStyle.Sizes.appBarSpacing

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    background: Rectangle {
        implicitHeight: EaStyle.Sizes.appBarHeight

        color: EaStyle.Colors.appBarBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        ///layer.enabled: control.Material.elevation > 0
        ///layer.effect: ElevationEffect {
        ///    elevation: control.Material.elevation
        ///    fullWidth: true
        ///}

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            height: 1 //EaStyle.Sizes.borderThickness ???

            color: EaStyle.Colors.appBarBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }    
}
