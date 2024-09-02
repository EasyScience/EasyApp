import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false

    property string xAxisTitle: ''
    property string yAxisTitle: ''

    property var xyData: ({})

    width: parent.width
    height: parent.height

    url: Qt.resolvedUrl("Plotly1dLine.html")

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            setXAxisTitle()
            setYAxisTitle()
            setXyData()
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
            setXAxisTitle()
            redrawPlot()
        }
    }

    onYAxisTitleChanged: {
        if (loadSucceededStatus) {
            setYAxisTitle()
            redrawPlot()
        }
    }

    onXyDataChanged: {
        if (loadSucceededStatus) {
            setXyData()
            redrawPlot()
        }
    }

    // Logic

    function redrawPlot() {
        chartView.runJavaScript(`redrawPlot()`)
    }

    function setXAxisTitle() {
        runJavaScript(`setXAxisTitle(${JSON.stringify(xAxisTitle)})`)
    }

    function setYAxisTitle() {
        runJavaScript(`setYAxisTitle(${JSON.stringify(yAxisTitle)})`)
    }

    function setXyData() {
        //runJavaScript(`setXyData(${JSON.stringify(xyData)})`, function(result) { console.log(JSON.stringify(result)); })
        runJavaScript(`setXyData(${JSON.stringify(xyData)})`)
    }

    function redrawPlotWithAnimation() {
        runJavaScript(`redrawPlotWithAnimation(${JSON.stringify(xyData)})`)

    }

}
