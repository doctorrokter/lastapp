import bb.cascades 1.4

CustomListItem {
    id: root
    
    property int number: 1
    property string name: "The Tropper"
    property int listeners: 1500
    property int maxListeners: 1500
    
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
                
                Container {
                    margin.topOffset: ui.du(1)
                    Label {
                        text: root.listeners + " " + (qsTr("listeners") + Retranslate.onLocaleOrLanguageChanged)
                        textStyle.color: ui.palette.secondaryTextOnPlain
                        textStyle.base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
                
                Container {
                    margin.topOffset: ui.du(3)
                    minHeight: ui.du(0.75)
                    background:  ui.palette.secondaryTextOnPlain
                    
                    preferredWidth: {
                        if (root.maxListeners === root.listeners) {
                            return trackLUH.layoutFrame.width;
                        } else {
                            var percents = (root.listeners * 100) / root.maxListeners;
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
}