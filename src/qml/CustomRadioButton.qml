import QtQuick 2.12
import QtQuick.Controls 2.12

import QtQuick.Controls.Material 2.1

//import app 1.0
RadioButton {
    property string buttonText: ""
    property string customColor: customRadioButton.down ? "#21be2b" : "#000000"

    id: customRadioButton
    indicator: Rectangle {
        implicitWidth: 18
        implicitHeight: 18
        x: customRadioButton.leftPadding
        y: parent.height / 2 - height / 2
        radius: 12
        border.color: customColor

        Rectangle {
            width: 12
            height: 12
            anchors.centerIn: customRadioButton.indicator

            radius: 6
            color: customColor
            visible: customRadioButton.checked
        }
    }

    contentItem: Text {
        text: buttonText
        opacity: enabled ? 1.0 : 0.3
        color: customColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: customRadioButton.indicator.width + customRadioButton.spacing
    }
}
