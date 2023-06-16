import QtQuick 2.15
import QtQuick.Controls 2.15

import EasyApp.Gui.Style 1.0 as EaStyle
import EasyApp.Gui.Animations 1.0 as EaAnimations
import EasyApp.Gui.Elements 1.0 as EaElements

Rectangle {
    id: statusBar

    default property alias contentRowData: contentRow.data

    width: parent.width
    height: parent.height

    color: EaStyle.Colors.statusBarBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    // main content container
    Row {
        id: contentRow

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize

        spacing: EaStyle.Sizes.fontPixelSize * 1.5
    }

    // Status bar top border
    Rectangle {
        anchors.top: statusBar.top
        anchors.left: statusBar.left
        anchors.right: statusBar.right

        height: 1//EaStyle.Sizes.borderThickness

        color: EaStyle.Colors.appBarBorder
        Behavior on color { EaAnimations.ThemeChange {} }
    }

}
