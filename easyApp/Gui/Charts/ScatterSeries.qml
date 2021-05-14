import QtQuick 2.13
import QtCharts 2.13

import easyApp.Gui.Style 1.0 as EaStyle

import Gui.Globals 1.0 as ExGlobals

ScatterSeries {
    property var customPoints: [] //[Qt.point(0, -1), Qt.point(10, 6)] //[{"x":0,"y":-1},{"x":10,"y":6}]

    color: EaStyle.Colors.chartLine

    onCustomPointsChanged: customReplacePoints()

    // Python-based logic

    function customReplacePoints() {
        ExGlobals.Constants.proxy.plotting1d.lineSeriesCustomReplace(this, customPoints)
    }
}
