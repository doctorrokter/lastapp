/*
 * AlbumController.cpp
 *
 *  Created on: Sep 13, 2017
 *      Author: misha
 */

#include "AlbumController.hpp"
#include <bb/cascades/QmlDocument>
#include "LastFMCommon.hpp"
#include <QUrl>
#include <QNetworkRequest>
#include <bb/data/JsonDataAccess>
#include "LastFM.hpp"

using namespace bb::cascades;
using namespace bb::data;

namespace bb {
    namespace lastfm {
        namespace controllers {

            Logger AlbumController::logger = Logger::getLogger("AlbumController");

            AlbumController::AlbumController(QObject* parent) : QObject(parent) {
                m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
            }

            AlbumController::~AlbumController() {}

            void AlbumController::getInfo(const QString& artist, const QString& album, const QString& mbid, const int& autocorrect, const QString& username, const QString& lang) {
                QUrl url = LastFM::defaultUrl(ALBUM_GET_INFO);
                if (mbid.isEmpty()) {
                    url.addQueryItem("artist", artist);
                    url.addQueryItem("album", album);
                } else {
                    url.addQueryItem("mbid", mbid);
                }
                url.addQueryItem("autocorrect", QString::number(autocorrect));
                if (!username.isEmpty()) {
                    url.addQueryItem("username", username);
                }
                url.addQueryItem("lang", lang);

                logger.info(url);

                QNetworkRequest req;
                req.setUrl(url);

                QNetworkReply* reply = m_pNetwork->get(req);
                bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onInfoLoaded()));
                Q_ASSERT(res);
                res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
                Q_ASSERT(res);
                Q_UNUSED(res);
            }

            void AlbumController::onInfoLoaded() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    JsonDataAccess jda;
                    QVariantMap album = jda.loadFromBuffer(reply->readAll()).toMap().value("album").toMap();
                    emit infoLoaded(album);
                }

                reply->deleteLater();
            }

            void AlbumController::search(const QString& album, const int& page, const int& limit) {
                QUrl url = LastFM::defaultUrl(ALBUM_SEARCH);
                url.addQueryItem("page", QString::number(page));
                url.addQueryItem("limit", QString::number(limit));
                url.addQueryItem("album", album);

                logger.info(url);

                QNetworkRequest req;
                req.setUrl(url);

                QNetworkReply* reply = m_pNetwork->get(req);
                bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onSearchLoaded()));
                Q_ASSERT(res);
                res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
                Q_ASSERT(res);
                Q_UNUSED(res);
            }

            void AlbumController::onSearchLoaded() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    JsonDataAccess jda;
                    QVariantList albums = jda.loadFromBuffer(reply->readAll()).toMap().value("results").toMap().value("albummatches").toMap().value("album").toList();
                    emit searchLoaded(albums);
                }

                reply->deleteLater();
            }

            void AlbumController::onError(QNetworkReply::NetworkError e) {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
                logger.error(e);
                logger.error(reply->errorString());
                reply->deleteLater();
                emit error();
            }

            void AlbumController::setAccessToken(const QString& accessToken) {
                m_accessToken = accessToken;
            }
        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */
