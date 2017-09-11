import bb.cascades 1.4
import chachkouski.util 1.0
import "../components"

Page {
    id: root
    
    property string mbid: ""
    property string name: ""
    property variant stats: {
        listeners: 0,
        playcount: 0,
        userplaycount: 0
    }
    property variant tags: []
    property variant images: []
    property variant similar: []
    property string bio: ""
    
    signal artistTopTracksRequested(string name, string mbid)
    signal artistChosen(string name, string mbid)
    
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
                    
                    margin.topOffset: ui.du(28)
                    
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
                    }
                    
                    Divider {}
                    
                    Stats {
                        playcount: root.stats.playcount
                        listeners: root.stats.listeners
                        userplaycount: root.stats.userplaycount
                    }
                    
                    Divider {}
                    
                    TagsContainer {
                        tags: root.tags
                    }                  
                    
                    Container {
                        id: bioContainer
                        
                        property bool expanded: false
                        property double maxHeightBio: 35
                        
                        leftPadding: ui.du(2)
                        rightPadding: ui.du(2)
                        topMargin: ui.du(4)
                        maxHeight: ui.du(maxHeightBio)
                        
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Bio") + Retranslate.onLocaleOrLanguageChanged
                            textStyle.base: SystemDefaults.TextStyles.PrimaryText
                            textStyle.fontWeight: FontWeight.Bold
                        }
                        
                        Label {
                            text: root.bio
                            multiline: true
                            textFormat: TextFormat.Html
                            textStyle.base: SystemDefaults.TextStyles.BodyText
                            textStyle.fontWeight: FontWeight.W100
                        }
                        
                        onTouch: {
                            if (event.touchType === TouchType.Down) {
                                bioContainer.background = ui.palette.plain;
                            } else if (event.touchType === TouchType.Up) {
                                bioContainer.background = ui.palette.background;
                                bioContainer.expanded = !bioContainer.expanded;
                            } else {
                                bioContainer.background = ui.palette.background;
                            }
                        }
                        
                        onExpandedChanged: {
                            if (expanded) {
                                maxHeight = Infinity;
                            } else {
                                maxHeight = ui.du(maxHeightBio);
                            }
                        }
                    }  
                    
                    Divider {}
                    
                    Container {
                        id: topTracksContainer
                        
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Container {
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                            
                            Label {
                                text: qsTr("Top tracks") + Retranslate.onLocaleOrLanguageChanged
                                textStyle.base: SystemDefaults.TextStyles.PrimaryText
                                textStyle.fontWeight: FontWeight.Bold
                            }
                        }
                        
                        Container {
                            id: topTracksMainContainer
                            
                            margin.topOffset: ui.du(2)
                        }
                    }
                    
                    Header {
                        title: qsTr("More top tracks...") + Retranslate.onLocaleOrLanguageChanged
                        mode: HeaderMode.Interactive
                        
                        onClicked: {
                            root.artistTopTracksRequested(root.name, root.mbid);
                        }
                    }
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        margin.topOffset: ui.du(2)
                        
                        Container {
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                            
                            Label {
                                text: qsTr("Similar artists") + Retranslate.onLocaleOrLanguageChanged
                                textStyle.base: SystemDefaults.TextStyles.PrimaryText
                                textStyle.fontWeight: FontWeight.Bold
                            }
                        }
                        
                        ScrollView {
                            margin.topOffset: ui.du(2)
                            scrollViewProperties.scrollMode: ScrollMode.Horizontal
                            
                            Container {
                                id: similarContainer
                                
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                            }
                        }
                        
                    }
                    
                    Container {
                        minHeight: ui.du(12)
                        horizontalAlignment: HorizontalAlignment.Fill
                    }
                }

                Container {
                    id: avatarContainer
                    
                    property double padding: 0.25
                    
                    verticalAlignment: VerticalAlignment.Top
                    
                    margin.topOffset: ui.du(5)
                    margin.leftOffset: ui.du(2)
                    
                    leftPadding: ui.du(padding)
                    topPadding: ui.du(padding)
                    rightPadding: ui.du(padding)
                    bottomPadding: ui.du(padding)
                    
                    background: Color.White
                    
                    maxWidth: ui.du(25)
                    maxHeight: ui.du(25)
                    
                    WebImageView {
                        id: avatar
                        image: ""
                        minWidth: ui.du(25 - avatarContainer.padding * 2)
                        minHeight: ui.du(25 - avatarContainer.padding * 2)
                    }
                }
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: topTrackListItem
            TopTrackListItem {}
        },
        
        ComponentDefinition {
            id: topArtist
            TopArtist {
                id: similarArtistObj
                    
                minWidth: ui.du(40)
                minHeight: ui.du(40)
                maxWidth: ui.du(40)
                maxHeight: ui.du(40)
                
                gestureHandlers: [
                    TapHandler {
                        onTapped: {
                            root.artistChosen(similarArtistObj.name, similarArtistObj.mbid);
                        }
                    }
                ]
            }
        }
    ]
    
    onCreationCompleted: {
        _artist.infoLoaded.connect(root.setArtist);
        _artist.topTracksLoaded.connect(root.setTopTracks);
    }
    
    onNameChanged: {
        _artist.getInfo(root.name, root.mbid, _lang, 1, _appConfig.get("lastfm_name"));
        _artist.getTopTracks(root.name, root.mbid, 1, 1, 5);
    }
    
    onImagesChanged: {
        avatar.image = getImage("large");
        backgroundImage.image = getImage("extralarge");
        backgroundImage.maxHeight = mainLUH.layoutFrame.height / 2;
        backgroundImage.maxWidth = mainLUH.layoutFrame.width;
    }
    
    function setArtist(artist) {
        _artist.infoLoaded.disconnect(root.setArtist);
        root.name = artist.name;
        root.mbid = artist.mbid || "";
        root.images = artist.image;
        root.tags = artist.tags.tag;
        root.stats = artist.stats;
        root.bio = artist.bio.content || "";
        
        var similarArtists = artist.similar.artist;
        similarArtists.forEach(function(a, index) {
            var sa = topArtist.createObject();
            if (index > 0) {
                sa.margin.leftOffset = ui.du(0.5);
            }
            sa.name = a.name;
            sa.image = a.image.filter(function(i) {
                return i.size === "large";
            })[0]["#text"];
            similarContainer.add(sa);
        });
    }
    
    function setTopTracks(tracks) {
        _artist.topTracksLoaded.disconnect(root.setTopTracks);
        var sorted = tracks.sort(function(a, b) {
            return a.listeners < b.listeners;
        });
        var maxListeners = sorted[0].listeners;
        sorted.forEach(function(t, index) {
            var ttli = topTrackListItem.createObject();
            ttli.number = index + 1;
            ttli.name = t.name;
            ttli.listeners = t.listeners;
            ttli.maxListeners = maxListeners;
            topTracksMainContainer.add(ttli);  
        });
    }
    
    function getImage(size) {
        var img = root.images.filter(function(i) {
            return i.size === size;
        })[0];
        return img === undefined ? "" : img["#text"];
    }
}