import QtQuick

import EasyApp.Gui.Elements as EaElements

EaElements.CheckBox {
    property string headerText: ""
    property int horizontalAlignment: Text.AlignHCenter

    anchors.verticalCenter: parent.verticalCenter
}
