import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations


T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    /*
    topInset: 0
    bottomInset: 0
    horizontalPadding: 0
    */

    flat: true

    // Icon text
    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font

        color: foregroundColor()
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: control
        hoverEnabled: true
        //onClicked: control.clicked()
        onPressed: mouse.accepted = false
    }

    // Logic

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse || control.checked || control.down)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }
}
