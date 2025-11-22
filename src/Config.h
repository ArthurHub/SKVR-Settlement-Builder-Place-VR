#pragma once

#include "Resources.h"
#include "skcf/ConfigBase.h"

namespace Placement
{
    static const auto BASE_PATH = GAME_BASE_PATH + "\\" + std::string(Version::PROJECT);
    static const auto INI_PATH = BASE_PATH + "\\" + std::string(Version::PROJECT) + ".ini";

    class Config : public ConfigBase
    {
    public:
        explicit Config();

        // Mod configs
        float myConfigValue = 0.0f;

    protected:
        virtual void loadIniConfigInternal(const CSimpleIniA& ini) override;
    };

    // Global singleton for easy access
    inline Config g_config;
}
