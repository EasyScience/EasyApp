import QtQuick
import QtQuick.Controls
import QtWebEngine

WebEngineView {
    id: chartView

    property bool loadSucceededStatus: false

    property string xAxisTitle: ''
    property string yAxisTitle: ''

    property var xArray: ([])
    property var yArray: ([])

    property var measuredData: ({})
    property var calculatedData: ({})
    property var allCalculatedData: ({})

    width: parent.width
    height: parent.height

    url: 'ChartViewDiffraction1dPlotly.html'

    onLoadSucceededStatusChanged: {
        if (loadSucceededStatus) {
            //setXAxisTitle(xAxisTitle)
            //setYAxisTitle(yAxisTitle)
            //setXArray(xArray)
            //setYArray(yArray)
            //redrawPlot()
        }
    }

    onXAxisTitleChanged: {
        if (loadSucceededStatus) {
            //setXAxisTitle(newTitle)
            //redrawPlot()
        }
    }

    onYAxisTitleChanged: {
        if (loadSucceededStatus) {
            //setYAxisTitle(newTitle)
            //redrawPlot()
        }
    }

    onXArrayChanged: {
        if (loadSucceededStatus) {
            //setXArray(xArray)
            //redrawPlot()
        }
    }

    onYArrayChanged: {
        if (loadSucceededStatus) {
            //setYArray(yArray)
            //redrawPlot()
        }
    }

    onMeasuredDataChanged:  {
        if (loadSucceededStatus) {
            setMeasuredData(measuredData)
            redrawPlot()
        }
    }

    onCalculatedDataChanged:  {
        if (loadSucceededStatus) {
            //setCalculatedData(calculatedData)
            //redrawPlot()
        }
    }

    onAllCalculatedDataChanged: {
        if (loadSucceededStatus) {
            setAllCalculatedData()
            redrawPlot()
        }
    }



    onLoadingChanged: {
        if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
            loadSucceededStatus = true
        }
    }

    function setXAxisTitle(newTitle) {
        //runJavaScript(`setXAxisTitle(${JSON.stringify(newTitle)})`)
    }

    function setYAxisTitle(newTitle) {
        //runJavaScript(`setYAxisTitle(${JSON.stringify(newTitle)})`)
    }

    function setXArray(newArray) {
        //runJavaScript(`setXArray(${JSON.stringify(newArray)})`)
    }

    function setYArray(newArray) {
        //runJavaScript(`setYArray(${JSON.stringify(newArray)})`)
    }

    function redrawPlot() {
        runJavaScript(`redrawPlot()`)
    }

    function setMeasuredData() {
        console.log("!!!!!!!!!!!!! measuredData qml", JSON.stringify(measuredData))
        runJavaScript(`setMeasuredData(${JSON.stringify(measuredData)})`, function(result) { console.log(result); })
    }

    function setCalculatedData() {
        //console.log("!!!!!!!!!!!!!", JSON.stringify(calculatedData))
        runJavaScript(`setCalculatedData(${JSON.stringify(calculatedData)})`, function(result) { console.log(result); })
    }

    function setAllCalculatedData() {
        console.log("!!!!!!!!!!!!! allCalculatedData.x qml", JSON.stringify(allCalculatedData.x))
        console.log("!!!!!!!!!!!!! allCalculatedData.difference.y qml", JSON.stringify(allCalculatedData.difference.y))
        runJavaScript(`setAllCalculatedData(${JSON.stringify(allCalculatedData)})`, function(result) { console.log(result); })
    }

}
