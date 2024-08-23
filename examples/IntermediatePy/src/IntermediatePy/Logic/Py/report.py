# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject, Signal, Property


_HTML = """<!DOCTYPE html>
<html>
<style>
    th, td { padding-right: 18px; }
    th { text-align: left; }
</style>
<body>
    <table>
    <tr></tr>
    <tr>
        <td><h1>Summary</h1></td>
    </tr>
    <tr></tr>
    <tr>
        <td><h3>Project information</h3></td>
    </tr>
    <tr></tr>
    <tr>
        <th>Name</th>
        <th>La0.5Ba0.5CoO3</th>
    </tr>
    <tr>
        <td>Description</td>
        <td>neutrons, powder, constant wavelength</td>
    </tr>
    <tr>
        <td>No. of phases</td>
        <td>1</td>
    </tr>
    <tr>
        <td>No. of experiments</td>
        <td>1</td>
    </tr>
    <tr></tr>
        <tr>
            <td><h3>Crystal data</h3></td>
        </tr>
        <tr></tr>
    <tr>
        <th>Phase datablock</th>
        <th>lbco</th>
    </tr>
    <tr>
        <td>Crystal system, space group</td>
        <td>cubic,&nbsp;&nbsp;<i>P m -3 m</i></td>
    </tr>
    <tr></tr>
        <tr>
            <td><h3>Data collection</h3></td>
        </tr>
        <tr></tr>
    <tr>
        <th>Experiment datablock</th>
        <th>hrpt</th>
    </tr>
    <tr>
        <td>Radiation probe</td>
        <td>neutron</td>
    </tr>
    <tr>
        <td>Measured range: min, max, inc (&deg;)</td>
        <td>10.0,&nbsp;&nbsp;164.85,&nbsp;&nbsp;0.05</td>
    </tr>
    <tr></tr>
    </table>
</body>
</html>
"""


class Report(QObject):
    created_changed = Signal()
    as_html_changed = Signal()

    def __init__(self, parent):
        super().__init__(parent)
        self._proxy = parent
        self._created = False
        self._as_html = _HTML

    @Property(bool, notify=created_changed)
    def created(self):
        return self._created

    @created.setter
    def created(self, new_value):
        if self._created == new_value:
            return
        self._created = new_value
        self.created_changed.emit()

    @Property(str, notify=as_html_changed)
    def as_html(self):
        return self._as_html

    @as_html.setter
    def as_html(self, new_value):
        if self._as_html == new_value:
            return
        self._as_html = new_value
        self.as_html_changed.emit()
