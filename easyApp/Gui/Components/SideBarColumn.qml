import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle

// Basic controls area
Flickable {

    default property alias content: basicControlsContainer.data

    contentHeight: basicControlsContainer.height
    contentWidth: basicControlsContainer.width

    clip: true
    flickableDirection: Flickable.VerticalFlick

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        interactive: false
    }

    Column {
        id: basicControlsContainer

        width: EaStyle.Sizes.sideBarWidth // ???
    }
}
