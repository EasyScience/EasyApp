// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    // Main
    readonly property var app: {
        // Main.qml populate this object
        'appbar': {
            'resetStateButton': null,
            'homeButton': null,
            'projectButton': null,
            'summaryButton': null,
        },
        // Home/Page.qml populate this object
        'homePage': {
            'startButton': null
        },
        // Project/Page.qml populate this object
        'projectPage': {
            'continueButton': null
        }
    }
}
