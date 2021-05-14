import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Templates 2.13 as T

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

import easyApp.Logic.Maintenance 1.0 as EaMaintenance


T.ApplicationWindow {
    id: window

    property string appName: ''
    property string appVersion: ''
    property string appDate: ''

    property string webVersion: updater.webVersion
    property string webDate: ''

    visible: true
    flags: EaGlobals.Variables.appWindowFlags

    x: EaStyle.Sizes.appWindowX
    y: EaStyle.Sizes.appWindowY

    width: EaStyle.Sizes.appWindowWidth
    height: EaStyle.Sizes.appWindowHeight

    minimumWidth: EaStyle.Sizes.appWindowMinimumWidth
    minimumHeight: EaStyle.Sizes.appWindowMinimumHeight

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    // Updater

    EaMaintenance.Updater {
        id: updater

        onUpdateFound: updateFoundDialog.open()
        onUpdateNotFound: updateNotFoundDialog.open()
        onUpdateFailed: updateFailedDialog.open()

        Component.onCompleted: EaGlobals.Variables.updater = this
    }

    // Check update on app start (if needed)

    Timer {
        interval: 2000
        repeat: false
        running: EaGlobals.Variables.checkUpdateOnAppStart
        onTriggered: {
            updater.silentCheck = true
            updater.checkUpdate()
        }
    }

    // Updater dialogs

    EaElements.Dialog {
        id: updateFoundDialog

        title: qsTr('Update Available')

        Column {
            spacing: EaStyle.Sizes.fontPixelSize

            EaElements.Label {
                textFormat: Text.RichText
                text: qsTr("Current version: %1 (%2)<br>
                            Available version: %3 (%4)"
                           .arg(appVersion).arg(appDate)
                           .arg(webVersion).arg(webDate))
            }

            Column {
                visible: updater.releaseNotes

                EaElements.Label {
                    text: qsTr("Release notes:")
                }

                ScrollView {
                    width: EaStyle.Sizes.fontPixelSize * 40
                    height: EaStyle.Sizes.fontPixelSize * 25
                    clip: true

                    EaElements.TextArea {
                        wrapMode: TextEdit.Wrap
                        readOnly: true
                        backgroundOpacity: 0.5
                        textFormat: Text.MarkdownText
                        text: updater.releaseNotes
                    }
                }
            }
        }

        footer: EaElements.DialogButtonBox {
            EaElements.Button {
                text: qsTr("Not Now")
                onClicked: updateFoundDialog.close()
            }

            EaElements.Button {
                text: qsTr("Update")
                onClicked: updater.installUpdate()
            }
        }
    }

    EaElements.Dialog {
        id: updateNotFoundDialog

        title: qsTr('No Updates')

        standardButtons: Dialog.Ok

        EaElements.Label {
            textFormat: Text.RichText
            text: qsTr("You are up to date.<br><br>
                        %1 version %2 (%3)<br>
                        is currently the newest version available."
                       .arg(appName).arg(appVersion).arg(appDate))
        }
    }

    EaElements.Dialog {
        id: updateFailedDialog

        title: qsTr('Update Error')

        standardButtons: Dialog.Ok

        EaElements.Label {
            textFormat: Text.RichText
            text: qsTr('There was an error checking for updates.
                        <br>
                        Please try again later.')
        }
    }

    // Quit animation

    PropertyAnimation {
        id: quitAnimo

        target: window

        property: 'opacity'
        to: 0

        duration: 150
        easing.type: Easing.InCubic

        alwaysRunToEnd: true

        onFinished: Qt.quit()
    }

    function quit() {
        quitAnimo.start()
    }
}
