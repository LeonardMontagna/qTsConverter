import QtQuick 2.12
import QtQuick.Controls 2.12

import QtQuick.Controls.Material 2.1

//import app 1.0
RadioButton {
    property string buttonText: ""
    property string customColor: /*customRadioButton.down ? "#21be2b" :*/ "#000000"

    id: customRadioButton
    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        x: customRadioButton.leftPadding
        y: parent.height / 2 - height / 2
        radius: 8
        border.color: customColor

        Rectangle {
            width: 10
            height: 10
            anchors.centerIn: customRadioButton.indicator

            radius: 5
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
