import bb.cascades 1.4
import chachkouski.util 1.0
import "../components"

Page {
    id: root
    
    property string mbid: ""
    property string name: ""
    property variant artist: {
        name: ""
    }
    property int listeners: 0
    property int playcount: 0
    property int userplaycount: 0
    property variant tags: []
    property variant images: []
    property variant tracks: []
    property string bio: ""
    
    signal tagChosen(string tag)
    signal artistChosen(string name, string mbid)
    signal trackChosen(string name, string mbid, variant artist)
    
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
            
            PageGradient {}
            
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
                        
                        Label {
                            id: artistName
                            text: root.artist.name
                            textStyle.base: SystemDefaults.TextStyles.PrimaryText
                        }
                    }
                    
                    Divider {}
                    
                    Stats {
                        playcount: root.playcount
                        listeners: root.listeners
                        userplaycount: root.userplaycount
                    }
                    
                    Divider {}
                    
                    TagsContainer {
                        tags: root.tags
                        
                        onChosen: {
                            root.tagChosen(name);
                        }
                    }
                    
                    BioContainer {
                        id: bioContainer
                        bio: root.bio
                    }  
                    
                    Divider {}
                    
                    Container {
                        id: topTracksContainer
                        
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Container {
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                            
                            Label {
                                text: qsTr("Tracks") + Retranslate.onLocaleOrLanguageChanged
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
                        id: header
                        
                        title: root.artist.name + " " + (qsTr("page...") + Retranslate.onLocaleOrLanguageChanged)
                        mode: HeaderMode.Interactive
                        
                        onClicked: {
                            root.artistChosen(root.artist.name, root.artist.mbid);
                        }
                    }
                    
                    Container {
                        minHeight: ui.du(12)
                        horizontalAlignment: HorizontalAlignment.Fill
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
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: albumTrackListItem
            AlbumTrackListItem {
                onTrackChosen: {
                    root.trackChosen(name, mbid, artist);
                }
            }
        }
    ]
    
    onCreationCompleted: {
        _album.infoLoaded.connect(root.setAlbum);
//        _album.error.connect(root.error);
    }
    
    onNameChanged: {
        _album.getInfo(root.artist.name, root.name, root.mbid, 1, _app.prop("lastfm_name"), _lang);
    }
    
    onArtistChanged: {
        header.title = artist.name + " " + (qsTr("page...") + Retranslate.onLocaleOrLanguageChanged);
        artistName.text = artist.name;
    }
    
    onImagesChanged: {
        avatar.image = _imageService.getImage(root.images, "large");
        backgroundImage.image = _imageService.getImage(root.images, "extralarge");
        backgroundImage.maxHeight = mainLUH.layoutFrame.height / 2;
        backgroundImage.maxWidth = mainLUH.layoutFrame.width;
    }
    
    onTracksChanged: {
        tracks.forEach(function(tr, index) {
            var atli = albumTrackListItem.createObject();
            atli.name = tr.name;    
            atli.number = index + 1;
            atli.artist = root.artist;
            topTracksMainContainer.add(atli);
        });
    }
    
    function error() {
//        spinner.stop();
    }
    
    function setAlbum(album) {
        _album.infoLoaded.disconnect(root.setAlbum);
        root.mbid = album.mbid || "";
        root.name = album.name;
        root.playcount = album.playcount;
        root.listeners = album.listeners;
        root.userplaycount = album.userplaycount || 0;
        root.tags = album.tags.tag;
        root.images = album.image;
        root.tracks = album.tracks.track;
        root.bio = album.wiki === undefined ? "" : album.wiki.content;
    }
}
