import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.XmlListModel 2.15

import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Components 1.0 as EaComponents

Column {
    property alias model: listView.model
    property alias delegate: listView.delegate
    property alias currentIndex: listView.currentIndex

    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    property alias defaultInfoText: defaultInfoLabel.text
    property alias titleText: titleLabel.text

    width: EaStyle.Sizes.sideBarContentWidth

    EaElements.Label {
        id: titleLabel

        enabled: false
    }

    ListView {
        id: listView

        property int modelStatus: model.status
        property int lastOriginY: 0
        property int lastContentY: 0
        property int lastCurrentIndex: 0

        enabled: count > 0

        width: parent.width
        height: count > 0 ?
                    EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 2 )

        clip: true
        headerPositioning: ListView.OverlayHeader
        boundsBehavior: Flickable.StopAtBounds

        // Highlight current row
        highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
        highlight: Rectangle {
            z: 2 // To display highlight rect above delegate
            color: listView.count > 1 ? EaStyle.Colors.tableHighlight : "transparent"
        }

        // Default info, if no rows added
        Rectangle {
            visible: model.count === 0

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

        // Table border
        Rectangle {
            anchors.fill: parent

            color: "transparent"

            border.color: EaStyle.Colors.appBarComboBoxBorder
            Behavior on border.color { EaAnimations.ThemeChange {} }
        }

        // Create table header
        onCountChanged: {
            if (header !== null)
                return
            if (count > 0) {
                header = createHeader()
                positionViewAtBeginning()
            }
        }

        // Save/restore current view and index
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

        // Default current index
        Component.onCompleted: currentIndex = 0

        // Logic

        function createHeader() {
            const tableViewDelegate = listView.contentItem.children[0]
            if (typeof tableViewDelegate === "undefined")
                return null

            const firstTableRow = tableViewDelegate.children[0]
            if (typeof firstTableRow === "undefined")
                return null

            let qmlString = ''
            const cells = firstTableRow.children
            for (let cellIndex in cells) {
                const alignmentTypes = { 1: 'Text.AlignLeft', 2: 'Text.AlignRight', 4: 'Text.AlignHCenter', 8: 'Text.AlignJustify' }
                const horizontalAlignment = alignmentTypes[cells[cellIndex].horizontalAlignment]
                const width = cells[cellIndex].width
                const headerText = cells[cellIndex].headerText
                qmlString +=
                        "EaComponents.TableViewLabel { \n" +
                            `textFormat: Text.RichText \n` +
                            `text: '${headerText}' \n` +
                            `width: ${width} \n` +
                            `horizontalAlignment: ${horizontalAlignment} \n` +
                        "} \n"
            }

            qmlString =
                    "import QtQuick 2.15 \n" +
                    "import easyApp.Gui.Components 1.0 as EaComponents \n" +
                    "Component { \n" +
                        "EaComponents.TableViewHeader { \n" +
                            `${qmlString}` +
                         "} \n" +
                    "} \n"

            const headerObj = Qt.createQmlObject(qmlString, listView)

            return headerObj
        }

        /*
        function calcFlexibleColumnWidth() {
            const tableViewDelegate = listView.contentItem.children[0]
            if (typeof tableViewDelegate === "undefined")
                return

            const firstTableRow = tableViewDelegate.children[0]
            if (typeof firstTableRow === "undefined")
                return

            let fixedColumnsWidth = 0
            const cells = firstTableRow.children
            for (let cellIndex in cells)
                fixedColumnsWidth += cells[cellIndex].width

            const spacingWidth = EaStyle.Sizes.tableColumnSpacing * (cells.length - 1)
            const allColumnWidth = listView.width
            const flexibleColumnWidth = allColumnWidth - fixedColumnsWidth - spacingWidth

            return flexibleColumnWidth
        }

        function updateFlexibleColumnWidth(width) {
            const tableRows = listView.contentItem.children
            for (let rowIndex in tableRows) {
                const tableRow = tableRows[rowIndex].children[0]
                if (typeof tableRow === "undefined")
                    return

                const cells = tableRow.children
                for (let cellIndex in cells)
                    if (cells[cellIndex].width === 0)
                        cells[cellIndex].width = width
            }
        }
        */

    }

}
