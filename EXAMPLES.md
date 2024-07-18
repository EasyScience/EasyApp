## Types of examples

Different types of examples are provided, depending on how the backend logic is implemented and which tool is needed to view the graphical frontend. These examples can be categorised as shown in the following table:

| Example        | Type | Frontend | Backend  | Viewer               |
| -------------- | ---- | -------- | -------- | -------------------- |
| BasicQml       | I    | QML      | Mock QML | `qml` tool           |
| BasicMinimalPy | II   | QML      | Mock QML | `python` interpreter |
| BasicPy        | III  | QML      | Python   | `python` interpreter |
| IntermediatePy | III  | QML      | Python   | `python` interpreter |
| BasicC++       | IV   | QML      | Mock QML | need to be compiled  |


## How to run

### Type I Examples: BasicQml

A Python backend is not required here at all. A graphical QML frontend (with a mock QML backend) will be displayed using Qt `qml` viewer.

#### Preparation

* Download Qt Online Installer from [qt.io](https://www.qt.io/download-qt-installer-oss). More info at [doc.qt.io](https://doc.qt.io/qt-6/qt-online-installation.html).
* Install Qt for desktop development using a custom installation that includes the following components:
    * Qt
	   * [ ] Qt 6.7.z
	       * [x] Desktop (***macOS***) or MSVC 2019 64-bit (***Windows***)
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
  $ cd examples/BasicQml/src/BasicQml
  ```

* Run `main.qml` (specifying the paths to the current directory and the EasyApp module directory) using the `qml` tool installed with the Qt Framework in the previous step, e.g., like this

  ```sh
  $ ~/Qt/6.x.y/macos/bin/qml -I . -I ../../../.. main.qml
  ```

#### How to edit GUI elements in live mode

* In Qt Creator, select the `.qml` file to be edited in live mode
* Click the `Design` button at the top of the left sidebar of `Qt Creator`
    * _Note: If this button is disabled, find and click `About plugins...` in the `Qt Creator` menu, scroll down to the `Qt Quick` section and enable `QmlDesigner`._
* In the `Design` window, click the `Show Live Preview` button in the top panel of the application (small play button in a circle).
    * _Note: Showing the entire `main.qml` application window in live mode works best when the open `main.qml` is moved to another monitor and does not overlap with the `Qt Creator` window_.
* When the desired GUI component appears, you can click the `Edit` button at the top of the left sidebar of `Qt Creator` to return to the source code of that qml component and still see it live in a separate window.

### Type II Examples: BasicMinimalPy

Most examples can be run via Python, even if they only have a mock backend in QML (the Python backend is not implemented). The minimum configuration requires a base `main.py` file and, if Qt Creator is used as the IDE, a `*.pyproject` file. If these are available, do the following:

#### Preparation

* Download and install the Qt Framework following the instruction above for the Type I example
* Install the Qt PySide6 module in the desired python environment

***macOS and Linux***

  ```sh
  $ python3.11 -m venv .venv    # create new python environment '.venv'
  $ source .venv/bin/activate   # activate '.venv'
  $ pip install PySide6         # install Qt for Python
  ```

***Windows***

  ```sh
  $ python3.11 -m venv .venv    # create new python environment '.venv'
  $ .venv\Scripts\activate      # activate '.venv'
  $ pip install PySide6         # install Qt for Python
  ```

#### Run with the QtCreator IDE
* Run Qt Creator
* Open the python project file `*.pyproject` from the example folder, e.g., from `example/qml-qml-py/most-basic`
* Select the desired python environment with the Qt PySide6 module installed
* Click Run (Green play button)

#### Run from the terminal
* Go to the example folder, e.g.,

  ```sh
  $ cd examples/BasicMinimalPy/src/BasicMinimalPy
  ```
* Run using Python (provided that the required python environment is activated)

  ```sh
  $ python3 main.py
  ```

### Type III Examples: BasicPy and IntermediatePy

These examples can be run through Python in the same way as Type II described above. These examples have a Python-based backend and a python proxy object created in `main.py` that is exposed to QML. Communication between the Qt QML frontend and the Python backend occurs through this python proxy.

### Possible Issues

* If in Qt Creator some components are highlighted and marked as "Unknown component. (M300)", try resetting via "Tools > QML/JS > Reset Code Model".

### Type IV Examples: BasicC++

These examples can be run after compilation into an executable program. They only have a mock backend in QML (the C++ backend is not implemented). The minimum configuration requires a base `main.cpp` file and, if Qt Creator is used as the IDE, a `*.pro` file.
