/*
 * TrackController.cpp
 *
 *  Created on: Jun 30, 2017
 *      Author: misha
 */

#define API_NAMESPACE "track"

#include "TrackController.hpp"
#include "LastFMCommon.hpp"
#include "../config/AppConfig.hpp"
#include <QUrl>
#include <QCryptographicHash>
#include <QDebug>
#include <bb/cascades/QmlDocument>
#include "LastFM.hpp"
#include <bb/data/JsonDataAccess>

using namespace bb::cascades;
using namespace bb::data;

namespace bb {
    namespace lastfm {
        namespace controllers {

            Logger TrackController::logger = Logger::getLogger("TrackController");

TrackController::TrackController(QObject* parent) : QObject(parent) {
    m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
}

TrackController::~TrackController() {
    m_pNetwork->deleteLater();
}

void TrackController::updateNowPlaying(const QString& artist, const QString& track) {
    QNetworkRequest req;

    QUrl url(API_ROOT);
    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    QString sk = AppConfig::instance()->get(LAST_FM_KEY).toString();
    QString sig = QString("api_key").append(API_KEY)
                .append("artist").append(artist.toUtf8())
                .append("method").append(TRACK_UPDATE_NOW_PLAYING)
                .append("sk").append(sk)
                .append("track").append(track.toUtf8())
                .append(SECRET);
    QString hash = QCryptographicHash::hash(sig.toAscii(), QCryptographicHash::Md5).toHex();

    QUrl body = LastFM::defaultBody(TRACK_UPDATE_NOW_PLAYING);
    body.addQueryItem("artist", artist.toUtf8());
    body.addQueryItem("track", track.toUtf8());
    body.addQueryItem("sk", sk);
    body.addQueryItem("api_sig", hash);

    logger.info(url);
    logger.info(body);

    QNetworkReply* reply = m_pNetwork->post(req, body.encodedQuery());
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onNowPlayingUpdated()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void TrackController::onNowPlayingUpdated() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << reply->readAll() << endl;
    }

