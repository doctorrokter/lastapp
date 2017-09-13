import bb.cascades 1.4

Container {
    id: root
    
    property string mbid: ""
    property string name: "Wasted Years"
    property variant artist: {
        name: "Iron Maiden",
        mbid: "",
        url: ""
    }
    property int playcount: 0
    property string image: ""
    property string url: ""
    
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
        leftPadding: ui.du(1)
        
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
                text: root.artist.name
                textStyle.color: ui.palette.secondaryTextOnPlain
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
            }
            
            Label {
                visible: root.playcount !== 0
                text: root.playcount + " " + (qsTr("Scrobbles") + Retranslate.onLocaleOrLanguageChanged)
                textStyle.color: ui.palette.secondaryTextOnPlain
                textStyle.base: SystemDefaults.TextStyles.SmallText
                verticalAlignment: VerticalAlignment.Center
            }
        }
    }
}
