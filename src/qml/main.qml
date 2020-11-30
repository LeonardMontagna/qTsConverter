import QtQuick 2.12

import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.1
import Qt.labs.settings 1.0

import app 1.0

Window {
    title: "qTsConverter " + version

    minimumHeight: 340
    minimumWidth: 840

    height: minimumHeight
    width: minimumWidth

    visible: ApplicationWindow.Windowed

    readonly property bool isCsvFormat: comboType.currentIndex === ConverterGuiProxy.Ts2Csv
                                        || comboType.currentIndex === ConverterGuiProxy.Csv2Ts

    readonly property bool conversionToTs: comboType.currentIndex === ConverterGuiProxy.Csv2Ts
                                           || comboType.currentIndex === ConverterGuiProxy.Xlsx2Ts

    Settings {
        id: settings

        property string lastSourceInput
        property string lastSourceOutput
        property alias textList: sourceInput.model
        property bool multiXlsx2Ts: false
        property bool multiTs2Xlsx: false
    }

    GridLayout {
        anchors {
            fill: parent
            margins: 15
        }

        columns: 1
        rows: 4
        RowLayout {
            RowLayout {
                Text {
                    id: multi
                    text: qsTr("Select Multi-File mode:")
                }
                ColumnLayout {

                    spacing: -15
                    CustomRadioButton {
                        id: nonMulti
                        buttonText: qsTr("Non-Multilanguage")
                        checked: true
                        onClicked: {
                            settings.multiTs2Xlsx = false
                            settings.multiXlsx2Ts = false
                            comboType.currentIndex = 4
                        }
                    }

                    CustomRadioButton {
                        id: ts2Xlsx
                        buttonText: qsTr("Multilanguage: TS to XLSX")
                        onClicked: {
                            settings.multiTs2Xlsx = true
                            settings.multiXlsx2Ts = false
                            comboType.currentIndex = 2
                        }
                    }
                    CustomRadioButton {
                        id: xlsx2Ts
                        buttonText: qsTr("Multilanguage: XLSX to TS")
                        onClicked: {
                            settings.multiTs2Xlsx = false
                            settings.multiXlsx2Ts = true
                            comboType.currentIndex = 3
                        }
                    }

                    //                Rectangle {
                    //                    width: 20
                    //                    height: 20
                    //                    color: settings.multiXlsx2Ts ? "#FF00FF" : settings.multiTs2Xlsx ? "#0000FF" : "#008000"
                    //                }
                }
            }
        }
        RowLayout {

            Text {
                id: sourceFilename
                text: "Source filename:"
            }

            ListView {
                id: sourceInput
                Layout.fillWidth: true
                //Layout:
                Layout.alignment: parent.verticalCenter
                Layout.minimumHeight: 40
                model: settings.textList
                delegate: Text {
                    color: Material.color(Material.Grey)
                    text: model.modelData
                }

                ScrollBar.vertical: ScrollBar {
                    active: true
                    policy: settings.textList.length > 3 ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                }
            }

            Button {
                text: "Browse"
                highlighted: true

                onClicked: {
                    loadFileDialog.nameFilters = conversionModel.getLoadFT()
                    if (loadFileDialog.folder !== "")
                        settings.lastSourceInput = loadFileDialog.folder
                    loadFileDialog.folder = settings.lastSourceInput

                    loadFileDialog.open()
                }
            }
        }

        RowLayout {

            Text {
                text: "Destination filename:"
            }

            Text {
                id: sourceOutput
                color: Material.color(Material.Grey)
                Layout.fillWidth: true
                onTextChanged: sourceOutput.text = conversionModel.setOutput(
                                   text)
            }

            Button {
                text: "Browse"
                highlighted: true
                onClicked: {

                    if (settings.multiXlsx2Ts === true
                            && conversionModel.getInputFT(
                                settings.textList) === "xlsx") {
                        saveFolderDialog.folder = settings.lastSourceOutput
                        saveFolderDialog.open()
                    } else {
                        saveFileDialog.nameFilters = conversionModel.getSaveFT()
                        saveFileDialog.folder = settings.lastSourceOutput
                        saveFileDialog.open()
                    }
                }
            }
        }

        RowLayout {
            spacing: 20

            ComboBox {
                id: comboType
                model: conversionModel
                onActivated: {
                    conversionModel.setIndex(comboType.currentIndex)
                    loadFileDialog.nameFilters = conversionModel.getLoadFT()
                    saveFileDialog.nameFilters = conversionModel.getSaveFT()
                }
            }

            Row {
                visible: isCsvFormat

                Text {
                    text: "Field separator:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    border.width: 0.5
                    border.color: "black"
                    width: 30
                    height: 30

                    TextInput {
                        id: fieldSeparator
                        text: ";"
                        anchors.centerIn: parent
                    }
                }
            }

            Row {
                visible: isCsvFormat

                Text {
                    text: "String separator:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    border.width: 0.5
                    border.color: "black"
                    color: "transparent"
                    width: 30
                    height: 30

                    TextInput {
                        id: stringSeparator
                        text: "\""
                        anchors.centerIn: parent
                    }
                }
            }

            Row {
                visible: conversionToTs

                Text {
                    text: "TS version:"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    border.width: 0.5
                    border.color: "black"
                    color: "transparent"
                    width: 30
                    height: 30

                    TextInput {
                        id: tsVersion
                        text: "2.1"
                        anchors.centerIn: parent
                    }
                }
            }
        }

        Button {
            Layout.fillWidth: true
            text: "Convert"
            highlighted: true
            Material.background: Material.Orange
            enabled: //comboType.currentIndex !== ConverterGuiProxy.Dummy
                     //&& sourceInput.text.length !== 0


                     /*sourceInput.text.length !== 0
                     &&*/ sourceOutput.text.length !== 0
                          && fieldSeparator.text.length !== 0
                          && stringSeparator.text.length !== 0
            onClicked: {
                converter.convert(comboType.currentIndex, settings.textList,
                                  sourceOutput.text, fieldSeparator.text,
                                  stringSeparator.text, tsVersion.text)
                finishDialog.visible = true
            }
        }
    }

    LoadFileDialog {
        id: loadFileDialog
        objectName: "loadFileDialog"
        //        onAccepted: sourceInput.text = loadFileDialog.file
        onAccepted: {
            //sourceInput.model = loadFileDialog.files
            //            settings.textList = loadFileDialog.files
            settings.textList = conversionModel.toStringList(
                        loadFileDialog.files)
        }
    }

    SaveFolderDialog {
        id: saveFolderDialog
        objectName: "saveFolderDialog"
        onAccepted: sourceOutput.text = saveFolderDialog.folder
    }

    SaveFileDialog {
        id: saveFileDialog
        objectName: "saveFileDialog"

        onAccepted: sourceOutput.text = saveFileDialog.file
    }

    FinishDialog {
        id: finishDialog
        objectName: "finishDialog"

        onAccepted: visible = false
    }

    Connections {
        function onSetComboBoxIndex(index) {
            comboType.currentIndex = index
            conversionModel.setIndex(comboType.currentIndex)
        }
        target: conversionModel
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    Component.onCompleted: comboType.currentIndex = ConverterGuiProxy.Dummy
}
