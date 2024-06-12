import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements

import Globals as Globals


Grid {
    columns: 2
    spacing: EaStyle.Sizes.fontPixelSize

    EaElements.SideBarButton {
        fontIcon: "plus-circle"
        text: qsTr("Create a new")

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
        fontIcon: "upload"
        text: qsTr("Open an existing")

        onClicked: {
            fileDialogLoadProject.open()
            console.debug(`Clicking '${text}' button: ${this}`)
        }
//        Component.onCompleted: ExGlobals.Variables.openProjectButton = this
    }

    EaElements.SideBarButton {
        enabled: false

        fontIcon: "download"
        text: qsTr("Save as...")
    }

    EaElements.SideBarButton {
        enabled: false

        fontIcon: "times-circle"
        text: qsTr("Close current")
    }

    FileDialog {
        id: fileDialogLoadProject
        nameFilters: ["Project files (*.json)"]
        onAccepted: {
            // enablement will depend on what is available in the project file,
            // obviously, so care is needed. TODO
            console.debug(`Selected '${selectedFile}'`)
            Globals.BackendProxy.main.project.load(selectedFile)

//            ExGlobals.Variables.samplePageEnabled = true
//            ExGlobals.Variables.experimentPageEnabled = true
        }
    }


}

