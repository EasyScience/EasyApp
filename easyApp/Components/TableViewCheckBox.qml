import QtQuick 2.13

import easyAppGui.Elements 1.0 as EaElements

EaElements.CheckBox {
    property string headerText: ""
    property int horizontalAlignment: Text.AlignHCenter

    anchors.verticalCenter: parent.verticalCenter
}
