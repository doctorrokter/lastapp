import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    titleBar: CustomTitleBar {
        title: qsTr("Settings") + Retranslate.onLocaleOrLanguageChanged
    }
    
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            layout: DockLayout {}
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                Header {
                    title: qsTr("Look and Feel") + Retranslate.onLocaleOrLanguageChanged
                }
                
                Container {
                    layout: DockLayout {}
                    topPadding: ui.du(2)
                    bottomPadding: ui.du(2.5)
                    leftPadding: ui.du(2.5)
                    rightPadding: ui.du(2.5)
                    horizontalAlignment: HorizontalAlignment.Fill
                    Label {
                        text: qsTr("Dark theme") + Retranslate.onLocaleOrLanguageChanged
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left
                    }
                    
                    ToggleButton {
                        id: themeToggle
                        horizontalAlignment: HorizontalAlignment.Right
                        
                        onCheckedChanged: {
                            if (checked) {
                                Application.themeSupport.setVisualStyle(VisualStyle.Dark);
                                _appConfig.set("theme", "DARK");
                            } else {
                                Application.themeSupport.setVisualStyle(VisualStyle.Bright);
                                _appConfig.set("theme", "BRIGHT");
                            }
                        }
                    }
                }
                
                Header {
                    title: qsTr("Behaviour") + Retranslate.onLocaleOrLanguageChanged
                }
                
                Container {
                    layout: DockLayout {}
                    topPadding: ui.du(2)
                    bottomPadding: ui.du(2.5)
                    leftPadding: ui.du(2.5)
                    rightPadding: ui.du(2.5)
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    Label {
                        text: qsTr("Hub notifications") + Retranslate.onLocaleOrLanguageChanged
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Left
                    }
                    
                    ToggleButton {
                        id: notifyToggle
                        horizontalAlignment: HorizontalAlignment.Right
                        
                        onCheckedChanged: {
                            if (checked) {
                                _appConfig.set("notify_now_playing", "true");
                            } else {
                                _appConfig.set("notify_now_playing", "false");
                            }
                        }
                    }
                }
                
//                Container {
//                    layout: DockLayout {}
//                    topPadding: ui.du(2)
//                    bottomPadding: ui.du(2.5)
//                    leftPadding: ui.du(2.5)
//                    rightPadding: ui.du(2.5)
//                    horizontalAlignment: HorizontalAlignment.Fill
//                    
//                    Label {
//                        text: qsTr("Headless scrobbling") + Retranslate.onLocaleOrLanguageChanged
//                        verticalAlignment: VerticalAlignment.Center
//                        horizontalAlignment: HorizontalAlignment.Left
//                    }
//                    
//                    ToggleButton {
//                        id: headlessToggle
//                        horizontalAlignment: HorizontalAlignment.Right
//                        
//                        onCheckedChanged: {
//                            if (checked) {
//                                _appConfig.set("headless_scrobbling", "true");
//                                _app.startHeadless();
//                            } else {
//                                _appConfig.set("headless_scrobbling", "false");
//                                _app.stopHeadless();
//                            }
//                        }
//                    }
//                }
                
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    minHeight: ui.du(20)
                }
            }
        }
    }
    
    function adjustTheme() {
        var theme = _appConfig.get("theme");
        themeToggle.checked = theme && theme === "DARK";
    }
    
    function adjustNotification() {
        var notify = _appConfig.get("notify_now_playing");
        notifyToggle.checked = notify === "" || notify === "true";
    }
    
    function adjustHeadless() {
        var headless = _appConfig.get("headless_scrobbling");
        headlessToggle.checked = headless === "" || headless === "true";
    }
    
    onCreationCompleted: {
        adjustTheme();
        adjustNotification();
//        adjustHeadless();
    }
}