import bb.cascades 1.4
import bb.system 1.2
import bb.platform 1.3
import "../components"

Page {
    id: root
    
    signal changelogPageRequested()
    
    titleBar: CustomTitleBar {
        title: qsTr("About") + Retranslate.onLocaleOrLanguageChanged
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            
            Container {
                leftPadding: ui.du(2.5)
                topPadding: ui.du(2.5)
                rightPadding: ui.du(2.5)
                
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                
                Label {
                    text: qsTr("Author:") + Retranslate.onLocaleOrLanguageChanged
                    textStyle.base: textStyle.style
                }
                
                Label {
                    text: "Mikhail Chachkouski"
                    textStyle.color: ui.palette.primary
                    textStyle.fontWeight: FontWeight.W500
                    
                    gestureHandlers: [
                        TapHandler {
                            onTapped: {
                                bbwInvoke.trigger(bbwInvoke.query.invokeActionId);
                            }
                        }
                    ]
                }
            }
            
            Container {
                leftPadding: ui.du(2.5)
                topPadding: ui.du(2.5)
                rightPadding: ui.du(2.5)
                
                Label { 
                    text: (qsTr("App name: ") + Retranslate.onLocaleOrLanguageChanged) + Application.applicationName
                }
                
                Label {
                    text: (qsTr("App version: ") + Retranslate.onLocaleOrLanguageChanged) + Application.applicationVersion
                }
                
                Label {
                    text: (qsTr("OS version: ") + Retranslate.onLocaleOrLanguageChanged) + platform.osVersion
                }
            }
            
            Container {
                topMargin: ui.du(2.5)
                
                Header {
                    title: qsTr("Changelog") + Retranslate.onLocaleOrLanguageChanged
                    mode: HeaderMode.Interactive
                    
                    onClicked: {
                        root.changelogPageRequested();
                    }
                }
            }
        }
    }
    
    attachedObjects: [
        Invocation {
            id: bbwInvoke
            query {
                uri: "appworld://vendor/97424"
                invokeActionId: "bb.action.OPEN"
                invokeTargetId: "sys.appworld"
            }
        },
        
        PlatformInfo {
            id: platform
        }
    ]
}
