#pragma once
#include <QFile>
#include <QString>
#include <xlsx/xlsxdocument.h>

struct TitleHeader {
    static constexpr char Context[]     = "Context";
    static constexpr char Source[]      = "Source";
    static constexpr char Translation[] = "Translation";
    static constexpr char Location[]    = "Location";
};

static QString Language = "";
static QXlsx::Document xlsx;
static int LanguageColumn = 3;
