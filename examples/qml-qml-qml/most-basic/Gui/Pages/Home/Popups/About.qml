// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.AboutDialog {

    visible: EaGlobals.Vars.showAppAboutDialog
    onClosed: EaGlobals.Vars.showAppAboutDialog = false

    appIconPath: Globals.Vars.backendProxy.about.icon
    appUrl: Globals.Vars.backendProxy.about.homePageUrl

    appPrefixName: Globals.Vars.backendProxy.about.namePrefixForLogo
    appSuffixName: Globals.Vars.backendProxy.about.nameSuffixForLogo
    appVersion: Globals.Vars.backendProxy.about.version
    appDate: Globals.Vars.backendProxy.about.date

    eulaUrl: Globals.Vars.backendProxy.about.licenseUrl
    oslUrl: Globals.Vars.backendProxy.about.dependenciesUrl

    description: Globals.Vars.backendProxy.about.description
    developerIcons: Globals.Vars.backendProxy.about.developerIcons
    developerYearsFrom: Globals.Vars.backendProxy.about.developerYearsFrom
    developerYearsTo: Globals.Vars.backendProxy.about.developerYearsTo

}
