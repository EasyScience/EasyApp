import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

T.TabButton {
    id: control

    property bool highlighted: false
    property bool outlineIcon: false
    property string fontIcon: ""
    property string iconColor: ""
    property string backgroundColor: getBackgroundColor()
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
        visible: control.hovered && EaGlobals.Vars.showToolTips && text !== ""
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

                color: iconColor ? iconColor : foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }

                // Icon outline
                Repeater {
                    model: 9

                    Label {
                        x: 0.5 * (index % 3 - 1)
                        y: 0.5 * (Math.floor(index / 3) - 1)
                        z: -2

                        font.family: parent.font.family
                        font.pixelSize: parent.font.pixelSize

                        opacity: outlineIcon ? 1 : 0

                        color: EaStyle.Colors.isDarkTheme ?
                                   Qt.lighter(iconColor, 1.6) :
                                   Qt.darker(iconColor, 1.6)
                        Behavior on color { EaAnimations.ThemeChange {} }

                        text: parent.text
                    }
                }
                // Icon outline
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

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        //onClicked: control.clicked() // Doesn't work as for Button or ToolButton
        onPressed: (mouse) => mouse.accepted = false // Color doesn't changed onPressed
    }

    // Logic

    function getBackgroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.contentBackground
        if (mouseArea.containsMouse)
            return EaStyle.Colors.themeBackgroundHovered1
        return EaStyle.Colors.contentBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (!highlighted) {
            if (mouseArea.containsMouse || control.checked || control.down)
                return EaStyle.Colors.themeForegroundHovered
            return EaStyle.Colors.themeForeground
        }
        return EaStyle.Colors.themeForegroundHighlight
    }
}
