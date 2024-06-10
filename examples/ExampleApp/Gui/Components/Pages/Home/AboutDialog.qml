import QtQuick

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Globals as Globals

// AboutDialog made from Globals.Configs
EaComponents.AboutDialog {

    visible: EaGlobals.Vars.showAppAboutDialog
    onClosed: EaGlobals.Vars.showAppAboutDialog = false

    appIconPath: Globals.Configs.appConfig.icon
    appUrl: Globals.Configs.appConfig.homePageUrl

    appPrefixName: Globals.Configs.appConfig.namePrefixForLogo
    appSuffixName: Globals.Configs.appConfig.nameSuffixForLogo
    appVersion: Globals.Configs.appConfig.version
    appDate: Globals.Configs.appConfig.date

    eulaUrl: Globals.Configs.appConfig.licenseUrl
    oslUrl: Globals.Configs.appConfig.dependenciesUrl

    description: Globals.Configs.appConfig.description
    developerIcons: Globals.Configs.appConfig.developerIcons
    developerYearsFrom: Globals.Configs.appConfig.developerYearsFrom
    developerYearsTo: Globals.Configs.appConfig.developerYearsTo

}
