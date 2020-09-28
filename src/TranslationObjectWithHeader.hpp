#pragma once

#include <QString>
#include <vector>
struct TranslationHeader {
    QString language;
};

struct TranslationMessage {
    QString source;
    QString translation;
    std::vector<std::pair<QString, int>> locations;
};

struct TranslationContext {
    QString name;
    std::vector<TranslationMessage> messages;
    TranslationHeader language;
};

using TranslationsHeader = std::vector<TranslationContext>;
