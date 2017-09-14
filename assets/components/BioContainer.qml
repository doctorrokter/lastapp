import bb.cascades 1.4

Container {
    id: bioContainer
    
    property string bio: ""
    property bool expanded: false
    property double maxHeightBio: 35
    
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    topMargin: ui.du(4)
    maxHeight: ui.du(maxHeightBio)
    
    horizontalAlignment: HorizontalAlignment.Fill
    
    Label {
        text: qsTr("Bio") + Retranslate.onLocaleOrLanguageChanged
        textStyle.base: SystemDefaults.TextStyles.PrimaryText
        textStyle.fontWeight: FontWeight.Bold
    }
    
    Label {
        text: bioContainer.bio
        multiline: true
        textFormat: TextFormat.Html
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W100
    }
    
    onTouch: {
        if (event.touchType === TouchType.Down) {
            bioContainer.background = ui.palette.plain;
        } else if (event.touchType === TouchType.Up) {
            bioContainer.background = ui.palette.background;
            bioContainer.expanded = !bioContainer.expanded;
        } else {
            bioContainer.background = ui.palette.background;
        }
    }
    
    onExpandedChanged: {
        if (expanded) {
            maxHeight = Infinity;
        } else {
            maxHeight = ui.du(maxHeightBio);
        }
    }
}
