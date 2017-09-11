/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/DevelopmentSupport>
#include <bb/cascades/ThemeSupport>

#include "config/AppConfig.hpp"
#include "lastfm/LastFMCommon.hpp"
#include "Common.hpp"
#include <QDir>

using namespace bb::cascades;

Logger ApplicationUI::logger = Logger::getLogger("ApplicationUI");

ApplicationUI::ApplicationUI(): QObject() {
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    m_pLastFM = new LastFM(this);
    m_pImageService = new ImageService(this);
    m_pNetworkConf = new QNetworkConfigurationManager(this);
    m_pToast = new SystemToast(this);

    QString theme = AppConfig::instance()->get("theme").toString();
    if (theme.compare("") != 0) {
        if (theme.compare("DARK") == 0) {
            Application::instance()->themeSupport()->setVisualStyle(VisualStyle::Dark);
        } else {
            Application::instance()->themeSupport()->setVisualStyle(VisualStyle::Bright);
        }
    }

    QString imagesPath = QDir::currentPath().append(IMAGES_LOCATION);
    QDir images(imagesPath);
    if (!images.exists()) {
        logger.info("Create path: " + imagesPath);
        images.mkpath(imagesPath);
    }

    bool res = QObject::connect(m_pLastFM, SIGNAL(accessTokenObtained(const QString&, const QString&)), this, SLOT(storeAccessToken(const QString&, const QString&)));
    Q_ASSERT(res);
    res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()));
    Q_ASSERT(res);
    res = QObject::connect(m_pNetworkConf, SIGNAL(onlineStateChanged(bool)), this, SLOT(onOnlineChanged(bool)));
    Q_ASSERT(res);
    Q_UNUSED(res);

    onSystemLanguageChanged();
    DevelopmentSupport::install();

    QLocale systemLocale;
    QString lang = "en";
    if (systemLocale.language() == QLocale::Russian) {
        lang = "ru";
    }

    QDeclarativeEngine* engine = QmlDocument::defaultDeclarativeEngine();
    QDeclarativeContext* rootContext = engine->rootContext();
    rootContext->setContextProperty("_app", this);
    rootContext->setContextProperty("_appConfig", AppConfig::instance());
    rootContext->setContextProperty("_lastFM", m_pLastFM);
    rootContext->setContextProperty("_user", m_pLastFM->getUserController());
    rootContext->setContextProperty("_artist", m_pLastFM->getArtistController());
    rootContext->setContextProperty("_chart", m_pLastFM->getChartController());
    rootContext->setContextProperty("_imageService", m_pImageService);
    rootContext->setContextProperty("_lang", lang);

    if (AppConfig::instance()->get(LAST_FM_KEY).toString().compare("") == 0) {
        renderLogin();
    } else {
        renderMain();
    }
}

ApplicationUI::~ApplicationUI() {
    m_pTranslator->deleteLater();
    m_pLocaleHandler->deleteLater();
    m_pNetworkConf->deleteLater();
    m_pToast->deleteLater();
    m_pLastFM->deleteLater();
    AppConfig::instance()->deleteLater();
}

void ApplicationUI::onSystemLanguageChanged() {
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    QString locale_string = QLocale().name();
    QString file_name = QString("Lastapp_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}

void ApplicationUI::storeAccessToken(const QString& name, const QString& accessToken) {
    AppConfig::instance()->set(LAST_FM_KEY, accessToken);
    AppConfig::instance()->set(LAST_FM_NAME, name);
    Application::instance()->scene()->deleteLater();
    toast(tr("Logged in as: ") + name);
    renderMain();
}

void ApplicationUI::renderLogin() {
    QmlDocument *qml = QmlDocument::create("asset:///pages/Login.qml").parent(this);
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

void ApplicationUI::renderMain() {
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    AbstractPane *root = qml->createRootObject<AbstractPane>();
    Application::instance()->setScene(root);
}

void ApplicationUI::toast(const QString& message) {
    m_pToast->setBody(message);
    m_pToast->show();
}

bool ApplicationUI::isOnline() const { return m_online; }

void ApplicationUI::onOnlineChanged(bool online) {
    if (m_online != online) {
        m_online = online;
        emit onlineChanged(m_online);
    }
}
