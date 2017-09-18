/*
 * TrackController.hpp
 *
 *  Created on: Jun 30, 2017
 *      Author: misha
 */

#ifndef TRACKCONTROLLER_HPP_
#define TRACKCONTROLLER_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include "../Logger.hpp"
#include <bb/system/SystemToast>

using namespace bb::system;

namespace bb {
    namespace lastfm {
        namespace controllers {
class TrackController: public QObject {
    Q_OBJECT
public:
    TrackController(QObject* parent = 0);
    virtual ~TrackController();

    Q_INVOKABLE void updateNowPlaying(const QString& artist, const QString& track);
    Q_INVOKABLE void scrobble(const QString& artist, const QString& track, const int& timestamp);
    Q_INVOKABLE void love(const QString& artist, const QString& track);
    Q_INVOKABLE void unlove(const QString& artist, const QString& track);
    Q_INVOKABLE void getInfo(const QString& track, const QString& artist, const QString& mbid = "", const QString& username = "", const int& autocorrect = 1);

    Q_SIGNALS:
        void nowPlayingUpdated();
        void scrobbled();
        void loved(const QString& artist, const QString& track);
        void unloved(const QString& artist, const QString& track);
        void infoLoaded(const QVariantMap& track);

private slots:
    void onNowPlayingUpdated();
    void onScrobbled();
    void onLoved();
    void onUnloved();
    void onInfoLoaded();
    void onError(QNetworkReply::NetworkError e);

private:
    static Logger logger;
    QNetworkAccessManager* m_pNetwork;
    SystemToast m_toast;
};
        }
    }
}

#endif /* TRACKCONTROLLER_HPP_ */