    reply->deleteLater();
}

void TrackController::scrobble(const QString& artist, const QString& track, const int& timestamp) {
    QNetworkRequest req;

    QUrl url(API_ROOT);
    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    QString sk = AppConfig::instance()->get(LAST_FM_KEY).toString();
    QString sig = QString("api_key").append(API_KEY)
                    .append("artist").append(artist.toUtf8())
                    .append("method").append(TRACK_SCROBBLE)
                    .append("sk").append(sk)
                    .append("timestamp").append(QString::number(timestamp))
                    .append("track").append(track.toUtf8())
                    .append(SECRET);
    QString hash = QCryptographicHash::hash(sig.toAscii(), QCryptographicHash::Md5).toHex();

    QUrl body = LastFM::defaultBody(TRACK_SCROBBLE);
    body.addQueryItem("artist", artist.toUtf8());
    body.addQueryItem("track", track.toUtf8());
    body.addQueryItem("timestamp", QString::number(timestamp));
    body.addQueryItem("sk", sk);
    body.addQueryItem("api_sig", hash);

    logger.info(url);
    logger.info(body);

    QNetworkReply* reply = m_pNetwork->post(req, body.encodedQuery());
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onScrobbled()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void TrackController::love(const QString& artist, const QString& track) {
    QNetworkRequest req;

    QUrl url(API_ROOT);
    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    QString sk = AppConfig::instance()->get(LAST_FM_KEY).toString();
    QString sig = QString("api_key").append(API_KEY)
                        .append("artist").append(artist.toUtf8())
                        .append("method").append(TRACK_LOVE)
                        .append("sk").append(sk)
                        .append("track").append(track.toUtf8())
                        .append(SECRET);
    QString hash = QCryptographicHash::hash(sig.toAscii(), QCryptographicHash::Md5).toHex();

    QUrl body = LastFM::defaultBody(TRACK_LOVE);
    body.addQueryItem("artist", artist.toUtf8());
    body.addQueryItem("track", track.toUtf8());
    body.addQueryItem("sk", sk);
    body.addQueryItem("api_sig", hash);

    logger.info(url);
    logger.info(body);

    QNetworkReply* reply = m_pNetwork->post(req, body.encodedQuery());
    reply->setProperty("artist", artist);
    reply->setProperty("track", track);
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onLoved()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void TrackController::unlove(const QString& artist, const QString& track) {
    QString sk = AppConfig::instance()->get(LAST_FM_KEY).toString();
    QString sig = QString("api_key").append(API_KEY)
                            .append("artist").append(artist.toUtf8())
                            .append("method").append(TRACK_UNLOVE)
                            .append("sk").append(sk)
                            .append("track").append(track.toUtf8())
                            .append(SECRET);
    QString hash = QCryptographicHash::hash(sig.toAscii(), QCryptographicHash::Md5).toHex();

    QUrl body = LastFM::defaultBody(TRACK_UNLOVE);
    body.addQueryItem("artist", artist.toUtf8());
    body.addQueryItem("track", track.toUtf8());
    body.addQueryItem("sk", sk);
    body.addQueryItem("api_sig", hash);

    QUrl url(API_ROOT);
    QNetworkRequest req;
    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    logger.info(url);
    logger.info(body);

    QNetworkReply* reply = m_pNetwork->post(req, body.encodedQuery());
    reply->setProperty("artist", artist);
    reply->setProperty("track", track);
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onUnloved()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void TrackController::getInfo(const QString& track, const QString& artist, const QString& mbid, const QString& username, const int& autocorrect) {
    QUrl url = LastFM::defaultUrl(TRACK_GET_INFO);
    if (mbid.isEmpty()) {
        url.addQueryItem("track", track);
    } else {
        url.addQueryItem("mbid", mbid);
    }
    url.addQueryItem("artist", artist);
    url.addQueryItem("autocorrect", QString::number(autocorrect));
    if (!username.isEmpty()) {
        url.addQueryItem("username", username);
    }

    QNetworkRequest req;
    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    logger.info(url);

    QNetworkReply* reply = m_pNetwork->get(req);
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onInfoLoaded()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void TrackController::onInfoLoaded() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        JsonDataAccess jda;
        QVariantMap track = jda.loadFromBuffer(reply->readAll()).toMap().value("track").toMap();
        emit infoLoaded(track);
    }

    reply->deleteLater();
}

void TrackController::search(const QString& track, const QString& artist, const int& page, const int& limit) {
    QUrl url = LastFM::defaultUrl(TRACK_SEARCH);
    url.addQueryItem("page", QString::number(page));
    url.addQueryItem("limit", QString::number(limit));
    url.addQueryItem("track", track);
    if (!artist.isEmpty()) {
        url.addQueryItem("artist", artist);
    }

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

void TrackController::onSearchLoaded() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        JsonDataAccess jda;
        QVariantList tracks = jda.loadFromBuffer(reply->readAll()).toMap().value("results").toMap().value("trackmatches").toMap().value("track").toList();
        emit searchLoaded(tracks);
    }

    reply->deleteLater();
}

void TrackController::onScrobbled() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << reply->readAll() << endl;
    }

    reply->deleteLater();
    emit scrobbled();
}

void TrackController::onLoved() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        logger.info(reply->readAll());
        m_toast.setBody(tr("Track loved!"));
        m_toast.show();
        emit loved(reply->property("artist").toString(), reply->property("track").toString());
    }

    reply->deleteLater();
}

void TrackController::onUnloved() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        logger.info(reply->readAll());
        m_toast.setBody(tr("Track unloved"));
        m_toast.show();
        emit unloved(reply->property("artist").toString(), reply->property("track").toString());
    }

    reply->deleteLater();
}

void TrackController::onError(QNetworkReply::NetworkError e) {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    logger.error(e);
    logger.error(reply->errorString());
    reply->deleteLater();
    emit error();
}
        }
    }
}
