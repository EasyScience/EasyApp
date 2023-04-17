import QtQuick

import EasyApp.Gui.Elements as EaElements

EaElements.Label {
    property string headerText: ""
    property bool flexibleWidth: false

    height: parent.height
    width: parent.height

    bottomInset: 4
    topInset: 4
    leftInset: 4
    rightInset: 4

    anchors.verticalCenter: parent.verticalCenter

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    elide: Text.ElideMiddle
}
