from PyQt5.QtSql import QSqlQueryModel, QSqlDatabase
from PyQt5.QtCore import pyqtSignal, pyqtSlot, pyqtProperty
from PyQt5.QtCore import QModelIndex, Qt
from PyQt5.QtQml import qmlRegisterSingletonType, qmlRegisterType

class DBGameQueryModel(QSqlQueryModel):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._rawQuery = None # type: str
        self._database = None # type: QSqlDatabase
        self._roleNames = {} # type: Dict[int, str]

    def generate_role_names(self):
        self._roleNames = {}
        for i in range(0, self.record().count()):
            self._roleNames[Qt.UserRole + i + 1] = self.record().fieldName(i)

    def setQuery(self, *__args):
        super().setQuery(*__args)
        self.generate_role_names()

    def data(self, modelIdx: QModelIndex, role=None):
        if role < Qt.UserRole:
            return super().data(modelIdx, role)
        else:
            colidx = role - Qt.UserRole - 1
            idx = self.index(modelIdx.row(), colidx)
            return super().data(idx, Qt.DisplayRole)

    @pyqtProperty('QString')
    def database(self, name: str):
        self._database = QSqlDatabase.database(name)
        if self._rawQuery is not None:
            self.setQuery(self._rawQuery, self._database)

    @pyqtProperty('QString')
    def command(self):
        return self._rawQuery

    @command.setter
    def command(self, cmd: str):
        self._rawQuery = cmd
        if self._database is not None:
            self.setQuery(self._rawQuery, self._database)


qmlRegisterType(DBGameQueryModel, "dbgame.models", 1, 0, "QueryModel")