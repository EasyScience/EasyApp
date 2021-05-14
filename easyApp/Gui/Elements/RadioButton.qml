import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import Globals 1.0 as Globals
import Templates.Animations 1.0 as Animations
import Templates.Controls 1.0

T.RadioButton {
    id: control

    property color color: Globals.Colors.themeAccent

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    //spacing: 8
    //padding: 8
    //verticalPadding: padding + 6

    spacing: Globals.Sizes.fontPixelSize * 0.5
    padding: Globals.Sizes.fontPixelSize * 0.5
    verticalPadding: padding + Globals.Sizes.fontPixelSize * 0.5

    indicator: RadioIndicator {
        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: control

        border.color: control.color
        Behavior on border.color {
            Animations.ThemeChange {}
        }

        Rectangle {
            z: -1
            anchors.centerIn: parent

            //implicitWidth: Globals.Sizes.toolButtonHeight
            //implicitHeight: Globals.Sizes.toolButtonHeight
            width: Globals.Sizes.touchSize
            height: Globals.Sizes.touchSize

            //radius: Globals.Sizes.toolButtonHeight * 0.5
            radius: height * 0.5

            color: rippleArea.containsMouse ?
                       (rippleArea.containsPress ? // TODO: fix this, as currently containsPress is not catched because of onPressed: mouse.accepted = false
                            Globals.Colors.appBarButtonBackgroundPressed :
                            Globals.Colors.appBarButtonBackgroundHovered) :
                        Globals.Colors.appBarButtonBackground
            Behavior on color {
                PropertyAnimation {
                    duration: rippleArea.containsMouse ? 500 : 0 //Globals.Variables.themeChangeTime
                    alwaysRunToEnd: true
                    easing.type: Easing.OutCubic
                }
            }

            MouseArea {
                id: rippleArea
                anchors.fill: parent
                hoverEnabled: true
                onPressed: mouse.accepted = false
            }
        }
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing - Globals.Sizes.fontPixelSize * 0.2 : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        color: control.enabled ?
                   Globals.Colors.themeForeground :
                   Globals.Colors.themeForegroundDisabled // control.Material.foreground : control.Material.hintTextColor
        Behavior on color {
            Animations.ThemeChange {}
        }
    }
}
