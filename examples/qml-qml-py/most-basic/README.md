## Structure of the _most-basic_ example

### Without the full structure of the application pages

```sh
🗂️ most-basic                       # Parent directory
├── qmlproject.qmlproject           # QML project for QtCreator
├── main.qml                        # Root QML component        
│
└── 🗂️ Gui                          # Frontend GUI components
    ├── qmldir                      # Declares objects which can be then imported in other qml files
    ├── ApplicationWindow.qml       # Layout of the top-level application window
    ├── StatusBar.qml               # Status bar of the application window
    │
    ├── 🗂️ Globals                  # Globally accessible objects and variables
    │   ├── qmldir                  # Declares objects to be imported in other qml files
    │   ├── MockProxy.qml           # Mock proxy object to be used if no other proxies is defined
    │   ├── Refs.qml                # QML object id attributes to be exposed to the backend proxy
    │   └── Vars.qml                # Variables (backendProxy, homePageEnabled, etc.).
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

### Application pages only

```sh
🗂️ Pages
├── 🗂️ Home                         # Components of the application 'Home' page
│   ├── Content.qml
│   └── 🗂️ Popups                   
│       └── About.qml
│
├── 🗂️ Project                      # Components of the application 'Project' page
│   ├── Layout.qml                  # Layout of the whole page
│   ├── 🗂️ MainAreaTabs             # Tabs of the main area
│   │   └── Description.qml
│   └── 🗂️ SidebarTabs              # Tabs of the sidebar
│       ├── 🗂️ Basic                # Components of the sidebar tab with basic controls
│       │   ├── Layout.qml          
│       │   ├── 🗂️ Groups           
│       │   │   ├── GetStarted.qml
│       │   │   ├── Examples.qml
│       │   │   └── Recent.qml
│       │   └── 🗂️ Popups           
│       │       └── ProjectDescription.qml
│       ├── 🗂️ Extra                # Components of the sidebar tab with extra controls
│       │   ├── Layout.qml          
│       │   └── 🗂️ Groups           
│       │       └── Scrolling.qml
│       └── 🗂️ Text                 # Components of the sidebar tab with controls in text mode
│           └── Layout.qml          
│
└── 🗂️ Report                       # Components of the application 'Report' page
    ├── Layout.qml                  # Layout of the whole page
    ├── 🗂️ MainAreaTabs             # Tabs of the main area
    │   └── Summary.qml
    └── 🗂️ SidebarTabs              # Tabs of the sidebar
        ├── 🗂️ Basic                # Components of the sidebar tab with basic controls
        │   ├── Layout.qml          
        │   └── 🗂️ Groups           
        │       └── Export.qml
        └── 🗂️ Extra                # Components of the sidebar tab with extra controls
            ├── Layout.qml          
            └── 🗂️ Groups           
                └── Empty.qml
```
