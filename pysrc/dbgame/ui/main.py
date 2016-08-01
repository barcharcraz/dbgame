from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from . import DgbameQueryModel
import sys
import os

apppath = os.path.dirname(__file__)

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine(app)
engine.load("dbgame/ui/qml/qml.qml")
sys.exit(app.exec_())
