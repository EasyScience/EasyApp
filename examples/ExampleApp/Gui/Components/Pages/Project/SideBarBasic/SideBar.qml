import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        title: qsTr("Project")
        collapsible: false

        Loader { source: 'ProjectGroup.qml' }
    }

    EaElements.GroupBox {
        title: qsTr("Example Projects")
        collapsed: true
        last: true

        Loader { source: 'ExamplesGroup.qml' }
    }

}

