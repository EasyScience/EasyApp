import QtQuick 2.13

import easyApp.Gui.Elements 1.0 as EaElements

EaElements.CheckBox {
    property string headerText: ""
    property int horizontalAlignment: Text.AlignHCenter

    anchors.verticalCenter: parent.verticalCenter
}
