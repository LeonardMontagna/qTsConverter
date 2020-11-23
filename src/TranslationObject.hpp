#pragma once

#include <QString>
#include <vector>
// struct TranslationHeader {
//    QString language;
//};

struct TranslationMessage {
    QString source;
    QString translation;
    std::vector<std::pair<int, QString>> translations;
    // QString language;
    std::vector<std::pair<QString, int>> locations;
};

struct TranslationContext {
    QString name;
    QString language;
    std::vector<TranslationMessage> messages;
};

using Translations = std::vector<TranslationContext>;