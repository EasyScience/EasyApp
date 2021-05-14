pragma Singleton

import QtQuick 2.13

import easyApp.Logic 1.0 as EaLogic

QtObject {

    // Python objects
    readonly property bool isTestMode: typeof _isTestMode !== "undefined" && _isTestMode !== null ?
                                          _isTestMode :
                                          false

    readonly property var projectConfig: typeof _projectConfig !== "undefined" && _projectConfig !== null ?
                                             _projectConfig :
                                             EaLogic.ProjectConfig.projectConfig()

    readonly property var translator: typeof _translator !== "undefined" && _translator !== null ?
                                          _translator :
                                          new EaLogic.Translate.Translator()

    // Settings
    readonly property string settingsFile: typeof _settingsPath !== "undefined" && _settingsPath !== null ?
                                               _settingsPath :
                                               'settings.ini'

    // Application parameters
    readonly property int appWindowFlags: Qt.Window | Qt.WindowFullscreenButtonHint // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false
    property bool showAppAboutDialog: false
    property bool showToolTips: true
    property bool showUserGuides: false
    property bool showProjectDescriptionDialog: false

    // Updater
    property bool checkUpdateOnAppStart: isTestMode ? false : true
    property var updater

    // Screenshots control
    property bool saveScreenshotsRunning: false

    // App bar
    property int appBarCurrentIndex: 0
    enum AppBarIndexEnum {
        HomePageIndex = 0,
        ProjectPageIndex = 1,
        SamplePageIndex = 2,
        ExperimentPageIndex = 3,
        AnalysisPageIndex = 4,
        SummaryPageIndex = 5
    }
}
