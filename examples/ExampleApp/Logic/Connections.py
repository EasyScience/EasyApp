# SPDX-FileCopyrightText: 2023 EasyExample contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

from PySide6.QtCore import QObject


class Connections(QObject):

    def __init__(self, parent):
        super().__init__(parent)
        self._proxy = parent

        # Project
        self._proxy.project.dataChanged.connect(self.onProjectDataChanged)
        self._proxy.project.createdChanged.connect(self.onProjectDataChanged)

    # Project
    def onProjectDataChanged(self):
        self._proxy.project.setNeedSaveToTrue()
