import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle


Flickable {

    default property alias content: column.data
    readonly property int childrenCount: column.children.length

    //enabled: childrenCount

    contentHeight: column.height
    contentWidth: column.width

    clip: true
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        interactive: false
    }

    Column {
        id: column

        width: EaStyle.Sizes.sideBarWidth
    }

}
