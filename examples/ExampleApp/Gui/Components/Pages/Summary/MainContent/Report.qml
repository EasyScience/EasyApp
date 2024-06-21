import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.BasicReport {

    xAxisTitle: "x from BasicReport.qml"
    yAxisTitle: "y from BasicReport.qml"

    measuredXYData: Globals.BackendProxy.main.summary.created ?
                        {'x': Globals.BackendProxy.main.summary.xMeasuredData, 'y': Globals.BackendProxy.main.summary.yMeasuredData} :
                        {}
    calculatedXYData: Globals.BackendProxy.main.summary.created ?
                          {'x': Globals.BackendProxy.main.summary.xCalculatedData, 'y': Globals.BackendProxy.main.summary.yCalculatedData} :
                          {}
}

// The other elements of the report are defined in the EasyApp/Gui/Components/BasicReport.qml and EasyApp/Gui/Html/BasicReport.html 
