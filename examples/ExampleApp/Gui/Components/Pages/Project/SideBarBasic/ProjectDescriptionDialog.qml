import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.ProjectDescriptionDialog {
    visible: EaGlobals.Vars.showProjectDescriptionDialog
    onClosed: EaGlobals.Vars.showProjectDescriptionDialog = false

    onAccepted: {
        Globals.Proxies.main.project.editData('name', projectName)
        Globals.Proxies.main.project.editData('description', projectDescription)
        Globals.Proxies.main.project.editData('location', projectLocation)
        Globals.Proxies.main.project.create()
    }

    Component.onCompleted: {
        projectName = Globals.Proxies.main.project.data.name
        projectDescription = Globals.Proxies.main.project.data.description
        projectLocation = Globals.Proxies.main.project.data.location
    }
}


