TEMPLATE = app

# Application name
TARGET = BasicC++

CONFIG += c++17

# Makes compiler emit warnings if deprecated feature is used
DEFINES += QT_DEPRECATED_WARNINGS

QT += core quick qml

SOURCES += \
    BasicC++/main.cpp

RESOURCES += BasicC++/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    BasicC++ \
    ../../../src/EasyApp

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += \
    BasicC++ \
    ../../../src/EasyApp
