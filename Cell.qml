import QtQuick 2.0

Rectangle {
    id: cell
    color: "transparent"
    width: cellSize*0.75
    height:width
    radius:width/2
    property var curX:0
    property var curY:0
    Text {
        id: txtCell
        font.pixelSize: Screen.width <Screen.height ? Screen.width/15:Screen.height/15
        anchors.centerIn: parent
    }
    function setText(text)
    {
        txtCell.text=text
    }
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        onPressed:
        {
            curX = parent.x
            curY = parent.y
        }
        onReleased:
        {
            for(var i =0;i<gridRepeater.count;i++)
            {
                var gridCell = gridRepeater.itemAt(i)
                var cell = cellRepeater.itemAt(i)
                if(((Math.pow((parent.x-gridCell.x),2)+Math.pow((parent.y-gridCell.y),2))  < (cellSize*cellSize)/4)&& i!==index)
                {
                    var startX = index%8
                    var startY = Math.floor(index/8)
                    var endX = i%8
                    var endY = Math.floor(i/8)
                    if(board.checkMove(startX,startY,endX,endY))
                        board.makeMove(startX,startY,endX,endY)
                    break
                }
            }
            parent.x=curX
            parent.y=curY
        }
    }
}
