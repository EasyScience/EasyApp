import QtQuick 2.13
import QtQuick.Controls 2.13
import QtWebEngine 1.10

import Gui.Globals 1.0 as ExGlobals
import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Logic 1.0 as EaLogic
import easyApp.Gui.Charts 1.0 as EaCharts

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
    Row {
        visible: plot.isSpinPolarized
        height: plot.isSpinPolarized ? 20 : 0
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: plot.paddings
        anchors.left: parent.left

        spacing: 5

        RadioButton {
            text: qsTr("Up \uff0b Down")
            checked: true // default
            // We shouldn't be using direct proxy here, but instead
            // have a property settable by the app code.
            onClicked: ExGlobals.Constants.proxy.plotting1d.setSpinComponent("Sum")
        }
        RadioButton {
            text: qsTr("Up \uff0d Down")
            onClicked: ExGlobals.Constants.proxy.plotting1d.setSpinComponent("Difference")
        }
        RadioButton {
            text: qsTr("Up")
            onClicked: ExGlobals.Constants.proxy.plotting1d.setSpinComponent("Up")
        }
        RadioButton {
            text: qsTr("Down")
            onClicked: ExGlobals.Constants.proxy.plotting1d.setSpinComponent("Down")
        }
    }
    /*
    Row {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: plot.fontPixelSize
        anchors.rightMargin: plot.fontPixelSize

        spacing: 3

        EaElements.TabButton {
            //checked: mainChart.allowZoom
            autoExclusive: false
            height: plot.chartToolButtonsHeight
            width: plot.chartToolButtonsHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "expand"
            ToolTip.text: qsTr("Box zoom")
            //onClicked: mainChart.allowZoom = !mainChart.allowZoom
        }

        EaElements.TabButton {
            checkable: false
            height: plot.chartToolButtonsHeight
            width: plot.chartToolButtonsHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "sync-alt"
            ToolTip.text: qsTr("Reset")
            //onClicked: mainChart.zoomReset()
            onClicked: chartView.runJavaScript("OnClick()", function(result) {
                console.log(result);
                //var button = document.querySelector(".bk-tool-icon-reset");
                //console.log("!!!!!!!!!!!!!!!!!", button)
                //if (button) {
                //  button.click();
                //}
            });
        }

        EaElements.TabButton {
            //checked: mainChart.allowHover
            autoExclusive: false
            height: plot.chartToolButtonsHeight
            width: plot.chartToolButtonsHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "comment-alt"
            ToolTip.text: qsTr("Hover")
            //onClicked: mainChart.allowHover = !mainChart.allowHover
        }
    }
    */

    onHtmlChanged: {
        // print(html)
        chartView.loadHtml(html)
    }
}
