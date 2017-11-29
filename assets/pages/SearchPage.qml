import bb.cascades 1.4
import bb.device 1.4
import "../components"

Page {
    id: root
    
    property variant charts: {
        TOP_ARTISTS: "topartists",
        TOP_TRACKS: "toptracks",
        TOP_ALBUMS: "topalbums"
    }
    property int page: 0
    property int limit: 200
    property bool hasNext: true
    
    signal artistChosen(string name, string mbid)
    signal albumChosen(variant artist, string name, string mbid)
    signal trackChosen(string name, string mbid, variant artist)
    
    titleBar: InputTitleBar {
        scrollBehavior: TitleBarScrollBehavior.NonSticky
        showCancel: false
        hintText: qsTr("Artist name") + Retranslate.onLocaleOrLanguageChanged
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
                id: chartSegments
                
                horizontalAlignment: HorizontalAlignment.Fill
                options: [
                    Option {
                        text: qsTr("Artists") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_ARTISTS
                    },
                    
                    Option {
                        text: qsTr("Albums") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_ALBUMS
                    },
                    
                    Option {
                        text: qsTr("Tracks") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_TRACKS
                    }
                ]
                
                onSelectedOptionChanged: {
                    root.clear();
                    root.titleBar.reset();
                    switch (selectedOption.value) {
                        case root.charts.TOP_ARTISTS:
                            root.titleBar.hintText = qsTr("Aritst name") + Retranslate.onLocaleOrLanguageChanged
                            break;
                        case root.charts.TOP_TRACKS:
                            root.titleBar.hintText = qsTr("Track name or 'Artist name - Track name'") + Retranslate.onLocaleOrLanguageChanged
                            break;
                        case root.charts.TOP_ALBUMS:
                            root.titleBar.hintText = qsTr("Album name") + Retranslate.onLocaleOrLanguageChanged
                            break;
                        default:
                            console.debug("Unknown chart type");
                            break;
                    
                    }
                }
            }
            
            ListView {
                id: listView
                
                dataModel: ArrayDataModel {
                    id: dataModel
                }
                
                layout: gridListLayout
                scrollRole: ScrollRole.Main
                
                function itemType(data, indexPath) {
                    return data.type;
                }
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    switch (chartSegments.selectedOption.value) {
                        case root.charts.TOP_ARTISTS:
                            root.artistChosen(data.name, data.mbid);
                            break;
                        case root.charts.TOP_ALBUMS:
                            root.albumChosen(data.artist, data.name, data.mbid);
                            break;
                    }
                
                }
                
                listItemComponents: [
                    ListItemComponent {
                        type: "artist"
                        CustomListItem {
                            dividerVisible: false
                            
                            TopArtist {
                                name: ListItemData.name
                                playcount: ListItemData.playcount || 0
                                url: ListItemData.url
                                image: ListItemData.image.filter(function(i) {
                                        return i.size === "large";
                                })[0]["#text"]
                            }
                        }
                    },
                    
                    ListItemComponent {
                        type: "track"
                        CustomListItem {
                            TopTrack {
                                mbid: ListItemData.mbid
                                name: ListItemData.name
                                playcount: ListItemData.playcount || 0
                                listeners: ListItemData.listeners || 0
                                url: ListItemData.url
                                artist: ListItemData.artist
                                image: ListItemData.image.filter(function(i) {
                                        return i.size === "medium";
                                })[0]["#text"]
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
                    },
                    
                    ListItemComponent {
                        type: "album"
                        CustomListItem {
                            TopAlbum {
                                mbid: ListItemData.mbid
                                name: ListItemData.name
                                playcount: ListItemData.playcount || 0
                                listeners: ListItemData.listeners || 0
                                url: ListItemData.url
                                artist: ListItemData.artist
                                image: ListItemData.image.filter(function(i) {
                                        return i.size === "large";
                                })[0]["#text"]
                            }
                        }
                    }
                ]
            }
        }
        
        ActivityIndicator {
            id: spinner
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            minWidth: ui.du(20)
        }
    }
    
    onCreationCompleted: {
        root.titleBar.focus();
        _artist.searchLoaded.connect(root.processArtistsSearch);
        _track.searchLoaded.connect(root.processTracksSearch);
        _album.searchLoaded.connect(root.processAlbumsSearch);
    }
    
    attachedObjects: [
        DisplayInfo {
            id: display
        },
        
        GridListLayout {
            id: gridListLayout
            columnCount: {
                if (display.pixelSize.width === 1440) {
                    return 3;
                }
                return 2;
            }
        },
        
        StackListLayout {
            id: stackListLayout
        }
    ]
    
    actions: [
        ActionItem {
            id: search
            title: qsTr("Search") + Retranslate.onLocaleOrLanguageChanged
            imageSource: "asset:///images/ic_search.png"
            ActionBar.placement: ActionBarPlacement.Signature
            
            onTriggered: {
                root.clear();
                root.load();
            }
        }
    ]
    
    function error() {
        spinner.stop();
    }
    
    function setChartData(chartData) {
        spinner.stop();
        if (chartData.length < root.limit) {
            root.hasNext = false;
        }
        dataModel.append(chartData);
    }
    
    function load() {
        var selectedChart = chartSegments.selectedOption.value.trim();
        var search = root.titleBar.value();
        if (search !== "") {
            spinner.start();
            var searchArray = search.split(" - ");
            switch (selectedChart) {
                case root.charts.TOP_ARTISTS:
                    listView.layout = gridListLayout;
                    _artist.search(search, ++root.page, root.limit);
                    break;
                case root.charts.TOP_TRACKS:
                    listView.layout = stackListLayout;
                    if (searchArray.length > 1) {
                        _track.search(searchArray[1], searchArray[0], ++root.page, root.limit);
                    } else {
                        _track.search(search, "", ++root.page, root.limit);
                    }
                    break;
                case root.charts.TOP_ALBUMS:
                    listView.layout = gridListLayout;
                    _album.search(search, ++root.page, root.limit);
                    break;
                default:
                    console.debug("Unknown chart type");
                    break;
            
            }
        }
    }
        
    
    function cleanUp() {
        root.clear();
        root.titleBar.reset();
    }
    
    function clear() {
        dataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function init() {
        clear();
    }
    
    function processArtistsSearch(artists) {
        spinner.stop();
        root.hasNext = artists.length === root.limit;
        artists.forEach(function(a) {
            a.type = "artist";
        });
        dataModel.append(artists);
    }
    
    function processTracksSearch(tracks) {
        spinner.stop();
        root.hasNext = tracks.length === root.limit;
        tracks.forEach(function(t) {
            t.type = "track";
            t.artist = {name: t.artist};
        });
        dataModel.append(tracks);
    }
    
    function processAlbumsSearch(albums) {
        spinner.stop();
        root.hasNext = albums.length === root.limit;
        albums.forEach(function(a) {
            a.type = "album";
            a.artist = {name: a.artist};
        });
        dataModel.append(albums);
    }
}