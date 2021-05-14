import QtQuick 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

Item {
    id: root
    implicitWidth: initialSize
    implicitHeight: initialSize

    property real value: 0
    property bool handleHasFocus: false
    property bool handlePressed: false
    property bool handleHovered: false
    readonly property int initialSize: 20
    readonly property var control: parent

    Rectangle {
        id: handleRect
        width: parent.width
        height: parent.height
        radius: width / 2

        scale: root.handlePressed ? 1.5 : 1
        color: EaStyle.Colors.themeForegroundHovered
        Behavior on color { EaAnimations.ThemeChange {} }

        Behavior on scale {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Ripple {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: initialSize * 1.25
        height: initialSize * 1.25

        pressed: root.handlePressed
        active: root.handlePressed || root.handleHasFocus || root.handleHovered

        color: root.control.Material.rippleColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }
}
