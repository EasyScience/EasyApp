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
    defaultInfo: Globals.Vars.backendProxy.summary.created ?
                     "" :
                     qsTr("No Summary Generated")

    mainView: EaComponents.MainContent {
        tabs: [
            EaElements.TabButton { text: qsTr("Summary") }
        ]

        items: [
            Loader {
                source: 'MainAreaTabs/Summary.qml'
                onStatusChanged: if (status === Loader.Ready) console.debug(`${source} loaded`)
            }
        ]
    }

    sideBar: EaComponents.SideBar {
        tabs: [
            EaElements.TabButton { text: qsTr("Basic controls") },
            EaElements.TabButton { text: qsTr("Extra controls") }
        ]

        items: [
            Loader { source: 'SidebarTabs/Basic/Layout.qml' },
            Loader { source: 'SidebarTabs/Extra/Layout.qml' }
        ]

        continueButton.visible: false
    }

    Component.onCompleted: console.debug(`Summary page loaded ::: ${this}`)
    Component.onDestruction: console.debug(`Summary page destroyed ::: ${this}`)
}
