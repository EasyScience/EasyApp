import QtQuick 2.13
import QtQuick.Controls 2.13

import easyApp.Gui.Style 1.0 as EaStyle

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
