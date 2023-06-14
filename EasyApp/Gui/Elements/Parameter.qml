import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements


EaElements.TextField {
    id: control

    property string units: ''
    property string title: ''

    rightPadding: unitsPlaceholder.width

    topInset: title === '' ? 0 : EaStyle.Sizes.fontPixelSize * 1.5
    topPadding: topInset + padding

    width: (EaStyle.Sizes.sideBarContentWidth -
            (parent.children.length - 1) * EaStyle.Sizes.fontPixelSize * 0.5) /
           parent.children.length
    placeholderText: ''

    onAccepted: focus = false

    EaElements.Label {
        anchors.right: parent.right
        rightPadding: unitsPlaceholder.width

        color: EaStyle.Colors.themeForegroundMinor

        text: control.title
    }

    PlaceholderText {
        id: unitsPlaceholder

        x: control.width - width
        anchors.verticalCenter: control.verticalCenter
        leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
        rightPadding: EaStyle.Sizes.fontPixelSize * 0.75

        font: control.font
        color: control.placeholderTextColor

        text: units
        textFormat: Text.RichText
    }

}
