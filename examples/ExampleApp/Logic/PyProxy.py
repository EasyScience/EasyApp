# SPDX-FileCopyrightText: 2023 EasyExample contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

from PySide6.QtCore import QObject 
from PySide6.QtCore import Property

from Logic.Project import Project
from Logic.Summary import Summary


class PyProxy(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._project = Project(self)
        self._summary = Summary(self)


    @Property('QVariant', constant=True)
    def project(self):
        return self._project

    @Property('QVariant', constant=True)
    def summary(self):
        return self._summary