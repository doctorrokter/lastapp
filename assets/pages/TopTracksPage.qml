import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    signal trackChosen(string name, string mbid, variant artist)
    
    titleBar: CustomTitleBar {
        title: qsTr("Top Tracks") + Retranslate.onLocaleOrLanguageChanged
        
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        PeriodsList {
            id: periods
            
            onChosen: {
                mainListView.reload(period);
            }
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            layout: DockLayout {}
            
            ListView {
                id: mainListView
                
                property string period: "7day"
                property int page: 0
                property int limit: 50
                property bool hasNext: true
                
                dataModel: ArrayDataModel {
                    id: mainDataModel
                }
                
                scrollRole: ScrollRole.Main
                
                attachedObjects: [
                    ListScrollStateHandler {
                        onAtEndChanged: {
                            if (atEnd && !mainDataModel.isEmpty() && !spinner.running) {
                                mainListView.load();
                            }
                        }
                    }
                ]
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    root.trackChosen(data.name, data.mbid, data.artist);
                }
                
                listItemComponents: [
                    ListItemComponent {
                        CustomListItem {
                            TopTrack {
                                mbid: ListItemData.mbid
                                name: ListItemData.name
                                artist: ListItemData.artist
                                url: ListItemData.url
                                playcount: ListItemData.playcount
                                image: _imageService.getImage(ListItemData.image, "large")
                            }
                            
                            contextActions: [
                                ActionSet {
                                    LoveTrackActionItem {
                                        artist: ListItemData.artist.name
                                        track: ListItemData.name
                                    }
                                }
                            ]
                        }
                    }
                ]
                
                function reload(period) {
                    mainDataModel.clear();
                    if (period !== undefined) {
                        mainListView.period = period;
                    }
                    mainListView.page = 0;
                    mainListView.hasNext = true;
                    load();
                }
                
                function load() {
                    spinner.start();
                    _user.getTopTracks(_appConfig.get("lastfm_name"), ++mainListView.page, mainListView.limit, period);
                }
                
                function topTracksLoaded(tracks, period, user) {
                    spinner.stop();
                    if (tracks.length < mainListView.limit) {
                        mainListView.hasNext = false;
                    }
                    mainDataModel.append(tracks);
                }
                
                onCreationCompleted: {
                    _user.topTracksLoaded.connect(mainListView.topTracksLoaded);
                }
            }
            
            ActivityIndicator {
                id: spinner
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                minWidth: ui.du(20)
            }
        }
    }
    
    actions: [
        ReloadActionItem {
            onTriggered: {
                root.init();
            }
        }
    ]
    
    function clear() {
        mainDataModel.clear();
        mainListView.page = 0;
        mainListView.hasNext = true;
    }
    
    function init() {
        clear();
        periods.choose([0]);
    }
}
