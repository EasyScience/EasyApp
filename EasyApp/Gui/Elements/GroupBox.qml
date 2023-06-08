import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic  // Fixes EasyApp/Gui/Elements/GroupBox.qml:51:22: QML Row: The current style does not support customization of this control (property: "contentItem" item: QQuickRow(0x60000381e200, parent=0x0, geometry=0,0 0x0)). Please customize a non-native style (such as Basic, Fusion, Material, etc). For more information, see: https://doc.qt.io/qt-6/qtquickcontrols2-customize.html#customization-reference
import QtQuick.Templates as T

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Animations as EaAnimations


T.GroupBox {
    id: control

    property bool collapsible: true
    property bool collapsed: collapsible ? true : false
    property bool last: false

    implicitWidth: parent.width
    implicitHeight: collapsed ?
                        titleArea.height :
                        titleArea.height + spacing + contentHeight + bottomPadding

    spacing: EaStyle.Sizes.fontPixelSize * 0.5 // between title and content
    padding: 0
    topPadding: titleArea.height + spacing
    bottomPadding: EaStyle.Sizes.fontPixelSize
    leftPadding: EaStyle.Sizes.fontPixelSize
    rightPadding: EaStyle.Sizes.fontPixelSize

    clip: true

    font.pixelSize: EaStyle.Sizes.fontPixelSize

    // Group box title area

    label: Button {
        id: titleArea

        enabled: control.collapsible

        height: EaStyle.Sizes.tabBarHeight
        width: control.width
        anchors.left: control.left
        anchors.leftMargin: EaStyle.Sizes.fontPixelSize * 0.5
        topInset: 0
        bottomInset: 0

        checkable: false
        flat: true

        // Group box title layout
        contentItem: Row {
            id: titleLayout

            anchors.verticalCenter: parent.verticalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // Group box title icon
            Label {
                id: titleIcon

                anchors.verticalCenter: parent.verticalCenter

                text: control.collapsible ? "play" : "circle"

                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: control.font.pixelSize * 0.7

                color: control.foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }

                transform: Rotation {
                    id: titleIconRotation

                    origin.x: titleIcon.width * 0.5
                    origin.y: titleIcon.height * 0.5

                    Component.onCompleted: control.collapsed ? angle = 0 : angle = 90
                }
            }

            // Group box title text
            Label {
                id: titleTextlabel

                anchors.verticalCenter: parent.verticalCenter

                text: control.title

                font.family: EaStyle.Fonts.fontFamily
                font.pixelSize: control.font.pixelSize

                color: control.foregroundColor()
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }

        //Mouse area to react on click events
        MouseArea {
            id: rippleArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: titleArea.clicked()
        }

        // Folding-unfolding animation on title area clicked
        onClicked: collapsionAnimo.restart()
    }

    // Group box content area
    background: Rectangle {
        id: contentArea

        y: titleArea.height
        width: control.width
        height: control.height - control.topPadding + control.bottomPadding

        color: 'transparent'


        // Horisontal border at the bottom
        Rectangle {
            visible: !last

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6 + height // 6?

            width: control.width
            height: EaStyle.Sizes.borderThickness

            color: EaStyle.Colors.appBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }

    // Collapsion animation

    ParallelAnimation {
        id: collapsionAnimo

        NumberAnimation {
            target: control
            property: "implicitHeight"
            to: control.collapsed ? control.contentHeight + titleArea.height : titleArea.height
            duration: 150
        }

        NumberAnimation {
            target: titleIconRotation
            property: "angle"
            to: control.collapsed ? 90 : 0
            duration: 150
        }

        onFinished: control.collapsed = !control.collapsed
    }

    // Logic

    function foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

}
