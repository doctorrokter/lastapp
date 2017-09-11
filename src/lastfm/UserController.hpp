/*
 * UserController.hpp
 *
 *  Created on: Aug 13, 2017
 *      Author: misha
 */

#ifndef USERCONTROLLER_HPP_
#define USERCONTROLLER_HPP_

#include <QObject>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantList>
#include "../Logger.hpp"

namespace bb {
    namespace lastfm {
        namespace controllers {
            class UserController: public QObject {
                Q_OBJECT
            public:
                UserController(QObject* parent = 0);
                virtual ~UserController();

                Q_INVOKABLE void getRecentTracks(const QString& user, const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void getTopArtists(const QString& user, const int& page = 1, const int& limit = 50, const QString& period = "overall");
                Q_INVOKABLE void getTopAlbums(const QString& user, const int& page = 1, const int& limit = 50, const QString& period = "overall");
                Q_INVOKABLE void getTopTracks(const QString& user, const int& page = 1, const int& limit = 50, const QString& period = "overall");
                Q_INVOKABLE void getFriends(const QString& user, const int& page = 1, const int& limit = 50);

                Q_SIGNALS:
                    void recentTracksLoaded(const QVariantList& recentTracks);
                    void topArtistsLoaded(const QVariantList& topArtists, const QString& period);
                    void topAlbumsLoaded(const QVariantList& topAlbums, const QString& period);
                    void topTracksLoaded(const QVariantList& topTracks, const QString& period);
                    void friendsLoaded(const QVariantList& friends);

            private slots:
                void onRecentTracksLoaded();
                void onTopArtistsLoaded();
                void onTopAlbumsLoaded();
                void onTopTracksLoaded();
                void onFriendsLoaded();
                void onError(QNetworkReply::NetworkError error);

            private:
                QNetworkAccessManager* m_pNetwork;

                static Logger logger;
            };

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */

#endif /* USERCONTROLLER_HPP_ */
