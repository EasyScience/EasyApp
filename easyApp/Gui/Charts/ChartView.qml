import QtQuick
import QtCharts

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

ChartView {
    id: chart

    property bool showAxesRect: true
    property bool allowZoom: true

    margins.top: 0
    margins.bottom: 0
    margins.left: 0
    margins.right: 0

    //anchors.margins: -12 //doesn't work

    antialiasing: true

    //theme: Globals.Colors.chartTheme
    animationDuration: EaStyle.Times.chartAnimation //0
    animationOptions: ChartView.SeriesAnimations

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
    Behavior on titleColor {
        Animations.ThemeChange {}
    }
    */

    plotAreaColor: EaStyle.Colors.chartPlotAreaBackground
    Behavior on plotAreaColor { EaAnimations.ThemeChange {} }

    // Plot axes rect
    Rectangle {
        visible: showAxesRect
        x: plotArea.x
        y: plotArea.y
        height: 1
        width: plotArea.width

        color: EaStyle.Colors.chartAxis
        Behavior on color { EaAnimations.ThemeChange {} }
    }
    Rectangle {
        visible: showAxesRect
        x: plotArea.x
        y: plotArea.y + plotArea.height
        height: 1
        width: plotArea.width

        color: EaStyle.Colors.chartAxis
        Behavior on color { EaAnimations.ThemeChange {} }
    }
    Rectangle {
        visible: showAxesRect
        x: plotArea.x
        y: plotArea.y
        height: plotArea.height
        width: 1

        color: EaStyle.Colors.chartAxis
        Behavior on color { EaAnimations.ThemeChange {} }
    }
    Rectangle {
        visible: showAxesRect
        y: plotArea.y
        x: plotArea.x + plotArea.width
        height: plotArea.height
        width: 1

        color: EaStyle.Colors.chartAxis
        Behavior on color { EaAnimations.ThemeChange {} }
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
            color: EaStyle.Colors.appBorder
        }
    }

    // Left mouse button events
    MouseArea {
        enabled: allowZoom

        anchors.fill: chart
        acceptedButtons: Qt.LeftButton

        onPressed: {
            //chart.animationOptions = ChartView.SeriesAnimations
            chart.animationDuration = EaStyle.Times.chartAnimation

            recZoom.x = mouseX
            recZoom.y = mouseY
            recZoom.visible = true
        }

        onMouseXChanged: {
            if (mouseX > recZoom.x) {
                recZoom.xScaleZoom = 1
                recZoom.width = Math.min(mouseX, chart.width) - recZoom.x
            } else {
                recZoom.xScaleZoom = -1
                recZoom.width = recZoom.x - Math.max(mouseX, 0)
            }
        }

        onMouseYChanged: {
            if (mouseY > recZoom.y) {
                recZoom.yScaleZoom = 1
                recZoom.height = Math.min(mouseY, chart.height) - recZoom.y
            } else {
                recZoom.yScaleZoom = -1
                recZoom.height = recZoom.y - Math.max(mouseY, 0)
            }
        }

        onReleased: {
            //enableAnimation()

            const x = Math.min(recZoom.x, mouseX) - chart.anchors.leftMargin
            const y = Math.min(recZoom.y, mouseY) - chart.anchors.topMargin

            const width = recZoom.width
            const height = recZoom.height

            chart.zoomIn(Qt.rect(x, y, width, height))
            recZoom.visible = false

            //disableAnimation()
        }
    }

    // Right mouse button events
    MouseArea {
        enabled: allowZoom

        anchors.fill: chart
        acceptedButtons: Qt.RightButton

        onClicked: {
            //enableAnimation()

            chart.zoomReset()

            //disableAnimation()
        }
    }

    // Disable animation timer
    Timer {
        id: disableAnimationTimer
        interval: animationDuration
        onTriggered: animationDuration = 0
    }

    // Logic

    function enableAnimation() {
        animationDuration = EaStyle.Times.chartAnimation
    }

    function disableAnimation() {
        disableAnimationTimer.restart()
    }

}
