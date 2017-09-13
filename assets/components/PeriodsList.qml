import bb.cascades 1.4

HorizontalList {
    options: [
        {title: qsTr("7 day") + Retranslate.onLocaleOrLanguageChanged, value: "7day"},
        {title: qsTr("1 month") + Retranslate.onLocaleOrLanguageChanged, value: "1month"},
        {title: qsTr("3 month") + Retranslate.onLocaleOrLanguageChanged, value: "3month"},
        {title: qsTr("6 month") + Retranslate.onLocaleOrLanguageChanged, value: "6month"},
        {title: qsTr("12 month") + Retranslate.onLocaleOrLanguageChanged, value: "12month"},
        {title: qsTr("Overall") + Retranslate.onLocaleOrLanguageChanged, value: "overall"}
    ]
}
