import bb.cascades 1.4

Container {
    horizontalAlignment: HorizontalAlignment.Fill
    opacity: 0.8
    maxHeight: ui.du(25)
    margin.topOffset: ui.du(15)
    ImageView {
        filterColor: Color.Black
        horizontalAlignment: HorizontalAlignment.Fill
        imageSource: "asset:///images/gradient.png"
    }
}