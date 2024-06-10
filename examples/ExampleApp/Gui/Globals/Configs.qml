// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

pragma Singleton

import QtQuick


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    readonly property var projectConfig: QtObject {
        readonly property var release: QtObject {
            readonly property string app_name: 'EasyExample'
            readonly property string app_issues_url: 'https://github.com/EasyScience/EasyExample/issues'
        }
        readonly property var tool: QtObject {
            property var poetry: QtObject {
                readonly property string homepage: 'https://github.com/EasyScience/EasyExample'
                readonly property string version: '1.0.example'
            }
        }
        readonly property var ci: QtObject {
            property var app: QtObject {}
        }
    }

    readonly property var appConfig: QtObject {
        readonly property string name: projectConfig.release.app_name
        readonly property string namePrefix: "Easy"
        readonly property string nameSuffix: name.replace(namePrefix, "")
        readonly property string namePrefixForLogo: namePrefix.toLowerCase()
        readonly property string nameSuffixForLogo: nameSuffix.toLowerCase()

        readonly property string icon: iconPath('App.svg')

        readonly property string version: projectConfig.tool.poetry.version

        readonly property string homePageUrl: projectConfig.tool.poetry.homepage
        readonly property string issuesUrl: projectConfig.release.app_issues_url

        readonly property bool remote: typeof projectConfig.ci.app.info !== 'undefined'

        readonly property string date: remote ?
                                           projectConfig.ci.app.info.build_date :
                                           new Date().toISOString().slice(0,10)


        readonly property string licenseUrl: `https://www.link.to.license`
        readonly property string dependenciesUrl: `https://www.link.to.dependencies`

        readonly property string description:
`${name} is an example of how to use EasyExample Components.

${name} is developed by the European Spallation Source ERIC, Sweden.`
        readonly property var developerIcons: [
            { url: "https://ess.eu", icon: iconPath('ESS.png'), heightScale: 3.0 }
        ]
        readonly property string developerYearsFrom: "2019"
        readonly property string developerYearsTo: "2023"
    }

    // Logic

    function iconPath(file) {
        return Qt.resolvedUrl(`../Resources/Logo/${file}`)
    }
}
