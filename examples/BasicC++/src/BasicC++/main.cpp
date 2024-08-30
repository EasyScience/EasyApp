// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>

const QString CURRENT_DIR = "qrc:/";  // path to qml components of the easyapp module
const QString EASYAPP_DIR = "qrc:/../../../../src/EasyApp";  // path to qml components of the current project

int main(int argc, char *argv[])
{
    // Create application
    QGuiApplication app(argc, argv);

    // Create QML application engine
    QQmlApplicationEngine engine;
    engine.addImportPath(CURRENT_DIR);
    engine.addImportPath(EASYAPP_DIR);
    engine.load("qrc:/main.qml");

    // Event loop
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
