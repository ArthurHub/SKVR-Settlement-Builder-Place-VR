#include "Papyrus.h"

#include "Placement.h"
#include "RE/T/TESObjectREFR.h"

namespace Papyrus
{
    void LivePlace(RE::StaticFunctionTag*, RE::TESObjectREFR* a_refr, const float faceRotation, const float yMult, const float zOffset, const float xOffset)
    {
        if (!a_refr) {
            // Handle null reference
            SKSE::log::warn("Live place null ref!");
            return;
        }

        logger::info("Start live place handle for '{}': Rot({:.2f}), Mult({:.2f}), Offset({:.2f}, {:.2f})", a_refr->GetName(), faceRotation, yMult, zOffset, xOffset);
        Placement::StartLivePlace(a_refr, faceRotation, yMult, zOffset, xOffset);
    }

    bool RegisterFuncs(RE::BSScript::IVirtualMachine* a_vm)
    {
        if (!a_vm) {
            logger::error("Papyrus - couldn't get VMState");
            return false;
        }

        logger::debug("Registering Papyrus functions...");
        a_vm->RegisterFunction("LivePlace", "SBPlaceVR"sv, LivePlace);

        logger::info("Papyrus functions registered successfully");
        return true;
    }
}
