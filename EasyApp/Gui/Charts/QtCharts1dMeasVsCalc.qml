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

    ScatterSeries {
        id: measSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        markerSize: 5
        borderWidth: 1
        color: 'cornflowerblue'
        borderColor: this.color
    }

    LineSeries {
        id: bkgSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: 'grey'
        width: 2
    }

    LineSeries {
        id: calcSerie

        axisX: chartView.axisX
        axisY: chartView.axisY

        useOpenGL: chartView.useOpenGL

        color: 'coral'
        width: 2
    }

}
