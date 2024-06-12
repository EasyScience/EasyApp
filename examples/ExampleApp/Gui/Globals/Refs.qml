// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

pragma Singleton

import QtQuick


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    // Main
    readonly property var app: {
        'appbar': {
            'resetStateButton': null,
        },
        'homePage': {
            'startButton': null
        },
        'projectPage': {
            'continueButton': null
        },
        'summaryPage': {
            'continueButton': null
        },
    }
}
