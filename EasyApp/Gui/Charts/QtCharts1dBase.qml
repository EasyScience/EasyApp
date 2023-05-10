import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Style as EaStyle


ChartView {
    id: chartView

    property bool useOpenGL: false

    property alias axisX: axisX
    property alias axisY: axisY
    property alias xAxisTitle: axisX.titleText
    property alias yAxisTitle: axisY.titleText
    property alias xMin: axisX.min
    property alias xMax: axisX.max
    property alias yMin: axisY.min
    property alias yMax: axisY.max

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

    ValueAxis {
        id: axisX
    }

    ValueAxis {
        id: axisY
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
