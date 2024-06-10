import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Elements as EaElements


Column {
    property int numLabels: 50

    spacing: EaStyle.Sizes.fontPixelSize

    Repeater {
        model: numLabels
        EaElements.Label {
            text: `Label ${index+1} of ${numLabels}`
        }
    }

}

