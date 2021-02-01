import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: root
    width: 1000
    height: 700
    visible: true
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    title: qsTr("Hello World")
    property real sz: 50
    property real kw: Math.cos(Math.PI / 6) * sz
    property real kh: Math.sin(Math.PI / 6) * sz
    property var b: {
        var _t = []
        for(var x = 0; x * kw < width; x++) {
            var _r = []
            for(var y = 0; y * kh < height; y++) _r.push(0)
            _t.push(_r)
        }
        return _t
    }
    property int x: Math.floor(mouseArea.mouseX / kw)
    property int y: Math.floor(mouseArea.mouseY / kh + 0.5)
    property var palette: ['#fff', '#bbb', '#777', '#333']
    property int currentColor: 0

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext('2d')
            ctx.reset()
            var n = 0
            for(var y = 0; y * root.kh < height; y++) {
                for(var x = 0; x * root.kw < width; x++) {
                    ctx.fillStyle = root.palette[root.b[x][y]]
                    ctx.strokeStyle = Qt.rgba(0.5, 0.5, 0.5, 0.1)
                    ctx.beginPath()
                    if((x + y) % 2 > 0) {
                        ctx.moveTo(x * root.kw, (y - 1) * root.kh)
                        ctx.lineTo(x * root.kw, (y + 1) * root.kh)
                        ctx.lineTo((x + 1) * root.kw, y * root.kh)
                    } else {
                        ctx.moveTo(x * root.kw, y * root.kh)
                        ctx.lineTo((x + 1) * root.kw, (y + 1) * root.kh)
                        ctx.lineTo((x + 1) * root.kw, (y - 1) * root.kh)
                    }
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                }
            }
        }

        Rectangle {
            width: 40
            height: width
            border.color: "black"
            border.width: 2
            anchors.margins: 20
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: root.palette[root.currentColor]

            Text {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: parent.anchors.margins
                text: "" + root.x + ", " + root.y
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            focus: true
            hoverEnabled: true
            onClicked: {
                console.log("clicked", root.x, root.y)
                root.b[root.x][root.y] = root.currentColor
                canvas.requestPaint()
            }
            Keys.onTabPressed: root.currentColor = (root.currentColor + 1) % root.palette.length
            Keys.onDigit1Pressed: root.currentColor = 0
            Keys.onDigit2Pressed: root.currentColor = 1
            Keys.onDigit3Pressed: root.currentColor = 2
            Keys.onDigit4Pressed: root.currentColor = 3
        }
    }
}
