import QtQuick


import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Globals as Globals

EaComponents.ContentPage {
    defaultInfo: Globals.BackendProxy.main.project.created ?
                     "" :
                     qsTr("No project created / opened")

    mainView: EaComponents.MainContent {
        tabs: [
            EaElements.TabButton { text: qsTr("Description") }
        ]

        items: [
            Loader { source: 'MainContent/MainContent.qml' }
        ]
    }

    sideBar: EaComponents.SideBar {
        tabs: [
            EaElements.TabButton { text: qsTr("Basic controls") },
            EaElements.TabButton { text: qsTr("Advanced controls") }
        ]

        items: [
            Loader { source: 'SideBarBasic/SideBar.qml' },
            Loader { source: 'SideBarAdvanced/SideBar.qml' }
        ]

        continueButton.text: Globals.BackendProxy.main.project.created ?
                                 qsTr("Continue") :
                                 qsTr("Continue without project")

        continueButton.onClicked: {            
            console.debug(`Clicking '${continueButton.text}' button: ${this}`)
            Globals.Vars.summaryPageEnabled = true
            Globals.Refs.app.appbar.summaryPageButton.toggle()
        }

        Component.onCompleted: Globals.Refs.app.projectPage.continueButton = continueButton
    }

    Component.onCompleted: console.debug(`Project page loaded: ${this}`)
    Component.onDestruction: console.debug(`Project page destroyed: ${this}`)
}
