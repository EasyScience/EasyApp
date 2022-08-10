import QtQuick
import QtQuick.Templates 2.13 as T
import QtQuick.Controls
import QtQuick.Controls.impl 2.13

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.Button {
    id: control

    property int horizontalAlignment: Text.AlignHCenter
    property int elide: Text.ElideRight
    property color color: enabled ?
               EaStyle.Colors.themeForeground :
               EaStyle.Colors.themeForegroundDisabled
    property color backgroundColor: "transparent"
    property string headerText: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    padding: 0
    spacing: EaStyle.Sizes.fontPixelSize * 0.5

    anchors.verticalCenter: parent.verticalCenter

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // ToolTip
    EaElements.ToolTip {
        text: control.ToolTip.text
        visible: label.truncated && control.hovered && EaGlobals.Variables.showToolTips && text !== ""
    }

    // Text label
    contentItem: Label {
        id: label

        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: control.horizontalAlignment

        font.family: control.font.family
        font.pixelSize: control.font.pixelSize

        text: control.text

        elide: control.elide

        color: control.color
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    background: Rectangle {
        width: control.width
        height: control.height

        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }
}
