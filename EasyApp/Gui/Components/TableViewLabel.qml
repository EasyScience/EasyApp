import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements

EaElements.Label {
    id: control

    property bool flexibleWidth: false

    height: parent.height
    width: parent.height  // ???

    bottomInset: 4
    topInset: 4
    leftInset: 4
    rightInset: 4

    anchors.verticalCenter: parent.verticalCenter

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    elide: Text.ElideMiddle

    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: text !== "" &&
                 control.truncated &&
                 mouseArea.containsMouse &&
                 EaGlobals.Vars.showToolTips
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
