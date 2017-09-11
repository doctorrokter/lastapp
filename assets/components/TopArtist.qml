import bb.cascades 1.4

Container {
    id: root
    
    property string mbid: ""
    property string name: ""
    property int playcount: 0
    property string url: ""
    property string image: ""
    
    layout: DockLayout {}
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    WebImageView {
        image: root.image
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
        
        background: Color.Black
        
        preferredHeight: ui.du(10)
        opacity: 0.5
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
        
        preferredHeight: ui.du(10)
        leftPadding: ui.du(1)
        topPadding: ui.du(0.5)
        bottomPadding: ui.du(0.5)
        
        Container {
            preferredHeight: ui.du(10)
            layout: DockLayout {}
            
            Label {
                verticalAlignment: VerticalAlignment.Top
                text: root.name
                textStyle.color: ui.palette.textOnPrimary
                textStyle.base: SystemDefaults.TextStyles.BodyText
            }
            
            Label {
                visible: root.playcount !== 0;
                verticalAlignment: VerticalAlignment.Bottom
                text: root.playcount + " " + (qsTr("Scrobbles") + Retranslate.onLocaleOrLanguageChanged)
                textStyle.color: ui.palette.textOnPrimary
                textStyle.base: SystemDefaults.TextStyles.SubtitleText
                textStyle.fontWeight: FontWeight.W100
            }
        }
    }
}