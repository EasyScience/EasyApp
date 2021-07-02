import QtQuick 2.13
import QtQuick.Controls 2.13
import QtWebEngine 1.10

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Charts 1.0 as EaCharts
import easyApp.Gui.Logic 1.0 as EaLogic

import Gui.Globals 1.0 as ExGlobals

EaCharts.BasePlot {
    id: plot

    property int appScale: EaStyle.Sizes.defaultScale
    property int theme: EaStyle.Colors.theme

    color: EaStyle.Colors.chartPlotAreaBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    WebEngineView {
        id: chartView

        property var info: {
            'version': '2.3.2',
            'url': 'https://bokeh.org',
            'baseSrc': 'https://cdn.pydata.org/bokeh/release'
        }
        property string src: `${chartView.info.baseSrc}` //bokeh-${version}.min.js
        property string headScript: `<script type="text/javascript" src="${chartView.src}"></script>`

        anchors.fill: parent
        anchors.margins: 0

        backgroundColor: parent.color

        url: 'BaseBokeh.html'

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                setCalculatedData(hasCalculatedData, calculatedData)
                setMeasuredData(hasMeasuredData, measuredData)
                setDifferenceData(hasDifferenceData, differenceData)
                setBraggData(hasBraggData, braggData)
                setBackgroundData(hasBackgroundData, backgroundData)

                //                setPlotRanges()

                //setInitPlotRanges(hasPlotRangesData, plotRanges)

                setChartSizesTimer.restart()
                setChartLabels()
                setChartColors()
            }
        }

        onContextMenuRequested: {
            request.accepted = true
        }
    }

    // On changes

    onCalculatedDataChanged: setCalculatedData(hasCalculatedData, calculatedData)
    onMeasuredDataChanged: setMeasuredData(hasMeasuredData, measuredData)
    onDifferenceDataChanged: setDifferenceData(hasDifferenceData, differenceData)
    onBraggDataChanged: setBraggData(hasBraggData, braggData)
    onBackgroundDataChanged: setBackgroundData(hasBackgroundData, backgroundData)
    onPlotRangesChanged: {
        print("__________A plotRanges", JSON.stringify(plotRanges));
        ////setInitPlotRanges(hasPlotRangesData, plotRanges)
    }

    onHasCalculatedDataChanged: setCalculatedData(hasCalculatedData, calculatedData)
    onHasMeasuredDataChanged: setMeasuredData(hasMeasuredData, measuredData)
    onHasDifferenceDataChanged: setDifferenceData(hasDifferenceData, differenceData)
    onHasBraggDataChanged: setBraggData(hasBraggData, braggData)
    onHasBackgroundDataChanged: setBackgroundData(hasBackgroundData, backgroundData)
    onHasPlotRangesDataChanged: {
        ////setInitPlotRanges(hasPlotRangesData, plotRanges)
        ////setPlotRanges(hasPlotRangesData, plotRanges)
    }

    onMainChartHeightChanged: {
        ////setInitPlotRanges(hasPlotRangesData, plotRanges)
        ////setPlotRanges(hasPlotRangesData, plotRanges)
        setChartSizes()
    }
    onDifferenceChartHeightChanged: setChartSizes()
    onBraggChartHeightChanged: setChartSizes()

    onWidthChanged: setChartSizesTimer.restart()
    onHeightChanged: setChartSizesTimer.restart()
    onAppScaleChanged: setChartSizesTimer.restart()

    onThemeChanged: setChartColors()

    // Timers

    Timer {
        id: setChartDataTimer
        interval: 50
        onTriggered: {
            setCalculatedData(hasCalculatedData, calculatedData)
            setMeasuredData(hasMeasuredData, measuredData)
            setDifferenceData(hasDifferenceData, differenceData)
            setBraggData(hasBraggData, braggData)
            setBackgroundData(hasBackgroundData, backgroundData)
        }
    }

    Timer {
        id: setChartSizesTimer
        interval: 50
        onTriggered: setChartSizes()
    }

    // Logic

    function setCalculatedData(hasData, data) {
        chartView.runJavaScript(`setCalculatedData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setMeasuredData(hasData, data) {
        chartView.runJavaScript(`setMeasuredData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setDifferenceData(hasData, data) {
        chartView.runJavaScript(`setDifferenceData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setBraggData(hasData, data) {
        chartView.runJavaScript(`setBraggData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setBackgroundData(hasData, data) {
        chartView.runJavaScript(`setBackgroundData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setInitPlotRanges(hasRanges, ranges) {
        print("_____======== setInitPlotRanges", JSON.stringify(ranges))
        chartView.runJavaScript(`setInitPlotRanges(${hasRanges}, ${JSON.stringify(ranges)})`)
    }

    function setPlotRanges(hasRanges, ranges) {
        print("!!!!!======== setPlotRanges", JSON.stringify(ranges))
        chartView.runJavaScript(`setPlotRanges(${hasRanges}, ${JSON.stringify(ranges)})`)
    }

    function setChartSizes() {
        const sizes = {
            'chartWidth': plot.chartWidth,
            'mainChartHeight': plot.mainChartHeight,
            'braggChartHeight': plot.braggChartHeight,
            'differenceChartHeight': plot.differenceChartHeight,
            'xAxisChartHeight': plot.xAxisChartHeight,

            'measuredLineWidth': plot.measuredLineWidth,
            'calculatedLineWidth': plot.calculatedLineWidth,
            'differenceLineWidth': plot.differenceLineWidth,
            'backgroundLineWidth': plot.backgroundLineWidth,

            'fontPixelSize': plot.fontPixelSize
        }
        chartView.runJavaScript(`setChartSizes(${JSON.stringify(sizes)})`)
    }

    function setChartLabels() {
        const labels = {
            'xAxisTitle': plot.xAxisTitle,
            'yMainAxisTitle': plot.yMainAxisTitle,
            'yDifferenceAxisTitle': plot.yDifferenceAxisTitle
        }
        chartView.runJavaScript(`setChartLabels(${JSON.stringify(labels)})`)
    }

    function setChartColors() {
        const colors = {
            'chartBackgroundColor': plot.chartBackgroundColor.toString(),
            'chartForegroundColor': plot.chartForegroundColor.toString(),
            'chartAxisColor': plot.chartAxisColor.toString(),
            'chartGridLineColor': plot.chartGridLineColor.toString(),
            'chartMinorGridLineColor': plot.chartMinorGridLineColor.toString(),

            'measuredLineColor': plot.measuredLineColor.toString(),
            'measuredAreaColor': plot.measuredAreaColor.toString(),
            'calculatedLineColor': plot.calculatedLineColor.toString(),
            'differenceLineColor': plot.differenceLineColor.toString(),
            'braggTicksColor': plot.braggTicksColor.toString(),
            'backgroundLineColor': plot.backgroundLineColor.toString(),
            'differenceAreaColor': plot.differenceAreaColor.toString()
        }
        chartView.runJavaScript(`setChartColors(${JSON.stringify(colors)})`)
    }

}
