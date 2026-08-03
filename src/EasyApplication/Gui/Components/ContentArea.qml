import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Globals as EaGlobals

SwipeView {
    //anchors.top: parent.top
    //anchors.bottom: parent.bottom
    //anchors.left: parent.left
    //anchors.right: parent.right
    //anchors.fill: parent

    // WebAssembly: a layer instead of clip. See EaGlobals.Vars.isWasm and the
    // longer note in SideBar.qml. This is the outermost of the three swipe
    // views - the workflow pages - so its texture is the size of the content
    // area. If WebAssembly performance suffers, this is the first one to
    // reconsider.
    clip: !EaGlobals.Vars.isWasm
    layer.enabled: EaGlobals.Vars.isWasm
    interactive: false
}
