// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Globals as Globals


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        enabled: Globals.Proxies.main.project.created
        title: qsTr("Export report")
        collapsible: false
        last: true

        Loader { source: 'SideBarBasic/ExportReportGroup.qml' }
    }

}
