import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

import Gui.Globals as ExGlobals

Rectangle {
    id: statusBar

    //property alias text: label.text
    property alias model: listView.model

    //visible: EaGlobals.Vars.showAppStatusBar

    //Component.onCompleted: y = visible ? 0 : height

    width: parent.width
    height: parent.height

    color: EaStyle.Colors.statusBarBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    // Status bar main content
    ListView {
        id: listView

        width: statusBar.width
        height: statusBar.height
        spacing: EaStyle.Sizes.fontPixelSize
        orientation: ListView.Horizontal

        model: ListModel {
            ListElement {
                label: "Label1"
                value: "Value1"
            }
            ListElement {
                label: "Label2"
                value: "Value2"
            }
        }

        delegate: EaElements.Label {
            topPadding: (statusBar.height - 3 / 2 * font.pixelSize) * 0.5
            leftPadding: font.pixelSize
            color: EaStyle.Colors.statusBarForeground
            text: model.label + ": " + model.value
        }
    }

    // Fitting label
    EaElements.RunningLabel {
        text: "Fitting in progress"
    }

    // Status bar top border
    Rectangle {
        anchors.top: statusBar.top
        anchors.left: statusBar.left
        anchors.right: statusBar.right

        height: 1//EaStyle.Sizes.borderThickness

        color: EaStyle.Colors.appBarBorder
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    /*
    // Show-hide status bar animation
    Behavior on visible {
        InterfaceAnimations.BarShow {
            parentTarget: statusBar
        }
    }
    */
}
