import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


ListView {
    id: listView

    property alias defaultInfoText: defaultInfoLabel.text
    property var headerLabelItems: headerItem.children[0].children
    property int contentItemChildrenLength: contentItem.children.length
    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    //property int modelStatus: model.status
    property int lastOriginY: 0
    property int lastContentY: 0
    property int lastCurrentIndex: 0

    enabled: count > 0

    width: EaStyle.Sizes.sideBarContentWidth
    height: count > 0 ?
                EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 2 )

    clip: true
    headerPositioning: ListView.OverlayHeader
    boundsBehavior: Flickable.StopAtBounds

    onHeaderLabelItemsChanged: setWidthOfFlexibleColumnForHeader()
    onContentItemChildrenLengthChanged: widthAndAlignmentChangeTimer.start()

    // Highlight current row
    highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
    highlight: Rectangle {
        z: 2 // To display highlight rect above delegate
        color: listView.count > 1 ? EaStyle.Colors.tableHighlight : "transparent"
    }

    // Default info, if no rows added
    Rectangle {
        visible: listView.count === 0
        width: listView.width
        height: EaStyle.Sizes.tableRowHeight * 2
        color: EaStyle.Colors.themeBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            id: defaultInfoLabel

            anchors.verticalCenter: parent.verticalCenter
            leftPadding: EaStyle.Sizes.fontPixelSize
        }
    }

    // Empty header row
    header: EaComponents.TableViewHeader {}

    delegate: EaComponents.TableViewDelegate {}

    // Table border
    Rectangle {
        anchors.fill: listView
        color: "transparent"
        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    /*
    // Save-restore current view and index
    onModelStatusChanged: {
        // Save current view and index before model changed
        if (modelStatus === JsonListModel.Updating) {
            lastOriginY = originY
            lastContentY = contentY
            lastCurrentIndex = currentIndex
        // Restore current index after model changed
        } else if (modelStatus === JsonListModel.Ready) {
            highlightMoveDuration = 0
            currentIndex = lastCurrentIndex
            highlightMoveDuration = EaStyle.Sizes.tableHighlightMoveDuration
        }
    }

    // Restore current view after xml model changed
    onOriginYChanged: contentY = originY + (lastContentY - lastOriginY)
    */

    // Default current index
    //Component.onCompleted: currentIndex = 0

    Timer {
        id: widthAndAlignmentChangeTimer
        interval: 10
        onTriggered: setAllColumnsWidthAndAlignment()
    }

    // Logic

    function flexibleColumnWidth() {
        let fixedColumnsWidth = 0
        for (let item of headerLabelItems) {
            if (!item.flexibleWidth) {
                fixedColumnsWidth += item.width
            }
        }
        const allColumnWidth = listView.width
        const spacingWidth = EaStyle.Sizes.tableColumnSpacing * (headerLabelItems.length - 1)
        const borderThickness = EaStyle.Sizes.borderThickness * 2
        const flexibleColumnWidth = allColumnWidth -
                                  fixedColumnsWidth -
                                  spacingWidth -
                                  borderThickness
        return flexibleColumnWidth
    }

    function setWidthOfFlexibleColumnForHeader() {
        for (let item of headerLabelItems) {
            if (item.flexibleWidth) {
                item.width = flexibleColumnWidth()
            }
        }
    }

    function setAllColumnsWidthAndAlignment() {
        for (let item of contentItem.children) {
            if (item instanceof TableViewDelegate) {
                for (let columnIndex in item.children[0].children) {
                    item.children[0].children[columnIndex].width = headerLabelItems[columnIndex].width
                    item.children[0].children[columnIndex].horizontalAlignment = headerLabelItems[columnIndex].horizontalAlignment
                }
            }
        }
    }

}
