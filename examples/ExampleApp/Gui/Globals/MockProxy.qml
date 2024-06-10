// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

pragma Singleton

import QtQuick

import Globals as Globals


QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    //////////
    // Logger
    //////////

    readonly property var logger: QtObject {
        property string level: 'debug'
    }

    //////////////
    // Connections
    //////////////

    readonly property var connections: QtObject {

        Component.onCompleted: {
        }

    }

    //////////
    // Project
    //////////

    readonly property var project: QtObject {
        readonly property var _DEFAULT_DATA: {
            'name': 'MockProxy',
            'description': 'Default project description from Mock proxy',
            'location': '',
            'creationDate': ''
        }

        readonly property var _EXAMPLES: [
            {
                'name': 'Horizontal line',
                'description': 'Straight line, horizontal, PicoScope 2204A',
                'path': '../Resources/Examples/HorizontalLine/project.json'
            }
        ]

        property var data: _DEFAULT_DATA
        property var examples: _EXAMPLES
        property bool created: false
        property bool needSave: false

        function setNeedSaveToTrue() {
            needSave = true
        }

        function create() {
            data = _DEFAULT_DATA
            data.creationDate = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
            dataChanged()  // Emit signal, as it is not emited automatically
            created = true
        }

        function editData(key, value) {
            if (data[key] === value) {
                return
            }
            data[key] = value
            dataChanged()  // Emit signal, as it is not emited automatically
        }

        function save() {
            let out = {}
            if (created) {
                out['project'] = data
            }
            if (qmlProxy.experiment.defined) {
                out['experiment'] = qmlProxy.experiment.dataBlocks
            }
            if (qmlProxy.model.defined) {
                out['model'] = qmlProxy.model.dataBlocks
            }
            const filePath = `${out.project.location}/project.json`
            EaLogic.Utils.writeFile(filePath, JSON.stringify(project))
            needSave = false
        }
    }
}
