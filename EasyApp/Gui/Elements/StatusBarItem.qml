import QtQuick 2.15
import QtQuick.Controls 2.15

import EasyApp.Gui.Style 1.0 as EaStyle
import EasyApp.Gui.Animations 1.0 as EaAnimations
import EasyApp.Gui.Elements 1.0 as EaElements

Row {
    property string key: ''
    property string value: ''

    visible: value !== ''

    spacing: EaStyle.Sizes.fontPixelSize * 0.5
    height: parent.height

    EaElements.Label {
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        color: EaStyle.Colors.isDarkTheme ? "#777": "#888"
        text: key
    }

    EaElements.Label {
        id: valueLabel

        height: parent.height
        verticalAlignment: Text.AlignVCenter
        color: EaStyle.Colors.isDarkTheme ? "#aaa": "#555"
        text: value

        onTextChanged: {
            valueLabel.color = EaStyle.Colors.themeForegroundHovered
            colorResetAnimo.restart()
        }

        SequentialAnimation {
            id: colorResetAnimo
            alwaysRunToEnd: false

            PauseAnimation {
                alwaysRunToEnd: false
                duration: 1000
            }

            PropertyAnimation {
                alwaysRunToEnd: false
                target: valueLabel
                property: 'color'
                to: EaStyle.Colors.isDarkTheme ? "#aaa": "#555"
                duration: 1000
            }
        }
    }
}
