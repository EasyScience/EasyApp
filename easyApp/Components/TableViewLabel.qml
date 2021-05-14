import QtQuick 2.13

import easyApp.Elements 1.0 as EaElements

EaElements.Label {
    property string headerText: ""

    height: parent.height
    width: parent.height

    bottomInset: 4
    topInset: 4
    leftInset: 4
    rightInset: 4

    anchors.verticalCenter: parent.verticalCenter

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
