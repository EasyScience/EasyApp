// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string xAxisTitle: ''
    property string yAxisTitle: ''

    width: parent.width
    height: parent.height

    url:  Qt.resolvedUrl('Plotly2dHeatmap.html')

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle(xAxisTitle)
            setYAxisTitle(yAxisTitle)
            redrawPlot()
        }
    }

    onLoadingChanged: {
        // Bug "loadRequest" is not declared - https://bugreports.qt.io/browse/QTBUG-84746
        //if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
        if (loadProgress === 100) {
            loadSucceededStatus = true
        }
    }

    onXAxisTitleChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle(newTitle)
            redrawPlot()
        }
    }

    onYAxisTitleChanged: {
        if (loadSucceededStatus) {
            setYAxisTitle(newTitle)
            redrawPlot()
        }
    }

    // Logic

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function setXAxisTitle(newTitle) {
        runJavaScript(`setXAxisTitle(${JSON.stringify(newTitle)})`)
    }

    function setYAxisTitle(newTitle) {
        runJavaScript(`setYAxisTitle(${JSON.stringify(newTitle)})`)
    }

}
