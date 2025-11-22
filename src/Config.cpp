#include "Config.h"

#include <SimpleIni.h>

namespace
{
    const char* DEFAULT_SECTION = Version::PROJECT.data();
}

namespace Placement
{
    Config::Config() :
        ConfigBase(Version::PROJECT, INI_PATH, IDR_CONFIG_INI) {}

    void Config::loadIniConfigInternal(const CSimpleIniA& ini)
    {
        // TODO: load config from ini
        myConfigValue = static_cast<float>(ini.GetDoubleValue(DEFAULT_SECTION, "fMyConfigValue", 3.0));
    }
}
