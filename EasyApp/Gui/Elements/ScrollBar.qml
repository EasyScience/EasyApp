import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material

T.ScrollBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: control.interactive ? 2 : 2
    visible: control.policy !== T.ScrollBar.AlwaysOff
    minimumSize: {
        let actualSize = 0.1
        if (orientation === Qt.Horizontal) {
            actualSize = height / width
        } else if (orientation === Qt.Vertical) {
            actualSize = width / height
        }
        const minSize = 0.1
        const selectedSize = Math.max(minSize, actualSize)
        return selectedSize
    }

    contentItem: Rectangle {
        implicitWidth: control.interactive ? 4 : 4
        implicitHeight: control.interactive ? 4 : 4

        color: control.pressed ?
                   control.Material.scrollBarPressedColor :
                   control.interactive && control.hovered ?
                       control.Material.scrollBarHoveredColor :
                       control.Material.scrollBarColor
        opacity: 0.0
    }

    background: Rectangle {
        implicitWidth: control.interactive ? 4 : 4
        implicitHeight: control.interactive ? 4 : 4
        color: "#0e000000"
        opacity: 0.0
        visible: control.interactive
    }

    states: State {
        name: "active"
        when: control.policy === T.ScrollBar.AlwaysOn || (control.active && control.size < 1.0)
    }

    transitions: [
        Transition {
            to: "active"
            NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 1.0 }
        },
        Transition {
            from: "active"
            SequentialAnimation {
                PropertyAction{ targets: [control.contentItem, control.background]; property: "opacity"; value: 1.0 }
                PauseAnimation { duration: 2450 }
                NumberAnimation { targets: [control.contentItem, control.background]; property: "opacity"; to: 0.0 }
            }
        }
    ]
}
