import QtQuick
import QtQuick.Controls
import QtCharts

import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Charts as EaCharts


ChartView {
    id: chartView

    property alias axisX: axisX
    property alias axisY: axisY

    property bool useOpenGL: false
    property bool allowZoom: true
    property bool allowHover: true

    property bool detectXYChange: true
    property real initialXMin: 0
    property real initialXMax: 0
    property real initialYMin: 0
    property real initialYMax: 0

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

    animationOptions: ChartView.SeriesAnimations
    animationDuration: EaStyle.Times.chartAnimation

    EaCharts.QtCharts1dValueAxis {
        id: axisX
        onMinChanged: if (detectXYChange) initialXMin = axisX.min
        onMaxChanged: if (detectXYChange) initialXMax = axisX.max
    }

    EaCharts.QtCharts1dValueAxis {
        id: axisY
        onMinChanged: if (detectXYChange) initialYMin = axisY.min
        onMaxChanged: if (detectXYChange) initialYMax = axisY.max
    }

    // Zoom rectangle
    Rectangle{
        id: recZoom
        property int xScaleZoom: 0
        property int yScaleZoom: 0
        visible: false
        transform: Scale { origin.x: 0; origin.y: 0; xScale: recZoom.xScaleZoom; yScale: recZoom.yScaleZoom}
        border.color: EaStyle.Colors.appBorder
        border.width: 1
        opacity: 0.9
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: recZoom.border.color
        }
    }

    // Pan with left mouse button
    MouseArea {
        property real initialMouseX: 0
        property real initialMouseY: 0
        property int deltaX: 0
        property int deltaY: 0
        property int threshold: 1
        enabled: !allowZoom
        anchors.fill: chartView
        acceptedButtons: Qt.LeftButton
        onPressed: {
            initialMouseX = mouseX
            initialMouseY = mouseY
        }
        onMouseXChanged: {
            deltaX = Math.round(mouseX - initialMouseX)
            initialMouseX = mouseX
        }
        onMouseYChanged: {
            deltaY = Math.round(mouseY - initialMouseY)
            initialMouseY = mouseY
        }
        onDeltaXChanged: {
            detectXYChange = false
            if (deltaX > threshold)
                chartView.scrollLeft(deltaX)
            else if (deltaX < -threshold)
                chartView.scrollRight(-deltaX)
            detectXYChange = true
        }
        onDeltaYChanged: {
            detectXYChange = false
            if (deltaY > threshold)
                chartView.scrollUp(deltaY)
            else if (deltaY < -threshold)
                chartView.scrollDown(-deltaY)
            detectXYChange = true
        }
    }

    // Reset axes with right mouse button (after move)
    MouseArea {
        enabled: !allowZoom
        anchors.fill: chartView
        acceptedButtons: Qt.RightButton
        onClicked: resetMove()
    }

    // Zoom with left mouse button
    MouseArea {
        enabled: allowZoom
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

    // Reset axes with right mouse button (after zoom)
    MouseArea {
        enabled: allowZoom
        anchors.fill: chartView
        acceptedButtons: Qt.RightButton
        onClicked: resetZoom()
    }

    // Logic

    function resetMove() {
        axisX.min = initialXMin
        axisX.max = initialXMax
        axisY.min = initialYMin
        axisY.max = initialYMax
    }

    function resetZoom() {
        chartView.zoomReset()
    }

}
