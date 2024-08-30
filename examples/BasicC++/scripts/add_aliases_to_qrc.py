import re

filename = 'src/BasicC++/resources.qrc'
with open(filename, 'r') as f:
    content = f.read()

prefix = '../../../../src/'
search_pattern = rf'<file>{prefix}(.*?)</file>'
replace_pattern = rf'<file alias="\g<1>">{prefix}\g<1></file>'

result = re.sub(search_pattern, replace_pattern, content)

with open(filename, 'w') as f:
    f.write(result)
