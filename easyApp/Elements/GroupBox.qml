import QtQuick 2.13
//import QtGraphicalEffects 1.13
import QtQuick.Templates 2.13 as T
//import QtQuick.Controls 2.13
//import QtQuick.Controls.impl 2.13

import easyApp.Style 1.0 as EaStyle
import easyApp.Animations 1.0 as EaAnimations

T.GroupBox {
    id: control

    default property alias contentItemData: contentItem.data
    property bool collapsible: true
    property bool collapsed: collapsible ? true : false
    property bool last: false

    implicitWidth: parent.width
                       //Math.max(parent.width,
                       //titleArea.implicitWidth + leftPadding + rightPadding,
                       //contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: titleArea.implicitHeight + contentItem.height + spacing
                    + topPadding + bottomPadding

    spacing: 0 // between title and content
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    title: "Untitled group"
    //width: parent.width

    // Title area
    label: Button {
        id: titleArea

        enabled: collapsible

        implicitHeight: EaStyle.Sizes.tabBarHeight
        width: label.width

        topInset: 0
        bottomInset: 0

        checkable: false
        flat: true

        // Custom icon
        Label {
            id: icon

            width: font.pixelSize - 1

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: titleArea.left
            anchors.leftMargin: EaStyle.Sizes.fontPixelSize * 0.75

            font.family: EaStyle.Fonts.iconsFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 0.7

            text: collapsible ? "play" : "circle"

            color: foregroundColor()
            Behavior on color { EaAnimations.ThemeChange {} }

            transform: Rotation {
                id: iconRotation

                origin.x: icon.width * 0.5
                origin.y: icon.height * 0.5

                Component.onCompleted: collapsed ? angle = 0 : angle = 90
            }
        }

        // Custom text label
        contentItem: null // reimplemented as label to support above icon rotation animation
        Label {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: EaStyle.Sizes.fontPixelSize * 0.75

            font.family: EaStyle.Fonts.fontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize
            //font.bold: true

            text: control.title

            color: foregroundColor()
            Behavior on color { EaAnimations.ThemeChange {} }
        }

        //Mouse area to react on click events
        MouseArea {
            id: rippleArea
            anchors.fill: parent
            hoverEnabled: true
            onPressed: mouse.accepted = false
        }

        // On clicked animation
        onClicked: collapsionAnimo.restart()
    }

    // Content area
    background: Column {
        id: contentItem

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.leftMargin: icon.anchors.leftMargin
        anchors.rightMargin: anchors.leftMargin

        topPadding: EaStyle.Sizes.fontPixelSize * 0.5
        bottomPadding: anchors.leftMargin * 1.5
        leftPadding: icon.width * 0.5
        rightPadding: 0

        spacing: EaStyle.Sizes.sideBarPadding

        //width: control.width
        height: 0

        clip: true

        onImplicitHeightChanged: collapsed ? height = 0 : height = implicitHeight
    }

    // Horisontal border at the bottom
    Rectangle {
        visible: !last

        y: control.height - height
        width: control.width
        height: EaStyle.Sizes.borderThickness

        color: EaStyle.Colors.appBorder
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // Collapsion animation
    ParallelAnimation {
        id: collapsionAnimo

        NumberAnimation {
            target: contentItem
            property: "height"
            to: collapsed ? contentItem.implicitHeight : 0
            duration: 150
        }

        NumberAnimation {
            target: iconRotation
            property: "angle"
            to: collapsed ? 90 : 0
            duration: 150
        }

        onFinished: collapsed = !collapsed
    }

    // Collapse when disabled
    onEnabledChanged: {
        if (!enabled && collapsible) {
            collapsed = false
            collapsionAnimo.restart()
        }
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
