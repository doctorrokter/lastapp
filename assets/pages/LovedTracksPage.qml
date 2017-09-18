import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    property int page: 0
    property int limit: 50
    property bool hasNext: true
    
    signal trackChosen(string name, string mbid, variant artist)
    
    titleBar: CustomTitleBar {
        title: qsTr("Loved Tracks") + Retranslate.onLocaleOrLanguageChanged
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
                            listView.margin.bottomOffset = ui.du(12);    
                        } else {
                            listView.margin.bottomOffset = 0;
                        }
                        
                        if (atEnd && !spinner.running && root.hasNext) {
                            root.load();
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
                        RecentTrack {
                            nowplaying: false
                            mbid: ListItemData.mbid || ""
                            name: ListItemData.name
                            artist: ListItemData.artist.name
                            url: ListItemData.url || ""
                            image: _imageService.getImage(ListItemData.image, "medium")
                            date: Qt.formatDate(new Date(ListItemData.date.uts * 1000), "MMM dd, yyyy")
                        }
                        
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: qsTr("Unlove Track") + Retranslate.onLocaleOrLanguageChanged
                                    imageSource: "asset:///images/heart_empty.png"
                                    
                                    onTriggered: {
                                        _track.unlove(ListItemData.artist.name, ListItemData.name);
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
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            minWidth: ui.du(20)
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
        _user.lovedTracksLoaded.connect(root.setLovedTracks);
        _track.unloved.connect(root.onUnloved);
    }
    
    function onUnloved(artist, track) {
        for (var i = 0; i < dataModel.size(); i++) {
            var t = dataModel.value(i);
            if (t.artist.name === artist && t.name === track) {
                dataModel.removeAt(i);
            }
        }
    }
    
    function setLovedTracks(tracks, user, total) {
        spinner.stop();
        if (tracks.length < root.limit) {
            root.hasNext = false;
        }
        dataModel.append(tracks);
    }
    
    function init() {
        clear();
        load();
    }
    
    function clear() {
        dataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function load() {
        spinner.start();
        _user.getLovedTracks(_appConfig.get("lastfm_name"), ++root.page, root.limit);
    }
}
