# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

# It is usually assumed that the EasyApp package is already installed in the desired python environment.
# If this is not the case, and if the example is run from the EasyApp repository, one need to add the path to the
# EasyApp source code.
CURRENT_DIR = Path(__file__).parent  # path to qml components of the current project
EASYAPP_DIR = CURRENT_DIR / '..' / '..' / '..' / '..' / 'src'  # path to qml components of the easyapp module
sys.path.append(str(EASYAPP_DIR))


if __name__ == '__main__':
    # Create application
    app = QGuiApplication(sys.argv)

    # Create QML application engine
    engine = QQmlApplicationEngine()
    engine.addImportPath(EASYAPP_DIR)
    engine.addImportPath(CURRENT_DIR)
    engine.load(CURRENT_DIR / 'main.qml')

    # Event loop
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
