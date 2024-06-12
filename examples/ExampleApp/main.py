import sys

# We need to add the path for the ExampleApp to the search path so that we can import the PyProxy class  
from os.path import dirname
# We need to add the path for the ExampleApp module
sys.path.append(dirname(dirname(__file__)))
# We need to add the path for the EasyApp module
sys.path.append(dirname(dirname(dirname(__file__))))

from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from ExampleApp.Logic.PyProxy import PyProxy

if __name__ == "__main__":
    qml_dir = Path(__file__).parent / "Gui"

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(qml_dir)

    # Load and construct the GUI from QML file
    engine.load(qml_dir / "Main.qml")

    # Use the PyProxy as backend to the GUI
    engine.rootContext().setContextProperty('proxy', PyProxy())

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
