# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject


class ConnectionsHandler(QObject):

    def __init__(self, parent):
        super().__init__(parent)
        self._proxy = parent

        # Project
        self._proxy.project.name_changed.connect(self.on_project_name_changed)
        self._proxy.project.created_changed.connect(self.on_project_created_changed)

    #########
    # Project
    #########

    def on_project_name_changed(self):
        self._proxy.status.project = self._proxy.project.name
        self._proxy.report._as_html = self._proxy.project.name

    def on_project_created_changed(self):
        self._proxy.report.created = self._proxy.project.created
