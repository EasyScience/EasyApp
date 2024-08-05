# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import sys

# If running the example within the EasyApp repo we need to add the path to the source code for the module
# Usually the module will be installed in the python environment
from os.path import dirname
sys.path.append(dirname(dirname(dirname(dirname(dirname(__file__))))) + '/src')

from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import qInstallMessageHandler

from EasyApp.Logic.Logging import console

from Logic.Py.backend_proxy import BackendProxy


CURRENT_DIR = Path(__file__).parent                            # path to qml components of the current project
EASYAPP_DIR = CURRENT_DIR / '..' / '..' / '..' / '..' / 'src'  # path to qml components of the easyapp module
MAIN_QML = CURRENT_DIR / 'main.qml'                            # path to the root qml file


if __name__ == '__main__':
    qInstallMessageHandler(console.qmlMessageHandler)
    console.debug('Custom Qt message handler defined')

    app = QGuiApplication(sys.argv)
    console.debug(f'Qt Application created {app}')

    engine = QQmlApplicationEngine()
    console.debug(f'QML application engine created {engine}')

    backend_proxy = BackendProxy()
    engine.rootContext().setContextProperty('backend_proxy_py', backend_proxy)
    console.debug('backend_proxy object exposed to QML as backend_proxy_py')

    engine.addImportPath(EASYAPP_DIR)
    engine.addImportPath(CURRENT_DIR)
    console.debug('Paths added where QML searches for components')

    engine.load(MAIN_QML)
    console.debug('Main QML component loaded')

    console.debug('Application event loop is about to start')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
