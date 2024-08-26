# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import time
from pathlib import Path
from PySide6.QtCore import QObject, Signal, Slot, Property

from EasyApp.Logic.Logging import console
from .helpers import IO
from .helpers import DottyDict


_INFO = {
    'description': '',
    'location': str(Path.home()),
    'creationDate': ''
}

_EXAMPLES = [
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3 (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3-Raw (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3-Raw_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI, 2 phases',
        'name': 'La0.5Ba0.5CoO3-Mult-Phases (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3-Mult-Phases_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, D20@ILL',
        'name': 'Co2SiO4 (D20)',
        'path': ':/Examples/Co2SiO4_D20@ILL/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, G41@LLB',
        'name': 'Dy3Al5O12 (G41)',
        'path': ':/Examples/Dy3Al5O12_G41@LLB/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, D1A@ILL',
        'name': 'PbSO4 (D1A)',
        'path': ':/Examples/PbSO4_D1A@ILL/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, 3T2@LLB',
        'name': 'LaMnO3 (3T2)',
        'path': ':/Examples/LaMnO3_3T2@LLB/project.cif'
    }
]


class Project(QObject):
    created_changed = Signal()
    name_changed = Signal()
    info_changed = Signal()
    examples_changed = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._proxy = parent
        self._created = False
        self._name = ''
        self._info = _INFO
        self._examples = _EXAMPLES

    # Properties

    @Property(bool, notify=created_changed)
    def created(self):
        return self._created

    @created.setter
    def created(self, new_value):
        if self._created == new_value:
            return
        self._created = new_value
        self.created_changed.emit()

    @Property(str, notify=name_changed)
    def name(self):
        return self._name

    @name.setter
    def name(self, new_value):
        if self._name == new_value:
            return
        console.debug(IO.format_msg('main', f"Changing project name from '{self.name}' to '{new_value}'"))
        self._name = new_value
        self.name_changed.emit()

    @Property('QVariant', notify=info_changed)
    def info(self):
        return self._info

    @Property('QVariant', constant=True)
    def examples(self):
        return self._examples

    # Methods

    @Slot()
    def create(self):
        console.debug(IO.format_msg('main', f"Creating project '{self.name}'"))
        self.info['creationDate'] = time.strftime("%d %b %Y %H:%M", time.localtime())
        self.info_changed.emit()
        self.created = True

    @Slot()
    def save(self):
        console.debug(IO.format_msg('main', f"Saving project '{self.name}'"))

    @Slot(str, str)
    def edit_info(self, path, new_value):
        if DottyDict.get(self._info, path) == new_value:
            return
        console.debug(IO.format_msg('main', f"Changing project info.{path} from '{DottyDict.get(self._info, path)}' to '{new_value}'"))
        DottyDict.set(self._info, path, new_value)
        self.info_changed.emit()
