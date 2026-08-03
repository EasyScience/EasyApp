import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Elements as EaElements

Item {
    id: mainAreaContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    anchors.fill: parent

    EaElements.TabBar {
        id: tabs

        anchors.top: mainAreaContainer.top
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right
    }

    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: mainAreaContainer.bottom
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right

        // WebAssembly: a layer instead of clip. See EaGlobals.Vars.isWasm and
        // the longer note in SideBar.qml - the same applies to the main
        // area's own tabs.
        clip: !EaGlobals.Vars.isWasm
        layer.enabled: EaGlobals.Vars.isWasm
        interactive: false

        currentIndex: tabs.currentIndex
    }

}
