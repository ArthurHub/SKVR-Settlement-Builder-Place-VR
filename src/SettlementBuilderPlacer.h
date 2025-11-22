#pragma once

#include "Config.h"
#include "skcf/ModBase.h"

namespace Placement
{
    class SettlementBuilderPlacer : public ModBase
    {
    public:
        SettlementBuilderPlacer();

    protected:
        virtual void onModLoaded(const SKSE::LoadInterface* skse) override;
        virtual void onGameLoaded() override;
        virtual void onGameSessionLoaded() override;
        virtual void onFrameUpdate() override;

    private:
    };

    // The ONE global to rule them ALL
    inline SettlementBuilderPlacer g_myMod;
}
