import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        title: qsTr("Get started")
        collapsible: false

        Loader { source: 'GetStartedGroup.qml' }
    }

    EaElements.GroupBox {
        title: qsTr("Examples")
        collapsed: true
        last: true

        Loader { source: 'ExamplesGroup.qml' }
    }

}

