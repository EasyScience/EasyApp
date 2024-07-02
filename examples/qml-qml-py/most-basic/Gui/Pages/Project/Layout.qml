// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.ContentPage {

    defaultInfo: Globals.Vars.backendProxy.project.created ?
                     '' :
                     qsTr('No project defined')

    mainView: EaComponents.MainContent {
        tabs: [
            EaElements.TabButton { text: qsTr('Description') }
        ]

        items: [
            Loader { source: 'MainAreaTabs/Description.qml' }
        ]
    }

    sideBar: EaComponents.SideBar {
        tabs: [
            EaElements.TabButton { text: qsTr('Basic controls') },
            EaElements.TabButton { text: qsTr('Extra controls') },
            EaElements.TabButton { text: qsTr('Text mode controls'); enabled: false}
        ]

        items: [
            Loader { source: 'SidebarTabs/Basic/Layout.qml' },
            Loader { source: 'SidebarTabs/Extra/Layout.qml' },
            Loader { source: 'SidebarTabs/Text/Layout.qml' }
        ]

        continueButton.text: Globals.Vars.backendProxy.project.created ?
                                 qsTr('Continue') :
                                 qsTr('Continue without project')

        continueButton.onClicked: {            
            console.debug(`Clicking '${continueButton.text}' button ::: ${this}`)
            Globals.Vars.summaryPageEnabled = true
            Globals.Refs.app.appbar.summaryButton.toggle()
        }

        Component.onCompleted: Globals.Refs.app.projectPage.continueButton = continueButton
    }

    Component.onCompleted: console.debug(`Project page loaded ::: ${this}`)
    Component.onDestruction: console.debug(`Project page destroyed ::: ${this}`)

}
