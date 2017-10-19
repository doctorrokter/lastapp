import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    titleBar: CustomTitleBar {
        title: qsTr("Changelog") + Retranslate.onLocaleOrLanguageChanged
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            Header {
                title: qsTr("Version 1.1.0") + Retranslate.onLocaleOrLanguageChanged
            }
            
            Changelog {
                description: qsTr("Added Changelog page :)") + Retranslate.onLocaleOrLanguageChanged
            }
            
            Changelog {
                description: qsTr("Enable/Disable scrobbling in app settings") + Retranslate.onLocaleOrLanguageChanged
            }
            
            Changelog {
                description: qsTr("Added possibility to enable/disable scrobbling via system hot keys without launching UI part of app") + Retranslate.onLocaleOrLanguageChanged
            }
            
            Changelog {
                description: qsTr("Long numbers converted to short format. \nEx.: 10000 became as 10k.") + Retranslate.onLocaleOrLanguageChanged
            }
            
            Changelog {
                description: qsTr("Small UI improvements") + Retranslate.onLocaleOrLanguageChanged
            }
        }
    }
}
