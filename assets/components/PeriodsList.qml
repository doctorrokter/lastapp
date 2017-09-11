import bb.cascades 1.4

    Container {
        id: root
        
        signal chosen(string period)
        
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
                var data = [];
                data.push({title: qsTr("7 day") + Retranslate.onLocaleOrLanguageChanged, value: "7day"});
                data.push({title: qsTr("1 month") + Retranslate.onLocaleOrLanguageChanged, value: "1month"});
                data.push({title: qsTr("3 month") + Retranslate.onLocaleOrLanguageChanged, value: "3month"});
                data.push({title: qsTr("6 month") + Retranslate.onLocaleOrLanguageChanged, value: "6month"});
                data.push({title: qsTr("12 month") + Retranslate.onLocaleOrLanguageChanged, value: "12month"});
                data.push({title: qsTr("Overall") + Retranslate.onLocaleOrLanguageChanged, value: "overall"});
                periodsDataModel.append(data);
            }
        }
        
        function choose(indexPath) {
            periodsListView.triggered(indexPath);
        }
    }
