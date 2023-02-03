import QtQuick
import QtCharts

import easyApp.Gui.Style as EaStyle
import easyApp.Gui.Globals as EaGlobals
import easyApp.Gui.Animations as EaAnimations

ValueAxis {
    property string title: ""

    lineVisible: false // Hide axes lines (only grid is visible)

    color: EaStyle.Colors.chartAxis
    Behavior on color { EaAnimations.ThemeChange {} }

    gridLineColor: EaStyle.Colors.chartGridLine
    Behavior on gridLineColor { EaAnimations.ThemeChange {} }

    minorGridLineColor: EaStyle.Colors.chartMinorGridLine
    Behavior on minorGridLineColor { EaAnimations.ThemeChange {} }

    labelsColor: EaStyle.Colors.chartLabels
    Behavior on labelsColor { EaAnimations.ThemeChange {} }

    titleText: `<font color='${labelsColor}'>${title}</font>` // The only way to change a title color

    labelsFont.family: EaStyle.Fonts.fontFamily
    labelsFont.pixelSize: EaStyle.Sizes.fontPixelSize
    titleFont.family: EaStyle.Fonts.fontFamily
    titleFont.pixelSize: EaStyle.Sizes.fontPixelSize
    //titleFont.bold: true
}
