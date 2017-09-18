import bb.cascades 1.4

CustomListItem {
    id: root
    
    property int number: 1
    property string name: ""
    property variant artist: {
        name: ""
    }
    property string mbid: ""
    
    signal trackChosen(string name, string mbid, variant artist);
    
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
                        text: root.name
                    }
                }                
            }
        }
    }
    
    contextActions: [
        ActionSet {
            LoveTrackActionItem {
                artist: root.artist.name
                track: root.name
            }
        }
    ]
    
    gestureHandlers: [
        TapHandler {
            onTapped: {
                root.trackChosen(root.name, root.mbid, root.artist);
            }
        }
    ]
}