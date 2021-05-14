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
