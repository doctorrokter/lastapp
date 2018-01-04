import bb.cascades 1.4
import "../components"
import "../js/util.js" as Util;

Page {
    id: root
    
    property int page: 0
    property int limit: 50
    property bool hasNext: true
    
    signal userChosen(string user)
    
    titleBar: CustomTitleBar {
        title: qsTr("Friends") + Retranslate.onLocaleOrLanguageChanged
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        layout: DockLayout {}
        
        ListView {
            id: friendsList
            
            dataModel: ArrayDataModel {
                id: friendsDataModel
            }
            
            scrollRole: ScrollRole.Main
            
            onTriggered: {
                var data = friendsDataModel.data(indexPath);
                root.userChosen(data.name);
            }
            
            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if (atEnd) {
                            friendsList.margin.bottomOffset = ui.du(12);    
                        } else {
                            friendsList.margin.bottomOffset = 0;
                        }
                        
                        if (atEnd && root.hasNext && !spinner.running) {
                            root.load();
                        }
                    }
                }
            ]
            
            listItemComponents: [
                ListItemComponent {
                    CustomListItem {
                        Friend {
                            name: ListItemData.name
                            realname: ListItemData.realname || ""
                            url: ListItemData.url
                            country: ListItemData.country || ""
                            playcount: ListItemData.playcount
                            image: ListItemData.image.filter(function(i) {
                                return i.size === "medium";
                            })[0]["#text"];
                        }
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
        _user.friendsLoaded.connect(root.friendsLoaded);
        _user.error.connect(root.error);
    }
    
    function error() {
        spinner.stop();
    }
    
    function load() {
        spinner.start();
        _user.getFriends(_app.prop("lastfm_name"), ++root.page, root.limit);
    }
    
    function friendsLoaded(friends) {
        spinner.stop();
        if (friends.length < root.limit) {
            root.hasNext = false;
        }
        friendsDataModel.append(friends);
    }
    
    function clear() {
        friendsDataModel.clear();
        root.page = 0;
        root.hasNext = true;
    }
    
    function init() {
        clear();
        load();
    }
}
