#include "Placement.h"

#include <cmath>

#include "BoundsUtil.h"
#include "Config.h"
#include "InputBlocker.h"
#include "VRInputHandler.h"
#include "RE/Skyrim.h"
#include "SKSE/SKSE.h"

namespace Placement
{
    static PlacementState g_state;
    constexpr float DISTANCE_STEP = 2.0f; // units per frame per full axis

    static void SendModEvent(std::string_view eventName, std::string_view strArg = "", const float numArg = 0.0f, RE::TESForm* sender = nullptr)
    {
        logger::debug("Send mod event '{}': args({})", eventName, strArg);
        // BSFixedString can be built from const char*
        const SKSE::ModCallbackEvent e{ eventName.data(), strArg.data(), numArg, sender };
        SKSE::GetModCallbackEventSource()->SendEvent(&e);
    }

    static float NormalizeAngle(const float a)
    {
        float d = (a * 180.0f) / std::numbers::pi_v<float>;
        while (d >= 360.0f)
            d -= 360.0f;
        while (d < 0.0f)
            d += 360.0f;
        return (d * std::numbers::pi_v<float>) / 180.0f;
    }

    // simple linear interpolation
    static RE::NiPoint3 Lerp(const RE::NiPoint3& a, const RE::NiPoint3& b, const float t)
    {
        return RE::NiPoint3{ a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t };
    }

    // shortest angular difference in radians
    static float ShortestAngleDiff(const float from, const float to)
    {
        float diff = fmodf(to - from, 2.0f * std::numbers::pi_v<float>);
        if (diff < -std::numbers::pi_v<float>)
            diff += 2.0f * std::numbers::pi_v<float>;
        else if (diff > std::numbers::pi_v<float>)
            diff -= 2.0f * std::numbers::pi_v<float>;
        return diff;
    }

    class PlacementUpdateHandler : public RE::BSTEventSink<RE::MenuOpenCloseEvent>
    {
    public:
        static PlacementUpdateHandler* GetSingleton()
        {
            static PlacementUpdateHandler instance;
            return &instance;
        }

        virtual RE::BSEventNotifyControl ProcessEvent(const RE::MenuOpenCloseEvent* event, RE::BSTEventSource<RE::MenuOpenCloseEvent>* source) override
        {
            // WSActivateRollover even is triggered on every frame
            if (!g_state.active || !g_state.placedRef || event->menuName != "WSActivateRollover") {
                return RE::BSEventNotifyControl::kContinue;
            }

            const auto input = VRInputHandler::GetSingleton();

            // Adjust yaw with triggers
            constexpr float yawStep = 2.5f * std::numbers::pi_v<float> / 180.0f; // 2.5 degrees in radians
            if (input->IsLeftTriggerPressed()) {
                g_state.previewYaw -= yawStep;
            }
            if (input->IsRightTriggerPressed()) {
                g_state.previewYaw += yawStep;
            }

            // Adjust distance with right joystick Y
            const float joyY = input->GetRightJoystickY();
            if (std::abs(joyY) > 0.1f) {
                // Deadzone
                g_state.previewDistance += joyY * DISTANCE_STEP;
                g_state.previewDistance = std::clamp(g_state.previewDistance, 50.0f, 3000.0f); // Clamp to reasonable range
            }

            // Update preview position and rotation
            LivePlace(g_state.placedRef, g_state.previewYaw, g_state.previewDistance);

            // Confirm placement with "A" button
            if (input->IsAButtonPressed()) {
                g_state.placedRef->SetMotionType(RE::hkpMotion::MotionType::kDynamic, true);
                RE::DebugNotification("Item Placed");
                OnPlacementConfirmed(g_state.placedRef);
                g_state.active = false;
                g_state.placedRef = nullptr;
            }

            input->Reset();

            return RE::BSEventNotifyControl::kContinue;
        }

