import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

EaElements.TextField {
    id: control

    property string units: ""

    rightPadding: unitsPlaceholder.width

    PlaceholderText {
        id: unitsPlaceholder

        x: control.width - width
        anchors.verticalCenter: control.verticalCenter
        leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
        rightPadding: EaStyle.Sizes.fontPixelSize * 0.75

        font: control.font
        color: control.placeholderTextColor

        text: units
    }
}
