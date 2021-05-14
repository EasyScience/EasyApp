import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.12
import QtMultimedia 5.14
import QtTest 1.14

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

Item {
    id: rc

    property string audioDir: ""
    property bool audioEnabled: true

    parent: Overlay.overlay
    anchors.fill: parent
    z: 9999

    /*
    focus: true
    onFocusChanged: {
        focus = true
        print("*** rc focus", focus)
    }

    Keys.onPressed: {
        print("--event.key--", event.key)
        if (event.key === Qt.Key_Escape) {
            visible = false
        } else {
            event.accepted = false
        }
    }
    */

    TestUtil { id: util }
    TestResult { id: result }
    TestEvent { id: event }

    EaElements.RemotePointer { id: pointer }

    EaElements.Button {
        visible: rc.visible

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: EaStyle.Sizes.statusBarHeight - 0.5 * height

        height: EaStyle.Sizes.sideBarButtonHeight
        padding: EaStyle.Sizes.fontPixelSize

        background: Rectangle {
            radius: 2
            color: EaStyle.Colors.mainContentBackground

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 15
                samples: 50
                color: EaStyle.Colors.toolTipBorder
            }
        }

        text: qsTr("Stop tutorial")
        onClicked: {
            rc.hidePointer()
            rc.visible = false
        }
    }

    Audio {
        id: audio

        onDurationChanged: {
            play()
            wait(audio.duration)
        }
    }

    Timer {
        id: saveScreenshots

        property int i: 1
        property int fps: EaGlobals.Variables.projectConfig.ci.app.tutorials.video.fps
        property string screenshotsDir: EaGlobals.Variables.projectConfig.ci.project.subdirs.screenshots

        running: EaGlobals.Variables.saveScreenshotsRunning

        interval: 1000 / fps
        repeat: true

        onTriggered: {
            const fname = ("00000" + i++).slice(-6)
            const fpath = screenshotsDir + "/" + fname + ".png"
            saveScreenshot(rc, fpath)
        }
    }

    // Controller Logic

    function say(text) {
        if (!visible)
            return
        if (!audioEnabled)
            return
        if (text === "")
            return
        const fileName = text.replace(/ /g, "_")
        audio.source = `${audioDir}/${fileName}.mp3`
        wait(1000) // Needed for smooth pointer movement
    }

    function saveScreenshot(item, path) {
        if (!visible)
            return
        const image = result.grabImage(item)
        image.save(path)
    }

    function wait(ms) {
        if (!visible)
            return
        result.wait(ms)
    }

    function posToCenter() {
        if (!visible)
            return
        pointer.posX = rc.width / 2 - pointer.minSize / 2
        pointer.posY = rc.height / 2 - pointer.minSize / 2
        mouseMove(rc)
    }

    function showPointer() {
        if (!visible)
            return
        pointer.show()
        wait(pointer.showHideDuration)
    }

    function hidePointer() {
        if (!visible)
            return
        pointer.hide()
        wait(pointer.showHideDuration)
    }

    function pointerMove(item, x, y, delay, buttons) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (delay === undefined)
            delay = -1
        if (buttons === undefined)
            buttons = Qt.NoButton

        const pos = item.mapToItem(null, x, y)
        pointer.move(pos.x, pos.y)
    }

    function mousePress(item, x, y, button, modifiers, delay) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1

        //event.mouseMove(item, x, y, button, modifiers, delay)
        //event.mouseRelease(item, x, y, button, modifiers, delay)
        event.mousePress(item, x, y, button, modifiers, delay)
        pointer.click()
    }

    function mouseRelease(item, x, y, button, modifiers, delay) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1

        event.mouseRelease(item, x, y, button, modifiers, delay)
    }

    function mouseClick(item, x, y) {
        if (!visible)
            return
        pointerMove(item, x, y)
        wait(pointer.moveDuration)
        mouseMove(item)

        wait(500)

        mousePress(item, x, y)
        wait(pointer.pressDuration)
        mouseRelease(item, x, y)
        wait(pointer.clickRelaxation - pointer.pressDuration)

        wait(500)
    }

    function mouseLeftClickSilent(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.LeftButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseRightClickSilent(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.RightButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseMove(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.NoButton
        const delay = -1

        event.mouseMove(item, x, y, delay, button)
    }

    function mouseWheel(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const xDelta = 0
        const yDelta = 120  // 120 units * 1/8 = 15 degrees
        const button = Qt.NoButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseWheel(item, x, y, button, modifiers, xDelta, yDelta, delay) // ?
    }

    function typeText(text) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        for (const c of text) {
            event.keyClickChar(c, modifiers, delay)
            wait(100)
        }
    }

    function deleteCharacters(count) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        const key = Qt.Key_Backspace//Key_Clear//Key_Delete
        while (count > 0) {
            event.keyClick(key, modifiers, delay)
            wait(100)
            count -= 1
        }
    }

    function keyClick(key) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        event.keyClick(key, modifiers, delay)
        wait(500)
    }

}
