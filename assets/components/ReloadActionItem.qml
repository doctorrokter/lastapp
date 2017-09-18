import bb.cascades 1.4

ActionItem {
    id: reloadAction
    imageSource: "asset:///images/ic_reload.png"
    title: qsTr("Reload") + Retranslate.onLocaleOrLanguageChanged
    
    shortcuts: [
        Shortcut {
            id: reloadShortcut
            key: "r"
            
            onTriggered: {
                reloadAction.triggered();
            }
        }
    ]
}
