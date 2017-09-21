import bb.cascades 1.4
import bb.device 1.4
import "../components"

Page {
    id: root
    
    property variant charts: {
        TOP_ARTISTS: "topartists",
        TOP_TRACKS: "toptracks",
        TOP_TAGS: "toptags"
    }
    property int page: 0
    property int limit: 200
    property bool hasNext: true
    
    signal artistChosen(string name, string mbid)
    signal tagChosen(string tag)
    
    titleBar: CustomTitleBar {
        title: qsTr("Charts") + Retranslate.onLocaleOrLanguageChanged
        
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
                id: chartSegments
                
                horizontalAlignment: HorizontalAlignment.Fill
                options: [
                    Option {
                        text: qsTr("Top Artists") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_ARTISTS
                    },
                    
                    Option {
                        text: qsTr("Top Tracks") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_TRACKS
                    },
                    
                    Option {
                        text: qsTr("Top Tags") + Retranslate.onLocaleOrLanguageChanged
                        value: root.charts.TOP_TAGS
                    }
                ]
                
                onSelectedOptionChanged: {
                    root.clear();
                    root.loadChart(selectedOption.value);
                }
            }
            
            ListView {
                id: listView
                
                dataModel: ArrayDataModel {
                    id: dataModel
                }
                
                layout: gridListLayout
                scrollRole: ScrollRole.Main
                
                attachedObjects: [
                    ListScrollStateHandler {
                        onAtEndChanged: {
                            if (atEnd && !spinner.running) {
                                root.loadChart(chartSegments.selectedOption.value);
                            }
                        }
                    }
                ]
                
                function itemType(data, indexPath) {
                    return data.type;
                }
                
                onTriggered: {
                    var data = dataModel.data(indexPath);
                    switch (chartSegments.selectedOption.value) {
                        case root.charts.TOP_ARTISTS:
                            root.artistChosen(data.name, data.mbid);
                            break;
                        case root.charts.TOP_TAGS:
                            root.tagChosen(data.name);
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
                                playcount: ListItemData.playcount
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
                                playcount: ListItemData.playcount
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
                        type: "tag"
                        StandardListItem {
                            title: ListItemData.name
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
        _chart.chartLoaded.connect(root.setChartData);
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
    
    function setChartData(chartData) {
        spinner.stop();
        if (chartData.length < root.limit) {
            root.hasNext = false;
        }
        dataModel.append(chartData);
    }
    
    function loadChart(selectedChart) {
        spinner.start();
        switch (selectedChart) {
            case root.charts.TOP_ARTISTS:
                listView.layout = gridListLayout;
                _chart.getTopArtists(++root.page, root.limit);
                break;
            case root.charts.TOP_TRACKS:
                listView.layout = stackListLayout;
                _chart.getTopTracks(++root.page, root.limit);
                break;
            case root.charts.TOP_TAGS:
                listView.layout = stackListLayout;
                _chart.getTopTags(++root.page, root.limit);
                break;
            default:
                console.debug("Unknown chart type");
                break;
                
        }
    }
    
    function cleanUp() {
        _chart.chartLoaded.disconnect(root.setChartData);
    }
    
    function clear() {
        dataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function init() {
        clear();
        var selectedChart = chartSegments.selectedOption.value;
        root.loadChart(selectedChart);
    }
}
