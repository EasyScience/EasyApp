import QtQuick 2.15

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Elements 1.0 as EaElements

Item {
    id: control

    property string text: ""
    property bool running: false
    property color color: EaStyle.Colors.themeForegroundHovered

    visible: running
    width: childrenRect.width
    height: childrenRect.height
    anchors.right: parent.right
    anchors.rightMargin: EaStyle.Sizes.fontPixelSize
    anchors.verticalCenter: parent.verticalCenter

    EaElements.Label {
        id: label
        text: control.text
        color: control.color
        font.bold: true
    }

    SequentialAnimation {
        running: control.running
        loops: Animation.Infinite

        PropertyAnimation {
            target: label
            property: 'opacity'
            to: 1
            duration: 750
            easing: Easing.OutExpo
        }

        PropertyAnimation {
            target: label
            property: 'opacity'
            to: 0
            duration: 750
            easing: Easing.OutExpo
        }
    }
}
