/*
 * ChartController.cpp
 *
 *  Created on: Sep 10, 2017
 *      Author: misha
 */

#include "ChartController.hpp"
#include "../lastfm/LastFMCommon.hpp"
#include <bb/cascades/QmlDocument>
#include <QNetworkRequest>
#include <QUrl>
#include <bb/data/JsonDataAccess>
#include <QVariantMap>
#include "LastFM.hpp"

using namespace bb::cascades;
using namespace bb::data;

namespace bb {
    namespace lastfm {
        namespace controllers {

            Logger ChartController::logger = Logger::getLogger("ChartController");

            ChartController::ChartController(QObject* parent) : QObject(parent) {
                m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
            }

            ChartController::~ChartController() {}

            void ChartController::getTopArtists(const int& page, const int& limit) {
                invoke(CHART_GET_TOP_ARTISTS, page, limit);
            }

            void ChartController::getTopTracks(const int& page, const int& limit) {
                invoke(CHART_GET_TOP_TRACKS, page, limit);
            }

            void ChartController::getTopTags(const int& page, const int& limit) {
                invoke(CHART_GET_TOP_TAGS, page, limit);
            }

            void ChartController::invoke(const QString& method, const int& page, const int& limit) {
                QUrl url = LastFM::defaultUrl(method);
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

            void ChartController::onLoad() {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

                if (reply->error() == QNetworkReply::NoError) {
                    QString method = reply->property("method").toString();
                    JsonDataAccess jda;
                    QVariantMap response = jda.loadFromBuffer(reply->readAll()).toMap();
                    QVariantList chartData;
                    if (method.compare(QString(CHART_GET_TOP_ARTISTS)) == 0) {
                        QVariantList artists = response.value("artists").toMap().value("artist").toList();
                        prepareChartData(artists, chartData, "artist");
                    } else if (method.compare(QString(CHART_GET_TOP_TAGS)) == 0) {
                        QVariantList tags = response.value("tags").toMap().value("tag").toList();
                        prepareChartData(tags, chartData, "tag");
                    } else {
                        QVariantList tracks = response.value("tracks").toMap().value("track").toList();
                        prepareChartData(tracks, chartData, "track");
                    }
                    emit chartLoaded(chartData);
                }

                reply->deleteLater();
            }

            void ChartController::onError(QNetworkReply::NetworkError e) {
                QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
                logger.error(e);
                logger.error(reply->errorString());
                reply->deleteLater();
                emit error();
            }

            void ChartController::prepareChartData(const QVariantList& source, QVariantList& chartData, const QString& type) {
                foreach(QVariant var, source) {
                    QVariantMap map = var.toMap();
                    map["type"] = type;
                    chartData.append(map);
                }
            }

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */
