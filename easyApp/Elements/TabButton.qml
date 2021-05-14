import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.TabButton {
    id: control

    property string fontIcon: ""
    property color borderColor: "transparent"

    width: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                    implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topInset: 0
    bottomInset: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
    rightPadding: EaStyle.Sizes.fontPixelSize * 0.5
    spacing: EaStyle.Sizes.fontPixelSize * 0.5

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: control.hovered && EaGlobals.Variables.showToolTips && text !== ""
    }

    // Icon with text label
    contentItem: Item {
        implicitWidth: row.width

        Row {
            id: row
            width: childrenRect.width
            spacing: control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize * 1.25

                text: control.fontIcon

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }

            // Text label
            Label {
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize
                font.bold: control.checked ? true : false

                text: control.text

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }
    }

    // Background
    background: Rectangle {
        implicitHeight: EaStyle.Sizes.tabBarHeight

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: parent
        hoverEnabled: true
        //onClicked: control.clicked() // Doesn't work as for Button or ToolButton
        onPressed: mouse.accepted = false // Color doesn't changed onPressed
    }

    // Logic

    /*
    function backgroundColor() {
        if (!control.enabled)
            return "#00000000" //EaStyle.Colors.themeBackgroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.isDarkTheme ? "#22ffffff" : "#11000000" //EaStyle.Colors.themeBackgroundHovered
        return "#00000000" //EaStyle.Colors.themeBackground
    }
    */

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.contentBackground
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeBackgroundHovered1
        return EaStyle.Colors.contentBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }
}
