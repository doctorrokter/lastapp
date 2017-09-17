/*
 * ImageService.cpp
 *
 *  Created on: Aug 27, 2017
 *      Author: misha
 */

#include "ImageService.hpp"
#include <QUrl>
#include <QNetworkRequest>
#include <QStringList>
#include <QVariantMap>
#include <QDir>
#include <QFile>
#include "../Common.hpp"
#include <bb/cascades/QmlDocument>

using namespace bb::cascades;

ImageService::ImageService(QObject* parent) : QObject(parent) {
    m_pNetwork = QmlDocument::defaultDeclarativeEngine()->networkAccessManager();
}

ImageService::~ImageService() {
    m_pNetwork->deleteLater();
}

Logger ImageService::logger = Logger::getLogger("ImageService");

void ImageService::loadImage(const QString& remotePath) {
    if (remotePath.compare("") == 0) {
        emit imageLoaded(remotePath, remotePath);
    } else {
        QString remotePathCopy = remotePath;
        QString filename = remotePathCopy.split("/").last();

        QString localPath = QDir::currentPath().append(IMAGES_LOCATION).append("/").append(filename);
        QFile img(localPath);
        if (img.exists()) {
            emit imageLoaded(remotePath, QString("file://").append(localPath));
        } else {
            QUrl url(remotePath);

            QNetworkRequest req;
            req.setUrl(url);

            logger.info(url);

            QNetworkReply* reply = m_pNetwork->get(req);
            reply->setProperty("remote_path", remotePath);
            reply->setProperty("local_path", localPath);
            reply->setProperty("filename", filename);

            bool res = QObject::connect(reply, SIGNAL(finished()), this, SLOT(onImageLoaded()));
            Q_ASSERT(res);
            res = QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
            Q_ASSERT(res);
            Q_UNUSED(res);
        }
    }
}

void ImageService::onImageLoaded() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    if (reply->error() == QNetworkReply::NoError) {
        QString remotePath = reply->property("remote_path").toString();
        QString localPath = reply->property("local_path").toString();
        QString filename = reply->property("filename").toString();

        logger.info("Create file: " + localPath);

        QFile file(localPath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(reply->readAll());
            file.close();
            emit imageLoaded(remotePath, QString("file://").append(localPath));
        } else {
            logger.error(file.errorString());
            emit imageLoaded(remotePath, "");
        }
    }

    reply->deleteLater();
}

QString ImageService::getImage(const QVariantList& images, const QString& size) {
    foreach(QVariant imgVar, images) {
        QVariantMap imgMap = imgVar.toMap();
        if (imgMap.value("size").toString() == size) {
            return imgMap.value("#text", "").toString();
        }
    }
    return "";
}

void ImageService::onError(QNetworkReply::NetworkError e) {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    logger.error(e);
    logger.error(reply->errorString());
    reply->deleteLater();
}
