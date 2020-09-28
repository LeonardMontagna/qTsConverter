#include "ConverterGuiProxy.hpp"

#include "TitleHeaders.hpp"

#include <QDebug>

ConverterGuiProxy::ConverterGuiProxy(QObject *parent) : QObject(parent) {}

void ConverterGuiProxy::convert(QConversionType type, QStringList input,
                                QString output, const QString &fieldSeparator,
                                const QString &stringSeparator,
                                const QString &tsVersion)
{
    if (type == Xlsx2Ts) {
        for (int i = 0; i < 4; i++) {
            output = QUrl::fromUserInput(output + "i").toLocalFile();
            m_languages++;

            // Remove file:// on linux and file:/// on windows
            foreach (QString inputFile, input) {
                QString fileName = QUrl::fromUserInput(inputFile).toLocalFile();
                QTextStream(stdout) << "Converter: " << m_languages << endl;

                auto converter = ConverterFactory::make_converter(
                    static_cast<ConverterFactory::ConversionType>(type),
                    fileName, output, fieldSeparator, stringSeparator,
                    tsVersion);

                const auto results = converter->process();
                setConversionInfo(results.success, results.message,
                                  results.detailedMessage);
            }
        }
    } else {
        output = QUrl::fromUserInput(output).toLocalFile();

        // Remove file:// on linux and file:/// on windows
        foreach (QString inputFile, input) {
            QString fileName = QUrl::fromUserInput(inputFile).toLocalFile();

            auto converter = ConverterFactory::make_converter(
                static_cast<ConverterFactory::ConversionType>(type), fileName,
                output, fieldSeparator, stringSeparator, tsVersion);

            const auto results = converter->process();
            setConversionInfo(results.success, results.message,
                              results.detailedMessage);
        }
    }
}

bool ConverterGuiProxy::convSuccessfull() const
{
    return m_convSuccessfull;
}

QString ConverterGuiProxy::convMsg() const
{
    return m_convMsg;
}

QString ConverterGuiProxy::detailedConvMsg() const
{
    return m_detailedConvMsg;
}

void ConverterGuiProxy::setConversionInfo(bool convSuccessfull,
                                          const QString &errorMsg,
                                          const QString &detailedConvMsg)
{
    m_convSuccessfull = convSuccessfull;
    m_convMsg         = errorMsg;
    m_detailedConvMsg = detailedConvMsg;
    Q_EMIT conversionCompleted();
}

static_assert(static_cast<int>(ConverterGuiProxy::QConversionType::Dummy) ==
                  static_cast<int>(ConverterFactory::ConversionType::Dummy),
              "enum proxy QConversionType is different than ConversionType");
