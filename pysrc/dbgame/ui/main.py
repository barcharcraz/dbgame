import os
import sys

from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
from PyQt5.QtSql import QSqlDatabase
import dbgame.ui.DbGameQueryModel
apppath = os.path.dirname(__file__)

app = QApplication(sys.argv)

QSqlDatabase.addDatabase("QSQLITE", "mainDatabase")

engine = QQmlApplicationEngine(os.path.join(apppath, "qml/qml.qml"))
app.exec()
