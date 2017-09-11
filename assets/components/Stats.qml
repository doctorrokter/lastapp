import bb.cascades 1.4

Container {
    id: root
    
    property int playcount: 0
    property int listeners: 0
    property int userplaycount: 0
    
    topPadding: ui.du(2)
    horizontalAlignment: HorizontalAlignment.Fill
    
    layout: GridLayout {
        columnCount: 3
    }
    
    StatCount {
        title: qsTr("LISTENING") + Retranslate.onLocaleOrLanguageChanged
        count: root.playcount
    }
    
    StatCount {
        title: qsTr("LISTENERS") + Retranslate.onLocaleOrLanguageChanged
        count: root.listeners
    }                        
    
    StatCount {
        title: qsTr("YOUR LISTENING") + Retranslate.onLocaleOrLanguageChanged
        count: root.userplaycount
    }
}