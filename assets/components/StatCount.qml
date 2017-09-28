import bb.cascades 1.4
import "../js/util.js" as Util;

Container {
    id: root

    property string title: "LISTENING"
    property int count: 0
    property string value: ""
    
    horizontalAlignment: HorizontalAlignment.Fill
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        Label {
            text: root.title
            textStyle.base: SystemDefaults.TextStyles.SubtitleText
            textStyle.color: ui.palette.secondaryTextOnPlain
        }    
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        Label {
            text: root.value !== "" ? root.value : Util.abbrNum(root.count, 2)
            textStyle.fontWeight: FontWeight.Bold
        }    
    }                            
}