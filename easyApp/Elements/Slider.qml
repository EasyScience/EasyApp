import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import easyApp.Style 1.0 as EaStyle
import easyApp.Animations 1.0 as EaAnimations
import easyApp.Elements 1.0 as EaElements

T.Slider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)

    padding: 6

    handle: EaElements.SliderHandle {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        value: control.value
        handleHasFocus: control.visualFocus
        handlePressed: control.pressed
        handleHovered: control.hovered

        EaElements.ToolTip {
            visible: slider.pressed
            text: control.value.toFixed(4)
        }
    }

    background: Rectangle {
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        implicitWidth: control.horizontal ? 200 : 4
        implicitHeight: control.horizontal ? 4 : 200
        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight

        radius: 2
        scale: control.horizontal && control.mirrored ? -1 : 1
        color: EaStyle.Colors.appBorder
        Behavior on color { EaAnimations.ThemeChange {} }

        Rectangle {
            y: control.horizontal ? 0 : control.visualPosition * parent.height
            width: control.horizontal ? control.position * parent.width : 4
            height: control.horizontal ? 4 : control.position * parent.height

            radius: 2
            color: EaStyle.Colors.themeForegroundHovered
            Behavior on color { EaAnimations.ThemeChange {} }

        }
    }
}





/*
T.Slider {


    handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        implicitWidth: 28
        implicitHeight: 28
        radius: width / 2
        color: control.pressed ? control.palette.light : control.palette.window
        border.width: control.visualFocus ? 2 : 1
        border.color: control.visualFocus ? control.palette.highlight : control.enabled ? control.palette.mid : control.palette.midlight
    }


}
*/
