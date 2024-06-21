
from PySide6.QtCore import QObject 
from PySide6.QtCore import Property

_DEFAULT_MEASURED_X = [1, 2, 3, 4, 5]
_DEFAULT_MEASURED_Y = [1.1, 1.2, 1.3, 1.4, 1.5]
_DEFAULT_CALCULATED_X = [1, 2, 3, 4, 5]
_DEFAULT_CALCULATED_Y = [2.1, 2.2, 2.3, 2.4, 2.5]


class Summary(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)
        self._proxy = parent

    @Property('QVariant', constant=True)
    def created(self):
        return True

    @Property('QVariant', constant=True)
    def xMeasuredData(self):
        return _DEFAULT_MEASURED_X

    @Property('QVariant', constant=True)
    def yMeasuredData(self):
        return _DEFAULT_MEASURED_Y
    
    @Property('QVariant', constant=True)
    def xCalculatedData(self):
        return _DEFAULT_CALCULATED_X

    @Property('QVariant', constant=True)
    def yCalculatedData(self):
        return _DEFAULT_CALCULATED_Y

