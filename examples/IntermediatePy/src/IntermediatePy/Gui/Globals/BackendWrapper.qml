// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

// This module is registered in the main.py file and allows access to the properties
// and backend  methods of the singleton object of the ‘PyBackendProxy’ class.
// If ‘PyBackendProxy’ is not defined, then 'MockBackendProxy' from directory 'Logic' is used.
// It is needed to run the GUI frontend via the qml runtime tool without any Python backend.
import Backends as Backends


QtObject {

    ////////////////
    // Backend proxy
    ////////////////

    readonly property var activeProxy: {
        if (typeof Backends.PyBackend !== 'undefined') {
            console.debug('Currently, the REAL python backend is in use')
            return Backends.PyBackend
        } else {
            console.debug('Currently, the MOCK backend is in use')
            return Backends.MockBackend
        }
    }

    /////////////
    // Status bar
    /////////////

    readonly property string statusProject: activeProxy.status.project
    readonly property string statusPhasesCount: activeProxy.status.phasesCount
    readonly property string statusExperimentsCount: activeProxy.status.experimentsCount
    readonly property string statusCalculator: activeProxy.status.calculator
    readonly property string statusMinimizer: activeProxy.status.minimizer
    readonly property string statusVariables: activeProxy.status.variables

    ///////////////
    // Project page
    ///////////////

    property bool projectCreated: activeProxy.project.created
    onProjectCreatedChanged: activeProxy.project.created = projectCreated

    property string projectName: activeProxy.project.name
    onProjectNameChanged: activeProxy.project.name = projectName

    readonly property var projectInfo: activeProxy.project.info

    readonly property var projectExamples: activeProxy.project.examples

    function projectCreate() { activeProxy.project.create() }
    function projectSave() { activeProxy.project.save() }
    function projectEditInfo(path, new_value) { activeProxy.project.editInfo(path, new_value) }

    ///////////////
    // Summary page
    ///////////////

    property bool reportCreated: activeProxy.report.created
    onReportCreatedChanged: activeProxy.report.created = reportCreated

    readonly property string reportAsHtml: activeProxy.report.asHtml

}
