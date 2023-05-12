import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Charts as EaCharts


ChartView {
    id: chartView

    property bool useOpenGL: false

    property alias axisX: axisX
    property alias axisY: axisY
    property alias xAxisTitle: axisX.title
    property alias yAxisTitle: axisY.title
    property alias xMin: axisX.min
    property alias xMax: axisX.max
    property alias yMin: axisY.min
    property alias yMax: axisY.max

    property alias xAxisTitleVisible: axisX.titleVisible
    property alias xAxisLabelsVisible: axisX.labelsVisible

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: -12 // Reset default margins

    antialiasing: true

    legend.visible: false
    legend.alignment: Qt.AlignBottom
    legend.font.family: EaStyle.Fonts.fontFamily
    legend.font.pixelSize: EaStyle.Sizes.fontPixelSize
    legend.markerShape: Legend.MarkerShapeRectangle
    legend.labelColor: EaStyle.Colors.chartForeground
    Behavior on legend.labelColor { EaAnimations.ThemeChange {} }

    backgroundRoundness: 0
    backgroundColor: EaStyle.Colors.chartBackground
    Behavior on backgroundColor { EaAnimations.ThemeChange {} }

    titleFont.family: EaStyle.Fonts.fontFamily
    titleFont.pixelSize: EaStyle.Sizes.fontPixelSize
    titleFont.bold: true
    titleColor: EaStyle.Colors.chartForeground
    /* BREAKS ANIMATION !
    Behavior on titleColor { Animations.ThemeChange {} }
    */

    plotAreaColor: EaStyle.Colors.chartPlotAreaBackground
    Behavior on plotAreaColor { EaAnimations.ThemeChange {} }

    //animationDuration: EaStyle.Times.chartAnimation
    //animationOptions: ChartView.SeriesAnimations

    EaCharts.QtCharts1dValueAxis {
        id: axisX

        //onMaxChanged: console.info(`onMaxChanged new max: ${max}`)
        //onRangeChanged: console.info(`onRangeChanged new max: ${max}`)
    }

    EaCharts.QtCharts1dValueAxis {
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
