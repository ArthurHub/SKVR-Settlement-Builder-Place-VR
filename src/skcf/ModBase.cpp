#include "ModBase.h"

#include <cpptrace/from_current.hpp>
#include <fmt/chrono.h>

// #include "Debug.h"
// #include "MainLoopHook.h"
// #include "common/Logger.h"
// #include "f4vr/PlayerNodes.h"
// #include "f4vr/VRControllersManager.h"

namespace skcf
{
    ModBase::Settings::Settings(const std::string_view& name, const std::string_view& version, ConfigBase* config) :
        name(name),
        version(version),
        config(config),
        logFileName(name) {}

    ModBase::Settings::Settings(const std::string_view& name, const std::string_view& version, ConfigBase* config, const int trampolineAllocationSize,
        const bool setupMainGameLoop) :
        name(name),
        version(version),
        config(config),
        logFileName(name),
        trampolineAllocationSize(trampolineAllocationSize),
        setupMainGameLoop(setupMainGameLoop) {}

    ModBase::Settings::Settings(const std::string_view& name, const std::string_view& version, ConfigBase* config, const std::string_view& logFileName,
        const int trampolineAllocationSize, const bool setupMainGameLoop) :
        name(name),
        version(version),
        config(config),
        logFileName(logFileName),
        trampolineAllocationSize(trampolineAllocationSize),
        setupMainGameLoop(setupMainGameLoop) {}

    ModBase::ModBase(Settings settings) :
        _settings(std::move(settings))
    {
        if (g_mod) {
            throw std::runtime_error("mod already initialized for " + g_mod->_settings.name);
        }
        g_mod = this;
    }

    /**
     * Run F4SE plugin query to check compatibility and fill out plugin info.
     */
    bool ModBase::onF4SEPluginQuery(const SKSE::QueryInterface* skse, SKSE::PluginInfo* info) const
    {
        bool success = false;
        CPPTRACE_TRY
            {
                logger::init(_settings.logFileName);
                logPluginGameStart();

                info->infoVersion = SKSE::PluginInfo::kVersion;
                info->name = _settings.name.c_str();
                std::string tmp = _settings.version;
                std::erase(tmp, '.');
                info->version = std::stoi(tmp);

                if (skse->IsEditor()) {
                    logger::critical("Loaded in editor, marking as incompatible");
                    // ReSharper disable once CppUnreachableCode
                } else if (skse->RuntimeVersion() < SKSE::RUNTIME_LATEST) {
                    logger::critical("Unsupported runtime version {}", skse->RuntimeVersion().string());
                } else {
                    logger::info("F4SE Plugin Query v{} compatible: {} v{}", skse->SKSEVersion(), info->name, info->version);
                    success = true;
                }
            }
        CPPTRACE_CATCH(const std::exception& ex) {
            const auto stacktrace = cpptrace::from_current_exception().to_string();
            logger::error("Unhandled exception: {}\n{}", ex.what(), stacktrace);
        }
        return success;
    }

    /**
     * Run F4SE plugin load and initialize the plugin given the init handle.
     * Handle any exceptions and log them.
     */
    bool ModBase::onF4SEPluginLoad(const SKSE::LoadInterface* f4se)
    {
        bool success = false;
        CPPTRACE_TRY
            {
                logger::info("Init CommonLibF4 F4SE...");
                SKSE::Init(f4se, false);

                logger::info("Init config...");
                _settings.config->load();

                logger::info("Register F4SE messages...");
                _messaging = SKSE::GetMessagingInterface();
                _messaging->RegisterListener(onF4VRSEMessage);

                // allocate enough space for patches and hooks
                SKSE::AllocTrampoline(_settings.trampolineAllocationSize);

                logger::info("Load Mod...");
                onModLoaded(f4se);

                logger::info("Load successful");
                success = true;
            }
        CPPTRACE_CATCH(const std::exception& ex) {
            const auto stacktrace = cpptrace::from_current_exception().to_string();
            logger::error("Unhandled exception: {}\n{}", ex.what(), stacktrace);
        }
        return success;
    }

