import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
Window {
    visible: true
    width: 400
    height: 400
    title: "Start"
    modality: Qt.WindowModal
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
                    GradientStop { position: 0; color: bgColor1 }
                    GradientStop { position: 1.0; color: bgColor2 }
                }
        Label{
            id: lblOpponent
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
            font.bold:true
            text: " \u{1F916} Opponent     \u{27A1} "
            font.pixelSize: 25
        }

        ComboBox {
            id: cbOpponent
            width: 100
            height: 50
            anchors.verticalCenter: lblOpponent.verticalCenter
            anchors.left: cbMode.left
            model: ["Man", "AI"]
            currentIndex: 1
            onCurrentIndexChanged: {
                if(currentIndex===0)
                    setElements(false)
                else
                    setElements(true)
            }
        }

        Label{
            id: lblSide
            anchors.left: lblOpponent.left
            anchors.top: lblOpponent.bottom
            anchors.topMargin: 20
            font.bold:true
            text: " \u{1F3AE} You play      \u{27A1}"
            font.pixelSize: 25
        }

        ComboBox {
            id: cbSide
            width: 100
            height: 50
            anchors.verticalCenter: lblSide.verticalCenter
            anchors.leftMargin: 30
            anchors.left: lblSide.right
            model: ["Black", "White"]
            currentIndex: 0
        }

        Label{
            id: lblMode
            anchors.left: lblSide.left
            anchors.top: lblSide.bottom
            anchors.topMargin: 20
            font.bold:true
            text: " \u{26A1} Mode           \u{27A1}"
            font.pixelSize: 25
        }

        ComboBox {
            id: cbMode
            width: 100
            height: 50
            anchors.verticalCenter: lblMode.verticalCenter
            anchors.leftMargin: 30
            anchors.left: lblMode.right
            model: ["Easy", "Hard"]
            currentIndex: 0
        }


        Button {
            id: btnOK
            text: "OK"
            width: 80
            height: 50
            font.bold: true
            anchors.rightMargin: 10
            anchors.right: btnCancel.left
            anchors.bottom: btnCancel.bottom
            onClicked: {
                if(cbMode.currentIndex===0)
                    board.setEvaluateNum(100)
                else
                    board.setEvaluateNum(1000)
                board.setUp(cbSide.currentIndex,cbOpponent.currentIndex)
                close()
            }
        }

        Button {
            id: btnCancel
            text: "Cancel"
            width: 120
            height: 50
            font.bold: true
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                close()
            }
        }

    }
    function setElements(enabled)
    {
        cbMode.enabled=enabled
        cbSide.enabled=enabled
    }
}
