import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

Item {
    id: page

    property string defaultInfo: ""
    property alias mainContent: mainContentContainer.data
    property alias sideBar: sideBarContainer.data

    // Main content
    Item {
        id: mainContentContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: sideBarContainer.left

        clip: true
    }

    // Defaul info box
    Rectangle {
        visible: defaultInfo !== ""
        anchors.top: mainContentContainer.top
        anchors.bottom: mainContentContainer.bottom
        anchors.left: mainContentContainer.left
        anchors.right: mainContentContainer.right

        color: EaStyle.Colors.contentBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            enabled: false
            anchors.centerIn: parent
            font.family: EaStyle.Fonts.secondFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
            font.weight: Font.ExtraLight
            text: defaultInfo
        }
    }

    // Sidebar container
    Item {
        id: sideBarContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.right: page.right
        //width: childrenRect.width === border.width ? 0 : EaStyle.Sizes.sideBarWidth
        width: EaStyle.Sizes.sideBarWidth

        clip: true

        // Vertical border on the left side
        Rectangle {
            id: border

            z: 2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: EaStyle.Sizes.borderThickness

            color: EaStyle.Colors.appBorder
            Behavior on color { EaAnimations.ThemeChange {} }
        }
    }
}
