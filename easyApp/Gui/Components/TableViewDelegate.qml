import QtQuick

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations

Rectangle {
    default property alias contentRowData: contentRow.data

    width: parent === null ? 0 : parent.width
    height: EaStyle.Sizes.tableRowHeight

    color: index % 2 ?
               EaStyle.Colors.themeBackgroundHovered2 :
               EaStyle.Colors.themeBackgroundHovered1
    Behavior on color { EaAnimations.ThemeChange {} }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }

    // Highligh row on click
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.ListView.view.currentIndex = index
            mouse.accepted = false
        }
    }
}
