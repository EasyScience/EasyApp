// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.MockLogic as MockLogic

QtObject {

    property var application: MockLogic.Application
    property var project: MockLogic.Project
    property var status: MockLogic.Status
    property var report: MockLogic.Report

}


