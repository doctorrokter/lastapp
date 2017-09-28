import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    property variant bookmarks: {
        ARTISTS: "artists",
        ALBUMS: "albums",
        TRACKS: "tracks"
    }
    
    titleBar: CustomTitleBar {
        title: qsTr("Bookmarks") + Retranslate.onLocaleOrLanguageChanged
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            
            SegmentedControl {
                id: segments
                
                horizontalAlignment: HorizontalAlignment.Fill
                options: [
                    Option {
                        text: qsTr("Artists") + Retranslate.onLocaleOrLanguageChanged
                        value: root.bookmarks.ARTISTS
                        selected: true
                    },
                    
                    Option {
                        text: qsTr("Albums") + Retranslate.onLocaleOrLanguageChanged
                        value: root.bookmarks.ALBUMS
                    },
                    
                    Option {
                        text: qsTr("Tracks") + Retranslate.onLocaleOrLanguageChanged
                        value: root.bookmarks.TRACKS
                    }
                ]
                
                onSelectedOptionChanged: {
                    root.clear();
                    root.reload(selectedOption.value);
                }
            }
            
            ListView {
                id: listView
                
                dataModel: ArrayDataModel {
                    id: dataModel
                }
            }
        }
        
        ActivityIndicator {
            id: spinner
        }
    }
    
    function clear() {
        dataModel.clear();
    }
    
    function load(segment) {
        
    }
    
    function init() {
        clear();
        var selectedSegment = segments.selectedOption.value;
        root.load(selectedSegment);
    }
}
