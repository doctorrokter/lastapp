/*
 * ArtistController.hpp
 *
 *  Created on: Aug 29, 2017
 *      Author: misha
 */

#ifndef ARTISTCONTROLLER_HPP_
#define ARTISTCONTROLLER_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantMap>
#include "../Logger.hpp"

namespace bb {
    namespace lastfm {
        namespace controllers {
            class ArtistController: public QObject {
                Q_OBJECT
            public:
                ArtistController(QObject* parent = 0);
                virtual ~ArtistController();

                Q_INVOKABLE void getInfo(const QString& artist, const QString& mbid = "", const QString& lang = "en", const int& autocorrect = 1, const QString username = "");
                Q_INVOKABLE void getTopTracks(const QString& artist, const QString& mbid = "", const int& autocorrect = 1, const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void search(const QString& artist, const int& page = 1, const int& limit = 50);

                Q_SIGNALS:
                    void infoLoaded(const QVariantMap& info);
                    void topTracksLoaded(const QVariantList& topTracks);
                    void searchLoaded(const QVariantList& searchResult);
                    void error();

            private slots:
                void onInfoLoaded();
                void onTopTracksLoaded();
                void onSearchLoaded();
                void onError(QNetworkReply::NetworkError e);

            private:
                QNetworkAccessManager* m_pNetwork;

                static Logger logger;
            };

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */

#endif /* ARTISTCONTROLLER_HPP_ */
