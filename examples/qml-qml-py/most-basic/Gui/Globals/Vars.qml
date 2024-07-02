// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.Globals as Globals


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    // Use MockProxy as backend unless pyProxy is set in main.py
    property var backendProxy: typeof pyProxy !== 'undefined' && pyProxy !== null ?
                           pyProxy :
                           Globals.MockProxy

    // Pages accessibility
    property bool homePageEnabled: true
    property bool projectPageEnabled: false
    property bool summaryPageEnabled: false

}
