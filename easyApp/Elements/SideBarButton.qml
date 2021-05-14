import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyApp.Style 1.0 as EaStyle
import easyApp.Globals 1.0 as EaGlobals
import easyApp.Animations 1.0 as EaAnimations
import easyApp.Elements 1.0 as EaElements

T.Button {
    id: control

    property bool wide: false
    property bool smallIcon: false
    property int radius: 2
    property string fontIcon: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    padding: 0
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
        Row {
            spacing: control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                anchors.verticalCenter: parent.verticalCenter

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: smallIcon ?
                                    control.font.pixelSize * 1.0 :
                                    control.font.pixelSize * 1.25

                text: control.fontIcon

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }

            // Text label
            Label {
                anchors.verticalCenter: parent.verticalCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                text: control.text

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }
    }

    // Background
    background: Rectangle {
        implicitWidth: wide ? EaStyle.Sizes.sideBarContentWidth : (EaStyle.Sizes.sideBarContentWidth - EaStyle.Sizes.fontPixelSize) / 2
        implicitHeight: EaStyle.Sizes.sideBarButtonHeight

        radius: control.radius

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor()//control.hovered ? EaStyle.Colors.themeBackground : EaStyle.Colors.appBarBorder
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

    function backgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeBackgroundHovered1
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

    function borderColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (rippleArea.containsMouse || control.checked || control.down)
            return EaStyle.Colors.appBarBackground
        return EaStyle.Colors.appBarComboBoxBorder
    }

}

