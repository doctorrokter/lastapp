/*
 * LastFM.cpp
 *
 *  Created on: Jun 29, 2017
 *      Author: misha
 */

#include "LastFM.hpp"
#include <QCryptographicHash>
#include <QDebug>
#include <bb/data/JsonDataAccess>
#include <QVariantMap>
#include "LastFMCommon.hpp"
#include <bb/cascades/QmlDocument>

using namespace bb::cascades;
using namespace bb::data;

namespace bb {
    namespace lastfm {

        Logger LastFM::logger = Logger::getLogger("LastFM");

LastFM::LastFM(QObject* parent) : QObject(parent) {
    m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
    m_pTrack = new TrackController(this);
    m_pUser = new UserController(this);
    m_pArtist = new ArtistController(this);
    m_pChart = new ChartController(this);
    m_pTag = new TagController(this);
    m_pAlbum = new AlbumController(this);
}

LastFM::~LastFM() {
    m_pNetwork->deleteLater();
    m_pTrack->deleteLater();
    m_pUser->deleteLater();
    m_pArtist->deleteLater();
    m_pChart->deleteLater();
    m_pTag->deleteLater();
    m_pAlbum->deleteLater();
}

QUrl LastFM::defaultUrl(const QString& method) {
    QUrl url(API_ROOT);
    url.addQueryItem("method", method);
    url.addQueryItem("api_key", API_KEY);
    url.addQueryItem("format", "json");
    return url;
}

QUrl LastFM::defaultBody(const QString& method) {
    QUrl body;
    body.addQueryItem("method", method);
    body.addQueryItem("api_key", API_KEY);
    body.addQueryItem("format", "json");
    return body;
}

void LastFM::authenticate(const QString& username, const QString& password) {
    QNetworkRequest req;

    QUrl url(AUTH_ROOT);

    QByteArray body;
    url.addQueryItem("method", AUTH_METHOD);
    url.addQueryItem("username", username.toUtf8());
    url.addQueryItem("password", password.toUtf8());
    url.addQueryItem("api_key", API_KEY);
    url.addQueryItem("format", "json");

    QString sig = QString("api_key").append(API_KEY).append("method").append(AUTH_METHOD).append("password").append(password).append("username").append(username).append(SECRET);
    QString hash = QCryptographicHash::hash(sig.toAscii(), QCryptographicHash::Md5).toHex();
    url.addQueryItem("api_sig", hash);

    req.setUrl(url);
    req.setRawHeader("Content-Type", "application/x-www-form-urlencoded");

    QNetworkReply* reply = m_pNetwork->post(req, body);
    bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onAuthenticate()));
    Q_ASSERT(res);
    res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
    Q_ASSERT(res);
    Q_UNUSED(res);
}

void LastFM::onAuthenticate() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        JsonDataAccess jda;
        QVariantMap session = jda.loadFromBuffer(reply->readAll()).toMap().value("session").toMap();
        QString name = session.value("name").toString();
        QString key = session.value("key").toString();
        emit accessTokenObtained(name, key);
        emit authFinished(name, true);
    }

    reply->deleteLater();
}

void LastFM::onError(QNetworkReply::NetworkError e) {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    logger.error(e);
    logger.error(reply->errorString());
    reply->deleteLater();
    emit authFinished(reply->errorString(), false);
}

TrackController* LastFM::getTrackController() const { return m_pTrack; }

UserController* LastFM::getUserController() const { return m_pUser; }

ArtistController* LastFM::getArtistController() const { return m_pArtist; }

ChartController* LastFM::getChartController() const { return m_pChart; }

TagController* LastFM::getTagController() const { return m_pTag; }

AlbumController* LastFM::getAlbumController() const { return m_pAlbum; }

    }
}
