import sys

# We need to add the path for the ExampleApp to the search path so that we can import the PyProxy class  
from os.path import dirname
# We need to add the path to reach the code for ExampleApp
sys.path.append(dirname(dirname(__file__)))
# We need to add the path for the EasyApp module
sys.path.append(dirname(dirname(dirname(__file__))))

from pathlib import Path

from PySide6 import QtCore
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from ExampleApp.Logic.PyProxy import PyProxy

# This is needed by Report.qml  
QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_ShareOpenGLContexts, True)


if __name__ == "__main__":
    qml_dir = Path(__file__).parent / "Gui"

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(qml_dir)

    # Load and construct the GUI using QML
    qml_path = qml_dir / "Main.qml"
    engine.load(qml_path)

    # Use the PyProxy as backend to the GUI
    proxy = PyProxy()
    engine.rootContext().setContextProperty('proxy', proxy)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
