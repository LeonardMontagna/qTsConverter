#include "XlsxBuilder.hpp"

#include "TitleHeaders.hpp"

#include <QTextStream>
#include <QtDebug>

XlsxBuilder::XlsxBuilder(InOutParameter parameter) :
    Builder{ std::move(parameter) }
{
    if (!m_ioParameter.outputFile.endsWith("xlsx")) {
        m_ioParameter.outputFile += ".xlsx";
    }
}
// QXlsx::Document xlsx;

bool XlsxBuilder::build(const Translations &trs) const
{
    if (!m_ioParameter.outputFile.isNull()) {
        m_locationCol++;
        //        isMultifile = true;

    } else {
        m_locationCol = 4;
    }

    xlsx.write(1, 1, TitleHeader::Context);
    xlsx.write(1, 2, TitleHeader::Source);
    xlsx.write(1, m_locationCol, TitleHeader::Location);

    int row{ 2 };
    int col{ 1 };
    for (const auto &tr : trs) {
        xlsx.write(1, m_locationCol - 1, tr.language);

        for (const auto &msg : tr.messages) {
            if (m_locationCol > 4) {
                xlsx.write(row, col++, tr.name);
                xlsx.write(row, col++, msg.source);
            }
            xlsx.write(row, m_locationCol - 1, msg.translation);

            for (const auto &loc : msg.locations) {
                xlsx.write(
                    row, m_locationCol,
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
    //    m_locationCol = 4;

    return true;
}
