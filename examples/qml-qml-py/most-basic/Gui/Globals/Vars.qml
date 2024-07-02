// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.Globals as Globals


QtObject {

    // Use MockProxy as backend unless pyProxy is set in main.py
    property var backendProxy: typeof pyProxy !== 'undefined' && pyProxy !== null ?
                           pyProxy :
                           Globals.MockProxy

    // Pages accessibility
    property bool homePageEnabled: true
    property bool projectPageEnabled: true
    property bool summaryPageEnabled: true

}
