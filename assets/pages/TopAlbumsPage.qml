import bb.cascades 1.4
import bb.device 1.4
import "../components"

Page {
    id: root
    
    signal albumChosen(variant artist, string name, string mbid)
    
    titleBar: CustomTitleBar {
        title: qsTr("Top Albums") + Retranslate.onLocaleOrLanguageChanged
        
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
                
                layout: GridListLayout {
                    columnCount: {
                        if (display.pixelSize.width === 1440) {
                            return 3;
                        }
                        return 2;
                    }
                }
                
                attachedObjects: [
                    DisplayInfo {
                        id: display
                    },
                    
                    ListScrollStateHandler {
                        onAtEndChanged: {
                            if (atEnd && !mainDataModel.isEmpty() && !spinner.running) {
                                mainListView.load();
                            }
                        }
                    }
                ]
                
                onTriggered: {
                    var data = mainDataModel.data(indexPath);
                    root.albumChosen(data.artist, data.name, data.mbid);
                }
                
                listItemComponents: [
                    ListItemComponent {
                        CustomListItem {
                            dividerVisible: false
                            
                            TopAlbum {
                                name: ListItemData.name
                                playcount: ListItemData.playcount
                                url: ListItemData.url
                                mbid: ListItemData.mbid
                                image: ListItemData.image.filter(function(i) {
                                        return i.size === "large";
                                })[0]["#text"]
                                artist: ListItemData.artist
                            }
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
                    _user.getTopAlbums(_appConfig.get("lastfm_name"), ++mainListView.page, mainListView.limit, period);
                }
                
                function topAlbumsLoaded(albums, period) {
                    spinner.stop();
                    if (albums.length < mainListView.limit) {
                        mainListView.hasNext = false;
                    }
                    mainDataModel.append(albums);
                }
                
                function error() {
                    spinner.stop();
                }
                
                onCreationCompleted: {
                    _user.topAlbumsLoaded.connect(mainListView.topAlbumsLoaded);
                    _user.error.connect(mainListView.error);
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
