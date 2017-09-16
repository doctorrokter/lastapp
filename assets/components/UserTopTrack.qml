import bb.cascades 1.4

Container {
    id: root
    
    property string name: ""
    property string artist: ""
    property double size: 16
    property string image: ""
    
    horizontalAlignment: HorizontalAlignment.Fill
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    maxHeight: ui.du(root.size)
    
    WebImageView {
        minWidth: ui.du(root.size)
        minHeight: ui.du(root.size)
        maxWidth: ui.du(root.size)
        maxHeight: ui.du(root.size)
        image: root.image
    }
    
    Container {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Fill
        margin.leftOffset: ui.du(1)
        
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        Container {
            Label {
                text: qsTr("TOP TRACK") + Retranslate.onLocaleOrLanguageChanged
                textStyle.color: ui.palette.secondaryTextOnPlain
                textStyle.base: SystemDefaults.TextStyles.SubtitleText
            }
        }
        
        Container {
            Label {
                text: root.name
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.fontWeight: FontWeight.Bold
                multiline: true
            }
        }
        
        Container {
            Label {
                text: root.artist
                textStyle.base: SystemDefaults.TextStyles.BodyText
            }
        }
    }
}