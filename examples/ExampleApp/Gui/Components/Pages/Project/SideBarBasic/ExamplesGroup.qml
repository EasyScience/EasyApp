import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Logic as EaLogic

import Globals as Globals


EaComponents.TableView {
    id: tableView

    maxRowCountShow: 9
    defaultInfoText: qsTr("No Examples Available")

    // Table model

    /*
    model: EaComponents.JsonListModel {
        json: JSON.stringify(Globals.BackendProxy.main.project.examples)
        query: "$[*]"
    }
    */

    // We only use the length of the model object defined in backend logic and
    // directly access that model in every row using the TableView index property.

    model: Globals.BackendProxy.main.project.examples.length


    // Header row

    header: EaComponents.TableViewHeader {

        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.fontPixelSize * 2.5
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("No.")
        }

        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.fontPixelSize * 10
            horizontalAlignment: Text.AlignLeft
            text: qsTr("Name")
        }

        EaComponents.TableViewLabel {
            flexibleWidth: true
            horizontalAlignment: Text.AlignLeft
            text: qsTr("Description")
        }

        EaComponents.TableViewLabel {
            width: EaStyle.Sizes.fontPixelSize * 3.0
        }

    }

    // Content rows

    delegate: EaComponents.TableViewDelegate {

        EaComponents.TableViewLabel {
            text: index + 1
        }

        EaComponents.TableViewLabel {
            text: Globals.BackendProxy.main.project.examples[index].name
        }

        EaComponents.TableViewLabelControl {
            width: headerItem.width
            text: Globals.BackendProxy.main.project.examples[index].description
            ToolTip.text: Globals.BackendProxy.main.project.examples[index].description
        }

        EaComponents.TableViewButton {
            enabled: false
            fontIcon: "upload"
            ToolTip.text: qsTr("Load this example")
        }

    }

}
