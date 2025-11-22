#include "SettlementBuilderPlacer.h"

#include "Papyrus.h"

// This is the entry point to the mod.
extern "C" DLLEXPORT bool SKSEAPI SKSEPlugin_Query(const SKSE::QueryInterface* a_skse, SKSE::PluginInfo* a_info)
{
    return g_mod->onSKSEPluginQuery(a_skse, a_info);
}

// This is the entry point to the mod.
extern "C" DLLEXPORT bool SKSEAPI SKSEPlugin_Load(const SKSE::LoadInterface* a_skse)
{
    return g_mod->onSKSEPluginLoad(a_skse);
}

namespace Placement
{
    SettlementBuilderPlacer::SettlementBuilderPlacer() :
        ModBase(Settings(
            Version::PROJECT,
            Version::NAME,
            &g_config,
            32,
            false)) {}

    /**
     * Run SKSE plugin load and initialize the plugin given the init handle.
     */
    void SettlementBuilderPlacer::onModLoaded(const SKSE::LoadInterface*)
    {
        SKSE::GetPapyrusInterface()->Register(Papyrus::RegisterFuncs);
    }

    /**
     * On game fully loaded initialize things that should be initialized only once.
     */
    void SettlementBuilderPlacer::onGameLoaded()
    {
        //noop
    }

    /**
     * Game session can be initialized multiple times as it is fired on new game and save loaded events.
     */
    void SettlementBuilderPlacer::onGameSessionLoaded()
    {
        //noop
    }

    /**
     * On every frame if player is initialized.
     */
    void SettlementBuilderPlacer::onFrameUpdate()
    {
        const auto player = RE::PlayerCharacter::GetSingleton();
        if (!player || !player->loadedData) {
            logger::sample(3000, "no player data - noop");
            return;
        }

        // TODO: add logic
    }
}
