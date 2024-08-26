# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject, Property

from EasyApp.Logic.Logging import LoggerLevelHandler

from .connections import ConnectionsHandler
from .project import Project
from .status import Status
from .report import Report


class BackendProxy(QObject):
    def __init__(self):
        super().__init__()

        self._logger = LoggerLevelHandler(self)

        self._project = Project()
        self._status = Status()
        self._report = Report()

        self._connections = ConnectionsHandler(self)

    @Property('QVariant', constant=True)
    def logger(self):
        return self._logger

    @Property('QVariant', constant=True)
    def project(self):
        return self._project

    @Property('QVariant', constant=True)
    def status(self):
        return self._status

    @Property('QVariant', constant=True)
    def report(self):
        return self._report
