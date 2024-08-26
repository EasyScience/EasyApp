# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject, Signal, Property


class Status(QObject):
    project_changed = Signal()
    phases_count_changed = Signal()
    experiments_count_changed = Signal()
    calculator_changed = Signal()
    minimizer_changed = Signal()
    variables_changed = Signal()

    def __init__(self):
        super().__init__()
        self._project = 'Undefined'
        self._phases_count = '1'
        self._experiments_count = '1'
        self._calculator = 'CrysPy'
        self._minimizer = 'Lmfit (leastsq)'
        self._variables = '31 (3 free, 28 fixed)'

    @Property(str, notify=project_changed)
    def project(self):
        return self._project

    @project.setter
    def project(self, new_value):
        if self._project == new_value:
            return
        self._project = new_value
        self.project_changed.emit()

    @Property(str, notify=phases_count_changed)
    def phases_count(self):
        return self._phases_count

    @phases_count.setter
    def phases_count(self, new_value):
        if self._phases_count == new_value:
            return
        self._phases_count = new_value
        self.phases_count_changed.emit()

    @Property(str, notify=experiments_count_changed)
    def experiments_count(self):
        return self._experiments_count

    @experiments_count.setter
    def experiments_count(self, new_value):
        if self._experiments_count == new_value:
            return
        self._experiments_count = new_value
        self.experiments_count_changed.emit()

    @Property(str, notify=calculator_changed)
    def calculator(self):
        return self._calculator

    @calculator.setter
    def calculator(self, new_value):
        if self._calculator == new_value:
            return
        self._calculator = new_value
        self.calculator_changed.emit()

    @Property(str, notify=minimizer_changed)
    def minimizer(self):
        return self._minimizer

    @minimizer.setter
    def minimizer(self, new_value):
        if self._minimizer == new_value:
            return
        self._minimizer = new_value
        self.minimizer_changed.emit()

    @Property(str, notify=variables_changed)
    def variables(self):
        return self._variables

    @variables.setter
    def variables(self, new_value):
        if self._variables == new_value:
            return
        self._variables = new_value
        self.variables_changed.emit()
