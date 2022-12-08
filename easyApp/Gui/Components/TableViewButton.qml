import QtQuick 2.15

import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Style 1.0 as EaStyle

EaElements.SideBarButton {
    property string headerText: ""
    property int horizontalAlignment: Text.AlignHCenter

    property int inset: 6

    leftInset: inset / 2
    rightInset: inset / 2
    topInset: inset / 2
    bottomInset: inset / 2

    y: -1

    height: EaStyle.Sizes.tableRowHeight
    width: EaStyle.Sizes.tableRowHeight
}
