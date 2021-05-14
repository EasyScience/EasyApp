import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.DialogButtonBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: EaStyle.Sizes.fontPixelSize * 2

    topPadding: 0
    bottomPadding: EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize * 1.5
    rightPadding: EaStyle.Sizes.fontPixelSize * 1.5
    verticalPadding: 2

    alignment: Qt.AlignRight
    buttonLayout: T.DialogButtonBox.AndroidLayout

    delegate: EaElements.Button { highlighted: true }

    contentItem: ListView {
        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    // Buttons area
    background: PaddedRectangle {
        color: EaStyle.Colors.dialogBackground
        Behavior on color { EaAnimations.ThemeChange {} }
    }
}
