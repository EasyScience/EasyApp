import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13
import QtQuick.XmlListModel 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

EaElements.Dialog {
    property string appIconPath: ""
    property string appUrl: ""
    property string appPrefixName: ""
    property string appSuffixName: ""
    property string appVersion: ""
    property string appDate: ""
    property string eulaUrl: ""
    property string oslUrl: ""
    property string essIconPath: ""
    property string essUrl: "https://ess.eu"
    property string description: ""

    property string commit: ''
    property string commitUrl: ''
    property string branch: ''
    property string branchUrl: ''

    title: qsTr("About")

    standardButtons: Dialog.Ok

    Column {
        spacing: EaStyle.Sizes.fontPixelSize * 2.0

        // Application icon, name, version container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: -EaStyle.Sizes.fontPixelSize * 0.25

            Row {
                // Application logo
                EaElements.LinkedImage {
                    anchors.verticalCenter: parent.verticalCenter
                    height: EaStyle.Sizes.fontPixelSize * 3.5
                    source: appIconPath
                    link: appUrl
                }

                // Application name
                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    bottomPadding: EaStyle.Sizes.fontPixelSize * 0.5
                    verticalAlignment: Text.AlignVCenter
                    text: " " + appPrefixName
                    font.family: EaStyle.Fonts.secondCondensedFontFamily
                    font.weight: Font.ExtraLight
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3.5
                }

                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    bottomPadding: EaStyle.Sizes.fontPixelSize * 0.5
                    text: appSuffixName
                    font.family: EaStyle.Fonts.secondCondensedFontFamily
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3.5
                }
            }

            // Application version
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: branch && branch !== 'master'
                      ? qsTr(`Version <a href="${commitUrl}">${appVersion}-${commit}</a> (${appDate})`)
                      : qsTr(`Version ${appVersion} (${appDate})`)
            }

            // Github branch
            EaElements.Label {
                visible: branch && branch !== 'master'
                topPadding: EaStyle.Sizes.fontPixelSize * 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`Branch <a href="${branchUrl}">${branch}</a>`)
            }
        }

        // EULA and licences container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // EULA
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`<a href="${eulaUrl}">End User Licence Agreement</a>`)
            }

            // Licences
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`<a href="${oslUrl}">Dependent Open Source Licenses</a>`)
            }
        }

        // Description container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // Text
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: description
            }

            // ESS icon
            EaElements.LinkedImage {
                anchors.horizontalCenter: parent.horizontalCenter
                height: EaStyle.Sizes.fontPixelSize * 4
                source: essIconPath
                link: essUrl
            }
        }

        // Footer
        EaElements.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "© 2019-2021 • All rights reserved"
        }
    }

}

