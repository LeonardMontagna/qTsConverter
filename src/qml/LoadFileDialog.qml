import QtQuick 2.12
import Qt.labs.platform 1.1

FileDialog {
    title: qsTr("Select File")
    nameFilters: conversionModel.getLoadFT()
    fileMode: settings.multiLanguage ? FileDialog.OpenFiles : FileDialog.OpenFile
}
