import bb.cascades 1.4

ScrollView {
    id: scrollView
    
    property variant tags: []
    
    horizontalAlignment: HorizontalAlignment.Fill
    scrollViewProperties.scrollMode: ScrollMode.Horizontal
    
    Container {
        id: root
        
        margin.topOffset: ui.du(2)
        leftPadding: ui.du(2)
        
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        onCreationCompleted: {
            addTags(tags);
        }
    }
    
    onTagsChanged: {
        addTags(tags);
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: tag
            Tag {}
        }
    ]
    
    function addTags(tags) {
        tags.forEach(function(t, index) {
                var tagObj = tag.createObject();
                tagObj.name = t.name;
                tagObj.url = t.url;
                if (index > 0) {
                    tagObj.leftMargin = ui.du(1);
                }
                root.add(tagObj);
        });
    }
}

