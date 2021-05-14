import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.MenuItem {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 16
    ///verticalPadding: Material.menuItemVerticalPadding
    spacing: 16

    icon.width: 24
    icon.height: 24
    ///icon.color: enabled ? Material.foreground : Material.hintTextColor

    indicator: EaElements.CheckIndicator {
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        visible: control.checkable
        control: control
        checkState: control.checked ? Qt.Checked : Qt.Unchecked
    }

    arrow: ColorImage {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2

        visible: control.subMenu
        mirror: control.mirrored
        ///color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        ///source: "qrc:/qt-project.org/imports/QtQuick/Controls.2/Material/images/arrow-indicator.png"
    }

    contentItem: Label {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        leftPadding: !control.mirrored ? indicatorPadding : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding

        font: control.font
        verticalAlignment: Text.AlignVCenter

        textFormat: Text.RichText

        text: control.text

        color: EaStyle.Colors.themeForeground
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    background: Rectangle {
        implicitWidth: 200
        //height: 20//control.height
        ///implicitHeight: control.Material.menuItemHeight
        ///color: control.highlighted ? control.Material.listHighlightColor : "transparent"
        color: control.hovered ? EaStyle.Colors.appBarButtonBackgroundHovered : "transparent"
        Behavior on color {
            PropertyAnimation {
                duration: control.hovered ? 500 : 0
                alwaysRunToEnd: true
                easing.type: Easing.OutCubic
            }
        }
        /*
        Behavior on color {
            PropertyAnimation {
                duration: Globals.Variables.themeChangeTime
                //alwaysRunToEnd: true
                easing.type: Easing.OutQuint
            }
        }*/
        /*
        Ripple {
            width: parent.width
            height: parent.height

            clip: visible
            pressed: control.pressed
            anchor: control
            active: control.down || control.highlighted
            color: control.Material.rippleColor
        }
        */
    }
}
