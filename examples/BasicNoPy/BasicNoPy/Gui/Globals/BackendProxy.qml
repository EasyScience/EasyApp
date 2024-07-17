// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Logic.Mock as MockLogic


// If the backend_proxy_py object is created in main.py and exposed to qml, it is used as
// realBackendProxyPy to access the necessary backend properties and methods. Otherwise, the mock
// proxy defined in MockLogic/BackendProxy.qml with hardcoded data is used.

QtObject {

    ///////////////
    // Backend proxy
    ///////////////

    readonly property var mockBackendProxyQml: MockLogic.BackendProxy

    readonly property var realBackendProxyPy: typeof backend_proxy_py !== 'undefined' &&
                                              backend_proxy_py !== null ?
                                                  backend_proxy_py :
                                                  null

    readonly property bool isRealBackendProxyPyDefined: realBackendProxyPy !== null

    /////////////
    // Status bar
    /////////////

    readonly property var status: QtObject {
        readonly property string project: isRealBackendProxyPyDefined ?
                                              realBackendProxyPy.status.project :
                                              mockBackendProxyQml.status.project

        readonly property string phaseCount: isRealBackendProxyPyDefined ?
                                                 realBackendProxyPy.status.phaseCount :
                                                 mockBackendProxyQml.status.phaseCount

        readonly property string experimentsCount: isRealBackendProxyPyDefined ?
                                                       realBackendProxyPy.status.experimentsCount :
                                                       mockBackendProxyQml.status.experimentsCount

        readonly property string calculator: isRealBackendProxyPyDefined ?
                                                 realBackendProxyPy.status.calculator :
                                                 mockBackendProxyQml.status.calculator

        readonly property string minimizer: isRealBackendProxyPyDefined ?
                                                realBackendProxyPy.status.minimizer :
                                                mockBackendProxyQml.status.minimizer

        readonly property string variables: isRealBackendProxyPyDefined ?
                                                realBackendProxyPy.status.variables :
                                                mockBackendProxyQml.status.variables
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        readonly property bool created: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.project.created :
                                            mockBackendProxyQml.project.created

        readonly property var info: isRealBackendProxyPyDefined ?
                                        realBackendProxyPy.project.info :
                                        mockBackendProxyQml.project.info

        readonly property var examples: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.project.examples :
                                            mockBackendProxyQml.project.examples

        function create() {
            if (isRealBackendProxyPyDefined)
                realBackendProxyPy.project.create()
            else
                mockBackendProxyQml.project.create()
        }

        function save() {
            if (isRealBackendProxyPyDefined)
                realBackendProxyPy.project.save()
            else
                mockBackendProxyQml.project.save()

        }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var summary: QtObject {
        readonly property bool created: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.report.created :
                                            mockBackendProxyQml.report.created

        readonly property string asHtml: isRealBackendProxyPyDefined ?
                                             realBackendProxyPy.report.asHtml :
                                             mockBackendProxyQml.report.asHtml

    }

}
