pragma Singleton

import QtQuick


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    // Main
    readonly property var app: {
        // Main.qml populate this object
        'appbar': {
            'resetStateButton': null,
            'homePageButton': null,
            'projectPageButton': null,
            'summaryPageButton': null,
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