        void LivePlace(RE::TESObjectREFR* a_refr, const float yawOffset, const float distance)
        {
            const auto player = RE::PlayerCharacter::GetSingleton();
            if (!player || !player->RightWandNode)
                return;

            // Get the world transform of the right wand node
            const auto wandNode = player->RightWandNode.get();
            const auto& wandTransform = wandNode->world;

            // The position of the wand in world space
            const auto& wandPos = wandTransform.translate;

            // The forward direction of the wand in world space
            const RE::NiPoint3 localForward{ 0.0f, 0.0f, -1.0f };
            const RE::NiPoint3 worldForward = wandTransform.rotate * localForward;

            RE::NiPoint3 targetPos = wandPos + (worldForward * distance);

            targetPos.x += g_state.previewXoffset;
            targetPos.z += g_state.previewZoffset;

            // Compute yaw so object faces player: yaw = atan2(player.x - obj.x, player.y - obj.y)
            const RE::NiPoint3 playerPos{ player->GetPosition().x, player->GetPosition().y, player->GetPosition().z };
            const float faceYaw = std::atan2(playerPos.x - targetPos.x, playerPos.y - targetPos.y);

            // Apply manual yaw offset (from triggers) on top of facing yaw
            const float targetYaw = faceYaw + yawOffset;

            // Apply smoothing (lerp) toward the instantaneous target
            g_state.currentPreviewPos = Lerp(g_state.currentPreviewPos, targetPos, g_state.positionSmoothAlpha);

            // Smooth yaw using shortest-angle interpolation
            const float angleDiff = ShortestAngleDiff(g_state.currentPreviewYaw, targetYaw);
            g_state.currentPreviewYaw += angleDiff * g_state.rotationSmoothAlpha;

            // Schedule a main-thread task to set the smoothed transform
            RE::NiPoint3 appliedPos = g_state.currentPreviewPos;
            float appliedYaw = g_state.currentPreviewYaw;

            // not sure if we really need a task for this and probably better not to do it on every frame
            logger::sample(3000, "Update object position Pos({:.2f}, {:.2f}, {:.2f}), Yaw({:.2f})", appliedPos.x, appliedPos.y, appliedPos.z, appliedYaw);
            SKSE::GetTaskInterface()->AddTask([a_refr, appliedPos, appliedYaw] {
                a_refr->SetPosition(appliedPos);
                a_refr->SetAngle(RE::NiPoint3{ 0.0f, 0.0f, appliedYaw });
                a_refr->Update3DPosition(true);
            });
        }
    };

    void StartLivePlace(RE::TESObjectREFR* placedRef, const float faceRotation, const float yMult, const float zOffset, const float xOffset)
    {
        if (!placedRef)
            return;

        // Set the placedRef to kKeyframed so physics doesn't interfere during placement)
        placedRef->SetMotionType(RE::hkpMotion::MotionType::kKeyframed, false);

        g_state.placedRef = placedRef;
        g_state.active = true;
        g_state.previewYaw = faceRotation;

        // Reset smoothing state so preview starts from current ref transform
        // initialize currentPreviewPos to the object's current world position if possible
        const auto info = BoundsUtil::GetApproxBounds(placedRef);
        const RE::NiPoint3 curPos = BoundsUtil::SafeSpawnInFrontOfPlayer(info.radius);
        g_state.previewXoffset = xOffset;
        g_state.previewZoffset = zOffset + 150.0f;
        g_state.currentPreviewPos = curPos;
        g_state.currentPreviewYaw = faceRotation;

        auto distance = curPos.GetDistance(RE::PlayerCharacter::GetSingleton()->GetPosition());
        g_state.previewDistance = yMult > 0.0 ? yMult : distance;

        // Register for per-frame updates (using MenuOpenCloseEvent as a simple per-frame hook)
        if (const auto ui = RE::UI::GetSingleton())
            ui->AddEventSink<RE::MenuOpenCloseEvent>(PlacementUpdateHandler::GetSingleton());

        VRInputHandler::Register();
        InputBlocker::EnterEditMode();
        RE::DebugNotification("Live Placement Started");
        logger::info("Live Placement Started for '{}': ID({}), Distance:({:.2f})", placedRef->GetName(), placedRef->GetFormID(), distance);
    }

    void OnPlacementConfirmed(RE::TESObjectREFR* a_refr)
    {
        SKSE::GetTaskInterface()->AddTask([a_refr] { SendModEvent("SBOnPlacementConfirmed", "Done", 0.0f, a_refr); });

        VRInputHandler::UnRegister();
        if (const auto ui = RE::UI::GetSingleton()) {
            ui->RemoveEventSink<RE::MenuOpenCloseEvent>(PlacementUpdateHandler::GetSingleton());
        }

        InputBlocker::ExitEditMode();

        logger::info("Placement Confirmed and Done");
    }
}
