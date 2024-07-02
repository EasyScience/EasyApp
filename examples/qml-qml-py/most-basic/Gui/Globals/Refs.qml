// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick


QtObject {

    // Initialisation of the reference dictionary. It is filled in later, when the
    // required object is created and its unique id is assigned and added here instead
    // of null. After that, any object whose id is specified here can be accessed from
    // any other qml file.
    readonly property var app: {

        // ApplicationWindows.qml populate this section
        'appbar': {
            'resetStateButton': null,
            'homeButton': null,
            'projectButton': null,
            'summaryButton': null,
        },

        // Pages/Home/Content.qml populate this section
        'homePage': {
            'startButton': null
        },

        // Pages/Project/Layout.qml populate this section
        'projectPage': {
            'continueButton': null
        }
    }

}
