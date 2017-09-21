import bb.cascades 1.4
import bb.device 1.4
import "../components"

Page {
    id: root
    
    property string tag: ""
    property variant charts: {
        TOP_ARTISTS: "topartists",
        TOP_ALBUMS: "topalbums",
        TOP_TRACKS: "toptracks"
    }
    property int page: 0
    property int limit: 50
    property bool hasNext: true
    
    signal artistChosen(string name, string mbid)
    
    titleBar: CustomTitleBar {
        title: root.tag
        
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
                        text: qsTr("Top Artists") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_ARTISTS
                    },
                    
                    Option {
                        text: qsTr("Top Albums") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_ALBUMS
                    },
                    
                    Option {
                        text: qsTr("Top Tracks") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_TRACKS
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
                
                layout: gridListLayout
                scrollRole: ScrollRole.Main
                
                function itemType(data, indexPath) {
                    return data.type;
                }
                
                attachedObjects: [
                    ListScrollStateHandler {
                        onAtEndChanged: {
                            if (atEnd && !spinner.running) {
                                root.load(segments.selectedOption.value);
                            }
                        }
                    }
                ]
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    switch (data.type) {
                        case "artist":
                            root.artistChosen(data.name, data.mbid);
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
                        type: "album"
                        CustomListItem {
                            dividerVisible: false
                            
                            TopAlbum {
                                name: ListItemData.name
                                playcount: ListItemData.playcount || 0
                                url: ListItemData.url
                                mbid: ListItemData.mbid
                                image: ListItemData.image.filter(function(i) {
                                        return i.size === "large";
                                })[0]["#text"]
                            artist: ListItemData.artist
                            }
                        }
                    },
                    
                    ListItemComponent {
                        type: "track"
                        CustomListItem {
                            TopTrack {
                                mbid: ListItemData.mbid
                                name: ListItemData.name
                                artist: ListItemData.artist
                                url: ListItemData.url
                                playcount: ListItemData.playcount || 0
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
        _tag.chartLoaded.connect(root.chartLoaded);
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
    
    onTagChanged: {
        clear();
        var selectedChart = segments.selectedOption.value;
        root.reload(selectedChart);
    }
    
    function chartLoaded(chart) {
        spinner.stop();
        if (chart.length < root.limit) {
            root.hasNext = false;
        }
        dataModel.append(chart);
    }
    
    function clear() {
        dataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function reload(segment) {
        clear();
        load(segment);
    }
    
    function load(segment) {
        spinner.start();
        switch (segment) {
            case root.charts.TOP_ARTISTS:
                listView.layout = gridListLayout;
                _tag.getTopArtists(root.tag, ++root.page, root.limit);
                break;
            case root.charts.TOP_ALBUMS:
                listView.layout = gridListLayout;
                _tag.getTopAlbums(root.tag, ++root.page, root.limit);
                break;
            case root.charts.TOP_TRACKS:
                listView.layout = stackListLayout;
                _tag.getTopTracks(root.tag, ++root.page, root.limit);
                break;
            default:
                console.debug("Unknown chart type");
                break;
        }
    }
    
    function cleanUp() {
        _tag.chartLoaded.disconnect(root.chartLoaded);
    }
}
