import bb.cascades 1.4

Container {
    id: root
    
    property string description: "sdfsdfsdfsdfssdfsdf sdfsdfsdfs sdfsdfsdfsdf sdfs dfsdfsdf sdfsdf sdfsdff"
    
    leftPadding: ui.du(1.5)
    rightPadding: ui.du(1.5)
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        ImageView {
            imageSource: "asset:///images/grey_pellet.png"
            verticalAlignment: VerticalAlignment.Center
        }
        
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            Label {
                verticalAlignment: VerticalAlignment.Center
                multiline: true
                text: root.description
                textStyle.base: SystemDefaults.TextStyles.BodyText
            }
            
            Divider {}
        }
    }
}
