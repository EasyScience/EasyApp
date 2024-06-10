import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.ProjectDescriptionDialog {
    visible: EaGlobals.Vars.showProjectDescriptionDialog
    onClosed: EaGlobals.Vars.showProjectDescriptionDialog = false

    onAccepted: {
        Globals.BackendProxy.main.project.editData('name', projectName)
        Globals.BackendProxy.main.project.editData('description', projectDescription)
        Globals.BackendProxy.main.project.editData('location', projectLocation)
        Globals.BackendProxy.main.project.create()
    }

    Component.onCompleted: {
        projectName = Globals.BackendProxy.main.project.data.name
        projectDescription = Globals.BackendProxy.main.project.data.description
        projectLocation = Globals.BackendProxy.main.project.data.location
    }
}


