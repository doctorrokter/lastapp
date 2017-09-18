import bb.cascades 1.4
import lastFM.controllers 1.0
import "../components"

Page {
    id: root
    
    property int page: 0
    property int limit: 50
    property bool hasNext: true
    
    titleBar: CustomTitleBar {
        title: qsTr("Scrobbles") + Retranslate.onLocaleOrLanguageChanged
    } 
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        ListView {
            id: listView
            
            scrollRole: ScrollRole.Main
            
            dataModel: ArrayDataModel {
                id: dataModel
            }
            
            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if (atEnd) {
                            root.loadRecentTracks();
                        }
                    }
                }
            ]
            
            listItemComponents: [
                ListItemComponent {
                    CustomListItem {
                        RecentTrack {
                            mbid: ListItemData.mbid
                            name: ListItemData.name
                            artist: ListItemData.artist["#text"]
                            date: ListItemData.date === undefined ? "" : Qt.formatDateTime(new Date(ListItemData.date.uts * 1000), "MMM dd, yyyy HH:mm")
                            image: ListItemData.image.filter(function(i) {
                                return i.size === "small";
                            })[0]["#text"];
                            url: ListItemData.url
                            nowplaying: {
                                if (ListItemData["@attr"] !== undefined) {
                                    return ListItemData["@attr"].nowplaying;
                                }
                                return false;
                            }
                        }
                        
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: qsTr("Love Track") + Retranslate.onLocaleOrLanguageChanged
                                    imageSource: "asset:///images/heart_filled.png"
                                    
                                    onTriggered: {
                                        _track.love(ListItemData.artist["#text"], ListItemData.name);
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        }
        
        ActivityIndicator {
            id: spinner
            running: false
            minWidth: ui.du(20)
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
    }
    
    actions: [
        ReloadActionItem {
            onTriggered: {
                root.init();
            }
        }
    ]
    
    onCreationCompleted: {
        _user.recentTracksLoaded.connect(root.recentTracksLoaded);
        init();
    }
    
    function loadRecentTracks() {
        if (root.hasNext && !spinner.running) {
            spinner.start();
            _user.getRecentTracks(_appConfig.get("lastfm_name"), ++root.page, root.limit);
        }
    }
    
    function recentTracksLoaded(tracks) {
        spinner.stop();
        if (tracks.length < root.limit) {
            root.hasNext = false;
        }
        dataModel.append(tracks);
    }
    
    function cleanUp() {
        _user.recentTracksLoaded.disconnect(root.recentTracksLoaded);
    }
    
    function clear() {
        dataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function init() {
        clear();
        loadRecentTracks();
    }
}
