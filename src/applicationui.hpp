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

#ifndef ApplicationUI_HPP_
#define ApplicationUI_HPP_

#include <QObject>
#include <QNetworkConfigurationManager>
#include <bb/system/SystemToast>
#include "lastfm/LastFM.hpp"
#include "services/ImageService.hpp"
#include "Logger.hpp"
#include <bb/multimedia/NowPlayingController>

namespace bb
{
    namespace cascades
    {
        class LocaleHandler;
    }
}

class QTranslator;

using namespace bb::cascades;
using namespace bb::system;
using namespace bb::multimedia;
using namespace bb::lastfm;

/*!
 * @brief Application UI object
 *
 * Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class ApplicationUI : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool online READ isOnline NOTIFY onlineChanged)
public:
    ApplicationUI();
    virtual ~ApplicationUI();

    Q_INVOKABLE void toast(const QString& message);
    bool isOnline() const;

    Q_SIGNALS:
        void onlineChanged(const bool& online);

private slots:
    void onSystemLanguageChanged();
    void storeAccessToken(const QString& name, const QString& accessToken);
    void onOnlineChanged(bool online);
    void nowPlayingChanged(QVariantMap metadata);

private:
    QTranslator* m_pTranslator;
    LocaleHandler* m_pLocaleHandler;
    QNetworkConfigurationManager* m_pNetworkConf;
    SystemToast* m_pToast;

    LastFM* m_pLastFM;
    ImageService* m_pImageService;
    bool m_online;

    NowPlayingController* m_pNpc;

    static Logger logger;

    void renderLogin();
    void renderMain();
};

#endif /* ApplicationUI_HPP_ */
