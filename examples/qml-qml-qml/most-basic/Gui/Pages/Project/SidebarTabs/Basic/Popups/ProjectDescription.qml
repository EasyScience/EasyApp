// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
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

    onAccepted: {
        Globals.Vars.backendProxy.project.create()
    }

    Component.onCompleted: {
        projectName = Globals.Vars.backendProxy.project.info.name
        projectDescription = Globals.Vars.backendProxy.project.info.description
        projectLocation = Globals.Vars.backendProxy.project.info.location
    }

}
