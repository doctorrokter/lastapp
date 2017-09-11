import bb.cascades 1.4

Container {
    id: root
    
    property string mbid: ""
    property string name: "test"
    property string artist: "test"
    property string date: "test"
    property string image: ""
    property string url: ""
    property bool nowplaying: true
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    maxHeight: ui.du(12)
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    
    WebImageView {
        image: root.image
        minWidth: ui.du(12)
        minHeight: ui.du(12)
        maxHeight: ui.du(12)
        maxWidth: ui.du(12)
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
        
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        Label {
            text: root.name
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            rightPadding: ui.du(1)
            
            Label {
                text: root.artist
                textStyle.color: ui.palette.secondaryTextOnPlain
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
            }
            
            Label {
                text: root.nowplaying ? qsTr("Now playing") + Retranslate.onLocaleOrLanguageChanged : root.date
                textStyle.color: ui.palette.secondaryTextOnPlain
                textStyle.base: SystemDefaults.TextStyles.SmallText
                verticalAlignment: VerticalAlignment.Center
            }
        }
    }
}