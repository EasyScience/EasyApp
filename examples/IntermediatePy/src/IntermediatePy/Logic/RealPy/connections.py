# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject


class ConnectionsHandler(QObject):
    """Connects the signals of various BackendWrapper objects to the methods of this class.
    This allows, through the methods of this class, to update dependent objects, but keep them
    unaware of each other."""

    def __init__(self, proxy):
        super().__init__(proxy)
        self._proxy = proxy

        # Project
        self._proxy.project.name_changed.connect(self.on_project_name_changed)
        self._proxy.project.created_changed.connect(self.on_project_created_changed)

    #########
    # Project
    #########

    def on_project_name_changed(self):
        self._proxy.status.project = self._proxy.project.name
        self._proxy.report._asHtml = self._proxy.project.name

    def on_project_created_changed(self):
        self._proxy.report.created = self._proxy.project.created
