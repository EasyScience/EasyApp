import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Style as EaStyle


ChartView {
    id: chartView

    property alias measSerie: measSerie
    property alias calcSerie: calcSerie
    property bool useOpenGL: false
    property string xAxisTitle: ""
    property string yAxisTitle: ""
    property real xMin: 0
    property real xMax: 1
    property real yMin: 0
    property real yMax: 1

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: -12 // Reset default margins

    antialiasing: true
    legend.visible: false

    backgroundRoundness: 0

    //animationDuration: EaStyle.Times.chartAnimation
    //animationOptions: ChartView.SeriesAnimations

    ScatterSeries {
        id: measSerie

        axisX: axisX
        axisY: axisY

        useOpenGL: false //chartView.useOpenGL

        markerSize: 5
        borderWidth: 1
        color: 'cornflowerblue'
        borderColor: this.color
    }

    LineSeries {
        id: calcSerie

        axisX: axisX
        axisY: axisY

        useOpenGL: chartView.useOpenGL

        color: 'coral'
        width: 2
    }

    ValueAxis {
        id: axisX

        titleText: xAxisTitle

        min: chartView.xMin
        max: chartView.xMax
    }

    ValueAxis {
        id: axisY

        titleText: yAxisTitle

        min: chartView.yMin
        max: chartView.yMax
    }

    // Zoom rectangle
    Rectangle{
        id: recZoom
        property int xScaleZoom: 0
        property int yScaleZoom: 0
        visible: false
        transform: Scale { origin.x: 0; origin.y: 0; xScale: recZoom.xScaleZoom; yScale: recZoom.yScaleZoom}
        border.color: "#999"
        border.width: 1
        opacity: 0.9
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: recZoom.border.color
        }
    }

    // Left mouse button events
    MouseArea {
        anchors.fill: chartView
        acceptedButtons: Qt.LeftButton
        onPressed: {
            recZoom.x = mouseX
            recZoom.y = mouseY
            recZoom.visible = true
        }
        onMouseXChanged: {
            if (mouseX > recZoom.x) {
                recZoom.xScaleZoom = 1
                recZoom.width = Math.min(mouseX, chartView.width) - recZoom.x
            } else {
                recZoom.xScaleZoom = -1
                recZoom.width = recZoom.x - Math.max(mouseX, 0)
            }
        }
        onMouseYChanged: {
            if (mouseY > recZoom.y) {
                recZoom.yScaleZoom = 1
                recZoom.height = Math.min(mouseY, chartView.height) - recZoom.y
            } else {
                recZoom.yScaleZoom = -1
                recZoom.height = recZoom.y - Math.max(mouseY, 0)
            }
        }
        onReleased: {
            const x = Math.min(recZoom.x, mouseX) - chartView.anchors.leftMargin
            const y = Math.min(recZoom.y, mouseY) - chartView.anchors.topMargin
            const width = recZoom.width
            const height = recZoom.height
            chartView.zoomIn(Qt.rect(x, y, width, height))
            recZoom.visible = false
        }
    }

    // Right mouse button events
    MouseArea {
        anchors.fill: chartView
        acceptedButtons: Qt.RightButton
        onClicked: chartView.zoomReset()
    }
}
