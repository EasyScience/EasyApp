pragma Singleton

import QtQuick

import Globals as Globals

// Mock for the backend functionality
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

        readonly property var _DEFAULT_EXAMPLES: [
            {
                'name': 'MockProxy Horizontal line',
                'description': 'Straight line, horizontal, PicoScope 2204A',
                'path': '../Resources/Examples/HorizontalLine/project.json'
            },
            {
                'name': 'MockProxy Slanting line 1',
                'description': 'Straight line, positive slope, Tektronix 2430A',
                'path': '../Resources/Examples/SlantingLine1/project.json'
            },
            {
                'name': 'MockProxy Slanting line 2',
                'description': 'Straight line, negative slope, Siglent SDS1202X-E',
                'path': '../Resources/Examples/SlantingLine2/project.json'
            }
        ]

        property var data: _DEFAULT_DATA
        property var examples: _DEFAULT_EXAMPLES
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

    //////////
    // Summary
    //////////

    readonly property var summary: QtObject {
        readonly property var _DEFAULT_MEASURED_X: [1, 2, 3, 4, 5]
        readonly property var _DEFAULT_MEASURED_Y: [1.1, 1.2, 1.3, 1.4, 1.5]
        readonly property var _DEFAULT_CALCULATED_X: [1, 2, 3, 4, 5]
        readonly property var _DEFAULT_CALCULATED_Y: [2.1, 2.2, 2.3, 2.4, 2.5]

        property bool created: true
        property var xMeasuredData: _DEFAULT_MEASURED_X
        property var yMeasuredData: _DEFAULT_MEASURED_Y
        property var xCalculatedData: _DEFAULT_CALCULATED_X
        property var yCalculatedData: _DEFAULT_CALCULATED_Y
    }
}
