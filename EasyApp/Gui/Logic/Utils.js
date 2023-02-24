function prettyXml(xml, tab = '    ')
{
    let formatted = ''
    let indent = ''

    xml.split(/>\s*</).forEach(function(node)
    {
        if (node.match( /^\/\w/ ))
            indent = indent.substring(tab.length)

        formatted += indent + '<' + node + '>\r\n'

        if (node.match( /^<?\w[^>]*[^\/]$/ ))
            indent += tab
    })

    return formatted.substring(1, formatted.length-3);
}

function prettyJson(json, tab = '    ')
{
    return JSON.stringify(json, null, tab.length)
}

function toFixed(value, num_digits = 4)
{
    if (typeof value === 'undefined')
    {
        return ""
    }
    else if (typeof value == 'number')
    {
        return value.toFixed(num_digits)
    }
    else
    {
        return value
    }
}

function osPathSep() {
    if (Qt.platform.os === "windows") {
		return '\\'
	}
	return '/'
}	

// converts a URL to a local file path
function urlToLocalFile(url)
{	
    if (Qt.platform.os === "windows")
    {
        return url.replace('file:///', '').split('/').join('\\')
    }
    else if (Qt.platform.os === "osx" || Qt.platform.os === "linux" || Qt.platform.os === "unix")
    {
        return url.replace('file://', '')
    }
    else
    {
        return url
    }
}

function isQmlScene()
{
    const runnerPath = Qt.application.arguments[0]
    if (runnerPath.includes('qmlscene'))
    {
        return true
    }
    return false
}

// XMLHttpRequest: Using PUT on a local file is disabled by default.
// Set QML_XHR_ALLOW_FILE_WRITE to 1 to enable this feature.
// E.g., 'QML_XHR_ALLOW_FILE_WRITE=1 qml main.qml'
function writeFile(url, content) {
    const method = "PUT"
    const async = false
    const request = new XMLHttpRequest()
    request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                print(`Succeeded to write file: '${url}'`)
            } else {
                print(`Failed to write file: '${url}'. Status: ${request.status}`)
            }
        }
    }
    request.open(method, url, async)
    request.send(content)
}

// XMLHttpRequest: Using GET on a local file is disabled by default.
// Set QML_XHR_ALLOW_FILE_READ to 1 to enable this feature.
// E.g., 'QML_XHR_ALLOW_FILE_READ=1 qml main.qml'
function readFile(url) {
    const method = "GET"
    const async = false
    const request = new XMLHttpRequest()
    request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                print(`Succeeded to read file: '${url}'`)
            } else {
                print(`Failed to read file: '${url}'. Status: ${request.status}`)
            }
        }
    }
    request.open(method, url, async)
    request.send()
    return request.responseText
}
