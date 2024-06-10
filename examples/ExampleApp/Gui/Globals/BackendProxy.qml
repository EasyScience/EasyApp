// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

pragma Singleton

import QtQuick

import Globals as Globals


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"
    // Use MockProxy as backend unless somehing else is set (PyProxy in main.py). 
    property var main: typeof proxy !== 'undefined' && proxy !== null ?
                                         proxy: Globals.MockProxy
}
