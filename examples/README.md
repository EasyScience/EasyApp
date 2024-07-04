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

* Download Qt Online Installer from [qt.io](https://www.qt.io/download-qt-installer-oss). More info at [doc.qt.io](https://doc.qt.io/qt-6/qt-online-installation.html).
* Install Qt for desktop development using a custom installation that includes the following components:
    * Qt 
	   * [ ] Qt 6.7.z
	       * [x] Desktop (**macOS**) or MSVC 2019 64-bit (**Windows**)
	       * [x] Qt 5 Compatibility Module
	       * [x] Qt Shader Tools
   	       * [ ] Additional Libraries
   	           * [x] Qt Charts  
	   * [ ] Developer and Designer Tools
	       * [x] Qt Creator x.y.z

#### Run with the Qt Creator IDE
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

#### How to edit GUI elements in live mode

* In Qt Creator, select the `.qml` file to be edited in live mode
* Click the `Design` button at the top of the left sidebar of `Qt Creator`
    * _Note: If this button is disabled, find and click `About plugins...` in the `Qt Creator` menu, scroll down to the `Qt Quick` section and enable `QmlDesigner`._
* In the `Design` window, click the `Show Live Preview` button in the top panel of the application (small play nutton in a circle). 
    * _Note: Showing the entire `main.qml` application window in live mode works best when the open `main.qml` is moved to another monitor and does not overlap with the `Qt Creator` window_.

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
