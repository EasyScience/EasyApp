import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements

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

    Row {
        EaElements.Label { text: control.text; color: control.color }
        EaElements.Label { id: dot1; text: '.'; color: control.color }
        EaElements.Label { id: dot2; text: '.'; color: control.color }
        EaElements.Label { id: dot3; text: '.'; color: control.color }
    }

    SequentialAnimation {
        running: control.running
        loops: Animation.Infinite

        SequentialAnimation {
            PropertyAnimation { target: dot1; property: 'opacity'; to: 1; duration: 500 }
            PropertyAnimation { target: dot2; property: 'opacity'; to: 1; duration: 500 }
            PropertyAnimation { target: dot3; property: 'opacity'; to: 1; duration: 500 }
        }

        PauseAnimation { duration: 250 }

        ParallelAnimation {
            PropertyAction { target: dot1; property: 'opacity'; value: 0 }
            PropertyAction { target: dot2; property: 'opacity'; value: 0 }
            PropertyAction { target: dot3; property: 'opacity'; value: 0 }
        }

        PauseAnimation { duration: 250 }
    }
}
