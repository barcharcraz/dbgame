import QtQuick 2.0
import QtQuick.Controls 1.4
pragma Singleton
QtObject {
  id: actionsRoot
  property var openDB: Action {
    id: openDBAction
    text: "Open Database"
    shortcut: StandardKey.Open
    onTriggered: console.log("Triggered")
  }
}
