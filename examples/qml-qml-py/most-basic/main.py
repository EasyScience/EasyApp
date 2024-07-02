# SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

if __name__ == '__main__':

    # Create application

    app = QGuiApplication(sys.argv)

    # Create QML application engine

    current_dir = Path(__file__).parent

    engine = QQmlApplicationEngine()

    engine.addImportPath(current_dir / '..' / '..' / '..')  # path to qml components of the easyapp module
    engine.addImportPath(current_dir)  # path to qml components of the current project

    engine.load(current_dir / 'main.qml')  # path to the root qml file

    # Event loop

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
