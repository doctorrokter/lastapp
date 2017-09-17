import bb.cascades 1.4

ActionItem {
    id: root
    
    property string artist: ""
    property string track: ""
    
    title: qsTr("Love Track") + Retranslate.onLocaleOrLanguageChanged
    imageSource: "asset:///images/heart_filled.png"
    
    onTriggered: {
        _track.love(root.artist, root.track);
    }
}