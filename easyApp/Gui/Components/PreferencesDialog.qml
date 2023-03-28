import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15
import QtQuick.XmlListModel 2.15
import Qt.labs.settings 1.0

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

EaElements.Dialog {
    id: dialog

    contentWidth: bar.implicitWidth
    contentHeight: bar.implicitHeight +
                   implicitHeaderHeight +
                   topPadding +
                   bottomPadding +
                   EaStyle.Sizes.fontPixelSize * 9

    visible: EaGlobals.Variables.showAppPreferencesDialog
    onClosed: EaGlobals.Variables.showAppPreferencesDialog = false

    title: qsTr("Preferences")

    standardButtons: Dialog.Ok

    Component.onCompleted: setPreferencesOkButton()

    // TabBar

    EaElements.TabBar {
        id: bar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        background: Rectangle {
            z: 2
            anchors.fill: parent
            color: "transparent"
            border.color: EaStyle.Colors.appBarBorder
        }

        EaElements.AppBarTabButton {
            fontIcon: "users"
            text: qsTr("Prompts")
            ToolTip.text: qsTr("")

            Component.onCompleted: EaGlobals.Variables.promptsTab = this
        }

        EaElements.AppBarTabButton {
            fontIcon: "cloud-download-alt"
            text: qsTr("Updates")
            ToolTip.text: qsTr("")
        }

        EaElements.AppBarTabButton {
            fontIcon: "paint-brush"
            text: qsTr("Appearance")
            ToolTip.text: qsTr("")

            Component.onCompleted: EaGlobals.Variables.appearanceTab = this
        }

        EaElements.AppBarTabButton {
            fontIcon: "flask"
            text: qsTr("Experimental")
            ToolTip.text: qsTr("")
        }

        EaElements.AppBarTabButton {
            fontIcon: "laptop-code"
            text: qsTr("Develop")
            ToolTip.text: qsTr("")
        }
    }

    // Main area

    SwipeView {
        id: view

        anchors.top: bar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: EaStyle.Sizes.fontPixelSize * 0.75
        leftPadding: EaStyle.Sizes.fontPixelSize * 0.5
        bottomPadding: EaStyle.Sizes.fontPixelSize * 3

        currentIndex: bar.currentIndex

        clip: true

        // Prompts tab content

        Grid {
            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
               text: qsTr("Enable tool tips") + ":"
            }

            EaElements.CheckBox {
                id: toolTipsCheckBox
                checked: EaGlobals.Variables.showToolTips
                onCheckedChanged: EaGlobals.Variables.showToolTips = checked
                Component.onCompleted: ExGlobals.Variables.enableToolTipsCheckBox = this
            }

            EaElements.Label {
               text: qsTr("Enable user guides") + ":"
            }

            EaElements.CheckBox {
                id: userGuidesCheckBox
                checked: EaGlobals.Variables.showUserGuides
                onCheckedChanged: EaGlobals.Variables.showUserGuides = checked
                Component.onCompleted: ExGlobals.Variables.enableUserGuidesCheckBox = this
            }

        }

        // Updates tab content

        Column {
            topPadding: EaStyle.Sizes.fontPixelSize * 0.5
            spacing: EaStyle.Sizes.fontPixelSize * 1.5

            Row {
                id: checkOnAppStartRow
                spacing: EaStyle.Sizes.fontPixelSize

                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Check on application start") + ":"
                }

                EaElements.CheckBox {
                    id: updatesCheckBox
                    padding: 0
                    checked: EaGlobals.Variables.checkUpdateOnAppStart
                    onCheckedChanged: EaGlobals.Variables.checkUpdateOnAppStart = checked
                }
            }

            EaElements.SideBarButton {
                width: checkOnAppStartRow.width
                highlighted: true
                text: qsTr("Check now")
                onClicked: {
                    EaGlobals.Variables.updater.silentCheck = false
                    EaGlobals.Variables.updater.checkUpdate()
                }
            }
        }

        // Appearance tab content

        Grid {
            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
                text: qsTr("Theme") + ":"
            }

            EaElements.ComboBox {
                model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                onActivated: {
                    if (currentIndex === 0)
                        EaStyle.Colors.theme = EaStyle.Colors.LightTheme
                    else if (currentIndex === 1)
                        EaStyle.Colors.theme = EaStyle.Colors.DarkTheme
                    else if (currentIndex === 2)
                        EaStyle.Colors.theme = EaStyle.Colors.SystemTheme
                }
                Component.onCompleted: {
                    ExGlobals.Variables.themeSelector = this
                    if (EaStyle.Colors.theme === EaStyle.Colors.LightTheme)
                        currentIndex = 0
                    else if (EaStyle.Colors.theme === EaStyle.Colors.DarkTheme)
                        currentIndex = 1
                    else if (EaStyle.Colors.theme === EaStyle.Colors.SystemTheme)
                        currentIndex = 2
                }
            }

            EaElements.Label {
                text: qsTr("Data plotting") + ":"
            }

            EaElements.ComboBox {
                model: ExGlobals.Constants.proxy.plotting1d.libs
                onActivated: ExGlobals.Constants.proxy.plotting1d.currentLib = currentValue
                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.plotting1d.currentLib)
                }
            }

            /*
            EaElements.Label {
                visible: ExGlobals.Constants.appName === 'easydiffraction'
                text: qsTr("Structure plotting") + ":"
            }

            EaElements.ComboBox {
                model: ExGlobals.Constants.proxy.plotting3d.plotting3dLibs
                onActivated: ExGlobals.Constants.proxy.plotting3d.current3dPlottingLib = currentValue
                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.plotting3d.current3dPlottingLib)
                }
            }
            */

        }

        // Experimental tab content

        Grid {
            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
                text: qsTr("Zoom") + ":"
            }

            EaElements.ComboBox {
                model: ["100%", "110%", "120%", "130%", "140%", "150%"]
                onCurrentTextChanged: {
                    if (parseInt(currentText) === EaStyle.Sizes.defaultScale) {
                        return
                    }
                    EaStyle.Sizes.defaultScale = parseInt(currentText)
                }
            }

            EaElements.Label {
                text: qsTr("Language") + ":"
            }

            EaElements.ComboBox {
                id: languageSelector
                model: XmlListModel {
                    xml: EaGlobals.Variables.translator.languagesAsXml()
                    query: "/data/item"
                    XmlRole {
                        name: "name"
                        query: "name/string()"
                    }
                    onStatusChanged: {
                        if (status === XmlListModel.Ready) {
                            languageSelector.currentIndex = EaGlobals.Variables.translator.defaultLanguageIndex()
                        }
                    }
                }
               onActivated: EaGlobals.Variables.translator.selectLanguage(currentIndex)
            }

        }

        // Develop tab content

        Grid {
            enabled: false

            columns: 2
            columnSpacing: EaStyle.Sizes.fontPixelSize
            rowSpacing: EaStyle.Sizes.fontPixelSize
            verticalItemAlignment: Grid.AlignVCenter

            EaElements.Label {
                text: qsTr("Logging to") + ":"
            }

            EaElements.ComboBox {
                model: ["Disabled", "Terminal", "File"]
                currentIndex: 1
            }

            EaElements.Label {
                text: qsTr("Logging level") + ":"
            }

            EaElements.ComboBox {
                model: ["Info", "Debug", "Warning"]
                currentIndex: 1
            }
        }

    }

    // Misc

    Settings {
        fileName: EaGlobals.Variables.settingsFile
        category: 'Preferences'
        property alias checkUpdateOnAppStart: updatesCheckBox.checked
        property alias enableToolTips: toolTipsCheckBox.checked
        property alias enableUserGuides: userGuidesCheckBox.checked
    }

    // Logic

    function setPreferencesOkButton() {
        const buttons = dialog.footer.contentModel.children
        for (let i in buttons) {
            const button = buttons[i]
            if (button.text === 'OK') {
                ExGlobals.Variables.preferencesOkButton = button
                return
            }
        }
    }
}
