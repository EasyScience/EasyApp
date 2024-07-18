# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


CURRENT_DIR = Path(__file__).parent                    # path to qml components of the current project
EASYAPP_DIR = CURRENT_DIR / '..' / '..' / '..' / '..'  # path to qml components of the easyapp module
MAIN_QML = CURRENT_DIR / 'main.qml'                    # path to the root qml file


if __name__ == '__main__':
    # Create application
    app = QGuiApplication(sys.argv)

    # Create QML application engine
    engine = QQmlApplicationEngine()
    engine.addImportPath(EASYAPP_DIR)
    engine.addImportPath(CURRENT_DIR)
    engine.load(MAIN_QML)

    # Event loop
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
