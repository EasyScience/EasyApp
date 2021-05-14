import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyApp.Style 1.0 as EaStyle
import easyApp.Animations 1.0 as EaAnimations

T.Label {
    id: control

    property color backgroundColor: "transparent"

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: enabled ?
               EaStyle.Colors.themeForeground :
               EaStyle.Colors.themeForegroundDisabled //Material.foreground : Material.hintTextColor
    Behavior on color { EaAnimations.ThemeChange {} }

    linkColor: hoveredLink ?
                   EaStyle.Colors.linkHovered :
                   EaStyle.Colors.link
    Behavior on linkColor { EaAnimations.ThemeChange {} }

    background: Rectangle {
        width: control.width
        height: control.height

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ?
                         Qt.PointingHandCursor :
                         Qt.ArrowCursor
    }

    onLinkActivated: Qt.openUrlExternally(link)
}
