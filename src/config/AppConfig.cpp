/*
 * AppConfig.cpp
 *
 *  Created on: Jan 17, 2017
 *      Author: misha
 */

#include "AppConfig.hpp"
#include <QUrl>
#include <QDir>
#include <QDebug>

AppConfig* AppConfig::m_pAppConfig = new AppConfig;

AppConfig::AppConfig(QObject* parent) : QObject(parent) {
    m_publicAssetsPath = QUrl("file://" + QDir::currentPath() + "/app/public").toString();
}

AppConfig::~AppConfig() {}

AppConfig* AppConfig::instance() {
    return m_pAppConfig;
}

QVariant AppConfig::get(const QString name) const {
    return m_settings.value(name, "");
}

void AppConfig::set(const QString name, const QVariant value) {
    m_settings.setValue(name, value);
    emit settingsChanged();
}

QString AppConfig::getPublicAssets() const { return m_publicAssetsPath; }
