import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Charts as EaCharts


EaCharts.QtCharts1dBase {
    id: chartView

    property alias measSerie: measSerie
    property alias bkgSerie: bkgSerie
    property alias calcSerie: calcSerie

    property string calcSerieColor: EaStyle.Colors.chartForegrounds[0]

    ScatterSeries {
        id: measSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        markerSize: 5
        borderWidth: 1
        color: EaStyle.Colors.chartForegroundsExtra[2]
        borderColor: this.color
    }

    LineSeries {
        id: bkgSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: EaStyle.Colors.chartForegrounds[1]
        width: 2
    }

    LineSeries {
        id: calcSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: calcSerieColor
        width: 2
    }

}
