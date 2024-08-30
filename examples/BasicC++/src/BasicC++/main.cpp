// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>


int main(int argc, char *argv[])
{
    // Create Qt application
    QGuiApplication app(argc, argv);

    // Create the QML application engine
    QQmlApplicationEngine engine;

    // Add the paths where QML searches for components
    // Use whatever is defined in the resources.qrc file
    engine.addImportPath("qrc:/");

    // Load the main QML component
    engine.load("qrc:/main.qml");

    // Start the application event loop
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
