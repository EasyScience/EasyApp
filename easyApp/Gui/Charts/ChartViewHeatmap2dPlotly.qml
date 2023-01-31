// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine 1.10

import easyApp.Gui.Elements 1.0 as EaElements

Rectangle {
    id: container

    property var z3dValues: [[1, 20, 30], [20, 1, 60], [30, 60, 1]]

    property int pageLoading: chartView.loading

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.bottomMargin: 20
        anchors.topMargin: 18
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        backgroundColor: parent.color

        url: 'ChartTemplateHeatmap2dPlotly.html'

        onContextMenuRequested: {
            request.accepted = true
        }

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                setZ3dValues()
                redrawPlot()
            }
        }

        onWidthChanged: reload()
        onHeightChanged: reload()        

    }

    // Logic

    function setZ3dValues() {
        //chartView.runJavaScript(`setZ3dValues(${JSON.stringify(z3dValues)})`, function(result) { console.log(result); })
        chartView.runJavaScript(`setZ3dValues(${JSON.stringify(z3dValues)})`)
    }

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

}
