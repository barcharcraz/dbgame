import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Dialogs 1.2

ApplicationWindow {
  visible: true
  width: 640
  height: 480
  title: qsTr("Hello World")

  menuBar: EditorMenuBar {}


  MessageDialog {
    id: messageDialog
    title: qsTr("May I have your attention, please?")

    function show(caption) {
      messageDialog.text = caption;
      messageDialog.open();
    }
  }
}
