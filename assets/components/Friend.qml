import bb.cascades 1.4
import "../js/util.js" as Util;

Container {
    id: root
    
    property string name: "mrm_guitargod"
    property string realname: "Mike"
    property int playcount: 0
    property string country: "Russia"
    property string image: ""
    property string url: ""
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    maxHeight: ui.du(14)
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    
    WebImageView {
        image: root.image
        minWidth: ui.du(14)
        minHeight: ui.du(14)
        maxHeight: ui.du(14)
        maxWidth: ui.du(14)
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
        
        leftPadding: ui.du(1)
        
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        Container {
            Label {
                text: root.name
                textStyle.fontWeight: FontWeight.W500
            }
        }
        
        Container {
            Label {
                text: root.realname
                textStyle.color: ui.palette.secondaryTextOnPlain
            }
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            rightPadding: ui.du(1)
            topPadding: ui.du(0.5)
            
            Label {
                text: Util.abbrNum(root.playcount, 2) + " " + (qsTr("Scrobbles") + Retranslate.onLocaleOrLanguageChanged)
                textStyle.color: ui.palette.secondaryTextOnPlain
                textStyle.base: SystemDefaults.TextStyles.SmallText
                verticalAlignment: VerticalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
            }
            
            Label {
                text: root.country
                textStyle.color: ui.palette.secondaryTextOnPlain
                textStyle.base: SystemDefaults.TextStyles.SmallText
                verticalAlignment: VerticalAlignment.Center
            }
        }
    }
}