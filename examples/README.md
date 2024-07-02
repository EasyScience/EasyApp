## Types of example

Three types of examples are provided, depending on how the backend logic is implemented and which tool is needed to view the graphical frontend. These examples can be found in the following directories:

| Directory     | Frontend | Backend  | Viewer   | Type |
| ------------- | -------- | -------- | -------- | ---- |
| `qml-qml-qml` | QML      | Mock QML | `qml`    | I    |
| `qml-qml-py`  | QML      | Mock QML | `python` | II   |
| `qml-py-py`   | QML      | Python   | `python` | III  |


## How to run

### Type I Examples: `qml-qml-qml`

A Python backend is not required here, but a graphical QML frontend is used with a mock QML backend that will be displayed using Qt `qml` viewer.

* Install Qt 6.x.y including the following modules:
	* Qt 5 Compatibility Module

#### Run using QtCreator IDE
* Run Qt Creator
* Open the qml project file `qmlproject.qmlproject`
* Click Run (Green play button)

#### Run via terminal
* `cd example/qml-qml-qml/most-basic`
* `~/Qt/6.x.y/macos/bin/qml -I . -I ../../.. main.qml`

### Type II Examples: `qml-qml-py`

Most examples can be run via Python, even if they only have a mock backend in QML (the Python backend is not implemented). The minimum configuration requires a base `main.py` file and, if QtCreator is used as the IDE, a `*.pyproject` file. If these are available, do the following:

#### Run using Qt Creator IDE
* Run Qt Creator
* Open the python project file `pyproject.qmlproject`
* Select the desired python environment
* Click Run (Green play button)

#### Run via terminal
* Activate the desired python environment
* `pip install PySide6`
* `cd example/qml-qml-qml/most-basic`
* `python3 Gui/main.qml`

### Type III Examples: `qml-py-py`

These examples can be run through Python in the same way as Type II described above. These examples have a Python-based backend and a python proxy object created in `main.py` that is exposed to QML. Communication between the Qt QML frontend and the Python backend occurs through this python proxy.
