import bb.cascades 1.4

CustomListItem {
    id: root
    
    property int number: 1
    property int count: 1500
    property int maxCount: 1500
    property string artist: ""
    property string title: ""
    property string subtitle: ""
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
        
        leftPadding: ui.du(2)
        rightPadding: ui.du(2)
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            Label {
                text: root.number    
                textStyle.color: ui.palette.secondaryTextOnPlain
                verticalAlignment: VerticalAlignment.Center
            }
            
            Container {
                verticalAlignment: VerticalAlignment.Fill
                
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                
                Container {
                    Label {
                        text: root.title
                        multiline: true
                    }
                }
                
                Container {
                    margin.topOffset: ui.du(1)
                    Label {
                        text: root.subtitle
                        textStyle.color: ui.palette.secondaryTextOnPlain
                        textStyle.base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
                
                Container {
                    margin.topOffset: ui.du(3)
                    minHeight: ui.du(0.75)
                    background:  ui.palette.secondaryTextOnPlain
                    
                    preferredWidth: {
                        if (root.maxCount === root.count) {
                            return trackLUH.layoutFrame.width;
                        } else {
                            var percents = (root.count * 100) / root.maxCount;
                            return (trackLUH.layoutFrame.width * percents) / 100;
                        }
                    }
                }
                
                attachedObjects: [
                    LayoutUpdateHandler {
                        id: trackLUH
                    }
                ]
            }
        }
    }
    
    contextActions: [
        ActionSet {
            LoveTrackActionItem {
                artist: root.artist
                track: root.title
            }
        }
    ]
}