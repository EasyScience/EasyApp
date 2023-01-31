// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false
    property string xAxisTitle: ''
    property string yAxisTitle: ''
    property string zAxisTitle: ''

    width: parent.width
    height: parent.height

    url: 'Plotly3dScatter.html'

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle(xAxisTitle)
            setYAxisTitle(yAxisTitle)
            setZAxisTitle(zAxisTitle)
            redrawPlot()
        }
    }

    onLoadingChanged: {
        if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
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

    onZAxisTitleChanged: {
        if (loadSucceededStatus) {
            setZAxisTitle(newTitle)
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

    function setZAxisTitle(newTitle) {
        runJavaScript(`setZAxisTitle(${JSON.stringify(newTitle)})`)
    }

}
