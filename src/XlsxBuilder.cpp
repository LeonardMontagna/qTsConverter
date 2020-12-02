#include "XlsxBuilder.hpp"

#include "TitleHeaders.hpp"

#include <QTextStream>
#include <QtDebug>

// TODO: Fix bug where using Ts2Xlsx qtsconverter multiple times results in an
// excel table with duplicate values

XlsxBuilder::XlsxBuilder(InOutParameter parameter) :
    Builder{ std::move(parameter) }
{
    if (!m_ioParameter.outputFile.endsWith("xlsx")) {
        m_ioParameter.outputFile += ".xlsx";
    }
}

bool XlsxBuilder::build(const Translations &trs) const
{
    xlsx.write(1, 1, TitleHeader::Context);
    xlsx.write(1, 2, TitleHeader::Source);
    xlsx.write(1, m_ioParameter.lang, TitleHeader::Location);

    int row{ 2 };
    int col{ 1 };
    for (const auto &tr : trs) {
        xlsx.write(1, m_ioParameter.lang - 1, tr.language);

        for (const auto &msg : tr.messages) {
            if (m_ioParameter.lang > 4) {
                xlsx.write(row, col++, tr.name);
                xlsx.write(row, col++, msg.source);
            }
            xlsx.write(row, m_ioParameter.lang - 1, msg.translation);

            for (const auto &loc : msg.locations) {
                xlsx.write(
                    row, m_ioParameter.lang,
                    QString(loc.first + " - " + QString::number(loc.second)));
            }
            ++row;
            col = 1;
        }
    }

    if (!xlsx.saveAs(m_ioParameter.outputFile)) {
        qWarning() << "error writing file";
        return false;
    }

    return true;
}
