// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


EaElements.StatusBar {
    visible: EaGlobals.Vars.appBarCurrentIndex !== 0

    EaElements.StatusBarItem {
        keyIcon: 'archive'
        keyText: qsTr('Project')
        valueText: Globals.Vars.backendProxy.status.project ?? ''
        ToolTip.text: qsTr('Current project')
    }

    EaElements.StatusBarItem {
        keyIcon: 'layer-group'
        keyText: qsTr('Models')
        valueText: Globals.Vars.backendProxy.status.phaseCount ?? ''
        ToolTip.text: qsTr('Number of models added')
    }

    EaElements.StatusBarItem {
        keyIcon: 'microscope'
        keyText: qsTr('Experiments')
        valueText: Globals.Vars.backendProxy.status.experimentsCount ?? ''
        ToolTip.text: qsTr('Number of experiments added')
    }

    EaElements.StatusBarItem {
        keyIcon: 'calculator'
        keyText: qsTr('Calculator')
        valueText: Globals.Vars.backendProxy.status.calculator ?? ''
        ToolTip.text: qsTr('Current calculation engine')
    }

    EaElements.StatusBarItem {
        keyIcon: 'level-down-alt'
        keyText: qsTr('Minimizer')
        valueText: Globals.Vars.backendProxy.status.minimizer ?? ''
        ToolTip.text: qsTr('Current minimization engine and method')
    }

    EaElements.StatusBarItem {
        keyIcon: 'th-list'
        keyText: qsTr('Parameters')
        valueText: Globals.Vars.backendProxy.status.variables ?? ''
        ToolTip.text: qsTr('Number of parameters: total, free and fixed')
    }

}
