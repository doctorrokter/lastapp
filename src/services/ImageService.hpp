/*
 * ImageService.hpp
 *
 *  Created on: Aug 27, 2017
 *      Author: misha
 */

#ifndef IMAGESERVICE_HPP_
#define IMAGESERVICE_HPP_

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QVariantList>
#include "../Logger.hpp"

class ImageService: public QObject {
    Q_OBJECT
public:
    ImageService(QObject* parent = 0);
    virtual ~ImageService();

    Q_INVOKABLE void loadImage(const QString& remotePath);
    Q_INVOKABLE QString getImage(const QVariantList& images, const QString& size);

    Q_SIGNALS:
        void imageLoaded(const QString& remotePath, const QString& localPath);

private slots:
    void onImageLoaded();
    void onError(QNetworkReply::NetworkError e);

private:
    QNetworkAccessManager* m_pNetwork;

    static Logger logger;
};

#endif /* IMAGESERVICE_HPP_ */
