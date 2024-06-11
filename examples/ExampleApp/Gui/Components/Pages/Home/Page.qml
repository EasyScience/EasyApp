import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements

import Globals as Globals


Item {
    id: root

    Column {
        anchors.centerIn: parent

        // Application logo
        Image {
            id: appLogo

            source: Globals.Configs.appConfig.icon
            anchors.horizontalCenter: parent.horizontalCenter
            width: EaStyle.Sizes.fontPixelSize * 5
            fillMode: Image.PreserveAspectFit
            antialiasing: true
        }

        // Application name
        Row {
            id: appName

            property string fontFamily: EaStyle.Fonts.thirdFontFamily
            property string fontPixelSize: EaStyle.Sizes.fontPixelSize * 4

            anchors.horizontalCenter: parent.horizontalCenter

            EaElements.Label {
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
                font.weight: Font.Light
                text: Globals.Configs.appConfig.namePrefixForLogo
            }
            EaElements.Label {
                font.family: parent.fontFamily
                font.pixelSize: parent.fontPixelSize
                font.weight: Font.DemiBold
                text: Globals.Configs.appConfig.nameSuffixForLogo
            }
        }

        // Application version
        EaElements.Label {
            id: appVersion

            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr('Version') + ` ${Globals.Configs.appConfig.version} (${Globals.Configs.appConfig.date})`
        }

        // Vertical spacer
        Item { width: 1; height: EaStyle.Sizes.fontPixelSize * 2.5 }

        // Start button
        EaElements.SideBarButton {
            id: startButton

            anchors.horizontalCenter: parent.horizontalCenter

            fontIcon: "rocket"
            text: qsTr("Start")
            onClicked: {
                console.debug(`Clicking '${text}' button: ${this}`)
                Globals.Vars.projectPageEnabled = true
                Globals.Refs.app.appbar.projectButton.toggle()
            }
            Component.onCompleted: Globals.Refs.app.homePage.startButton = this
        }

        // Vertical spacer
        Item { width: 1; height: EaStyle.Sizes.fontPixelSize * 2.5 }

        // Links
        Row {
            id: links

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 3

            Column {
                spacing: EaStyle.Sizes.fontPixelSize

                EaElements.Button {
                    text: qsTr("About %1".arg(Globals.Configs.appConfig.name))
                    onClicked: EaGlobals.Vars.showAppAboutDialog = true
                    Loader { source: "AboutDialog.qml" }
                }
                EaElements.Button {
                    text: qsTr("Online documentation")
                    onClicked: Qt.openUrlExternally("https://github.com/EasyScience/EasyApp")
                }
            }

            Column {
                spacing: EaStyle.Sizes.fontPixelSize

                EaElements.Button {
                    //enabled: false
                    text: qsTr("Tutorial") + " 3: " + qsTr("Advanced usage")
                    onClicked: {
                        console.debug("Tutorial 3 button clicked")
                        dataFittingTutorialTimer.start()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.debug(`Home page loaded: ${this}`)
        Globals.Vars.homePageCreated = true
    }

    Component.onDestruction: console.debug(`Home page destroyed: ${this}`)
}
