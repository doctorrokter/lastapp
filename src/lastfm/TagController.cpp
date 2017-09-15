/*
 * TagController.cpp
 *
 *  Created on: Sep 12, 2017
 *      Author: misha
 */

#include "TagController.hpp"
#include <QUrl>
#include <QNetworkRequest>
#include "LastFMCommon.hpp"
#include <bb/data/JsonDataAccess>
#include "LastFM.hpp"

using namespace bb::data;

namespace bb {
    namespace lastfm {
        namespace controllers {

            Logger TagController::logger = Logger::getLogger("TagController");

            TagController::TagController(QObject* parent) : QObject(parent) {
                m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
            }

            TagController::~TagController() {}

            void TagController::getTopArtists(const QString& tag, const int& page, const int& limit) {
                invoke(TAG_GET_TOP_ARTISTS, tag, page, limit);
            }

            void TagController::getTopAlbums(const QString& tag, const int& page, const int& limit) {
                invoke(TAG_GET_TOP_ALBUMS, tag, page, limit);
            }

            void TagController::getTopTracks(const QString& tag, const int& page, const int& limit) {
                invoke(TAG_GET_TOP_TRACKS, tag, page, limit);
            }

            void TagController::invoke(const QString& method, const QString& tag, const int& page, const int& limit) {
                QUrl url = LastFM::defaultUrl(method);
                url.addQueryItem("tag", tag);
                url.addQueryItem("page", QString::number(page));
                url.addQueryItem("limit", QString::number(limit));

                logger.info(url);

                QNetworkRequest req;
                req.setUrl(url);

                QNetworkReply* reply = m_pNetwork->get(req);
                reply->setProperty("method", method);

                bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onLoad()));
                Q_ASSERT(res);
                res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
                Q_ASSERT(res);
                Q_UNUSED(res);
            }

            void TagController::onLoad() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    QString method = reply->property("method").toString();
                    JsonDataAccess jda;
                    QVariantMap response = jda.loadFromBuffer(reply->readAll()).toMap();
                    QVariantList chartData;
                    if (method.compare(QString(TAG_GET_TOP_ARTISTS)) == 0) {
                        QVariantList artists = response.value("topartists").toMap().value("artist").toList();
                        prepareChartData(artists, chartData, "artist");
                    } else if (method.compare(QString(TAG_GET_TOP_ALBUMS)) == 0) {
                        QVariantList albums = response.value("albums").toMap().value("album").toList();
                        prepareChartData(albums, chartData, "album");
                    } else {
                        QVariantList tracks = response.value("tracks").toMap().value("track").toList();
                        prepareChartData(tracks, chartData, "track");
                    }
                    emit chartLoaded(chartData);
                }

                reply->deleteLater();
            }

            void TagController::onError(QNetworkReply::NetworkError e) {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
                logger.error(e);
                logger.error(reply->errorString());
                reply->deleteLater();
            }

            void TagController::prepareChartData(const QVariantList& source, QVariantList& chartData, const QString& type) {
                foreach(QVariant var, source) {
                    QVariantMap map = var.toMap();
                    map["type"] = type;
                    chartData.append(map);
                }
            }

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */
