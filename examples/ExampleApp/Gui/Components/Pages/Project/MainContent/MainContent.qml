import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Globals as Globals


Rectangle {
    readonly property int commonSpacing: EaStyle.Sizes.fontPixelSize * 1.5

    color: EaStyle.Colors.mainContentBackground

    Column {

        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: commonSpacing
        anchors.leftMargin: commonSpacing * 1.5

        spacing: commonSpacing

        // Project title

        EaElements.TextInput {
            font.family: EaStyle.Fonts.secondFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
            font.weight: Font.ExtraLight
            text: Globals.Proxies.main.project.data.name
            onEditingFinished: Globals.Proxies.main.project.editData('name', text)
        }

        // Project info

        Grid {
            columns: 2
            rowSpacing: 0
            columnSpacing: commonSpacing

            EaElements.Label {
                font.bold: true
                text: qsTr("Description:")
            }
            EaElements.TextInput {
                text: Globals.Proxies.main.project.data.description
                onEditingFinished: Globals.Proxies.main.project.editData('description', text)
            }

            EaElements.Label {
                font.bold: true
                text: qsTr("Location:")
            }
            EaElements.Label {
                text: Globals.Proxies.main.project.data.location
            }

            EaElements.Label {
                font.bold: true
                text: qsTr("Created:")
            }
            EaElements.Label {
                text: Globals.Proxies.main.project.data.creationDate
            }
        }

        // Project image

        Image {
            //visible: Globals.Proxies.main.fitting.isFitFinished

            //source: Globals.Proxies.main.project.image
            width: EaStyle.Sizes.fontPixelSize * 25
            fillMode: Image.PreserveAspectFit
        }

    }

}
