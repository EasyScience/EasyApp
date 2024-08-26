// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.ProjectDescriptionDialog {

    visible: EaGlobals.Vars.showProjectDescriptionDialog
    onClosed: EaGlobals.Vars.showProjectDescriptionDialog = false

    projectName: Globals.Backend.proxy.project.name
    projectDescription: Globals.Backend.proxy.project.info.description

    onAccepted: {
        Globals.Backend.proxy.project.name = projectName
        Globals.Backend.proxy.project.edit_info('description', projectDescription)
        Globals.Backend.proxy.project.create()
        Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
    }

    Component.onCompleted: {
        projectLocation = Globals.Backend.proxy.project.info.location
    }

}
