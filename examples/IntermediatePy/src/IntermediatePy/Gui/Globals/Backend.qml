// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

// This module is registered in the main.py file and allows access to the properties
// and backend  methods of the singleton object of the ‘PyBackendProxy’ class.
// If ‘PyBackendProxy’ is not defined, then 'MockBackendProxy' from directory 'Logic' is used.
// It is needed to run the GUI frontend via the qml runtime tool without any Python backend.
import Logic

QtObject {

    ////////////////
    // Backend proxy
    ////////////////

    readonly property var activeProxy: {
        if (typeof PyBackendProxy !== 'undefined' && PyBackendProxy !== null) {
            console.debug('Currently, the REAL python backend proxy is in use')
            return PyBackendProxy
        } else {
            console.debug('Currently, the MOCK backend proxy is in use')
            return MockBackendProxy
        }
    }

    /////////////
    // Status bar
    /////////////

    readonly property var status: QtObject {
        readonly property string project: activeProxy.status.project
        readonly property string phasesCount: activeProxy.status.phasesCount
        readonly property string experimentsCount: activeProxy.status.experimentsCount
        readonly property string calculator: activeProxy.status.calculator
        readonly property string minimizer: activeProxy.status.minimizer
        readonly property string variables: activeProxy.status.variables
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        property bool created: activeProxy.project.created
        onCreatedChanged: activeProxy.project.created = created

        property string name: activeProxy.project.name
        onNameChanged: activeProxy.project.name = name

        readonly property var info: activeProxy.project.info

        readonly property var examples: activeProxy.project.examples

        function create() { activeProxy.project.create() }
        function save() { activeProxy.project.save() }
        function editInfo(path, new_value) { activeProxy.project.editInfo(path, new_value) }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var report: QtObject {
        property bool created: activeProxy.report.created
        onCreatedChanged: activeProxy.project.created = created

        property string asHtml: activeProxy.report.asHtml
        onAsHtmlChanged: activeProxy.report.asHtml = asHtml
    }

}
