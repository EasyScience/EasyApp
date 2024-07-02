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
    path_to_easyapp = current_dir / '..' / '..' / '..'
    path_to_qml_components = current_dir
    path_to_root_qml_file = current_dir / "main.qml"
    engine = QQmlApplicationEngine()
    engine.addImportPath(path_to_easyapp)
    engine.addImportPath(path_to_qml_components)
    engine.load(path_to_root_qml_file)

    # Event loop
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
