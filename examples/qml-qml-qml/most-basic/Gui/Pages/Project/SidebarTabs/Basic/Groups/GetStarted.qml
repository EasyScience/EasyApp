// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Logic as EaLogic

import Gui.Globals as Globals


Grid {

    columns: 2
    spacing: EaStyle.Sizes.fontPixelSize

    EaElements.SideBarButton {
        fontIcon: 'plus-circle'
        text: qsTr('Create a new project')

        onClicked: {
            console.debug(`Clicking '${text}' button ::: ${this}`)
            projectDescriptionDialog.source = '../Popups/ProjectDescription.qml'
            EaGlobals.Vars.showProjectDescriptionDialog = true
        }

        Loader {
            id: projectDescriptionDialog
        }
    }

    EaElements.SideBarButton {
        fontIcon: 'upload'
        text: qsTr('Open an existing project')

        onClicked: {
            console.debug(`Clicking '${text}' button ::: ${this}`)
            openCifFileDialog.open()
        }
    }

    // Misc

    FileDialog{
        id: openCifFileDialog
        fileMode: FileDialog.OpenFile
        nameFilters: [ 'CIF files (*.cif)']
        onAccepted: {
            Globals.Vars.summaryPageEnabled = true
        }
    }

}
