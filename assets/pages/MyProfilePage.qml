import bb.cascades 1.4
import "../components"

Page {
    id: root
    
    property string name: ""
    property string realname: ""
    property string country: ""
    property int playcount: 0
    property int playlists: 0
    property int registered: 0
    property variant images: []
    
    property int artists: 0
    property int lovedTracks: 0
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
        
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            attachedObjects: [
                LayoutUpdateHandler {
                    id: mainLUH
                }
            ]
            
            layout: DockLayout {}
            
            ImageBackground {
                id: backgroundImage
                
                maxHeight: mainLUH.layoutFrame.height / 2
                maxWidth: mainLUH.layoutFrame.width
            }
            
            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            
                layout: DockLayout {}
            
                Container {
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
            
                    background: ui.palette.background
            
                    margin.topOffset: ui.du(40)
                
                    Divider {}
            
                    Container {
                        topPadding: ui.du(5)
                        leftPadding: ui.du(2)
                        rightPadding: ui.du(2)
                        Label {
                            text: root.name
                            textStyle.base: SystemDefaults.TextStyles.TitleText
                            textStyle.fontWeight: FontWeight.Bold
                        }
                
                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            
                            Label {
                                verticalAlignment: VerticalAlignment.Center
                                text: root.realname
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                            }
                            
                            Label {
                                verticalAlignment: VerticalAlignment.Center
                                text: qsTr("registered") + Retranslate.onLocaleOrLanguageChanged + " " + Qt.formatDate(new Date(root.registered * 1000), "MMM dd, yyyy")
                                textStyle.base: SystemDefaults.TextStyles.SubtitleText
                                textStyle.color: ui.palette.secondaryTextOnPlain
                            }
                        }
                        
                    }
            
                    Divider {}
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        layout: GridLayout {
                            columnCount: 3
                        }
                        
                        StatCount {
                            title: qsTr("COUNTRY") + Retranslate.onLocaleOrLanguageChanged
                            value: root.country
                        }
                        
                        StatCount {
                            title: qsTr("SCROBBLES") + Retranslate.onLocaleOrLanguageChanged
                            count: root.playcount
                        }
                        
                        StatCount {
                            title: qsTr("PLAYLISTS") + Retranslate.onLocaleOrLanguageChanged
                            count: root.playlists
                        }
                    }
                    
                    Divider {}
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        layout: GridLayout {
                            columnCount: 3
                        }
                        
                        StatCount {
                            title: qsTr("ARTISTS") + Retranslate.onLocaleOrLanguageChanged
                            value: root.artists
                        }
                        
                        StatCount {
                            title: qsTr("LOVED TRACKS") + Retranslate.onLocaleOrLanguageChanged
                            count: root.lovedTracks
                        }                        
                    }
                    
                    Divider {}
                    
                    UserTopTrack {
                        id: topTrackContainer
                        visible: false
                    }
                }
            }
            
            Container {
                id: avatarContainer
                
                property double padding: 0.25
                
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Center
                
                margin.topOffset: ui.du(12)
                
                leftPadding: ui.du(padding)
                topPadding: ui.du(padding)
                rightPadding: ui.du(padding)
                bottomPadding: ui.du(padding)
                
                background: Color.White
                
                WebImageView {
                    id: avatar
                    image: ""
                    minWidth: ui.du(35 - avatarContainer.padding * 2)
                    minHeight: ui.du(35 - avatarContainer.padding * 2)
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
    
    onCreationCompleted: {
        _user.infoLoaded.connect(root.setUser);
        _user.topTracksLoaded.connect(root.setTopTrack);
        _user.lovedTracksLoaded.connect(root.setLovedTracks);
        _user.topArtistsLoaded.connect(root.setTopArtists);
    }
    
    onImagesChanged: {
        avatar.image = getImage(root.images, "large");
        backgroundImage.image = getImage(root.images, "extralarge");
        backgroundImage.maxHeight = mainLUH.layoutFrame.height / 2;
        backgroundImage.maxWidth = mainLUH.layoutFrame.width;
    }
    
    function init() {
        spinner.start();
        _user.getInfo(_appConfig.get("lastfm_name"));
        _user.getTopTracks(_appConfig.get("lastfm_name"), 1, 1, "7day");
        _user.getLovedTracks(_appConfig.get("lastfm_name"), 1, 1);
        _user.getTopArtists(_appConfig.get("lastfm_name"), 1, 1);
    }
    
    function setUser(user) {
        if (root.name === "" || user.name === root.name) {
            spinner.stop();
            root.name = user.name || "";
            root.realname = user.realname || "";
            root.images = user.image;
            root.playcount = user.playcount || 0;
            root.country = user.country || (qsTr("Not provided") + Retranslate.onLocaleOrLanguageChanged);
            root.playlists = user.playlists || 0;
            root.registered = user.registered.unixtime;
        }
    }
    
    function setTopTrack(tracks, period, username) {
        if (root.name === username) {
            if (tracks.length !== 0) {
                var track = tracks[0];
                topTrackContainer.visible = true;
                topTrackContainer.name = track.name;
                topTrackContainer.artist = track.artist.name;
                topTrackContainer.image = root.getImage(track.image, "large");
            }
        }
    }
    
    function setLovedTracks(tracks, user, total) {
        if (root.name === user) {
            root.lovedTracks = total;
        }
    }
    
    function setTopArtists(artists, period, user, total) {
        if (root.name === user) {
            root.artists = total;
        }
    }
    
    function getImage(imgs, size) {
        var img = imgs.filter(function(i) {
                return i.size === size;
        })[0];
        return img === undefined ? "" : img["#text"];
    }
}
