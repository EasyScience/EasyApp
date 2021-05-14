import QtQuick 2.13

import easyApp.Style 1.0 as EaStyle
import easyApp.Animations 1.0 as EaAnimations
import easyApp.Elements 1.0 as EaElements

EaElements.TabButton {
    id: control

    implicitHeight: EaStyle.Sizes.appBarHeight

    // Icon with text label
    contentItem: Item {
        implicitWidth: row.width

        Column {
            id: row
            spacing: 0 //control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize * 1.5

                text: control.fontIcon

                color: foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }

            // Text label
            Label {
                id: textLabel

                anchors.horizontalCenter: parent.horizontalCenter

                font.family: control.font.family
                font.pixelSize: control.font.pixelSize * 0.95
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
        implicitWidth: textLabel.implicitWidth + control.font.pixelSize * 1.5

        color: backgroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
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
            return EaStyle.Colors.themeBackground
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeBackgroundHovered2
        return EaStyle.Colors.themeBackground
    }

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }
}
