/*
 * AlbumController.hpp
 *
 *  Created on: Sep 13, 2017
 *      Author: misha
 */

#ifndef ALBUMCONTROLLER_HPP_
#define ALBUMCONTROLLER_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantMap>
#include "../Logger.hpp"

namespace bb {
    namespace lastfm {
        namespace controllers {

            class AlbumController: public QObject {
                Q_OBJECT
            public:
                AlbumController(QObject* parent = 0);
                virtual ~AlbumController();

                Q_INVOKABLE void getInfo(const QString& artist, const QString& album, const QString& mbid = "", const int& autocorrect = 1, const QString& username = "", const QString& lang = "en");
                Q_INVOKABLE void search(const QString& album, const int& page = 1, const int& limit = 50);

                void setAccessToken(const QString& accessToken);

                Q_SIGNALS:
                    void infoLoaded(const QVariantMap& info);
                    void searchLoaded(const QVariantList& searchResult);
                    void error();

            private slots:
                void onInfoLoaded();
                void onSearchLoaded();
                void onError(QNetworkReply::NetworkError e);

            private:
                static Logger logger;
                QNetworkAccessManager* m_pNetwork;
                QString m_accessToken;
            };

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */

#endif /* ALBUMCONTROLLER_HPP_ */
