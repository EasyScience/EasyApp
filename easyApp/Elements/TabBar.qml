import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

T.TabBar {
    id: control

    property bool showBottomBorder: true

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 0

    contentItem: ListView {
        model: control.contentModel
        currentIndex: control.currentIndex

        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem

        highlightMoveDuration: 250
        highlightResizeDuration: 0
        highlightFollowsCurrentItem: true
        highlightRangeMode: ListView.ApplyRange
        //preferredHighlightBegin: 48
        //preferredHighlightEnd: width - 48

        highlight: Item {
            z: 2
            Rectangle {
                height: 2
                width: parent.width
                y: control.position === T.TabBar.Footer ? 0 : parent.height - height - EaStyle.Sizes.borderThickness
                color: EaStyle.Colors.themeAccent
            }
        }
    }

    background: Rectangle {
        z: 2
        //color: control.Material.backgroundColor
        color: "transparent"

        // tabs bottom border
        Rectangle {
            visible: showBottomBorder
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: EaStyle.Sizes.borderThickness
            color: EaStyle.Colors.appBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }
}
