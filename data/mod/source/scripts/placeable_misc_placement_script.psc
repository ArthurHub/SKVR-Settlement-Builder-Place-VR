Scriptname Placeable_MISC_Placement_Script extends ObjectReference

;========= Your original properties =========
Furniture Property Furniture_Item Auto
Activator Property Activator_Item Auto
MiscObject Property Misc_Inventory_Item Auto
Static   Property Static_Item    Auto

float XPos
float yPos
float Zangle
float Property Hight   Auto
float Property Rotation Auto

int Property Distance Auto
ObjectReference Misc_Item
FormList Placeable_A_DeleteAll

;========= New safety/feel toggles =========
Bool  Property IgnorePitch      Auto
Float Property MaxPitchForTan = 60.0 Auto
Float Property PreviewSpeed   = 1000.0 Auto

;========= Facing options =========
Bool  Property FacePlayerDuringPreview = True Auto
Float Property FaceZOffset = 0.0 Auto

;========= Forward distance controls =========
Float Property PreviewDistanceMultiplier = 0.0 Auto
Float Property PreviewDistanceOffset     = 0.0 Auto

;========= Height offset =========
Float Property PreviewHeightOffset       = 0.0 Auto

;========= NEW lateral offset (v1.4) =========
Float Property PreviewLateralOffset      = 0.0 Auto  ; positive = right, negative = left

;========= NEW (v1.5): safe spawn helper =========
Static Property XMarkerHeadingBase Auto ; set to vanilla XMarkerHeading in CK

;========= NEW (smoothing): preview tick interval =========
Float Property PreviewTickSeconds = 0.012 Auto

; ========= Internal: place-on-Activate state (SKSE control event) =========
Bool _placeRequested = False

Event OnInit()
    Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as FormList
EndEvent

Event OnSBOnPlacementConfirmed(string eventName, string strArg, float numArg, Form sender)
    Game.EnablePlayerControls()

    ObjectReference placedRef = sender as ObjectReference

    ; ======= Convert preview -> final (unchanged) =======
    if placedRef
        float fAx = placedRef.GetAngleX()
        float fAy = placedRef.GetAngleY()
        float fAz = placedRef.GetAngleZ()

        ObjectReference finalRef = None

        if Activator_Item
            finalRef = placedRef.PlaceAtMe(Activator_Item)
            if finalRef
                finalRef.MoveTo(placedRef, 0.0, 0.0, 0.0, false)
                finalRef.SetAngle(fAx, fAy, fAz)
                finalRef.SetMotionType(1)
                finalRef.ApplyHavokImpulse(0.0, 0.0, 1.0, 0.0)
            endif

            placedRef.DisableNoWait()
            placedRef.Delete()

            if Placeable_A_DeleteAll && finalRef
                Placeable_A_DeleteAll.AddForm(finalRef)
            endif

            Debug.Notification("Item Placed")
    	    UnRegisterForModEvent("SBOnPlacementConfirmed")
            return
        endif

        placedRef.SetMotionType(1)
        placedRef.ApplyHavokImpulse(0.0, 0.0, 1.0, 0.0)
        Debug.Notification("Item Placed")
    endif


    UnRegisterForModEvent("SBOnPlacementConfirmed")
EndEvent

;=== Drop-to-place: fires when this misc item leaves the player and has no new container (world drop) ===
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Actor playerRef = Game.GetPlayer()

    ; Only care about player -> world (drop)
    if akOldContainer == playerRef && akNewContainer == None

        ; Block dropping while crouched to prevent instant placement (unchanged UX guard)
        if playerRef.IsSneaking()
            playerRef.AddItem(Misc_Inventory_Item, 1, true)
            Debug.Notification("Stand up to start placing.")
            Self.DisableNoWait()
            Self.Delete()
            return
        endif

        ; --- safe temp marker in front/above player ---
        Float spawnDistance = 220.0
        Float spawnUp       = 60.0

        ObjectReference tempMarker = None
        if XMarkerHeadingBase
            tempMarker = playerRef.PlaceAtMe(XMarkerHeadingBase)
        endif

        if tempMarker
            Float angZ = playerRef.GetAngleZ()
            Float xOff = spawnDistance * Math.Sin(angZ)
            Float yOff = spawnDistance * Math.Cos(angZ)
            tempMarker.MoveTo(playerRef, xOff, yOff, spawnUp, false)

            ; preview: prefer Static_Item
            if Static_Item
                Misc_Item = tempMarker.PlaceAtMe(Static_Item)
            elseif Activator_Item
                Misc_Item = tempMarker.PlaceAtMe(Activator_Item)
            elseif Furniture_Item
                Misc_Item = tempMarker.PlaceAtMe(Furniture_Item)
            endif

            tempMarker.DisableNoWait()
            tempMarker.Delete()
        else
            ; fallback (no temp marker)
            if Static_Item
                Misc_Item = playerRef.PlaceAtMe(Static_Item)
            elseif Activator_Item
                Misc_Item = playerRef.PlaceAtMe(Activator_Item)
            elseif Furniture_Item
                Misc_Item = playerRef.PlaceAtMe(Furniture_Item)
            endif

            if Misc_Item
                Float angZ2 = playerRef.GetAngleZ()
                Float xOff2 = spawnDistance * Math.Sin(angZ2)
                Float yOff2 = spawnDistance * Math.Cos(angZ2)
                Misc_Item.DisableNoWait()
                Misc_Item.MoveTo(playerRef, xOff2, yOff2, spawnUp, false)
                Misc_Item.EnableNoWait()
            endif
        endif
        ; --- end safe spawn ---

        if Misc_Item
            Misc_Item.SetMotionType(4) ; KEYFRAMED
            if Placeable_A_DeleteAll
                Placeable_A_DeleteAll.AddForm(Misc_Item)
            endif

            Self.DisableNoWait()
            Self.Delete()

            Game.ForceFirstPerson()
            Game.DisablePlayerControls(false, true, true, false, false, true, true, false)	    

	    float baseRadius = Distance as float
	    if baseRadius <= 0.0
	        baseRadius = 120.0
	    endif
	
	    float radius = baseRadius
	    if PreviewDistanceMultiplier > 0.0
	        radius = baseRadius * PreviewDistanceMultiplier
	    endif
	    radius += PreviewDistanceOffset
	    if radius < 50.0
	        radius = 50.0
	    endif
            
            SBPlaceVR.LivePlace(Misc_Item, FaceZOffset, radius, PreviewHeightOffset, PreviewLateralOffset)
    	    RegisterForModEvent("SBOnPlacementConfirmed", "OnSBOnPlacementConfirmed")
        endif
    endif
EndEvent