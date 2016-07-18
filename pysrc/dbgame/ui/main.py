from PyQt5.QtCore import QCoreApplication, QUrl
from PyQt5.QtQml import QQmlApplicationEngine
import sys
import os

apppath = os.path.dirname(__file__)

app = QCoreApplication(sys.argv)
engine = QQmlApplicationEngine(QUrl("qrc:/qml/main.qml"))
app.exec()
