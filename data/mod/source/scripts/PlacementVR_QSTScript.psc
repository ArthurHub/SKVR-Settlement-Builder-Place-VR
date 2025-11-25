Scriptname PlacementVR_QSTScript extends Quest

; local copies of PapyrusVR event types
int Property PVREvent_Touched  = 0 AutoReadOnly
int Property PVREvent_Untouched = 1 AutoReadOnly
int Property PVREvent_Pressed   = 2 AutoReadOnly
int Property PVREvent_Released  = 3 AutoReadOnly

Event OnInit()
    ; make sure we get VR button events every time the quest starts
    PapyrusVR.UnregisterForVRButtonEvents(Self)
    Utility.Wait(1.5)
    PapyrusVR.RegisterForVRButtonEvents(Self)
EndEvent

Event OnPlayerLoadGame()
    ; re-register on load in case events were lost
    PapyrusVR.UnregisterForVRButtonEvents(Self)
    Utility.Wait(1.5)
    PapyrusVR.RegisterForVRButtonEvents(Self)
EndEvent

Event OnVRButtonEvent(int eventType, int buttonId, int deviceId)
    ; react to VR button presses without any prior bind
    if eventType == PVREvent_Pressed
        ; placement logic goes here
        ; if you want only trigger:
        ; if buttonId == 33 ; k_EButton_SteamVR_Trigger in your PapyrusVR
        ;     ; do placement
        ; endif
    endif
EndEvent