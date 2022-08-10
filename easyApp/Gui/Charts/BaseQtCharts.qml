import QtQuick
import QtQuick.Controls
import QtCharts 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Charts 1.0 as EaCharts

import Gui.Globals 1.0 as ExGlobals

EaCharts.BasePlot {
    id: plot

    property int chartExtraMargin: -12
    property int chartVMargin: chartExtraMargin
    property int chartHMargin: chartExtraMargin

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        ///////////////////////////
        // Chart tool buttons space
        ///////////////////////////

        Item {
            width: 1
            height: plot.chartToolButtonsHeight + 0.6 * plot.fontPixelSize
        }

        /////////////
        // Main chart
        /////////////

        Item {
            width: plot.chartWidth
            height: plot.mainChartHeight + plot.fontPixelSize

            EaCharts.ChartView {
                id: mainChart

                property bool allowHover: true
                property int initialized: 0

                anchors.fill: parent
                anchors.topMargin: plot.chartVMargin
                anchors.bottomMargin: plot.chartVMargin
                anchors.leftMargin: plot.chartHMargin
                anchors.rightMargin: plot.chartHMargin

                backgroundColor: 'transparent'  //'#250000ff'

                EaCharts.ValueAxis {
                    id: mainAxisX

                    title: plot.xAxisTitle

                    titleVisible: false
                    labelsVisible: false

                    min: plot.hasPlotRangesData ? plot.plotRanges.min_x : 0
                    max: plot.hasPlotRangesData ? plot.plotRanges.max_x : 1
                }

                EaCharts.ValueAxis {
                    id: mainAxisY

                    title: plot.yMainAxisTitle

                    min: plot.hasPlotRangesData ? plot.plotRanges.min_y : 0
                    max: plot.hasPlotRangesData ? plot.plotRanges.max_y : 1

                    onRangeChanged: {
                        adjustDifferenceChartRangeY()
                        adjustLeftAxesAnchor()
                    }
                }

                // Background curve
                EaCharts.LineSeries {
                    color: plot.backgroundLineColor
                    width: plot.backgroundLineWidth
                    style: Qt.DotLine

                    axisX: mainAxisX
                    axisY: mainAxisY

                    customPoints: plot.backgroundData.xy
                }

                // Measured data
                EaCharts.AreaSeries {
                    color: measuredLineColor

                    axisX: mainAxisX
                    axisY: mainAxisY

                    lowerSeries: EaCharts.LineSeries {
                        customPoints: plot.measuredData.xy_lower
                    }

                    upperSeries: EaCharts.LineSeries {
                        customPoints: plot.measuredData.xy_upper
                    }
                }

                // Calculated curve
                EaCharts.LineSeries {
                    color: plot.calculatedLineColor
                    width: plot.calculatedLineWidth

                    axisX: mainAxisX
                    axisY: mainAxisY

                    customPoints: plot.calculatedData.xy
                }

                // Hidden measured points for tooltips
                EaCharts.ScatterSeries {
                    axisX: mainAxisX
                    axisY: mainAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: plot.fontPixelSize * 2
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: plot.measuredData.xy

                    onHovered: showMainTooltip(mainChart, 'y_meas', point, state)
                }

                // Hidden calculated points for tooltips
                EaCharts.ScatterSeries {
                    axisX: mainAxisX
                    axisY: mainAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: plot.fontPixelSize * 2
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: plot.calculatedData.xy

                    onHovered: showMainTooltip(mainChart, 'y_calc', point, state)
                }

                onPlotAreaChanged: {
                    if (mainChart.initialized > 4) {
                        return
                    }
                    mainChart.initialized += 1
                    adjustDifferenceChartRangeY()
                    adjustLeftAxesAnchor()
                }
            }

            /////////////////////
            // Chart tool buttons
            /////////////////////

            Row {
                x: mainChart.plotArea.x
                   + mainChart.plotArea.width
                   + plot.chartHMargin
                   - childrenRect.width
                   + 1
                y: -childrenRect.height
                   + fontPixelSize
                   - 7
                spacing: 3

                EaElements.TabButton {
                    checked: mainChart.allowZoom
                    autoExclusive: false
                    height: plot.chartToolButtonsHeight
                    width: plot.chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartAxis
                    fontIcon: "expand"
                    ToolTip.text: qsTr("Box zoom")
                    onClicked: mainChart.allowZoom = !mainChart.allowZoom
                }

                EaElements.TabButton {
                    checkable: false
                    height: plot.chartToolButtonsHeight
                    width: plot.chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartAxis
                    fontIcon: "sync-alt"
                    ToolTip.text: qsTr("Reset")
                    onClicked: mainChart.zoomReset()
                }

                EaElements.TabButton {
                    checked: mainChart.allowHover
                    autoExclusive: false
                    height: plot.chartToolButtonsHeight
                    width: plot.chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartAxis
                    fontIcon: "comment-alt"
                    ToolTip.text: qsTr("Hover")
                    onClicked: mainChart.allowHover = !mainChart.allowHover
                }
            }
        }

        /////////////////
        // Main chart end
        /////////////////

        //////////////
        // Bragg chart
        //////////////

        Item {
            visible: hasBraggData

            width: plot.chartWidth
            height: plot.braggChartHeight + 0.2 * plot.fontPixelSize

            EaCharts.ChartView {
                id: braggChart

                anchors.fill: parent
                anchors.topMargin: plot.chartVMargin - 1.5 * plot.fontPixelSize
                anchors.bottomMargin: plot.chartVMargin
                anchors.leftMargin: plot.chartHMargin
                anchors.rightMargin: plot.chartHMargin

                allowZoom: false

                backgroundColor: 'transparent'  //'#2500ff00'

                EaCharts.ValueAxis {
                    id: braggAxisX

                    title: plot.xAxisTitle

                    titleVisible: false
                    labelsVisible: false

                    min: mainAxisX.min
                    max: mainAxisX.max
                }

                EaCharts.ValueAxis {
                    id: braggAxisY

                    titleVisible: false
                    labelsVisible: false

                    tickCount: 2

                    min: -0.83
                    max: 1
                }

                EaCharts.ScatterSeries {
                    axisX: braggAxisX
                    axisY: braggAxisY

                    brush: ExGlobals.Constants.proxy.plotting1d.verticalLine(markerSize, plot.calculatedLineColor)
                    markerShape: ScatterSeries.MarkerShapeRectangle
                    markerSize: 1.5 * fontPixelSize
                    borderWidth: 0.001
                    borderColor: 'transparent'

                    customPoints: plot.braggData.xy

                    onHovered: showBraggTooltip(point, state)
                }
            }
        }

        //////////////////
        // Bragg chart end
        //////////////////

        ///////////////////
        // Difference chart
        ///////////////////

        Item {
            visible: hasDifferenceData

            width: plot.chartWidth
            height: plot.differenceChartHeight + 0.35 * plot.fontPixelSize

            EaCharts.ChartView {
                id: differenceChart

                backgroundColor: 'transparent'  //'#25ff0000'

                anchors.fill: parent
                anchors.topMargin: plot.chartVMargin - 1.5 * fontPixelSize
                anchors.bottomMargin: plot.chartVMargin
                anchors.leftMargin: plot.chartHMargin
                anchors.rightMargin: plot.chartHMargin

                allowZoom: false

                EaCharts.ValueAxis {
                    id: differenceAxisX

                    title: plot.xAxisTitle

                    titleVisible: false
                    labelsVisible: false

                    min: mainAxisX.min
                    max: mainAxisX.max
                }

                EaCharts.ValueAxis {
                    id: differenceAxisY

                    title: plot.yDifferenceAxisTitle

                    tickType: ValueAxis.TicksFixed
                    tickCount: 3
                }

                // Difference area
                EaCharts.AreaSeries {
                    color: differenceLineColor

                    axisX: differenceAxisX
                    axisY: differenceAxisY

                    lowerSeries: EaCharts.LineSeries {
                        customPoints: plot.differenceData.xy_lower
                    }

                    upperSeries: EaCharts.LineSeries {
                        customPoints: plot.differenceData.xy_upper
                    }
                }

                // Hidden difference points for tooltips
                EaCharts.ScatterSeries {
                    axisX: differenceAxisX
                    axisY: differenceAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: 2 * plot.fontPixelSize
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: plot.differenceData.xy

                    onHovered: showMainTooltip(differenceChart, 'y_diff', point, state)
                }
            }
        }

        ///////////////////////
        // Difference chart end
        ///////////////////////

        ///////////////////
        // xAxisChart chart
        ///////////////////

        Item {
            width: plot.chartWidth
            height: 58 + 3.5 * plot.fontPixelSize + plot.xAxisChartHeight

            z: -1

            EaCharts.ChartView {
                id: xAxisChart

                backgroundColor: 'transparent'  //'#2500ffff'

                anchors.fill: parent
                anchors.topMargin: -anchors.bottomMargin
                anchors.bottomMargin: parent.height - 2.5 * plot.fontPixelSize
                anchors.leftMargin: plot.chartHMargin
                anchors.rightMargin: plot.chartHMargin

                showAxesRect: false
                allowZoom: false

                EaCharts.ValueAxis {
                    id: xAxisChartAxisX

                    title: plot.xAxisTitle

                    lineVisible: false
                    gridVisible: false

                    min: mainAxisX.min
                    max: mainAxisX.max
                }

                EaCharts.ValueAxis {
                    id: xAxisChartAxisY

                    visible: false
                }

                EaCharts.ScatterSeries {
                    axisX: xAxisChartAxisX
                    axisY: xAxisChartAxisY
                }
            }
        }

        ///////////////////////
        // xAxisChart chart end
        ///////////////////////

        ///////////
        // ToolTips
        ///////////

        EaElements.ToolTip {
            id: mainInfoToolTip
            textFormat: Text.RichText
            backgroundColor: plot.chartBackgroundColor
            borderColor: plot.chartGridLineColor
        }

        EaElements.ToolTip {
            id: braggInfoToolTip
            textFormat: Text.RichText
            backgroundColor: plot.chartBackgroundColor
            borderColor: plot.chartGridLineColor
        }

    }

    ////////
    // Logic
    ////////

    // Bragg chart tooltip

    function showBraggTooltip(point, state) {
        if (!mainChart.allowHover) {
            return
        }
        braggInfoToolTip.parent = braggChart
        braggInfoToolTip.visible = state
        const data = braggToolTipData(point)
        if (data === null) {
            return
        }
        const pos = braggChart.mapToPosition(point)
        braggInfoToolTip.x = pos.x
        braggInfoToolTip.y = pos.y - braggInfoToolTip.height
        braggInfoToolTip.text = braggTooltip(data)
    }

    function braggToolTipData(point) {
        if (!plot.hasBraggData) {
            return null
        }
        let data = { 'x': [], 'h': [], 'k': [], 'l': [] }
        for (let i in plot.braggData.xy) {
            if (point.x === plot.braggData.xy[i].x) {
                data.x.push(plot.braggData.xy[i].x)
                data.h.push(plot.braggData.h[i])
                data.k.push(plot.braggData.k[i])
                data.l.push(plot.braggData.l[i])
                return data
            }
        }
        return null
    }

    function braggTooltip(data) {
        let table = []
        for (let i in data.x) {
            table.push(`<div>`)
            const x = braggTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', `${data.x[i].toFixed(2)}`)
            table.push(x)
            table.push('&nbsp;')
            const hkl = braggTooltipRow(plot.calculatedLineColor, 'hkl', `(${data.h[i]} ${data.k[i]} ${data.l[i]})`)
            table.push(hkl)
            table.push(`</div>`)
        }
        const tooltip = table.join('\n')
        return tooltip
    }

    function braggTooltipRow(color, label, value, sigma='') {
        return `<span style="color:${color}">${label}:&nbsp;${value}</span>`
    }

    // Main chart tooltip

    function showMainTooltip(chart, line, point, state) {
        if (!mainChart.allowHover) {
            return
        }
        mainInfoToolTip.parent = chart
        mainInfoToolTip.visible = state
        const data = mainToolTipData(point)
        if (data === null) {
            return
        }
        const pos = chart.mapToPosition(Qt.point(point.x, data[line]))
        mainInfoToolTip.x = pos.x
        mainInfoToolTip.y = pos.y - mainInfoToolTip.height
        mainInfoToolTip.text = mainTooltip(data)
    }

    function mainToolTipData(point) {
        let xy = []
        if (plot.hasMeasuredData) {
            xy = plot.measuredData.xy
        } else if (plot.hasCalculatedData) {
            xy = plot.calculatedData.xy
        } else {
            return null
        }
        let data = {}
        for (let i in xy) {
            if (point.x === xy[i].x) {
                data.x = xy[i].x
                if (plot.hasMeasuredData) {
                    data.y_meas = plot.measuredData.xy[i].y
                    data.sy_meas = plot.measuredData.xy_upper[i].y - plot.measuredData.xy[i].y
                }
                if (plot.hasCalculatedData) {
                    data.y_calc = plot.calculatedData.xy[i].y
                }
                if (plot.hasDifferenceData) {
                    data.y_diff = plot.differenceData.xy[i].y
                }
                return data
            }
        }
        return null
    }

    function mainTooltip(data) {
        let table = []
        table.push(...[`<table>`, `<tbody>`])

        const x = mainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', `${data.x.toFixed(2)}`)
        table.push(...x)
        if (plot.hasMeasuredData) {
            const y_meas = mainTooltipRow(plot.measuredLineColor, 'meas', `${data.y_meas.toFixed(1)}`, `&#177;&nbsp;${data.sy_meas.toFixed(1)}`)
            table.push(...y_meas)
        }
        if (plot.hasCalculatedData) {
            const y_calc = mainTooltipRow(plot.calculatedLineColor, 'calc', `${data.y_calc.toFixed(1)}`)
            table.push(...y_calc)
        }
        if (plot.hasDifferenceData) {
            const y_diff = mainTooltipRow(plot.differenceLineColor, 'diff', `${data.y_diff.toFixed(1)}`)
            table.push(...y_diff)
        }

        table.push(...[`</tbody>`, `</table>`])

        const tooltip = table.join('\n')
        return tooltip
    }

    function mainTooltipRow(color, label, value, sigma='') {
        return [`<tr style="color:${color}">`,
                `   <td style="text-align:right">${label}:&nbsp;</td>`,
                `   <td style="text-align:right">${value}</td>`,
                `   <td>${sigma}</td>`,
                `</tr>`]
    }

    // Misc

    function differenceChartMeanY() {
        let ySum = 0, yCount = 0
        for (let i in plot.differenceData.xy) {
            if (differenceAxisX.min <= plot.differenceData.xy[i].x && plot.differenceData.xy[i].x <= differenceAxisX.max) {
                ySum += plot.differenceData.xy[i].y
                yCount += 1
            }
        }
        if (yCount > 0) {
            return ySum / yCount
        }
        return 0
    }

    function differenceChartHalfRangeY() {
        const mainChartRangeY = mainAxisY.max - mainAxisY.min
        const differenceToMainChartHeightRatio = differenceChart.plotArea.height / mainChart.plotArea.height
        const differenceChartRangeY = mainChartRangeY * differenceToMainChartHeightRatio
        return 0.5 * differenceChartRangeY
    }

    function adjustDifferenceChartRangeY() {
        if (hasDifferenceData) {
            differenceAxisY.min = differenceChartMeanY() - differenceChartHalfRangeY()
            differenceAxisY.max = differenceChartMeanY() + differenceChartHalfRangeY()
        }
    }

    function adjustLeftAxesAnchor() {
        xAxisChart.anchors.leftMargin = plot.chartHMargin + (mainChart.plotArea.x - xAxisChart.plotArea.x)
        if (hasDifferenceData) {
            differenceChart.anchors.leftMargin = plot.chartHMargin + (mainChart.plotArea.x - differenceChart.plotArea.x)
        }
        if (hasBraggData) {
            braggChart.anchors.leftMargin = plot.chartHMargin + (mainChart.plotArea.x - braggChart.plotArea.x)
        }
    }

    function axisLabelFormat(range) {
        if (range < 1)
            return "%.2f"
        else if (range < 10)
            return "%.1f"
        else
            return "%.0f"
    }

}
