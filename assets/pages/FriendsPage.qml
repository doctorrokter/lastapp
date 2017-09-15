import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    signal userChosen(string user)
    
    titleBar: CustomTitleBar {
        title: qsTr("Friends") + Retranslate.onLocaleOrLanguageChanged
    }
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        ListView {
            id: friendsList
            
            property int page: 0
            property int limit: 50
            property bool hasNext: true
            
            dataModel: ArrayDataModel {
                id: friendsDataModel
            }
            
            scrollRole: ScrollRole.Main
            
            onTriggered: {
                var data = friendsDataModel.data(indexPath);
                root.userChosen(data.name);
            }
            
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
    }
    
    onCreationCompleted: {
        _user.friendsLoaded.connect(root.friendsLoaded);
    }
    
    function load() {
        _user.getFriends(_appConfig.get("lastfm_name"), ++friendsList.page, friendsList.limit);
    }
    
    function friendsLoaded(friends) {
        console.debug(friends);
        if (friends.length < friendsList.limit) {
            friendsList.hasNext = false;
        }
        friendsDataModel.append(friends);
    }
    
    function clear() {
        friendsDataModel.clear();
        friendsList.page = 0;
        friendsList.hasNext = true;
    }
    
    function init() {
        clear();
        load();
    }
}
