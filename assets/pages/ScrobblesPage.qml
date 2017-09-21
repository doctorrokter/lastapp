import bb.cascades 1.4
import lastFM.controllers 1.0
import "../components"

Page {
    id: root
    
    property int page: 0
    property int limit: 50
    property bool hasNext: true
    
    signal trackChosen(string name, string mbid, variant artist)
    
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
            
            onTriggered: {
                var data = dataModel.data(indexPath);
                root.trackChosen(data.name, data.mbid, {name: data.artist["#text"]});
            }
            
            listItemComponents: [
                ListItemComponent {
                    CustomListItem {
                        RecentTrack {
                            mbid: ListItemData.mbid
                            name: ListItemData.name
                            artist: ListItemData.artist["#text"]
                            date: ListItemData.date === undefined ? "" : Qt.formatDateTime(new Date(ListItemData.date.uts * 1000), "MMM dd, yyyy HH:mm")
                            image: _imageService.getImage(ListItemData.image, "large")
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
        _user.error.connect(root.error);
        init();
    }
    
    function error() {
        spinner.stop();
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
