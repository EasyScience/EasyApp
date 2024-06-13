import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.BasicReport {

    xAxisTitle: "x"
    yAxisTitle: "y"

    measuredXYData: Globals.Proxies.main.summary.isCreated ?
                        {'x': Globals.Proxies.main.experiment.xData, 'y': Globals.Proxies.main.experiment.yData} :
                        {}
    calculatedXYData: Globals.Proxies.main.summary.isCreated ?
                          {'x': Globals.Proxies.main.experiment.xData, 'y': Globals.Proxies.main.model.yData} :
                          {}

    Component.onCompleted: Globals.Refs.summaryReportWebEngine = this

}

