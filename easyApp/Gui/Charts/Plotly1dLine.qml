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

    url: 'Plotly1dLine.html'

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle(xAxisTitle)
            setYAxisTitle(yAxisTitle)
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
