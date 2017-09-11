/*
 * ChartController.hpp
 *
 *  Created on: Sep 10, 2017
 *      Author: misha
 */

#ifndef CHARTCONTROLLER_HPP_
#define CHARTCONTROLLER_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantList>
#include "../Logger.hpp"

namespace bb {
    namespace lastfm {
        namespace controllers {

            class ChartController: public QObject {
                Q_OBJECT
            public:
                ChartController(QObject* parent = 0);
                virtual ~ChartController();

                Q_INVOKABLE void getTopArtists(const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void getTopTracks(const int& page = 1, const int& limit = 50);
                Q_INVOKABLE void getTopTags(const int& page = 1, const int& limit = 50);

                Q_SIGNALS:
                    void chartLoaded(const QVariantList& chartData);

            private slots:
                void onLoad();
                void onError(QNetworkReply::NetworkError e);

            private:
                static Logger logger;
                QNetworkAccessManager* m_pNetwork;

                void invoke(const QString& method, const int& page = 1, const int& limit = 50);
                void prepareChartData(const QVariantList& source, QVariantList& chartData, const QString& type);
            };

        } /* namespace controllers */
    } /* namespace lastfm */
} /* namespace bb */

#endif /* CHARTCONTROLLER_HPP_ */
