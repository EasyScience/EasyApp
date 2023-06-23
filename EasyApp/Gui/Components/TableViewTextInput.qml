import QtQuick

import EasyApp.Gui.Elements as EaElements

EaElements.TextInput {
    property string headerText: ""
    property bool flexibleWidth: false

    height: parent.height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    onAccepted: focus = false
}
