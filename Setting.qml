import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
Window {
    visible: true
    width: 400
    height: 400
    title: "Setting"
    modality: Qt.WindowModal
    property var colors: ["aliceblue","antiquewhite","aqua","aquamarine","azure","beige","bisque","black","blanchedalmond","blue","blueviolet","brown","burlywood","cadetblue","chartreuse",
        "chocolate","coral","cornflowerblue","cornsilk","crimson","cyan","darkblue","darkcyan","darkgoldenrod","darkgray","darkgreen","darkgrey","darkkhaki","darkmagenta",
        "darkolivegreen","darkorange","darkorchid","darkred","darksalmon","darkseagreen","darkslateblue","darkslategray","darkslategrey","darkturquoise","darkviolet",
        "deeppink","deepskyblue","dimgray","dimgrey","dodgerblue","firebrick","floralwhite","forestgreen","fuchsia","gainsboro","ghostwhite","gold","goldenrod","gray",
        "grey","green","greenyellow","honeydew","hotpink","indianred","indigo","ivory","khaki","lavender","lavenderblush","lawngreen","lemonchiffon","lightblue","lightcoral"
        ,"lightcyan","lightgoldenrodyellow","lightgray","lightgreen","lightgrey","lightpink","lightsalmon","lightseagreen","lightskyblue","lightslategray","lightslategrey",
        "lightsteelblue","lightyellow","lime","limegreen","linen","magenta","maroon","mediumaquamarine","mediumblue","mediumorchid","mediumpurple","mediumseagreen",
        "mediumslateblue","mediumspringgreen","mediumturquoise","mediumvioletred","midnightblue","mintcream","mistyrose","moccasin","navajowhite","navy","oldlace","olive",
        "olivedrab","orange","orangered","orchid","palegoldenrod","palegreen","paleturquoise","palevioletred","papayawhip","peachpuff","peru","pink","plum","powderblue",
        "purple","red","rosybrown","royalblue","saddlebrown","salmon","sandybrown","seagreen","seashell","sienna","silver","skyblue","slateblue","slategray","slategrey",
        "snow","springgreen","steelblue","tan","teal","thistle","tomato","turquoise","violet","wheat","white","whitesmoke","yellow","yellowgreen"]
    Component.onCompleted: {
        for (var i = 0; i < colors.length; ++i)
        {
            if(colors[i]===color1)
                cbColor1.currentIndex=i
            if(colors[i]===color2)
                cbColor2.currentIndex=i
            if(colors[i]===bgColor1)
                cbBgColor1.currentIndex=i
            if(colors[i]===bgColor2)
                cbBgColor2.currentIndex=i
        }
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
                    GradientStop { position: 0; color: bgColor1 }
                    GradientStop { position: 1.0; color: bgColor2 }
                }
        Label{
            id: lblColor1
            anchors.left: lblBoard.right
            anchors.top: parent.top
            anchors.leftMargin: 80
            anchors.topMargin: 20
            font.bold:true
            text: platform =="Android" ? "\u{1F3A8} 1":"Color 1"
            font.pixelSize: 20
        }
        Label{
            id: lblColor2
            anchors.left: cbColor2.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
            font.bold:true
            text: platform =="Android" ? "\u{1F3A8} 2":"Color 2"
            font.pixelSize: 20
        }
        Label{
            id: lblBoard
            anchors.left: parent.left
            anchors.top: lblColor1.bottom
            anchors.leftMargin: 20
            anchors.topMargin: 20
            font.bold:true
            text: "Board"
            font.pixelSize: 20
        }

        ComboBox {
            id: cbColor1
            width: 120
            height: 40
            anchors.verticalCenter: lblBoard.verticalCenter
            anchors.left: lblColor1.left
            model: colors
            popup.height: 150
        }

        ComboBox {
            id: cbColor2
            width: 120
            height: 40
            anchors.verticalCenter: lblBoard.verticalCenter
            anchors.left: cbColor1.right
            model: colors
            popup.height: 150
        }
        Label{
            id: lblBackground
            anchors.left: lblBoard.left
            anchors.topMargin: 20
            anchors.top:lblBoard.bottom
            font.bold:true
            text: "Background"
            font.pixelSize: 20
        }
        ComboBox {
            id: cbBgColor1
            width: 120
            height: 40
            anchors.verticalCenter: lblBackground.verticalCenter
            anchors.left: lblColor1.left
            model: colors
            popup.height: 150
        }

        ComboBox {
            id: cbBgColor2
            width: 120
            height: 40
            anchors.verticalCenter: lblBackground.verticalCenter
            anchors.left: cbColor2.left
            model: colors
            popup.height: 150
        }

        Button {
            id: btnOK
            text: "\u{2714}"
            width: 80
            height: 50
            font.pixelSize: 40
            font.bold: true
            anchors.rightMargin: 10
            anchors.right: btnCancel.left
            anchors.bottom: btnCancel.bottom
            onClicked: {
                color1=cbColor1.model[cbColor1.currentIndex]
                color2=cbColor2.model[cbColor2.currentIndex]
                bgColor1=cbBgColor1.model[cbBgColor1.currentIndex]
                bgColor2=cbBgColor2.model[cbBgColor2.currentIndex]
                close()
            }
        }

        Button {
            id: btnCancel
            text: "\u{2716}"
            width: 80
            height: 50
            font.pixelSize: 35
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: {
                close()
            }
        }

    }
}
