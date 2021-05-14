pragma Singleton

import QtQuick 2.13
import QtQuick.Controls.Material 2.13
import Qt.labs.settings 1.0

import easyAppGui.Globals 1.0 as EaGlobals

QtObject {
    id: object

    // Theme
    enum Themes { LightTheme = 0, DarkTheme, SystemTheme }
    property int theme: Colors.Themes.SystemTheme
    property bool isSystemThemeDark: typeof _isSystemThemeDark === 'undefined' ||
                                     _isSystemThemeDark === null ?
                                         false :
                                         _isSystemThemeDark
    property bool isDarkTheme: {
        if (theme === Colors.Themes.DarkTheme) {
            return true
        } else if (theme === Colors.Themes.LightTheme) {
            return false
        } else {
            if (isSystemThemeDark) {
                return true
            } else {
                return false
            }
        }
    }

    property color themeAccent: isDarkTheme ? "#4ec1ef": "#00a3e3"
    property color themePrimary: isDarkTheme ? "#111" : "#bbb"

    property color themeBackground: isDarkTheme ? "#303030" : "#e9e9e9"
    property color themeBackgroundDisabled: isDarkTheme ? "#333" : "#e9e9e9"
    property color themeBackgroundHovered1: isDarkTheme ? "#353535" : "#fefefe"
    property color themeBackgroundHovered2: isDarkTheme ? "#3a3a3a" : "#f7f7f7"

    property color themeForeground: isDarkTheme ? "#eee" : "#333"
    property color themeForegroundMinor: isDarkTheme ? "#888" : "#aaa"
    property color themeForegroundDisabled: isDarkTheme ? "#555": "#bbb" // control.Material.hintTextColor
    property color themeForegroundHovered: themeAccent
    property color themeForegroundHighlight: isDarkTheme ? '#FFAB91' : '#FF5722'

    // Application window
    property color appBorder: isDarkTheme ? "#292929" : "#ddd"

    // Application bar (on top of the application window)
    property color appBarBackground: themeBackground
    property color appBarForeground: isDarkTheme ? "#eee" : "#222"
    property color appBarBorder: isDarkTheme ? "#2e2e2e" : "#d6d6d6"

    property color appBarButtonBackground: "transparent"
    property color appBarButtonBackgroundDisabled: "transparent"
    property color appBarButtonBackgroundHovered: isDarkTheme ? "#20666666" : "#15666666" // temporary disable because of problems with RemoteController if parent: Overlay.overlay !?
    property color appBarButtonBackgroundPressed: isDarkTheme ? "#50666666" : "#25666666"
    property color appBarButtonForeground: isDarkTheme ? "#ccc" : "#444"

    property color appBarComboBoxBackground: isDarkTheme ? "#10666666" : "#70ffffff"
    property color appBarComboBoxBackgroundHovered: isDarkTheme ? "#50666666" : "#bbffffff"
    property color appBarComboBoxBackgroundPressed: isDarkTheme ? "#90666666" : "#ffffffff"
    property color appBarComboBoxBorder: isDarkTheme ? Qt.darker(appBarBackground, 1.1) : Qt.darker(appBarBackground, 1.05)

    // Content
    property color contentBackground: isDarkTheme ? "#3a3a3a" : "#f4f4f4"
    property color mainContentBackground: isDarkTheme ? "#444" : "#fff"

    // SideBar
    property color sideBarButtonBackground: appBarBackground
    property color sideBarButtonBackgroundHovered: isDarkTheme ? "#50666666" : "#e0e0e0"
    property color sideBarButtonBackgroundPressed: isDarkTheme ? "#50666666" : "#ccc"
    property color sideBarButtonForeground: isDarkTheme ? "#ccc" : "#444"

    // Status bar
    readonly property color statusBarBackground: appBarBackground
    readonly property color statusBarForeground: isDarkTheme ? "#aaa" : "#666"

    // Dialogs
    property color dialogBackground: themeBackground
    property color dialogOutsideBackground: isDarkTheme ? "#80000000" : "#80ffffff"
    property color dialogForeground: themeForeground

    // TextView
    property color textViewForeground: themeForeground
    property color textViewForegroundDisabled: themeForegroundDisabled
    property color textViewBackground: themeBackgroundHovered1
    property color textViewBackgroundDisabled: themeBackgroundHovered2

    // Text
    property color link: themeAccent
    property color linkHovered: isDarkTheme ? Qt.darker(themeAccent, 1.1) : Qt.lighter(themeAccent, 1.15)

    // Charts
    //property var chartForegrounds: ['#00a3e3', '#ff7f50', '#6b8e23']
    property var chartForegrounds: isDarkTheme ? ['#81D4FA', '#FFAB91', '#C5E1A5'] : ['#03A9F4', '#FF5722', '#8BC34A']
    property color chartForeground: themeForeground
    property color chartBackground: mainContentBackground
    property color chartPlotAreaBackground: mainContentBackground
    property color chartAxis: isDarkTheme ? "#2a2a2a" : "#ddd"
    property color chartGridLine: isDarkTheme ? "#3a3a3a" : "#eee"
    property color chartMinorGridLine: themeBackground
    property color chartLabels: chartForeground
    property color chartLine: "coral"

    // Table
    property color tableHighlight: isDarkTheme ? "#204ec1ef": "#2000a3e3"

    // ToolTip
    property color toolTipBackground: mainContentBackground
    property color toolTipBorder: appBarBorder

    // Colors
    property color blue: isDarkTheme ? '#81D4FA' : '#39abdf'
    property color red: isDarkTheme ? '#FFAB91' : '#FF5722'
    property color green: isDarkTheme ? '#C5E1A5' : '#7aaa42'
    property color grey: isDarkTheme ? "#777": "#bbb"

    // Persistent settings

    property var settings: Settings {
        fileName: EaGlobals.Variables.settingsFile
        category: 'Appearance'
        property alias theme: object.theme
    }

}
