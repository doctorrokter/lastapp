import bb.cascades 1.4

Container {
    id: root
    
    signal chosen(string period)
    
    property variant  options: []
    
    background: ui.palette.plainBase
    maxHeight: ui.du(11)
    
    ListView {
        id: periodsListView
        
        dataModel: ArrayDataModel {
            id: periodsDataModel
        }
        
        layout: StackListLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        flickMode: FlickMode.SingleItem
        
        onTriggered: {
            clearSelection();
            select(indexPath, true);
            
            var data = periodsDataModel.data(indexPath);
            root.chosen(data.value);                
        }
        
        listItemComponents: [
            ListItemComponent {
                CustomListItem {
                    id: period
                    
                    property bool selected: ListItem.selected
                    
                    maxWidth: ui.du(23)
                    
                    highlightAppearance: HighlightAppearance.None
                    dividerVisible: false
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        
                        layout: DockLayout {}
                        
                        Container {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            
                            Label {
                                text: ListItemData.title
                                textStyle.base: SystemDefaults.TextStyles.BodyText
                            }
                        }
                        
                        Container {
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Bottom
                            
                            preferredHeight: ui.du(0.5)
                            background: ui.palette.text
                            visible: period.selected
                        }
                    }
                
                }
            }
        ]
        
        onCreationCompleted: {
            periodsDataModel.append(root.options);
        }
    }
    
    function choose(indexPath) {
        periodsListView.triggered(indexPath);
    }
}
