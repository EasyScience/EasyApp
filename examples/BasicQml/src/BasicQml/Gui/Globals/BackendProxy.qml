// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Logic.Mock as MockLogic


QtObject {

    ///////////////
    // Backend proxy
    ///////////////

    // This property is used to access the backend proxy object from GUI components.
    readonly property var backendProxy: MockLogic.BackendProxy

    /////////////
    // Status bar
    /////////////

    readonly property var status: QtObject {
        readonly property string project: backendProxy.status.project
        readonly property string phaseCount: backendProxy.status.phaseCount
        readonly property string experimentsCount: backendProxy.status.experimentsCount
        readonly property string calculator: backendProxy.status.calculator
        readonly property string minimizer: backendProxy.status.minimizer
        readonly property string variables: backendProxy.status.variables
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        readonly property bool created: backendProxy.project.created
        readonly property var info: backendProxy.project.info
        readonly property var examples: backendProxy.project.examples

        function create() { backendProxy.project.create() }
        function save() { backendProxy.project.save() }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var summary: QtObject {
        readonly property bool created: backendProxy.report.created
        readonly property string asHtml: backendProxy.report.asHtml
    }

}
