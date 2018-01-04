/*
 * TagController.hpp
 *
 *  Created on: Sep 12, 2017
 *      Author: misha
 */

#ifndef TAGCONTROLLER_HPP_
#define TAGCONTROLLER_HPP_

#include <QObject>
#include <QNetworkAccessmanager>
#include <QNetworkReply>
#include <bb/cascades/QmlDocument>
#include "../Logger.hpp"

using namespace bb::cascades;

namespace bb {
    namespace lastfm {
        namespace controllers {

            class TagController: public QObject {
                Q_OBJECT
            public:
                TagController(QObject* parent = 0);
                virtual ~TagController();

                Q_INVOKABLE void getTopArtists(const QString& tag, const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void getTopAlbums(const QString& tag, const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void getTopTracks(const QString& tag, const int& page = 1, const int& limit = 50);

                void setAccessToken(const QString& accessToken);

                Q_SIGNALS:
                    void chartLoaded(const QVariantList& chartData);
                    void error();

            private slots:
                void onLoad();
                void onError(QNetworkReply::NetworkError e);

            private:
                QNetworkAccessManager* m_pNetwork;
                static Logger logger;
                QString m_accessToken;

                void invoke(const QString& method, const QString& tag, const int& page, const int& limit);
                void prepareChartData(const QVariantList& source, QVariantList& chartData, const QString& type);
            };

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */

#endif /* TAGCONTROLLER_HPP_ */
