import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property int chartToolButtonsHeight: EaStyle.Sizes.toolButtonHeight
    property int paddings: EaStyle.Sizes.fontPixelSize

    property var measuredData: ({})
    property var calculatedData: ({})
    property var differenceData: ({})
    property var braggData: ({})
    property var backgroundData: ({})
    property var plotRanges: ({})

    property bool hasMeasuredData: typeof measuredData !== 'undefined'
                                   && Object.keys(measuredData).length
                                   && (typeof measuredData.x !== 'undefined'
                                       || typeof measuredData.xy !== 'undefined')
    property bool hasCalculatedData: typeof calculatedData !== 'undefined'
                                     && Object.keys(calculatedData).length
    property bool hasDifferenceData: typeof differenceData !== 'undefined'
                                     && Object.keys(differenceData).length
    property bool hasBraggData: typeof braggData !== 'undefined'
                                && Object.keys(braggData).length
    property bool hasBackgroundData: typeof backgroundData !== 'undefined'
                                && Object.keys(backgroundData).length
    property bool hasPlotRangesData: typeof plotRanges !== 'undefined'
                                     && Object.keys(plotRanges).length

    property int chartContainerWidth: container.width
    property int chartContainerHeight: container.height

    property int chartWidth: container.width - 2 * paddings
    property int mainChartHeight: container.height
                                  - 2 * paddings
                                  - braggChartHeight
                                  - differenceChartHeight
                                  - chartToolButtonsHeight
                                  - xAxisChartHeight
    property int braggChartHeight: hasBraggData
                                   ? 3 * EaStyle.Sizes.fontPixelSize
                                   : 0
    property int differenceChartHeight: hasDifferenceData
                                        ? 8 * EaStyle.Sizes.fontPixelSize
                                        : 0
    property int xAxisChartHeight: 3 * EaStyle.Sizes.fontPixelSize

    property string xAxisTitle: ''
    property string yMainAxisTitle: ''
    property string yDifferenceAxisTitle: ''

    property color chartBackgroundColor: EaStyle.Colors.chartPlotAreaBackground
    property color chartForegroundColor: EaStyle.Colors.chartForeground
    property color chartGridLineColor: EaStyle.Colors.chartGridLine
    property color chartMinorGridLineColor: EaStyle.Colors.chartMinorGridLine

    property color measuredLineColor: EaStyle.Colors.chartForegrounds[0]
    property color measuredAreaColor: measuredLineColor
    property color calculatedLineColor: EaStyle.Colors.chartForegrounds[1]
    property color differenceLineColor: EaStyle.Colors.chartForegrounds[2]
    property color braggTicksColor: calculatedLineColor
    property color backgroundLineColor: EaStyle.Colors.chartAxis
    property color differenceAreaColor: differenceLineColor

    property int measuredLineWidth: 1
    property int calculatedLineWidth: 2
    property int differenceLineWidth: 1
    property int backgroundLineWidth: 2

    property int fontPixelSize: EaStyle.Sizes.fontPixelSize

    color: chartBackgroundColor
}
