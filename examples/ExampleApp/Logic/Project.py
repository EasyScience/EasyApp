# SPDX-FileCopyrightText: 2023 EasyExample contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

import os
import json
import jsbeautifier
import copy
from datetime import datetime
from PySide6.QtCore import QObject 
from PySide6.QtCore import Signal
from PySide6.QtCore import Slot
from PySide6.QtCore import Property

from EasyApp.Logic.Logging import console


_DEFAULT_DATA = {
    'name': 'PyProxy',
    'description': 'Default project description from PY proxy',
    'location': '',
    'creationDate': ''
}

_EXAMPLES = [
    {
        'name': 'Horizontal line',
        'description': 'Straight line, horizontal, PicoScope 2204A',
        'path': '../Resources/Examples/HorizontalLine/project.json'
     }
]

class Project(QObject):
    createdChanged = Signal()
    needSaveChanged = Signal()
    dataChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._proxy = parent
        self._data = copy.copy(_DEFAULT_DATA)
        self._examples = _EXAMPLES
        self._created = False
        self._needSave = False

    @Property('QVariant', notify=dataChanged)
    def data(self):
        return self._data

    @Property('QVariant', constant=True)
    def examples(self):
        return self._examples

    @Property(bool, notify=createdChanged)
    def created(self):
        return self._created

    @created.setter
    def created(self, newValue):
        if self._created == newValue:
            return
        self._created = newValue
        self.createdChanged.emit()

    @Property(bool, notify=needSaveChanged)
    def needSave(self):
        return self._needSave

    @needSave.setter
    def needSave(self, newValue):
        if self._needSave == newValue:
            return
        self._needSave = newValue
        self.needSaveChanged.emit()

    
    @Slot()
    def setNeedSaveToTrue(self):
        self.needSave = True

    @Slot()
    def create(self):
#        self._data = _DEFAULT_DATA
        self._data['creationDate'] = datetime.now().strftime("%d %b %Y %H:%M")
        self.dataChanged.emit()
        self.created = True
        self.needSave = True

    @Slot(str, str)
    def editData(self, key, value):
        if self._data[key] == value:
            return
        self._data[key] = value
        self.dataChanged.emit()

    @Slot()
    def save(self):
        console.debug('Save project')
        # Create full project dict
        out = {}
        if self.created:
            out['project'] = self._data
        # if self._proxy.experiment.defined:
        #     out['experiment'] = self._proxy.experiment.dataBlocks
        #     for idx, data in enumerate(out['experiment']):
        #         data['xArray'] = self._proxy.experiment._xArrays[idx].tolist()
        #         data['yMeasArray'] = self._proxy.experiment._yMeasArrays[idx].tolist()
        # if self._proxy.model.defined:
        #     out['model'] = self._proxy.model.dataBlocks
        #     for idx, data in enumerate(out['model']):
        #         data['yCalcArray'] = self._proxy.model._yCalcArrays[idx].tolist()
        # Format project as json
        options = jsbeautifier.default_options()
        options.indent_size = 2
        formattedProject = jsbeautifier.beautify(json.dumps(out), options)
        # Save formatted project as json
        filePath = os.path.join(out['project']['location'], 'project.json')
        os.makedirs(os.path.dirname(filePath), exist_ok=True)
        with open(filePath, 'w') as file:
            file.write(formattedProject)
        # Toggle need save
        self.needSave = False
