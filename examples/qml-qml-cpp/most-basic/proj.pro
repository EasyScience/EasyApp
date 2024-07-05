TEMPLATE = app

# Application name
TARGET = index

CONFIG += c++17

# Makes compiler emit warnings if deprecated feature is used
DEFINES += QT_DEPRECATED_WARNINGS

QT += quick gui qml

SOURCES += \
    main.cpp

RESOURCES += resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    . \
    ../../../EasyApp

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += \
    . \
    ../../../EasyApp
