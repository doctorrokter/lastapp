import bb.cascades 1.4
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
    property string bio: ""
    
    signal tagChosen(string tag)
    signal trackChosen(string name, string mbid)

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
                        title: qsTr("Info") + Retranslate.onLocaleOrLanguageChanged
                        bio: root.bio
                    }  
                    
                    Divider {}
                    
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
    
    onCreationCompleted: {
        _track.infoLoaded.connect(root.setTrack);
    }
    
    onNameChanged: {
        _track.getInfo(root.name, root.artist.name, root.mbid, _app.prop("lastfm_name"));
    }
    
    onImagesChanged: {
        avatar.image = _imageService.getImage(root.images, "large");
        backgroundImage.image = _imageService.getImage(root.images, "extralarge");
        backgroundImage.maxHeight = mainLUH.layoutFrame.height / 2;
        backgroundImage.maxWidth = mainLUH.layoutFrame.width;
    }
    
    function setTrack(track) {
        if (track !== undefined) {
            root.listeners = track.listeners || 0;
            root.playcount = track.playcount || 0;
            root.tags = track.toptags || [];
            if (track.wiki !== undefined) {
                bioContainer.bio = track.wiki.content;
            }
            if (track.album !== undefined) {
                root.images = track.album.image;
            }
        }
    }
    
    function cleanUp() {
        _track.infoLoaded.disconnect(root.setTrack);
    }
}
