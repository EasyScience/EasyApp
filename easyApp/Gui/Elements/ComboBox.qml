import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.impl 2.14
import QtQuick.Templates 2.14 as T

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Globals 1.0 as EaGlobals
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements

T.ComboBox {
    id: control

    property color borderColor: _borderColor()
    property color foregroundColor: _foregroundColor()
    property color backgroundColor: _backgroundColor()
    property color popupBackgroundColor: _popupBackgroundColor()

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    topInset: EaStyle.Sizes.fontPixelSize * 0.5
    bottomInset: EaStyle.Sizes.fontPixelSize * 0.5

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    flat: true
    hoverEnabled: true
    editable: false

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: parent//control
        hoverEnabled: true
        onPressed: mouse.accepted = false
    }

    delegate: EaElements.MenuItem {
        width: parent !== null ? parent.width : 0
        height: EaStyle.Sizes.comboBoxHeight

        font.family: control.font.family

        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        ///Material.foreground: control.currentIndex === index ? parent.Material.accent : parent.Material.foreground

        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: Label {
        x: control.mirrored ? control.padding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        text: "\uf0d7"

        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: EaStyle.Sizes.fontPixelSize

        ///color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        color: foregroundColor
        Behavior on color { EaAnimations.ThemeChange {} }
    }

    contentItem: Label {
        padding: EaStyle.Sizes.fontPixelSize * 0.5
        leftPadding: control.editable ? 2 : control.mirrored ? 0 : 12
        rightPadding: control.editable ? 2 : control.mirrored ? 12 : 0

        /////height: 20

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        ///autoScroll: control.editable
        ///readOnly: control.down
        ///inputMethodHints: control.inputMethodHints
        ///validator: control.validator

        font: control.font
        verticalAlignment: Text.AlignVCenter

        textFormat: Text.RichText

        ///selectionColor: control.Material.accentColor
        ///selectedTextColor: control.Material.primaryHighlightedTextColor

        ///color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        color: foregroundColor
        Behavior on color { EaAnimations.ThemeChange {} }

        ///cursorDelegate: CursorDelegate { }
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: EaStyle.Sizes.comboBoxHeight

        radius: control.flat ? 0 : 2

        ///color: !control.editable ? control.Material.dialogColor : "transparent"
        color: backgroundColor
        Behavior on color { EaAnimations.ThemeChange {} }

        border.color: borderColor
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    popup: T.Popup {
        y: control.editable ? control.height - 5 : 0
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: EaStyle.Sizes.fontPixelSize
        bottomMargin: EaStyle.Sizes.fontPixelSize

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ListView {
            id: listView

            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: 2

            color: popupBackgroundColor
            Behavior on color {
                PropertyAnimation {
                    duration: EaStyle.Times.themeChange
                    alwaysRunToEnd: true
                    easing.type: Easing.OutQuint
                }
            }

            layer.enabled: control.enabled
            layer.effect: EaElements.ElevationEffect {
                elevation: 8
            }
        }
    }

    // Logic

    function _popupBackgroundColor() {
        return EaStyle.Colors.dialogBackground
    }

    function _backgroundColor() {
        if (!control.hovered)
            return EaStyle.Colors.appBarComboBoxBackground
        if (control.pressed)
            return EaStyle.Colors.appBarComboBoxBackgroundPressed
        return EaStyle.Colors.appBarComboBoxBackgroundHovered
    }

    function _foregroundColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeForegroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.themeForeground
    }

    function _borderColor() {
        if (!control.enabled)
            return EaStyle.Colors.themeBackgroundDisabled
        if (rippleArea.containsMouse)
            return EaStyle.Colors.themeForegroundHovered
        return EaStyle.Colors.appBarComboBoxBorder
    }
}

// https://forum.qt.io/topic/103394/using-subscripts-in-text-inside-combobox/5
