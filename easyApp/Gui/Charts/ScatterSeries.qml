import QtQuick
import QtCharts

import easyApp.Gui.Style as EaStyle

import Gui.Globals as ExGlobals

ScatterSeries {
    property var customPoints: [] //[Qt.point(0, -1), Qt.point(10, 6)] //[{"x":0,"y":-1},{"x":10,"y":6}]

    color: EaStyle.Colors.chartLine

    onCustomPointsChanged: customReplacePoints()

    // Python-based logic

    function customReplacePoints() {
        ExGlobals.Constants.proxy.plotting1d.lineSeriesCustomReplace(this, customPoints)
    }
}