    /**
     * Runs on every game frame, main logic goes here.
     * Handle any exceptions and log them.
     */
    void ModBase::onFrameUpdateSafe()
    {
        CPPTRACE_TRY
            {
                // f4vr::VRControllers.update(f4vr::isLeftHandedMode());

                onFrameUpdate();

                checkDebugDump();
            }
        CPPTRACE_CATCH(const std::exception& ex) {
            const auto stacktrace = cpptrace::from_current_exception().to_string();
            logger::critical("Error in onFrameUpdate: {}\n{}", ex.what(), stacktrace);
            throw;
        }
    }

    void ModBase::logPluginGameStart() const
    {
        // const auto game = REL::Module::IsVR() ? "Fallout4VR" : "Fallout4";
        const auto game = "Skyrim VR";
        const auto runtimeVer = REL::Module::get().version();
        const auto dateTime = std::chrono::system_clock::now();
        logger::info("Starting '{}' v{} ; {} v{} ; {} ; BaseAddress: 0x{:X}",
            _settings.name, _settings.version, game, runtimeVer.string(), fmt::format("{:%Y-%m-%d %H:%M:%S%Ez}", dateTime), REL::Module::get().base());
    }

    /**
     * F4VRSE messages listener to handle game loaded, new game, and save loaded events.
     */
    // ReSharper disable once CppParameterMayBeConstPtrOrRef
    void ModBase::onF4VRSEMessage(SKSE::MessagingInterface::Message* msg)
    {
        if (!msg) {
            return;
        }

        if (msg->type == SKSE::MessagingInterface::kPreLoadGame) {
            // One time event fired after all plugins are loaded and game is full in main menu
            logger::info("F4VRSE On Game Loaded Message...");
            g_mod->onGameLoadedInner();
        }

        if (msg->type == SKSE::MessagingInterface::kPostLoadGame || msg->type == SKSE::MessagingInterface::kNewGame) {
            // If a game is loaded or a new game started re-initialize FRIK for clean slate
            logger::info("F4VRSE On Post Load Message...");
            g_mod->onGameSessionLoadedInner();
        }
    }

    /**
     * On game fully loaded initialize things that should be initialized only once.
     */
    void ModBase::onGameLoadedInner()
    {
        CPPTRACE_TRY
            {
                if (_settings.setupMainGameLoop) {
                    // main_hook::hook();
                }

                onGameLoaded();
            }
        CPPTRACE_CATCH(const std::exception& ex) {
            const auto stacktrace = cpptrace::from_current_exception().to_string();
            logger::critical("Error in onGameLoaded: {}\n{}", ex.what(), stacktrace);
            throw;
        }
    }

    /**
     * Game session can be initialized multiple times as it is fired on new game and save loaded events.
     * We should clear and reload as much of the game state as we can.
     */
    void ModBase::onGameSessionLoadedInner()
    {
        CPPTRACE_TRY
            {
                if (_settings.setupMainGameLoop) {
                    // main_hook::validate();
                }

                // f4vr::VRControllers.reset();

                logger::info("Reload config...");
                _settings.config->load();

                onGameSessionLoaded();
            }
        CPPTRACE_CATCH(const std::exception& ex) {
            const auto stacktrace = cpptrace::from_current_exception().to_string();
            logger::critical("Error in onGameSessionLoaded: {}\n{}", ex.what(), stacktrace);
            throw;
        }
    }

    /**
     * Dump game data if requested in "sDebugDumpDataOnceNames" flag in INI config.
     */
    void ModBase::checkDebugDump() const
    {
        // if (_settings.config->checkDebugDumpDataOnceFor("all_nodes")) {
        //     dump::printAllNodes();
        // }
        // if (_settings.config->checkDebugDumpDataOnceFor("pipboy")) {
        //     dump::printNodes(f4vr::getPlayerNodes()->PipboyRoot_nif_only_node);
        // }
        // if (_settings.config->checkDebugDumpDataOnceFor("world")) {
        //     dump::printNodes(f4vr::getPlayerNodes()->primaryWeaponScopeCamera->parent->parent->parent->parent->parent->parent);
        // }
        // if (_settings.config->checkDebugDumpDataOnceFor("fp_skelly")) {
        //     dump::printNodes(f4vr::getFirstPersonSkeleton());
        // }
        // if (_settings.config->checkDebugDumpDataOnceFor("skelly")) {
        //     dump::printNodes(f4vr::getRootNode()->parent);
        // }
        // if (_settings.config->checkDebugDumpDataOnceFor("geometry")) {
        //     dump::dumpPlayerGeometry();
        // }
    }
}
