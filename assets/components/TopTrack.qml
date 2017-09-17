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
    property int maxCount: 0
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
        
        Container {
            visible: root.maxCount !== 0
            margin.topOffset: ui.du(1)
            margin.rightOffset: ui.du(1)
            minHeight: ui.du(0.75)
            background:  ui.palette.secondaryTextOnPlain
            
            preferredWidth: {
                if (root.maxCount === root.playcount) {
                    return trackLUH.layoutFrame.width;
                } else {
                    var percents = (root.playcount * 100) / root.maxCount;
                    return (trackLUH.layoutFrame.width * percents) / 100;
                }
            }
        }
    }
    
    attachedObjects: [
        LayoutUpdateHandler {
            id: trackLUH
        }
    ]
    
    contextActions: [
        ActionSet {
            LoveTrackActionItem {
                artist: root.artist.name
                track: root.name
            }
        }
    ]
}
