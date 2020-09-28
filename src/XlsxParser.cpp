#include "XlsxParser.hpp"

#include "TitleHeaders.hpp"

#include <QtDebug>
#include <xlsx/xlsxdocument.h>

XlsxParser::XlsxParser(InOutParameter &&parameter) :
    Parser{ std::move(parameter) }
{
}

std::pair<Translations, QString> XlsxParser::parse() const
{
    QXlsx::Document xlsx(m_ioParameter.inputFile);
    const auto lastColumn = xlsx.dimension().lastColumn();
    if (xlsx.read(1, 1) != TitleHeader::Context ||
        xlsx.read(1, 2) != TitleHeader::Source ||
        //        xlsx.read(1, 3) != TitleHeader::Translation ||
        xlsx.read(1, lastColumn) != TitleHeader::Location) {
        qWarning() << "the xlsx file is not valid";
        return std::make_pair(Translations(),
                              "Invalid XLSX file, check the headers!");
    }

    Translations translations;
    TranslationContext context;
    TranslationMessage msg;
    m_languages++;
    const auto lastRow = xlsx.dimension().lastRow();

    for (auto row = 2; row <= lastRow; ++row) {
        context.name = xlsx.read(row, 1).toString();
        msg.source   = xlsx.read(row, 2).toString();

        //        msg.translations.at(m_languages - 1) =
        //            xlsx.read(row, m_languages).toString();
        //        QTextStream(stdout) << "Ts: " << m_languages << endl;

        //        for (int i = 3; i < lastColumn - 1; i++) {
        if (m_languages - 1 < lastColumn) {
            const auto loc = xlsx.read(row, m_languages - 1).toString();

            msg.translations.emplace_back(m_languages - 1, loc);
        }
        //        }

        // fix this
        for (auto col = lastColumn; col <= lastColumn; ++col) {
            const auto loc = xlsx.read(row, col).toString();

            auto list = loc.split(QStringLiteral(" - "));
            msg.locations.emplace_back(
                std::make_pair(list.first(), list.last().toInt()));
        }

        auto it =
            std::find_if(translations.begin(), translations.end(),
                         [&](const auto &c) { return c.name == context.name; });
        if (it == translations.end()) {
            context.messages.clear();
            context.messages.emplace_back(msg);
            translations.emplace_back(context);
        } else {
            context.messages.emplace_back(msg);
            translations.at(std::distance(translations.begin(), it)) = context;
        }
        msg.locations.clear();
        msg.translations.clear();
    }

    return std::make_pair(translations, "");
}
