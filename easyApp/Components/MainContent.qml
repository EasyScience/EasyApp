import QtQuick 2.13
import QtQuick.Controls 2.13

import easyApp.Elements 1.0 as EaElements

Item {
    id: mainAreaContainer

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    anchors.fill: parent

    EaElements.TabBar {
        id: tabs

        anchors.top: mainAreaContainer.top
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right
    }

    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: mainAreaContainer.bottom
        anchors.left: mainAreaContainer.left
        anchors.right: mainAreaContainer.right

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }

}
