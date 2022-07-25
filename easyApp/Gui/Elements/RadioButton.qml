import QtQuick 2.13
import QtQuick.Controls 2.13

RadioButton {
    id: control
    text: qsTr("RadioButton")
    checked: false

    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 9
        border.color: control.activeFocus ? "darkblue" : "gray"

        Rectangle {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 9
            anchors.fill: parent
            anchors.margins: 4
            color: "#555"
            visible: control.checked
        }
    }

    contentItem: Text {
        text: qsTr(control.text)
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "darkblue" : "gray"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
