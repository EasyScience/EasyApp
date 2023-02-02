import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import easyApp.Gui.Style 1.0 as EaStyle
//import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

Item {
    id: sideBarContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    property alias continueButton: continueButton

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
        anchors.bottom: continueButton.visible ? continueButton.top : sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }

    EaElements.SideBarButton {
        id: continueButton

        anchors.bottom: sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        anchors.margins: EaStyle.Sizes.fontPixelSize

        fontIcon: "arrow-circle-right"
        text: qsTr("Continue")
    }
}
