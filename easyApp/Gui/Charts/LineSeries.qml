import QtQuick
import QtCharts

import EasyApp.Gui.Style as EaStyle

import Gui.Globals as ExGlobals

LineSeries {
    property var customPoints: [] //[Qt.point(0, -1), Qt.point(10, 6)] //[{"x":0,"y":-1},{"x":10,"y":6}]

    width: 2.0
    color: EaStyle.Colors.chartLine

    onCustomPointsChanged: customReplacePoints()

    // Python-based logic

    function customReplacePoints() {
        ExGlobals.Constants.proxy.plotting1d.lineSeriesCustomReplace(this, customPoints)
    }

    // JS logic

    function customAppend_SLOW() {
        for (let i in customPoints) {
            append(customPoints[i].x, customPoints[i].y)
        }
    }

    function customReplacePoints_SLOW() {
        removePoints(0, count)
        for (let i in customPoints) {
            append(customPoints[i].x, customPoints[i].y)
        }
    }
}
