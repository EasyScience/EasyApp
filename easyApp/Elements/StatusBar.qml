import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

Rectangle {
    id: statusBar

    //property alias text: label.text
    property alias model: listView.model

    //visible: EaGlobals.Variables.showAppStatusBar

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
        running: !ExGlobals.Constants.proxy.isFitFinished
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
