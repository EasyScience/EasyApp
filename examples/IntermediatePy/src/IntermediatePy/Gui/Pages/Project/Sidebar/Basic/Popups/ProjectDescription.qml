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

    projectName: Globals.BackendProxy.projectName
    projectDescription: Globals.BackendProxy.projectInfo.description

    onAccepted: {
        Globals.BackendProxy.projectName = projectName
        Globals.BackendProxy.projectEditInfo('description', projectDescription)
        Globals.BackendProxy.projectCreate()
        Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
    }

    Component.onCompleted: {
        projectLocation = Globals.BackendProxy.projectInfo.location
    }

}
