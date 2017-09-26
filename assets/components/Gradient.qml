import bb.cascades 1.4

Container {
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Bottom
    
    maxHeight: ui.du(20)
    opacity: 0.8
    
    ImageView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        imageSource: "asset:///images/gradient.png"
        filterColor: Color.Black
    }
}