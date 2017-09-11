import bb.cascades 1.4

Page {
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            layout: DockLayout {}
            
            ImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                imageSource: "asset:///images/concert_bg.jpg"
                scalingMethod: ScalingMethod.AspectFill
            }
            
            Container {
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                
                background: Color.Black
                opacity: 0.25
            }
            
            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                
                margin.leftOffset: ui.du(15)
                
                ImageView {
                    horizontalAlignment: HorizontalAlignment.Center
                    imageSource: "asset:///images/Lastfm_logo.png"
                    scalingMethod: ScalingMethod.AspectFit
                    scaleX: 0.5
                    scaleY: 0.5
                }
                
                Label {
                    text: qsTr("Login") + Retranslate.onLocaleOrLanguageChanged
                    textStyle.base: SystemDefaults.TextStyles.PrimaryText
                }
                
                TextField {
                    id: username
                }
                
                Label {
                    text: qsTr("Password") + Retranslate.onLocaleOrLanguageChanged
                    textStyle.base: SystemDefaults.TextStyles.PrimaryText
                }
                
                TextField {
                    id: password
                    inputMode: TextFieldInputMode.Password
                }
                
                Button {
                    horizontalAlignment: HorizontalAlignment.Fill
                    
                    margin.topOffset: ui.du(5)
                    color: ui.palette.primaryBase
                    
                    text: qsTr("Sign in") + Retranslate.onLocaleOrLanguageChanged
                    
                    onClicked: {
                        if (_app.online) {
                            if (!spinner.running) {
                                spinner.start();
                                _lastFM.authenticate(username.text, password.text);
                            }
                        } else {
                            _app.toast(qsTr("No internet connection") + Retranslate.onLocaleOrLanguageChanged);
                        }
                    }
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
}