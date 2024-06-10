import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Logic as EaLogic

//import Gui.Globals as Globals


Grid {
    columns: 2
    spacing: EaStyle.Sizes.fontPixelSize

    EaElements.SideBarButton {
        fontIcon: "plus-circle"
        text: qsTr("Create a new project")

        onClicked: {
            console.debug(`Clicking '${text}' button: ${this}`)
            projectDescriptionDialog.source = 'ProjectDescriptionDialog.qml'
            EaGlobals.Vars.showProjectDescriptionDialog = true
        }

        Loader {
            id: projectDescriptionDialog
        }
    }

    EaElements.SideBarButton {
        enabled: false

        fontIcon: "upload"
        text: qsTr("Open an existing project")
    }

    EaElements.SideBarButton {
        enabled: false

        fontIcon: "download"
        text: qsTr("Save project as...")
    }

    EaElements.SideBarButton {
        enabled: false

        fontIcon: "times-circle"
        text: qsTr("Close current project")
    }

}

