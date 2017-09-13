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

#include "applicationui.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>

#include <Qt/qdeclarativedebug.h>
#include <QtCore/QTimer>

#include "lastfm/TrackController.hpp"
#include "lastfm/UserController.hpp"
#include "lastfm/ArtistController.hpp"
#include "lastfm/TagController.hpp"
#include "services/ImageService.hpp"

using namespace bb::cascades;
using namespace bb::lastfm::controllers;

Q_DECL_EXPORT int main(int argc, char **argv) {
    qmlRegisterType<QTimer>("chachkouski.util", 1, 0, "Timer");
    qRegisterMetaType<TrackController*>("TrackController*");
    qRegisterMetaType<UserController*>("UserController*");
    qRegisterMetaType<ArtistController*>("ArtistController*");
    qRegisterMetaType<TagController*>("TagController*");
    qRegisterMetaType<ImageService*>("ImageService*");
    qmlRegisterUncreatableType<TrackController>("lastFM.controllers", 1, 0, "TrackController", "test");
    qmlRegisterUncreatableType<UserController>("lastFM.controllers", 1, 0, "UserController", "test");
    qmlRegisterUncreatableType<ArtistController>("lastFM.controllers", 1, 0, "ArtistController", "test");
    qmlRegisterUncreatableType<ArtistController>("lastFM.controllers", 1, 0, "TagController", "test");

    Application app(argc, argv);
    ApplicationUI appui;
    return Application::exec();
}
