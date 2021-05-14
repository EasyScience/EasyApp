import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.3 as QtQuickDialogs1
import Qt.labs.platform 1.1 as QtLabsPlatform1
import Qt.labs.settings 1.0

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Logic 1.0 as EaLogic

EaElements.Dialog {
    id: dialog

    property alias projectName: projectNameField.text
    property alias projectShortDescription: projectShortDescriptionField.text

    //property alias shortcuts: projectParentDirDialog.shortcuts

    property string projectLocation: ""
    property int inputFieldWidth: EaStyle.Sizes.fontPixelSize * 30

    title: qsTr("Project Description")

    standardButtons: Dialog.Ok

    Column {
        spacing: EaStyle.Sizes.fontPixelSize * 1.0

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Name")
            }

            EaElements.TextField {
                id: projectNameField

                implicitWidth: inputFieldWidth
                horizontalAlignment: TextInput.AlignLeft
                placeholderText: qsTr("Enter project name here")

                Component.onCompleted: text = projectPathDict().basename
            }
        }

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Short description")
            }

            EaElements.TextField {
                id: projectShortDescriptionField

                implicitWidth: inputFieldWidth
                horizontalAlignment: TextInput.AlignLeft
                placeholderText: qsTr("Enter short project description here")
            }
        }

        Column {
            EaElements.Label {
                enabled: false
                text: qsTr("Location")
            }

            EaElements.TextField {
                id: projectLocationField

                implicitWidth: inputFieldWidth
                rightPadding: chooseButton.width
                horizontalAlignment: TextInput.AlignLeft

                placeholderText: qsTr("Enter project location here")
                text: EaLogic.Utils.urlToLocalFile(projectParentDirDialog.folder + EaLogic.Utils.osPathSep() + projectNameField.text)

                EaElements.ToolButton {
                    id: chooseButton

                    anchors.right: parent.right

                    fontIcon: "folder-open"
                    ToolTip.text: qsTr("Choose project parent directory")

                    showBackground: false

                    onClicked: projectParentDirDialog.open()
                }
            }
        }
    }

    QtQuickDialogs1.FileDialog {
        id: projectParentDirDialog

        title: qsTr("Choose project parent directory")
        selectFolder: true
        selectMultiple: false

        Component.onCompleted: folder = projectPathDict().parent
    }

    onAccepted: projectLocation = projectLocationField.text

    // Persistent settings

    Settings {
        fileName: EaGlobals.Variables.settingsFile
        category: 'Location'
        property alias projectLocation: dialog.projectLocation
    }

    // Logic

    function projectPathDict() {
        const sep = EaLogic.Utils.osPathSep()
        const array = projectLocation.split(sep)
        const basename = array[array.length - 1]
        const parent = array.slice(0, array.length - 1).join(sep)
        return {'basename': basename, 'parent': parent}
    }
}
