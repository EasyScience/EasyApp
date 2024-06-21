import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.BasicReport {

    xAxisTitle: "x"
    yAxisTitle: "y"

    measuredXYData: Globals.BackendProxy.main.summary.created ?
                        {'x': Globals.BackendProxy.main.summary.xMeasuredData, 'y': Globals.BackendProxy.main.summary.yMeasuredData} :
                        {}
    calculatedXYData: Globals.BackendProxy.main.summary.created ?
                          {'x': Globals.BackendProxy.main.summary.xCalculatedData, 'y': Globals.BackendProxy.main.summary.yCalculatedData} :
                          {}

//    Component.onCompleted: Globals.Refs.summaryReportWebEngine = this

}

