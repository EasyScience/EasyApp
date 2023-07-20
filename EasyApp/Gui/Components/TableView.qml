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
    property bool showHeader: true
    property bool tallRows: false
    property var headerLabelItems: headerItem.children[0].children
    property int contentItemChildrenLength: contentItem.children.length
    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    property int tableRowHeight: tallRows ?
                                     1.5 * EaStyle.Sizes.tableRowHeight :
                                     EaStyle.Sizes.tableRowHeight

    enabled: count > 0

    width: EaStyle.Sizes.sideBarContentWidth
    height: count === 0 ?
                2 * EaStyle.Sizes.tableRowHeight :
                showHeader ?
                    tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    tableRowHeight * (Math.min(count, maxRowCountShow))

    clip: true
    headerPositioning: ListView.OverlayHeader
    boundsBehavior: Flickable.StopAtBounds

    onHeaderLabelItemsChanged: setWidthOfFlexibleColumnForHeader()
    onContentItemChildrenLengthChanged: widthAndAlignmentChangeTimer.start()

    // Highlight current row
    highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
    highlight: Rectangle {
        z: 2 // To display highlight rect above delegate
        color: mouseHoverHandler.hovered ?
                   EaStyle.Colors.tableHighlight :
                   "transparent"
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    // Empty header row
    //header: EaComponents.TableViewHeader {}

    // Empty content rows
    //delegate: EaComponents.TableViewDelegate {}

    // Table border
    Rectangle {
        anchors.fill: listView
        color: "transparent"
        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
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

    // Width and alignment change timer
    Timer {
        id: widthAndAlignmentChangeTimer
        interval: 10
        onTriggered: setAllColumnsWidthAndAlignment()
    }

    // HoverHandler to react on hover events
    // Hide current row highlight if table is not hovered
    HoverHandler {
        id: mouseHoverHandler
        acceptedDevices: PointerDevice.AllDevices
        blocking: false
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (hovered) {
                //console.error(`${listView} [TableView.qml] hovered`)
            }
        }
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
