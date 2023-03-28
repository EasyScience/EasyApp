import QtQuick 2.15

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations

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
