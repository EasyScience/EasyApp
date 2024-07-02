// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Gui as Gui
import Gui.Globals as Globals

EaComponents.ApplicationWindow {

    ///////////////////
    // APPLICATION BAR
    ///////////////////

    // Left group of application bar tool buttons
    appBarLeftButtons: [

        EaElements.ToolButton {
            enabled: Globals.Vars.backendProxy.project.created
            highlighted: true
            fontIcon: 'save'
            ToolTip.text: qsTr('Save current state of the project')
            onClicked: Globals.Vars.backendProxy.project.save()
        }

    ]

    // Right group of application bar tool buttons
    appBarRightButtons: [

        EaElements.ToolButton {
            fontIcon: 'cog'
            ToolTip.text: qsTr('Application preferences')
            onClicked: EaGlobals.Vars.showAppPreferencesDialog = true
        }
    ]

    // Central group of application bar page buttons (workflow tabs)
    // Page buttons for the pages described below
    appBarCentralTabs.contentData: [

        // Home page
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.homePageEnabled
            fontIcon: 'home'
            text: qsTr('Home')
            ToolTip.text: qsTr('Home')
            Component.onCompleted: Globals.Refs.app.appbar.homeButton = this
        },
        // Home page

        // Project page
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.projectPageEnabled
            fontIcon: 'archive'
            text: qsTr('Project')
            ToolTip.text: qsTr('Project description page')
            Component.onCompleted: Globals.Refs.app.appbar.projectButton = this
        },
        // Project page

        // Summary page
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.summaryPageEnabled
            fontIcon: 'clipboard-list'
            text: qsTr('Summary')
            ToolTip.text: qsTr('Summary of the work done')
            Component.onCompleted: Globals.Refs.app.appbar.summaryButton = this
        }
        // Summary page
    ]

    //////////////////////////////////
    // APP PAGES (MAIN AREA + SIDEBAR)
    //////////////////////////////////

    // Pages for the tab buttons described above
    contentArea: [
        Loader { source: 'Pages/Home/Content.qml' },
        Loader { source: 'Pages/Project/Layout.qml' },
        Loader { source: 'Pages/Report/Layout.qml' }
    ]

    /////////////
    // STATUS BAR
    /////////////

    statusBar: Gui.StatusBar {}

    ///////
    // MISC
    ///////

    onClosing: Qt.quit()

    Component.onCompleted: console.debug(`Application window loaded ::: ${this}`)
    Component.onDestruction: console.debug(`Application window destroyed ::: ${this}`)

}
