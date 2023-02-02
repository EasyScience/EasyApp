import QtQuick

import easyApp.Gui.Elements 1.0 as EaElements

EaElements.ComboBox {
    property string headerText: ""
    property int horizontalAlignment: Text.AlignHCenter

    borderColor: "transparent"
    backgroundColor: "transparent"

    anchors.verticalCenter: parent.verticalCenter
}
