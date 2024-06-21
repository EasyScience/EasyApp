# VSCode

Add the following to your .vscode/launch.json file:
```
{
    "name": "Python: App",
    "type": "debugpy",
    "request": "launch",
    "program": "${workspaceFolder}//examples//ExampleApp//main.py",
    "console": "integratedTerminal",
    "justMyCode": false,
    "cwd": "${workspaceFolder}//examples//ExampleApp",
    "env": {
        "QML_IMPORT_PATH": "${workspaceFolder}",

    }                
}
```

You should now be able to run the code (`Python: App`) using the debugger

# QT Creator

In the `Maintain QT` application make sure the following are installed
- Qt
  - Qt 6.x.y
    - MSVC
    - Qt Shader Tools
    - Additional Libraries
      - Qt Charts
      - Qt Multimedia
      - Qt Positioning
      - Qt WebChannel
      - Qt WebEngine
      - Qt WebView  
  - Developer and Designer Tools
    - Qt Creator 13.x.y

You should now be able to open the project: `examples/ExampleApp/Gui/qml_project.qmlproject`
