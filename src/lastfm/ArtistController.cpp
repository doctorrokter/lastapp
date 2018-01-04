/*
 * ArtistController.cpp
 *
 *  Created on: Aug 29, 2017
 *      Author: misha
 */

#include "ArtistController.hpp"
#include <QUrl>
#include <QNetworkRequest>
#include <bb/data/JsonDataAccess>
#include "LastFMCommon.hpp"
#include <bb/cascades/QmlDocument>
#include "LastFM.hpp"

using namespace bb::cascades;
using namespace bb::data;

namespace bb {
    namespace lastfm {
        namespace controllers {

            Logger ArtistController::logger = Logger::getLogger("ArtistController");

            ArtistController::ArtistController(QObject* parent) : QObject(parent) {
                m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
            }

            ArtistController::~ArtistController() {
                m_pNetwork->deleteLater();
            }

            void ArtistController::getInfo(const QString& artist, const QString& mbid, const QString& lang, const int& autocorrect, const QString username) {
                QUrl url = LastFM::defaultUrl(ARTIST_GET_INFO);
                url.addQueryItem("lang", lang);
                url.addQueryItem("autocorrect", QString::number(autocorrect));

                if (!mbid.isEmpty()) {
                    url.addQueryItem("mbid", mbid);
                } else {
                    url.addQueryItem("artist", artist);
                }

                if (!username.isEmpty()) {
                    url.addQueryItem("username", username);
                }

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

            void ArtistController::onInfoLoaded() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    JsonDataAccess jda;
                    QVariantMap artist = jda.loadFromBuffer(reply->readAll()).toMap().value("artist").toMap();
                    emit infoLoaded(artist);
                }

                reply->deleteLater();
            }

            void ArtistController::getTopTracks(const QString& artist, const QString& mbid, const int& autocorrect, const int& page, const int& limit) {
                QUrl url = LastFM::defaultUrl(ARTIST_GET_TOP_TRACKS);
                url.addQueryItem("page", QString::number(page));
                url.addQueryItem("limit", QString::number(limit));
                url.addQueryItem("autocorrect", QString::number(autocorrect));

                if (!mbid.isEmpty()) {
                    url.addQueryItem("mbid", mbid);
                } else {
                    url.addQueryItem("artist", artist);
                }

                logger.info(url);

                QNetworkRequest req;
                req.setUrl(url);

                QNetworkReply* reply = m_pNetwork->get(req);
                bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onTopTracksLoaded()));
                Q_ASSERT(res);
                res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
                Q_ASSERT(res);
                Q_UNUSED(res);
            }

            void ArtistController::onTopTracksLoaded() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    JsonDataAccess jda;
                    QVariantList topTracks = jda.loadFromBuffer(reply->readAll()).toMap().value("toptracks").toMap().value("track").toList();
                    emit topTracksLoaded(topTracks);
                }

                reply->deleteLater();
            }

            void ArtistController::search(const QString& artist, const int& page, const int& limit) {
                QUrl url = LastFM::defaultUrl(ARTIST_SEARCH);
                url.addQueryItem("page", QString::number(page));
                url.addQueryItem("limit", QString::number(limit));
                url.addQueryItem("artist", artist);

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

            void ArtistController::onSearchLoaded() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    JsonDataAccess jda;
                    QVariantList artists = jda.loadFromBuffer(reply->readAll()).toMap().value("results").toMap().value("artistmatches").toMap().value("artist").toList();
                    emit searchLoaded(artists);
                }

                reply->deleteLater();
            }

            void ArtistController::onError(QNetworkReply::NetworkError e) {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
                logger.error(e);
                logger.error(reply->errorString());
                reply->deleteLater();
                emit error();
            }

            void ArtistController::setAccessToken(const QString& accessToken) {
                m_accessToken = accessToken;
            }

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */
