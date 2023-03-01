import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    default property alias contentRowData: contentRow.data

    width: parent == null ? 0 : parent.width
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
        onPressed: (mouse) => {
            parent.ListView.view.currentIndex = index
            mouse.accepted = false
        }        
    }
}
