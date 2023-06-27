import QtQuick

import EasyApp.Gui.Elements as EaElements

EaElements.TextInput {
    property string headerText: ""
    property bool flexibleWidth: false
    property bool fit: false

    height: parent.height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    font.bold: fit

    onAccepted: focus = false
}
