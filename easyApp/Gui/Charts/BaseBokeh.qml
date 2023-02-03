import QtQuick
import QtQuick.Controls
import QtWebEngine

import Gui.Globals as ExGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Logic as EaLogic
import EasyApp.Gui.Charts as EaCharts

EaCharts.BasePlot {
    id: plot

    property var chartData: {
        'measured': plot.measuredData,
        'calculated': plot.calculatedData,
        'phase': plot.phaseData,
        'difference': plot.differenceData,
        'bragg': plot.braggData,
        'background': plot.backgroundData,
        'ranges': plot.plotRanges,

        'hasMeasured': plot.hasMeasuredData,
        'hasCalculated': plot.hasCalculatedData,
        'hasPhase': plot.hasPhaseData,
        'hasDifference': plot.hasDifferenceData,
        'hasBragg': plot.hasBraggData,
        'hasBackground': plot.hasBackgroundData,
        'hasPlotRanges': plot.hasPlotRangesData,
        'isSpinPolarized': plot.isSpinPolarized,
        'setSpinComponent': plot.setSpinComponent,
        'spinComponent': plot.spinComponent,
    }

    property var chartSpecs: {
        'chartWidth': plot.chartWidth,
        'mainChartHeight': plot.mainChartHeight,
        'braggChartHeight': plot.braggChartHeight,
        'differenceChartHeight': plot.differenceChartHeight,
        'xAxisChartHeight': plot.xAxisChartHeight,

        'xAxisTitle': plot.xAxisTitle,
        'yMainAxisTitle': plot.yMainAxisTitle,
        'yDifferenceAxisTitle': plot.yDifferenceAxisTitle,

        'chartBackgroundColor': plot.chartBackgroundColor,
        'chartForegroundColor': plot.chartForegroundColor,
        'chartGridLineColor': plot.chartGridLineColor,
        'chartMinorGridLineColor': plot.chartMinorGridLineColor,

        'measuredLineColor': plot.measuredLineColor,
        'measuredAreaColor': plot.measuredAreaColor,
        'calculatedLineColor': plot.calculatedLineColor,
        'differenceLineColor': plot.differenceLineColor,
        'phaseLineColor' : plot.phaseLineColor,
        'braggTicksColor': plot.braggTicksColor,
        'backgroundLineColor': plot.backgroundLineColor,
        'differenceAreaColor': plot.differenceAreaColor,

        'measuredLineWidth': plot.measuredLineWidth,
        'calculatedLineWidth': plot.calculatedLineWidth,
        'differenceLineWidth': plot.differenceLineWidth,
        'backgroundLineWidth': plot.backgroundLineWidth,
        'phaseLineWidth': plot.phaseLineWidth,

        'fontPixelSize': plot.fontPixelSize
    }

    property string html: EaLogic.Plotting.bokehHtml(chartData, chartSpecs)

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.margins: plot.paddings
        anchors.topMargin: plot.paddings - 0.25 * plot.fontPixelSize
        backgroundColor: plot.chartBackgroundColor

        onContextMenuRequested: {
            request.accepted = true
        }
    }

    /////////////////////
    // Chart tool buttons
    /////////////////////

    ButtonGroup {
        buttons: polarizePatternType.children
    }

    Row {
        id: polarizePatternType

        visible: plot.isSpinPolarized

        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: 0.5 * EaStyle.Sizes.fontPixelSize + spacing - 1
        anchors.leftMargin: 6 * EaStyle.Sizes.fontPixelSize + 1

        spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        EaElements.TabButton {
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight * 2.1
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "arrow-up plus arrow-down"
            ToolTip.text: qsTr("Show sum: spin-up \uff0b spin-down component")
            checked: plot.spinComponent === "Sum"
            onClicked: plot.setSpinComponent("Sum")
        }

        EaElements.TabButton {
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight * 2.1
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "arrow-up minus arrow-down"
            ToolTip.text: qsTr("Show difference: spin-up \uff0d spin-down component")
            checked: plot.spinComponent === "Difference"
            onClicked: plot.setSpinComponent("Difference")
        }

        EaElements.TabButton {
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "arrow-up"
            ToolTip.text: qsTr("Show single component: spin-up")
            checked: plot.spinComponent === "Up"
            onClicked: plot.setSpinComponent("Up")
        }

        EaElements.TabButton {
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "arrow-down"
            ToolTip.text: qsTr("Show single component: spin-down")
            checked: plot.spinComponent === "Down"
            onClicked: plot.setSpinComponent("Down")
        }
    }

    onHtmlChanged: {
        // print(html)
        chartView.loadHtml(html)
    }
}
