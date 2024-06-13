pragma Singleton

import QtQuick

// Needed by AboutDialog.qml
QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"
    readonly property var appConfig: QtObject {
         readonly property string name: 'EasyExample'
         readonly property string namePrefix: 'Easy'
         readonly property string nameSuffix: name.replace(namePrefix, "")
         readonly property string namePrefixForLogo: namePrefix.toLowerCase()
         readonly property string nameSuffixForLogo: nameSuffix.toLowerCase()

         readonly property string homePageUrl: 'https://github.com/EasyScience/EasyExample'
         readonly property string issuesUrl: 'https://github.com/EasyScience/EasyExample/issues'
         readonly property string licenseUrl: `https://www.link.to.license`
         readonly property string dependenciesUrl: `https://www.link.to.dependencies`

         readonly property string version: '1.0.example'
         readonly property string icon: iconPath('App.svg')
         readonly property string date: new Date().toISOString().slice(0,10)
         readonly property string developerYearsFrom: "2019"
         readonly property string developerYearsTo: "2023"

         readonly property string description:
 `${name} is an example of how to use EasyExample Components.

 ${name} is developed by the European Spallation Source ERIC, Sweden.`
         readonly property var developerIcons: [
             { url: "https://ess.eu", icon: iconPath('ESS.png'), heightScale: 3.0 }
         ]
    }

    // Logic

    function iconPath(file) {
        return Qt.resolvedUrl(`../Resources/Logo/${file}`)
    }
}
