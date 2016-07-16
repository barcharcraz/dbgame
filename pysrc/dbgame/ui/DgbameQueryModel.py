from PyQt5.QtSql import QSqlQueryModel, QSqlDatabase
import PyQt5.Qt as Qt
from PyQt5.QtCore import pyqtSignal, pyqtSlot, pyqtProperty
from PyQt5.QtQml import qmlRegisterSingletonType, qmlRegisterType

class DBGameQueryModel(QSqlQueryModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._rawQuery = ""
        self._database = None # type: QSqlDatabase
        self._roleNames = {} # type: Dict[int, str]

    def generate_role_names(self):
        self._roleNames = {}
        for i in range(0, self.record().count()):
            self._roleNames[Qt.UserRole + i + 1] = self.record().fieldName(i)


