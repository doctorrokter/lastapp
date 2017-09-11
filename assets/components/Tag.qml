import bb.cascades 1.4

Container {
    id: root
    
    property string name: "heavy metal"
    property string url: ""
    
    leftPadding: ui.du(0.5)
    topPadding: ui.du(0.5)
    rightPadding: ui.du(0.5)
    bottomPadding: ui.du(0.5)
    
    background: ui.palette.primaryBase
    maxHeight: ui.du(6)
    
    Label {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        text: root.name
        textStyle.color: Color.White
    }
}
