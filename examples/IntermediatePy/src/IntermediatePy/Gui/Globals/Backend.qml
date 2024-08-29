// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

// This module is registered in the main.py file and allows access to the properties
// and backend  methods of the singleton object of the ‘PyBackendProxy’ class.
// If ‘PyBackendProxy’ is not defined, then MockBackendProxy from org/easyscience/easydiffraction is used.
// It is required to be able to run the GUI frontend via the qml runtime tool without a Python backend.
import Logic

QtObject {

    ////////////////
    // Backend proxy
    ////////////////

    readonly property var proxy: {
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
        readonly property string project: proxy.status.project
        readonly property string phases_count: proxy.status.phases_count
        readonly property string experiments_count: proxy.status.experiments_count
        readonly property string calculator: proxy.status.calculator
        readonly property string minimizer: proxy.status.minimizer
        readonly property string variables: proxy.status.variables
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        readonly property bool created: proxy.project.created
        readonly property string name: proxy.project.name
        readonly property var info: proxy.project.info
        readonly property var examples: proxy.project.examples

        function create() { proxy.project.create() }
        function save() { proxy.project.save() }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var summary: QtObject {
        readonly property bool created: proxy.report.created
        readonly property string as_html: proxy.report.as_html
    }

}
