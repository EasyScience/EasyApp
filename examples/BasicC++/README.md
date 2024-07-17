## Structure of the _most-basic_ example

### Without the full structure of the application pages

```sh
🗂️ most-basic                       # Current example directory
├── .qmlproject                     # QML project for Qt Creator
├── .pyproject                      # Python project for Qt Creator
│
├── main.qml                        # Root QML component        
├── main.py                         # Root Python file        
│
└── 🗂️ Gui                          # Frontend GUI components
    ├── qmldir                      
    ├── ApplicationWindow.qml       # Top-level application window
    ├── StatusBar.qml               # Status bar    
    │
    ├── 🗂️ Globals                  # Globally accessible objects
    │   ├── qmldir                  
    │   ├── ApplicationInfo.qml     
    │   ├── BackendProxy.qml        # Layer between the backend proxy and GUI objects
    │   └── References.qml          # QML object ids to globally access the desired objects
    │
    ├── 🗂️ MockLogic                # Mock logic to be used if no python logic is defined
    │   ├── qmldir                  
    │   ├── BackendProxy.qml        # Parent object for all other objects with mock logic
    │   ├── Status.qml              # Mock logic for the status bar
    │   ├── Project.qml             # Mock logic for the application page 'Project'
    │   └── Report.qml              # Mock logic for the application page 'Report'
    │
(*) ├── 🗂️ Pages                    # Application pages
    │   ├── 🗂️ Home                 # Components of the application page 'Home'
    │   ├── 🗂️ Project              # Components of the application page 'Project'
    │   └── 🗂️ Report               # Components of the application page 'Report'
    │    
    └── 🗂️ Resources
        └── 🗂️ Logos                # Logos of the application and contributors

(*) Full structure of the 'Pages' directory is shown below   
```

### Structure of the application pages only

```sh
🗂️ Pages
│
├── 🗂️ Home                         # Components of the application 'Home' page
│   ├── Content.qml
│   │
│   └── 🗂️ Popups                   
│       └── About.qml
│
├── 🗂️ Project                      # Components of the application 'Project' page
│   ├── Layout.qml                  # Layout of the whole page
│   │
│   ├── 🗂️ MainAreaTabs             # Tabs of the main area
│   │   └── Description.qml
│   │
│   └── 🗂️ SidebarTabs              # Tabs of the sidebar
│       │
│       ├── 🗂️ Basic                # Components of the sidebar tab with basic controls
│       │   ├── Layout.qml        
│       │   │
│       │   ├── 🗂️ Groups           
│       │   │   ├── GetStarted.qml
│       │   │   ├── Examples.qml
│       │   │   └── Recent.qml
│       │   │
│       │   └── 🗂️ Popups           
│       │       ├── OpenCifFile.qml
│       │       └── ProjectDescription.qml
│       │
│       ├── 🗂️ Extra                # Components of the sidebar tab with extra controls
│       │   ├── Layout.qml        
│       │   │ 
│       │   └── 🗂️ Groups           
│       │       └── Scrolling.qml
│       │
│       └── 🗂️ Text                 # Components of the sidebar tab with text mode controls
│           └── Layout.qml          
│
└── 🗂️ Report                       # Components of the application 'Report' page
    ├── Layout.qml                  # Layout of the whole page
    │
    ├── 🗂️ MainAreaTabs             # Tabs of the main area
    │   └── Summary.qml
    │
    └── 🗂️ SidebarTabs              # Tabs of the sidebar
        │
        ├── 🗂️ Basic                # Components of the sidebar tab with basic controls
        │   ├── Layout.qml   
        │   │       
        │   └── 🗂️ Groups           
        │       └── Export.qml
        │
        └── 🗂️ Extra                # Components of the sidebar tab with extra controls
            ├── Layout.qml          
            │
            └── 🗂️ Groups           
                └── Empty.qml
```

### Glossary

* qmldir - Declares objects that can then be imported into other qml files. See
[doc.qt.io](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) for more details.
