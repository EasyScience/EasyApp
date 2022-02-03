import QtQuick 2.13

import Globals 1.0 as Globals
import Templates.Animations 1.0 as Animations
import Templates.Controls 1.0

Rectangle {
    id: indicator

    implicitWidth: Globals.Sizes.fontPixelSize
    implicitHeight: Globals.Sizes.fontPixelSize

    radius: width / 2

    color: "transparent"
    border.width: Globals.Sizes.fontPixelSize / 8

    /*
    border.color: !control.enabled ?
               Globals.Colors.themeForegroundDisabled :
               control.checked || control.down ?
                   Globals.Colors.themeAccent :
                   Globals.Colors.themeForeground
                   */
    /*
    Behavior on border.color {
        Animations.ThemeChange {}
    }
    */

    property Item control

    Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        width: Globals.Sizes.fontPixelSize * 0.6
        height: Globals.Sizes.fontPixelSize * 0.6

        radius: width / 2

        visible: indicator.control.checked || indicator.control.down

        color: parent.border.color
        /*
        Behavior on color {
            Animations.ThemeChange {}
        }
        */
    }
}
