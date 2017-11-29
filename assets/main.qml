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
        
        actions: [
            ActionItem {
                id: rateAppAction
                
                title: qsTr("Rate app") + Retranslate.onLocaleOrLanguageChanged
                imageSource: "asset:///images/ic_blackberry.png"
                
                onTriggered: {
                    _appConfig.set("app_rated", "true");
                    bbwInvoke.trigger(bbwInvoke.query.invokeActionId);
                }
            },
            
            ActionItem {
                title: qsTr("Send feedback") + Retranslate.onLocaleOrLanguageChanged
                imageSource: "asset:///images/ic_feedback.png"
                
                onTriggered: {
                    invokeFeedback.trigger(invokeFeedback.query.invokeActionId);
                }
            }
        ]
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
        title: qsTr("Loved Tracks") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/heart_filled.png"
        
        onTriggered: {
            tabbedPane.changePane(lovedTracksPane);
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
        title: qsTr("Search") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/ic_search.png"
        
        onTriggered: {
            tabbedPane.changePane(searchPane);
        }
    }
    
//    Tab {
//        title: qsTr("Bookmarks") + Retranslate.onLocaleOrLanguageChanged
//        imageSource: "asset:///images/ic_add_bookmarks.png"
//        
//        onTriggered: {
//            tabbedPane.changePane(bookmarksPane);
//        }
//    }
    
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
        Invocation {
            id: invokeFeedback
            query {
                uri: "mailto:lastapp.bbapp@gmail.com?subject=Last.app:%20Feedback"
                invokeActionId: "bb.action.SENDEMAIL"
                invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            }
        },
        
        Invocation {
            id: bbwInvoke
            query {
                uri: "appworld://content/60004635"
                invokeActionId: "bb.action.OPEN"
                invokeTargetId: "sys.appworld"
            }
        },
        
        NavigationPane {
            id: scrobblesPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            ScrobblesPage {
                onTrackChosen: {
                    tabbedPane.openTrackPage(name, mbid, artist);
                }
            }    
        },
        
        NavigationPane {
            id: topArtistsPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            TopArtistsPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }
            }
        },
        
        NavigationPane {
            id: topAlbumsPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            TopAlbumsPage {
                onAlbumChosen: {
                    tabbedPane.openAlbumPage(artist, name, mbid);
                }
            }
        },
        
        NavigationPane {
            id: topTracksPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            TopTracksPage {
                onTrackChosen: {
                    tabbedPane.openTrackPage(name, mbid, artist);
                }
            }
        },
        
        NavigationPane {
            id: lovedTracksPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            LovedTracksPage {
                onTrackChosen: {
                    tabbedPane.openTrackPage(name, mbid, artist);
                }
            }  
        },
        
        NavigationPane {
            id: searchPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            SearchPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }    
                
                onAlbumChosen: {
                    tabbedPane.openAlbumPage(artist, name, mbid);
                }
                
                onTrackChosen: {
                    tabbedPane.openTrackPage(name, mbid, artist);
                }
            }     
        },
        
        NavigationPane {
            id: chartsPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            ChartsPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }
                
                onTagChosen: {
                    tabbedPane.openTagPage(tag);
                }
            }
        },
        
        NavigationPane {
            id: bookmarksPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            BookmarksPage {}    
        },
        
        NavigationPane {
            id: myProfilePane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            MyProfilePage {}
        },
        
        NavigationPane {
            id: friendsPane
            
            onPopTransitionEnded: {
                tabbedPane.popPage(page);
            }
            
            FriendsPage {
                onUserChosen: {
                    var up = userPage.createObject();
                    up.name = user;
                    tabbedPane.activePane.push(up);
                }
            }
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
                    tabbedPane.openArtistPage(name, mbid);
                }
                
                onTagChosen: {
                    tabbedPane.openTagPage(tag);
                }
            }
        },
        
        ComponentDefinition {
            id: artistTopTracksPage
            ArtistTopTracks {}
        },
        
        ComponentDefinition {
            id: tagPage
            TagPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }
                
                onAlbumChosen: {
                    tabbedPane.openAlbumPage(artist, name, mbid);
                }
            }
        },
        
        ComponentDefinition {
            id: albumPage
            AlbumPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }    
                
                onTagChosen: {
                    tabbedPane.openTagPage(tag);
                }
                
                onTrackChosen: {
                    tabbedPane.openTrackPage(name, mbid, artist);
                }
            }
        },
        
        ComponentDefinition {
            id: trackPage
            TrackPage {
                onTagChosen: {
                    tabbedPane.openTagPage(tag);
                }
            }    
        },
        
        ComponentDefinition {
            id: userPage
            UserPage {
                onArtistChosen: {
                    tabbedPane.openArtistPage(name, mbid);
                }
            }
        },
        
        ComponentDefinition {
            id: settingsPage
            SettingsPage {}
        },
        
        ComponentDefinition {
            id: helpPage
            HelpPage {
                onChangelogPageRequested: {
                    var cp = changelogPage.createObject();
                    tabbedPane.activePane.push(cp);
                }
            }
        },
        
        ComponentDefinition {
            id: changelogPage
            ChangelogPage {}
        }
    ]
    
    function openTrackPage(name, mbid, artist) {
//        var tp = trackPage.createObject();
//        tp.mbid = mbid;
//        tp.name = name;
//        tp.artist = artist;
//        tabbedPane.activePane.push(tp);
    }
    
    function popPage(page) {
        Application.menuEnabled = true;
        if (page.cleanUp !== undefined) {
            page.cleanUp();
        }
        page.destroy();
    }
    
    function openAlbumPage(artist, name, mbid) {
        var ap = albumPage.createObject();
        ap.artist = artist;
        ap.mbid = mbid;
        ap.name = name;
        tabbedPane.activePane.push(ap);
    }
    
    function openArtistPage(name, mbid) {
        var ap = artistPage.createObject();
        ap.name = name;
        ap.mbid = mbid;
        tabbedPane.activePane.push(ap);
    }
    
    function openTagPage(tag) {
        var tp = tagPage.createObject();
        tp.tag = tag;
        tabbedPane.activePane.push(tp);
    }
}