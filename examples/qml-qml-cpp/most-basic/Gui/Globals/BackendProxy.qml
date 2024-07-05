// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.MockLogic as MockLogic


// If the backend_proxy_py object is created in main.py and exposed to qml, it is used as
// realBackendProxyPy to access the necessary backend properties and methods. Otherwise, the mock
// proxy defined in MockLogic/BackendProxy.qml with hardcoded data is used.

QtObject {

    ///////////////
    // Backend proxy
    ///////////////

    readonly property var mockBackendProxyJs: MockLogic.BackendProxy

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
                                              mockBackendProxyJs.status.project

        readonly property string phaseCount: isRealBackendProxyPyDefined ?
                                                 realBackendProxyPy.status.phaseCount :
                                                 mockBackendProxyJs.status.phaseCount

        readonly property string experimentsCount: isRealBackendProxyPyDefined ?
                                                       realBackendProxyPy.status.experimentsCount :
                                                       mockBackendProxyJs.status.experimentsCount

        readonly property string calculator: isRealBackendProxyPyDefined ?
                                                 realBackendProxyPy.status.calculator :
                                                 mockBackendProxyJs.status.calculator

        readonly property string minimizer: isRealBackendProxyPyDefined ?
                                                realBackendProxyPy.status.minimizer :
                                                mockBackendProxyJs.status.minimizer

        readonly property string variables: isRealBackendProxyPyDefined ?
                                                realBackendProxyPy.status.variables :
                                                mockBackendProxyJs.status.variables
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        readonly property bool created: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.project.created :
                                            mockBackendProxyJs.project.created

        readonly property var info: isRealBackendProxyPyDefined ?
                                        realBackendProxyPy.project.info :
                                        mockBackendProxyJs.project.info

        readonly property var examples: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.project.examples :
                                            mockBackendProxyJs.project.examples

        function create() {
            if (isRealBackendProxyPyDefined)
                realBackendProxyPy.project.create()
            else
                mockBackendProxyJs.project.create()
        }

        function save() {
            if (isRealBackendProxyPyDefined)
                realBackendProxyPy.project.save()
            else
                mockBackendProxyJs.project.save()

        }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var summary: QtObject {
        readonly property bool created: isRealBackendProxyPyDefined ?
                                            realBackendProxyPy.report.created :
                                            mockBackendProxyJs.report.created

        readonly property string asHtml: isRealBackendProxyPyDefined ?
                                             realBackendProxyPy.report.asHtml :
                                             mockBackendProxyJs.report.asHtml

    }

}
