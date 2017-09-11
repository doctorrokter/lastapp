/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import "pages"

TabbedPane {
    id: tabbedPane

    showTabsOnActionBar: false
    
    activePane: scrobblesPane
    
    Menu.definition: MenuDefinition {
        settingsAction: SettingsActionItem {
            onTriggered: {
                var sp = settingsPage.createObject();
                tabbedPane.activePane.push(sp);
                Application.menuEnabled = false;
            }
        }
        
        helpAction: HelpActionItem {
            onTriggered: {
                var hp = helpPage.createObject();
                tabbedPane.activePane.push(hp);
                Application.menuEnabled = false;
            }
        }
    }

    Tab {
        title: qsTr("Scrobbles") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_all.png"
        
        onTriggered: {
            tabbedPane.changePane(scrobblesPane);
        }
    }
    
    Tab {
        title: qsTr("Top Artists") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_favorite.png" 
        
        onTriggered: {
            tabbedPane.changePane(topArtistsPane);
        }   
    }
    
    Tab {
        title: qsTr("Top Albums") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_cd.png"
        
        onTriggered: {
            tabbedPane.changePane(topAlbumsPane);
        } 
    }
    
    Tab {
        title: qsTr("Top Tracks") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_concerts.png"
        
        onTriggered: {
            tabbedPane.changePane(topTracksPane);
        }
    }
    
    Tab {
        title: qsTr("Charts") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_chart.png"
        
        onTriggered: {
            tabbedPane.changePane(chartsPane);
        }
    }
    
    Tab {
        title: qsTr("My Profile") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_contact.png"
        
        onTriggered: {
            tabbedPane.changePane(myProfilePane);
        }
    }
    
    Tab {
        title: qsTr("Friends") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_groups_white.png"
        
        onTriggered: {
            tabbedPane.changePane(friendsPane);
        }
    }
    
    function changePane(pane) {
        if (tabbedPane.activePane.at(0).clear !== undefined) {
            tabbedPane.activePane.at(0).clear();
        }
        tabbedPane.activePane = pane;
        if (tabbedPane.activePane.at(0).init !== undefined) {
            tabbedPane.activePane.at(0).init();
        }
    }
        
    attachedObjects: [
        NavigationPane {
            id: scrobblesPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            ScrobblesPage {}    
        },
        
        NavigationPane {
            id: topArtistsPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            TopArtistsPage {
                onArtistChosen: {
                    var ap = artistPage.createObject();
                    ap.name = name;
                    ap.mbid = mbid;
                    tabbedPane.activePane.push(ap);
                }
            }
        },
        
        NavigationPane {
            id: topAlbumsPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            TopAlbumsPage {}
        },
        
        NavigationPane {
            id: topTracksPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            TopTracksPage {}
        },
        
        NavigationPane {
            id: chartsPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            ChartsPage {
                onArtistChosen: {
                    var ap = artistPage.createObject();
                    ap.name = name;
                    ap.mbid = mbid;
                    tabbedPane.activePane.push(ap);
                }
            }
        },
        
        NavigationPane {
            id: myProfilePane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            MyProfilePage {}
        },
        
        NavigationPane {
            id: friendsPane
            
            onPopTransitionEnded: {
                Application.menuEnabled = true;
                if (page.cleanUp !== undefined) {
                    page.cleanUp();
                }
                page.destroy();
            }
            
            FriendsPage {}
        },
        
        ComponentDefinition {
            id: artistPage
            ArtistPage {
                onArtistTopTracksRequested: {
                    var attp = artistTopTracksPage.createObject();
                    attp.name = name;
                    attp.mbid = mbid;
                    tabbedPane.activePane.push(attp);
                }
                
                onArtistChosen: {
                    var ap = artistPage.createObject();
                    ap.name = name;
                    ap.mbid = mbid;
                    tabbedPane.activePane.push(ap);
                }
            }
        },
        
        ComponentDefinition {
            id: artistTopTracksPage
            ArtistTopTracks {}
        },
        
        ComponentDefinition {
            id: settingsPage
            SettingsPage {}
        },
        
        ComponentDefinition {
            id: helpPage
            HelpPage {}
        }
        
    ]
}