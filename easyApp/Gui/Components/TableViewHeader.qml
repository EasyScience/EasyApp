import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations

Rectangle {
    default property alias contentRowData: contentRow.data

    z: 2 // To display header above delegate

    width: parent === null ? 0 : parent.width
    height: EaStyle.Sizes.tableRowHeight

    color: EaStyle.Colors.themeBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }
}
