import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

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
