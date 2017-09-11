import bb.cascades 1.4

TitleBar {
    id: root
    
    property ActionItem leftAction
    property ActionItem rightAction
    
    appearance: TitleBarAppearance.Plain
    kind: TitleBarKind.FreeForm
    
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            background: Application.themeSupport.theme.colorTheme.primaryBase
            leftPadding: ui.du(2)
            rightPadding: ui.du(2)
            layout: DockLayout {}
            
            Container {
                id: leftActionContainer
                visible: false
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                
                ImageView {
                    id: leftActionImage
                    maxWidth: ui.du(8)
                    maxHeight: ui.du(8)
                    
                    gestureHandlers: TapHandler {
                        onTapped: {
                            root.leftAction.triggered();
                        }
                    }
                }
            }
            
            Container {
                id: rightActionContainer
                visible: false
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Center
                
                ImageView {
                    id: rightActionImage
                    maxWidth: ui.du(8)
                    maxHeight: ui.du(8)
                    
                    gestureHandlers: TapHandler {
                        onTapped: {
                            root.rightAction.triggered();
                        }
                    }
                }
            }
            
            Container {
                horizontalAlignment: {
                    if (root.leftAction) {
                        return HorizontalAlignment.Center;
                    }
                    return HorizontalAlignment.Left;
                }
                verticalAlignment: VerticalAlignment.Center
                Label {
                    text: title
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                    textStyle.color: ui.palette.textOnPrimary
                }
            }            
        }
    }
    
    onCreationCompleted: {
        if (root.leftAction) {
            leftActionContainer.visible = true;
            leftActionImage.imageSource = root.leftAction.imageSource;
        }
        
        if (root.rightAction) {
            rightActionContainer.visible = true;
            rightActionImage.imageSource = root.rightAction.imageSource;
        }
    }
    
    function changeRightActionImage(imageSource) {
        rightAction.imageSource = imageSource;
        rightActionImage.imageSource = imageSource;
    }  
    
    function leftRightActionImage(imageSource) {
        leftAction.imageSource = imageSource;
        leftActionImage.imageSource = imageSource;
    }  
}
