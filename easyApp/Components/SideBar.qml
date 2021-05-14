import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

import easyAppGui.Style 1.0 as EaStyle
//import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

Item {
    id: sideBarContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    anchors.fill: parent

    // Sidebar tabs
    EaElements.TabBar {
        id: tabs

        anchors.top: sideBarContainer.top
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        /*
        // Empty background with border
        background: Item {

            // Sidebar tabs bottom border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: EaStyle.Sizes.borderThickness
                color: EaStyle.Colors.appBorder
                Behavior on color { EaAnimations.ThemeChange {} }
            }
        }
        */
    }

    // Sidebar content
    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }
}
