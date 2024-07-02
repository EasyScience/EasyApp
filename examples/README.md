## Types of examples

Three types of examples are provided, depending on how the backend logic is implemented and which tool is needed to view the graphical frontend. These examples can be found in the following directories:

| Directory     | Frontend | Backend  | Viewer   | Type |
| ------------- | -------- | -------- | -------- | ---- |
| `qml-qml-qml` | QML      | Mock QML | `qml`    | I    |
| `qml-qml-py`  | QML      | Mock QML | `python` | II   |
| `qml-py-py`   | QML      | Python   | `python` | III  |


## How to run

### Type I Examples: `qml-qml-qml`

A Python backend is not required here, but a graphical QML frontend is used with a mock QML backend that will be displayed using Qt `qml` viewer.

#### Preparation

* Download Qt Framework 6.x.y from [qt.io](https://www.qt.io/download-dev)
* Install Qt Framework including the following modules:
	* Qt 5 Compatibility Module

#### Run with the QtCreator IDE
* Run Qt Creator
* Open the qml project file `*.qmlproject` from the example folder, e.g., from `example/qml-qml-qml/most-basic`
* Click Run (Green play button)

#### Run from the terminal
* Go to the example folder, e.g.,

  ```sh 
  $ cd example/qml-qml-qml/most-basic
  ```

* Run `main.qml` (specifying the paths to the current directory and the EasyApp module directory) using the `qml` tool installed with the Qt Framework in the previous step, e.g., like this

  ```sh 
  $ ~/Qt/6.x.y/macos/bin/qml -I . -I ../../.. main.qml
  ```

### Type II Examples: `qml-qml-py`

Most examples can be run via Python, even if they only have a mock backend in QML (the Python backend is not implemented). The minimum configuration requires a base `main.py` file and, if Qt Creator is used as the IDE, a `*.pyproject` file. If these are available, do the following:

#### Preparation

* Download Qt Framework 6.x.y from [qt.io](https://www.qt.io/download-dev)
* Install Qt Framework including the following modules:
	* Qt 5 Compatibility Module
* Install the Qt PySide6 module in the desired python environment

  ```sh 
  $ python3.11 -m venv venv-name   # create new python environment 'venv-name'
  $ source venv-name/bin/activate  # activate 'venv-name'
  $ pip install PySide6            # install dependencies
  ```

#### Run with the QtCreator IDE
* Run Qt Creator
* Open the python project file `*.pyproject` from the example folder, e.g., from `example/qml-qml-py/most-basic`
* Select the desired python environment with the Qt PySide6 module installed
* Click Run (Green play button)

#### Run from the terminal
* Go to the example folder, e.g.,

  ```sh 
  $ cd example/qml-qml-py/most-basic
  ```
* Run using Python (provided that the required python environment is activated)

  ```sh 
  $ python3 main.py
  ```

### Type III Examples: `qml-py-py`

These examples can be run through Python in the same way as Type II described above. These examples have a Python-based backend and a python proxy object created in `main.py` that is exposed to QML. Communication between the Qt QML frontend and the Python backend occurs through this python proxy.

### Issues

If in Qt Creator some components are highlighted and marked as "Unknown component. (M300)", try resetting via "Tools > QML/JS > Reset Code Model".