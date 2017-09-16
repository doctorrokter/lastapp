import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    property string name: "Iron Maiden"
    property string mbid: ""
    property int page: 0
    property int limit: 100
    property bool hasNext: true
    property int maxListeners: 0
    
    titleBar: CustomTitleBar {
        title: root.name
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        ListView {
            id: topTracksList
            
            scrollRole: ScrollRole.Main
            
            dataModel: ArrayDataModel {
                id: topTracksDataModel
            }
            
            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if (atEnd) {
                            root.load();
                        }
                    }
                }
            ]
            
            listItemComponents: [
                ListItemComponent {
                    TopTrackListItem {
                        count: ListItemData.listeners
                        maxCount: ListItemData.maxListeners
                        title: ListItemData.name
                        number: ListItemData.number
                        subtitle: ListItemData.listeners + " " + (qsTr("listeners") + Retranslate.onLocaleOrLanguageChanged)
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
    
    onCreationCompleted: {
        _artist.topTracksLoaded.connect(root.setTopTracks);
    }
    
    onNameChanged: {
        load();
    }
    
    function load() {
        if (root.hasNext && !spinner.running) {
            spinner.start();
            _artist.getTopTracks(root.name, root.mbid, 1, ++root.page, root.limit);
        }
    }
    
    function setTopTracks(tracks) {
        spinner.stop();
        if (tracks.length < root.limit) {
            root.hasNext = false;
        }
        
        var sorted = tracks.sort(function(a, b) {
            return a.listeners < b.listeners;
        });
        if (root.page === 1) {
            root.maxListeners = sorted[0].listeners;
        }
        var start = topTracksDataModel.size();
        sorted.forEach(function(t, index) {
            t.number = start + index + 1;
            t.maxListeners = root.maxListeners;
        });
        topTracksDataModel.append(sorted);
    }
    
    function cleanUp() {
        _artist.topTracksLoaded.disconnect(root.setTopTracks);
    }
}
