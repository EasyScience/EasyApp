import QtQuick
import QtQuick.Controls
import QtWebEngine 1.10

import easyApp.Gui.Style 1.0 as EaStyle
import easyApp.Gui.Animations 1.0 as EaAnimations
import easyApp.Gui.Elements 1.0 as EaElements
import easyApp.Gui.Logic 1.0 as EaLogic

import Gui.Globals 1.0 as ExGlobals

Rectangle {
    id: container

    property string cifStr: ""
    onCifStrChanged: {
        if (cifStr !== '""') {
            structureView.runJavaScript(`reloadCif(${cifStr})`)
        }
    }

    //property int size: Math.min(width, height)
    //onWidthChanged: setChartSizes()
    //onHeightChanged: setChartSizes()

    property int appScale: EaStyle.Sizes.defaultScale
    onAppScaleChanged: {
        if (cifStr !== '""') {
            setChartSizes()
        }
    }

    property int theme: EaStyle.Colors.theme
    onThemeChanged: setChartColors()

    color: EaStyle.Colors.chartPlotAreaBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    WebEngineView {
        id: structureView

        property var info: {
            'version': '9.2.0',
            'url': 'https://web.chemdoodle.com',
            'baseSrc': 'https://download.easydiffraction.org/3rdPartyLibs/ChemDoodleWeb'
        }
        property string src: `${structureView.info.baseSrc}/ChemDoodleWeb-${structureView.info.version}.unpacked.modified.js`
        property string headScript: `<script type="text/javascript" src="${structureView.src}"></script>`

        anchors.fill: parent
        anchors.margins: 0

        backgroundColor: parent.color

        url: 'BaseChemDoodle.html'

        opacity: cifStr === '""' ? 0 : 1
        Behavior on opacity {
            EaAnimations.ThemeChange { duration: 500 }
        }

        onLoadingChanged: {
            if (cifStr !== '""' && loadRequest.status === WebEngineView.LoadSucceededStatus) {
                hideChartToolbar()
                setChartSizes()
                setChartColors()
                reloadCif()
            }
        }

        onContextMenuRequested: {
            request.accepted = true
        }

        Component.onCompleted: ExGlobals.Variables.chemDoodleStructureChart = this
    }

    /////////////////////
    // Chart tool buttons
    /////////////////////

    Row {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize

        spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "showBonds"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "bone"
            //ToolTip.text: qsTr("Show/hide bonds") //checked ? qsTr("Hide bonds") : qsTr("Show bonds")
            onClicked: {
                structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.showBondsButton = this
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "showLabels"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "tag"
            //ToolTip.text: qsTr("Show/hide labels") //checked ? qsTr("Hide labels") : qsTr("Show labels")
            onClicked: {
                structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.showLabelsButton = this
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "projectionType"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "cube"
            //ToolTip.text: qsTr("Set perspective/orthographic view") //checked ? qsTr("Set orthographic view") : qsTr("Set perspective view")
            onClicked: {
                structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
                setToolTipText(`${htmlButtonPrefix}Button`, this)
            }
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.projectionTypeButton = this
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "xProjection"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "x"
            //ToolTip.text: qsTr("View along the x axis")
            onClicked: structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.xProjectionButton = this
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "yProjection"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "y"
            //ToolTip.text: qsTr("View along the y axis")
            onClicked: structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.yProjectionButton = this
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "zProjection"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "z"
            //ToolTip.text: qsTr("View along the z axis")
            onClicked: structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.zProjectionButton = this
        }

        EaElements.TabButton {
            property int pageLoading: structureView.loading
            property string htmlButtonPrefix: "defaultView"
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "home"
            //ToolTip.text: qsTr("Reset to default view")
            onClicked: structureView.runJavaScript(`${htmlButtonPrefix}Action()`)
            onPageLoadingChanged: {
                if (pageLoading === WebEngineView.LoadStartedStatus) {
                    setToolTipText(`${htmlButtonPrefix}Button`, this)
                }
            }
            Component.onCompleted: ExGlobals.Variables.defaultViewButton = this
        }
    }

    // Logic

    function hideChartToolbar() {
        structureView.runJavaScript(`showToolbar(false)`)
    }

    function reloadCif() {
        structureView.runJavaScript(`reloadCif(${cifStr})`)
    }

    function setChartSizes() {
        const sizes = {
            '--chartWidth': structureView.width,
            '--chartHeight': structureView.height,
            '--fontPixelSize': EaStyle.Sizes.fontPixelSize,
            '--toolButtonHeight': EaStyle.Sizes.toolButtonHeight
        }
        for (let key in sizes) {
            structureView.runJavaScript(`document.documentElement.style.setProperty('${key}', '${sizes[key]}')`)
        }
        structureView.runJavaScript(`setChartSizesExtra()`)
    }

    function setChartColors() {
        const colors = {
            '--backgroundColor': EaStyle.Colors.chartPlotAreaBackground,
            '--foregroundColor': EaStyle.Colors.chartForeground,
            '--buttonBackgroundColor': EaStyle.Colors.contentBackground,
            '--buttonBackgroundHoveredColor': EaStyle.Colors.themeBackgroundHovered1,
            '--buttonForegroundColor': EaStyle.Colors.themeForeground,
            '--buttonForegroundHoveredColor': EaStyle.Colors.themeForegroundHovered,
            '--buttonBorderColor': EaStyle.Colors.chartAxis,
            '--tooltipBackgroundColor': EaStyle.Colors.dialogBackground,
            '--tooltipForegroundColor': EaStyle.Colors.themeForeground,
            '--tooltipBorderColor': EaStyle.Colors.toolTipBorder
        }
        for (let key in colors) {
            structureView.runJavaScript(`document.documentElement.style.setProperty('${key}', '${colors[key]}')`)
        }
        structureView.runJavaScript(`setChartColorsExtra()`)
    }

    function setToolTipText(htmlButton, qmlButton) {
        structureView.runJavaScript(
                    `${htmlButton}.getAttribute('data-tooltip')`,
                    function(result) {
                        qmlButton.ToolTip.text = result
                    }
                    )
    }

    function getSource(){
        var js = "document.documentElement.outerHTML"
        structureView.runJavaScript(js, function(result){console.log(result)})
    }

}
