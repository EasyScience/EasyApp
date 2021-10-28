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
    property bool loadSucceeded: false

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
        anchors.topMargin: 2

        backgroundColor: parent.color

        url: 'BaseBokeh.html'

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                loadSucceeded = true
                print("-------------- LoadSucceededStatus", JSON.stringify(plotRanges))

                hideBraggChart()
                hideDifferenceChart()
                chartView.runJavaScript(`showToolbar(false)`)

//                setChartSizesTimer.restart()
                setChartSizes()

                setChartLabels()
                setChartColors()
            }
        }

        onContextMenuRequested: {
            request.accepted = true
        }
    }

    // On changes

    onCalculatedDataChanged: if (loadSucceeded) { setCalculatedData(calculatedData); print("-------> onCalculatedDataChanged", calculatedData.x.length, JSON.stringify(calculatedData)) }
    onMeasuredDataChanged: if (loadSucceeded) { setMeasuredData(measuredData); print("-------> onMeasuredDataChanged", measuredData.x.length, JSON.stringify(measuredData)) }
    onDifferenceDataChanged: if (loadSucceeded) { setDifferenceData(differenceData); print("-------> onDifferenceDataChanged", differenceData.x.length, JSON.stringify(differenceData)) }
    onBraggDataChanged: if (loadSucceeded) { setBraggData(braggData); print("-------> onBraggDataChanged", JSON.stringify(braggData)) }
    onBackgroundDataChanged: if (loadSucceeded) { setBackgroundData(backgroundData); print("-------> onBackgroundDataChanged", JSON.stringify(backgroundData)) }
    onPlotRangesChanged: if (loadSucceeded) {
        // setInitPlotRanges(plotRanges)
        setPlotRanges(plotRanges);
        print("-------> onPlotRangesChanged", JSON.stringify(plotRanges))
    }

    onMainChartHeightChanged: { print("+++++ onMainChartHeightChanged"); setChartSizes() }
    onDifferenceChartHeightChanged: { print("+++++ onDifferenceChartHeightChanged"); setChartSizes() }
    onBraggChartHeightChanged: { print("+++++ onBraggChartHeightChanged"); setChartSizes() }

//    onWidthChanged: setChartSizesTimer.restart()
//    onHeightChanged: setChartSizesTimer.restart()
//    onAppScaleChanged: setChartSizesTimer.restart()


    onYMainAxisTitleChanged: setChartLabels()

    onThemeChanged: setChartColors()

    // Timers

    /*
    Timer {
        id: setChartDataTimer
        interval: 50
        onTriggered: {
            setCalculatedData(calculatedData)
            setMeasuredData(measuredData)
            setDifferenceData(differenceData)
            setBraggData(braggData)
            setBackgroundData(backgroundData)
        }
    }

    Timer {
        id: setChartSizesTimer
        interval: 50
        onTriggered: setChartSizes()
    }
    */

    /////////////////////
    // Chart tool buttons
    /////////////////////

    Row {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: 1.5 * EaStyle.Sizes.fontPixelSize

        spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        EaElements.TabButton {
            property int pageLoading: chartView.loading
            property string htmlButtonPrefix: "activateBoxZoom"
            checkable: true
            checked: true
            autoExclusive: true
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "search-plus"
            onClicked: {
                chartView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
        }

        EaElements.TabButton {
            property int pageLoading: chartView.loading
            property string htmlButtonPrefix: "activatePan"
            checkable: true
            checked: false
            autoExclusive: true
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "arrows-alt"
            onClicked: {
                chartView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            property int pageLoading: chartView.loading
            property string htmlButtonPrefix: "reset"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "sync-alt"
            onClicked: {
                chartView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            property int pageLoading: chartView.loading
            property string htmlButtonPrefix: "toggleHover"
            checkable: true
            checked: true
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "comment-alt"
            onClicked: chartView.runJavaScript(`${htmlButtonPrefix}Action()`)
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
        }
    }

    // Logic

    function reset() {
        chartView.runJavaScript(`resetAction()`)
    }

    function hideDifferenceChart() {
        chartView.runJavaScript(`hideDifferenceChart()`)
    }

    function hideBraggChart() {
        chartView.runJavaScript(`hideBraggChart()`)
    }

    function setCalculatedData(data) {
        const hasData = EaLogic.Utils.hasData(data)
        print("------->>>>> setCalculatedData", hasData, JSON.stringify(data))
        chartView.runJavaScript(`setCalculatedData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setMeasuredData(data) {
        const hasData = EaLogic.Utils.hasData(data)
        print("------->>>>> setMeasuredData", hasData, JSON.stringify(data))
        chartView.runJavaScript(`setMeasuredData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setDifferenceData(data) {
        const hasData = EaLogic.Utils.hasData(data)
        print("------->>>>> setDifferenceData", hasData, JSON.stringify(data))
        chartView.runJavaScript(`setDifferenceData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setBraggData(data) {
        const hasData = EaLogic.Utils.hasData(data)
        print("------->>>>> setBraggData", hasData, JSON.stringify(data))
        chartView.runJavaScript(`setBraggData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setBackgroundData(data) {
        const hasData = EaLogic.Utils.hasData(data)
        print("------->>>>> setBackgroundData", hasData, JSON.stringify(data))
        chartView.runJavaScript(`setBackgroundData(${hasData}, ${JSON.stringify(data)})`)
    }

    function setInitPlotRanges(ranges) {
        const hasData = EaLogic.Utils.hasData(ranges)
        print("------->>>>> setInitPlotRanges", hasData, JSON.stringify(ranges))
        chartView.runJavaScript(`setInitPlotRanges(${hasData}, ${JSON.stringify(ranges)})`)
    }

    function setPlotRanges(ranges) {
        const hasData = EaLogic.Utils.hasData(ranges)
        print("------->>>>> setPlotRanges", hasData, JSON.stringify(ranges))
        chartView.runJavaScript(`setPlotRanges(${hasData}, ${JSON.stringify(ranges)})`)
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
        //print("****** =====================", JSON.stringify(sizes))
        chartView.runJavaScript(`setChartSizes(${JSON.stringify(sizes)})`)
    }

    function setChartLabels() {
        const labels = {
            'xAxisTitle': plot.xAxisTitle,
            'yMainAxisTitle': plot.yMainAxisTitle,
            'yDifferenceAxisTitle': plot.yDifferenceAxisTitle
        }
        print("****** =====================", JSON.stringify(labels))
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

    function setToolTipText(htmlButton, qmlButton) {
        chartView.runJavaScript(
                    `${htmlButton}.getAttribute('data-tooltip')`,
                    function(result) {
                        qmlButton.ToolTip.text = result
                    }
                    )
    }

}
