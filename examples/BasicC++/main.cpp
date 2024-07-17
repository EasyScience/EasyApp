// SPDX-FileCopyrightText: 2023 EasyExample contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
    // Create application
    QGuiApplication app(argc, argv);

    // Create QML application engine
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/EasyApp");
    engine.addImportPath("qrc:/");
    engine.load("qrc:/main.qml");

    // Event loop
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
