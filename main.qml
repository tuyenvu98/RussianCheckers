import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id:mainwindow
    visible: true
    width: platform =="Android" ?Screen.width:600
    height: platform =="Android" ?Screen.width:800
    title: qsTr("Chess")
    property int cellSize: (width-40)/8
    property string color1: "wheat"
    property string color2: "saddlebrown"
    property string bgColor1: "darkseagreen"
    property string bgColor2: "cadetblue"
    Connections {
        target: board
        onMapChanged: {
            for(var i =0;i<cellRepeater.count;i++)
            {
                var cell= cellRepeater.itemAt(i)
                var cols = i%8
                var rows = Math.floor(i/8)
                switch(board.map[rows][cols])
                {
                    case 0:
                        cell.visible = false
                        break;
                    case 1:
                        cell.visible = true
                        cell.setText( "\u{26AB}")
                        break
                    case 2:
                        cell.visible = true
                        cell.setText( "\u{26AA}")
                        break
                    case 3:
                        cell.visible = true
                        cell.setText( "\u{265B}")
                        break
                    case 4:
                        cell.visible = true
                        cell.setText( "\u{2655}")
                        break
                    default:
                        cell.visible = false;
                        break
                }
                var state = board.state()
                if(state[0] ===12 ||state[1] ===12)
                {
                    var component = Qt.createComponent("Result.qml");
                    if (component.status === Component.Ready) {
                        var window = component.createObject(mainwindow);
                        if(state[0] ===12)
                            window.side="WHITE"
                        else
                            window.side="BLACK"
                        window.show()
                        return
                    }
                }

                txtScore.text = state[0] + " - " + state[1]
                if(state[2]=== 0)
                {
                    whiteIcon.color = "gainsboro"
                    blackIcon.color = "springgreen"
                }
                else
                {
                    blackIcon.color = "gainsboro"
                    whiteIcon.color = "springgreen"
                }
                if(state[3]!== 0)
                    grid.enabled=false
                else
                    grid.enabled=true
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
              GradientStop { position: 0.0; color: bgColor1 }
              GradientStop { position: 1.0; color: bgColor2 }
          }
        Rectangle
        {
            id: whiteIcon
            anchors.top: rectScore.top
            anchors.right: rectScore.left
            anchors.rightMargin: 20
            height:45
            width: height
            radius: 10
            border.color: "black"
            Text
            {
                anchors.centerIn: parent
                font.pixelSize: 40
                text: "\u{2658}"
            }
        }

        Rectangle
        {
            id: rectScore
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30
            height:40
            width: 100
            radius: 10
            border.color: "black"
            Text
            {
                id: txtScore
                anchors.centerIn: parent
                text: " 0 - 0 "
                font.pixelSize: 30
            }
        }
        Rectangle
        {
            id: blackIcon
            anchors.top: rectScore.top
            anchors.left: rectScore.right
            anchors.leftMargin: 20
            height:45
            width: height
            radius: 10
            border.color: "black"
            Text
            {
                anchors.centerIn: parent
                font.pixelSize: 40
                text: "\u{265E}"
            }
        }


        Button {
            id:btnStart
            text: "\u{1F680}"
            width: 80
            height: 60
            font.bold: true
            font.pixelSize: 30
            onClicked: {
                var component = Qt.createComponent("Start.qml");
                if (component.status === Component.Ready) {
                    var window = component.createObject(mainwindow);
                    window.show();
                }
            }
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
        }

        Button {
            id: btnSetting
            text: "\u{2699}"
            width: 60
            height: 60
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.bottom: btnStart.bottom
            font.pixelSize: 30
            onClicked: {
                var component = Qt.createComponent("Setting.qml");
                if (component.status === Component.Ready) {
                    var window = component.createObject(parent);
                    window.show();
                }
            }
        }
        Rectangle{
            width:grid.width+15
            height:grid.height+15
            anchors.centerIn: parent
            border.color: "maroon"
            border.width: 5
            Grid {
                id:grid
                anchors.centerIn: parent
                rows: 8
                columns: 8
                Repeater {
                    id: gridRepeater
                    model: parent.rows * parent.columns
                    Rectangle {
                        id: rec
                        width: cellSize
                        height:cellSize
                        color:{
                            if((index%parent.rows+Math.floor(index/parent.rows))%2===0)
                                return color1
                            else return color2
                        }
                    }
                }

                Repeater {
                    id: cellRepeater
                    model: parent.rows * parent.columns
                    Cell {
                        x: index%parent.rows*cellSize+(cellSize-width)/2
                        y: Math.floor(index/parent.rows)*cellSize+(cellSize-width)/2
                        visible:false
                    }
                }
            }
        }
    }
}
