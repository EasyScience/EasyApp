import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Globals as Globals

EaComponents.ApplicationWindow {

    onClosing: Qt.quit()

    Component.onCompleted: {
        console.debug(`Application window loaded: ${this}`)
        Globals.Vars.applicationWindowCreated = true
    }
    Component.onDestruction: console.debug(`Application window destroyed: ${this}`)

    ///////////////////
    // APPLICATION BAR
    ///////////////////

    // Left group of application bar tool buttons
    appBarLeftButtons: [

        EaElements.ToolButton {
            enabled: Globals.Vars.homePageEnabled
            fontIcon: "backspace"
            ToolTip.text: qsTr("Reset to initial state")
            onClicked: {
                appBarCentralTabs.setCurrentIndex(0)
            }
            Component.onCompleted: Globals.Refs.app.appbar.resetStateButton = this
        },
        EaElements.ToolButton {
            enabled: Globals.BackendProxy.main.project.created &&
                    Globals.BackendProxy.main.project.needSave
            highlighted: true
            fontIcon: "save"
            ToolTip.text: qsTr("Save current state of the project")
            onClicked: Globals.BackendProxy.main.project.save()
        }

    ]

    // Right group of application bar tool buttons
    appBarRightButtons: [

        EaElements.ToolButton {
            fontIcon: "cog"
            ToolTip.text: qsTr("Application preferences")
            onClicked: EaGlobals.Vars.showAppPreferencesDialog = true
        }
    ]

    // Central group of application bar tab buttons (workflow tabs)
    // Tab buttons for the pages described below
    appBarCentralTabs.contentData: [

        // Home tab
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.homePageEnabled
            fontIcon: "home"
            text: qsTr("Home")
            ToolTip.text: qsTr("Home page")
            Component.onCompleted: {
                homePageLoader.source = 'Components/Pages/Home/Page.qml'
                Globals.Refs.app.appbar.homeButton = this
            }
        },

        // Project tab
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.projectPageEnabled
            fontIcon: "archive"
            text: qsTr("Project")
            ToolTip.text: qsTr("Project description page")
            onEnabledChanged: enabled ?
                                  projectPageLoader.source = 'Components/Pages/Project/Page.qml' :
                                  projectPageLoader.source = ''
            Component.onCompleted: Globals.Refs.app.appbar.projectButton = this
        },

        // Summary tab
        EaElements.AppBarTabButton {
            enabled: Globals.Vars.summaryPageEnabled
            fontIcon: "clipboard-list"
            text: qsTr("Summary")
            ToolTip.text: qsTr("Summary of the work done")
            onEnabledChanged: enabled ?
                                  summaryPageLoader.source = 'Components/Pages/Summary/Page.qml' :
                                  summaryPageLoader.source = ''
//            onCheckedChanged: checked ?
//                                  Globals.Proxies.main.summary.isCreated = true :
//                                  Globals.Proxies.main.summary.isCreated = false
            Component.onCompleted: Globals.Refs.app.appbar.summaryButton = this
        }
    ]

    //////////////////////
    // MAIN VIEW + SIDEBAR
    //////////////////////

    // Pages for the tab buttons described above
    contentArea: [
        Loader{ id: homePageLoader },
        Loader{ id: projectPageLoader },
        Loader{ id: summaryPageLoader }
    ]
}
