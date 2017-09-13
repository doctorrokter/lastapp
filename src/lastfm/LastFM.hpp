/*
 * LastFM.hpp
 *
 *  Created on: Jun 29, 2017
 *      Author: misha
 */

#ifndef LASTFM_HPP_
#define LASTFM_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "TrackController.hpp"
#include "UserController.hpp"
#include "ArtistController.hpp"
#include "ChartController.hpp"
#include "TagController.hpp"

using namespace bb::lastfm::controllers;

namespace bb {
    namespace lastfm {

class LastFM: public QObject {
    Q_OBJECT
    Q_PROPERTY(TrackController* track READ getTrackController)
    Q_PROPERTY(UserController* user READ getUserController)
    Q_PROPERTY(ArtistController* artist READ getArtistController)
    Q_PROPERTY(ChartController* chart READ getChartController)
    Q_PROPERTY(TagController* tag READ getTagController)
public:
    LastFM(QObject* parent = 0);
    virtual ~LastFM();

    Q_INVOKABLE void authenticate(const QString& username, const QString& password);

    Q_INVOKABLE TrackController* getTrackController() const;
    Q_INVOKABLE UserController* getUserController() const;
    Q_INVOKABLE ArtistController* getArtistController() const;
    Q_INVOKABLE ChartController* getChartController() const;
    Q_INVOKABLE TagController* getTagController() const;

    Q_SIGNALS:
        void accessTokenObtained(const QString& name, const QString& accessToken);
        void authFinished(const QString& message, const bool& success);

private slots:
    void onAuthenticate();
    void onError(QNetworkReply::NetworkError e);

private:
    QNetworkAccessManager* m_pNetwork;
    TrackController* m_pTrack;
    UserController* m_pUser;
    ArtistController* m_pArtist;
    ChartController* m_pChart;
    TagController* m_pTag;
};
    }
}

#endif /* LASTFM_HPP_ */
