import bb.cascades 1.4

Container {
    id: root
    
    property string title: "Similar"
    property variant artists: []
    
    signal artistChosen(string name, string mbid)
    
    horizontalAlignment: HorizontalAlignment.Fill
    
    Container {
        leftPadding: ui.du(2)
        rightPadding: ui.du(2)
        
        Label {
            text: root.title
            textStyle.base: SystemDefaults.TextStyles.PrimaryText
            textStyle.fontWeight: FontWeight.Bold
        }
    }
    
    ScrollView {
        margin.topOffset: ui.du(2)
        scrollViewProperties.scrollMode: ScrollMode.Horizontal
        
        Container {
            id: artistsContainer
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        }
    }
    
    attachedObjects: [
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
    
    onArtistsChanged: {
        artists.forEach(function(a, index) {
            var ta = topArtist.createObject();
            if (index > 0) {
                ta.margin.leftOffset = ui.du(0.5);
            }
            ta.name = a.name;
            ta.image = _imageService.getImage(a.image, "large");
            artistsContainer.add(ta);
        });
    }
}
