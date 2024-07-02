// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.Globals as Globals


QtObject {

    // If the pyProxy object is created in main.py and exposed to qml, it is used as
    // a backendProxy. Otherwise, the mock proxy defined in Globals/MockProxy.qml with
    // hardcoded data is used.
    property var backendProxy: typeof pyProxy !== 'undefined' && pyProxy !== null ?
                           pyProxy :
                           Globals.MockProxy

    // Enabled/disabled state of the application pages
    property bool homePageEnabled: true
    property bool projectPageEnabled: true
    property bool summaryPageEnabled: true

}
