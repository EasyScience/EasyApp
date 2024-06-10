import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        title: qsTr("Scrolling example")
        collapsed: false
        last: true

        Loader { source: 'ScrollingGroup.qml' }
    }

}

