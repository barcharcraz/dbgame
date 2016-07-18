import QtQuick 2.0
import QtQuick.Controls 1.4
import "."
MenuBar {
  Menu {
    title: "&File"
    MenuItem {
      //text: "Open Database"
      action: Actions.openDB
    }
  }
}
