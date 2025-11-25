; MenuUi_Container_Placement - reindexed after removing:
;   - Button #2: "Level Object"
;   - Button #7: "Move"
; New order in the Message record should be:
;   0 = Done, 1 = Open Container, 2 = Position Select, 3 = Bury Container,
;   4 = Pickup Container, 5 = Make Container Permanent

Scriptname Placeable_Container_Adjustment extends ObjectReference  

Import Game
Import Utility

ObjectReference Property Activate_Object Auto 
Message Property MenuUi_Make_Container_Permanent Auto
Message Property MenuUi_Container_Placement Auto
Message Property  Z_Ui Auto
Message Property   Y_Ui Auto
Message Property  X_Ui Auto
Message Property Rotate_Ui Auto

Message Property MenuUi_Make_BuryContainer_Static Auto
MiscObject Property MiscObj Auto
MiscObject Property Shovel01 Auto
MiscObject Property Shovel02 Auto
Activator Property Permanent_ContainerAct Auto
Activator Property Activator_Dirt_Pile Auto
Activator Property DummyActivator Auto 
Sound Property Placeable_NPCHumanShovel Auto
Sound Property Placeable_NPCHumanShovelDump Auto

; Non-SKSE properties retained
Actor Property PlayerRef Auto
Message Property MenuUi Auto
Message Property MenuUi_Options Auto
Message Property MenuUi_Options_PositionerMenu Auto
Activator Property My_Activator_Static Auto

FormList Placeable_A_DeleteAll ; RESET MODE Formlist!!!

;----------------------------------------SSB Placement Indicator Properties------------------------------------------------------------------
Spell Property Placeable_Auto_Level_Object_Global_Toggle_Spell Auto
GlobalVariable Property Placeable_Auto_Leveling_Items Auto

Armor Property Placeable_SSB_Indicator_Armor Auto
MiscObject Property Placeable_SSB_Indicator_Check Auto
Spell Property Placeable_SSB_Indicator_Spell Auto ; Placeable Indicator
MiscObject Property MAGINVReanimate Auto
Static Property Placeable_SSB_Indicator Auto
GlobalVariable Property Placeable_SSB_Indicator_Global_Var Auto
Static Property Placeable_SSB_Indicator_XMarker Auto
MiscObject Property Placeable_SSB_Activate_Effect Auto
;--------------------------------------------------------------------------------------------------------------------------------------------

Event OnInit()
	BlockActivation(self) 

	;===========================================Delete All Formlist Property===============================================
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as Formlist
	;========================================== Grab Activator=============================================================
	MAGINVReanimate = Game.GetFormFromFile(0x001097CC, "Skyrim.Esm") as MiscObject
	;========================================Auto Level Objects============================================================
	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable
	;========================================SSB Placeable Indicator=======================================================
	Placeable_SSB_Indicator_Armor = Game.GetFormFromFile(0x00F575F1, "LvxMagick - Skyrim - Settlement Builder.Esm") as Armor 
	Placeable_SSB_Indicator_Spell = Game.GetFormFromFile(0x00F74AF5, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell 
	Placeable_SSB_Indicator_Global_Var = Game.GetFormFromFile(0x00F79BFB, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable 
	Placeable_SSB_Indicator_XMarker = Game.GetFormFromFile(0x00F79BFC, "LvxMagick - Skyrim - Settlement Builder.Esm") as Static 
	Placeable_SSB_Activate_Effect = Game.GetFormFromFile(0x00F88F03, "LvxMagick - Skyrim - Settlement Builder.Esm") as MiscObject 

	If (Placeable_Auto_Leveling_Items.GetValue() == 0)
		GoToState("Auto_Level")
	EndIf
EndEvent

State Auto_Level
	Event OnBeginState()
		If (Placeable_Auto_Leveling_Items.GetValue() == 1)
			; Auto-Level OFF
		Else
			Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Default
		EndIf
	EndEvent
EndState

;---------------------------------------------------------------- Activation (non-SKSE) ------------------------------------------------------
Event OnActivate(ObjectReference akActionRef)
	BlockActivation(self)
	If akActionRef == Game.GetPlayer()
		Menu()
	EndIf
EndEvent

;=====================================================================================================================
;----------------------------------------------------Grab Activator--------------------------------------------------|
;=====================================================================================================================

ObjectReference dummyMovementObject
Event OnGrab()
	self.DisableNoWait()
	dummyMovementObject = PlaceAtMe(Placeable_SSB_Activate_Effect, 1)
	dummyMovementObject.SetMotionType(4) ; No Havok
	zKeyOldState = GetState()
	GoToState("ZKeyingObject")
	RegisterForSingleUpdate(0)
EndEvent

String zKeyOldState = "" ; Store the old state so we can go back to it once we're done

State ZKeyingObject
	Event OnUpdate()
		If !CustomZKeying_HandleIsKeyPressed()
			return
		EndIf
		
		If !PlayerRef.IsSneaking()
			Float Angle_X = PlayerRef.GetPositionX()
			Float Angle_Y = PlayerRef.GetPositionY()
			Float Angle_Z = PlayerRef.GetPositionZ() + 180.0
			Float Pos_X = PlayerRef.X + 100.0
			Float Pos_Y = PlayerRef.Y + 100.0
			Float Pos_Z = PlayerRef.Z + 100.0
			dummyMovementObject.TranslateTo(Pos_X, Pos_Y, Pos_Z, Angle_X, Angle_Y, Angle_Z, 200.0, 180.0)
		EndIf

		CustomZKeying_HandleIsKeyPressed(true)
	EndEvent
EndState

Bool Function CustomZKeying_HandleIsKeyPressed(bool registerForUpdate = false)
	If Input.IsKeyPressed(Input.GetMappedKey("Activate"))
		If registerForUpdate
			RegisterForSingleUpdate(0.1)
		EndIf
		return true
	Else
		self.MoveTo(dummyMovementObject, abMatchRotation = True)
		self.EnableNoWait()
		dummyMovementObject.Disable()
		dummyMovementObject.Delete()
		GoToState(zKeyOldState)
		zKeyOldState = ""
		return false
	EndIf
EndFunction

;=============================================================================================================================================
;----------------------------------------------- (Move) - Activator With Blue Indicator ------------------------------------------------------|
;=============================================================================================================================================

ObjectReference Move_Item
Function Move_Activator()
	Placeable_SSB_Indicator_Global_Var.SetValue(1.0)
	Placeable_SSB_Indicator_Spell.Cast(PlayerRef)
	Self.DisableNoWait() 
	Move_Activator_Update()
EndFunction   

Function Move_Activator_Update()
	While (Placeable_SSB_Indicator_Global_Var.GetValue() == 1.0) 
		Debug.Notification("Press Crouch To Place Item")
		MyMainFunc()
		Utility.Wait(1.1)
		Cleanup()
	EndWhile
EndFunction

Function MyMainFunc()
	Int i = Input.GetMappedKey("Sneak")
	RegisterForKey(i)
EndFunction

Event OnKeyDown(Int keycode)
	If PlayerRef.IsSneaking()
		Move_Item = PlayerRef.PlaceAtMe(Placeable_SSB_Indicator_XMarker)
		Move_Item.MoveTo(PlayerRef, 150.0 * Math.Sin(PlayerRef.GetAngleZ()), 150.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 128.0)
		Self.MoveTo(Move_Item)
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Float zOffset = Self.GetHeadingAngle(Game.GetPlayer())
		Self.SetAngle(Self.GetAngleX(), Self.GetAngleY(), Self.GetAngleZ() + zOffset)
		Self.EnableNoWait()
	EndIf
EndEvent

Function Cleanup()
	UnregisterForAllKeys()
EndFunction

;________________________________________________________________________________________________________________________________
;                                                        Main Menu (RE-INDEXED)                                                | 
;_______________________________________________________________________________________________________________________________|
Function Menu(Int aiButton = 0)
	aiButton = MenuUi_Container_Placement.Show()
	Utility.Wait(0.1)
  
	If aiButton == 0
		; Done / Exit

	ElseIf aiButton == 1            ; Open Container
		Self.SetOpen()
		Utility.Wait(0.0)
		Activate_Object.Activate(Game.GetPlayer())
		RegisterForSingleUpdate(1.0)
		OnUpdate()
		If ( ! Game.IsLookingControlsEnabled() )
			RegisterForSingleUpdate(0.5)
			return
		Else
			Utility.Wait(0.5) 
			Self.SetOpen(False)  ; Close Container
		EndIf

	ElseIf aiButton == 2            ; Position Select
		MenuUi_PositionSelect_Container()

	ElseIf aiButton == 3            ; Bury Container
		Bury_Container() 

	ElseIf aiButton == 4            ; Pickup Container
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		Disable()
		DeleteWhenAble()
		Delete()

	ElseIf aiButton == 5            ; Make Container Permanent
		MenuUi_Make_Container_Permanent()    

	EndIf
EndFunction

;_______________________________________________________________________________________________________________________________
;                                                        Positioner Menu                                                        | 
;_______________________________________________________________________________________________________________________________|

Function MenuUi_PositionSelect_Container(Int aiButton = 0)
	aiButton = MenuUi.Show()

	; 0 = Done (Back) – just return to caller
	If aiButton == 1
		; Height
		Z_Menu()
	ElseIf aiButton == 2
		; Y Axis
		Y_Menu()
	ElseIf aiButton == 3
		; X Axis
		X_Menu()
	ElseIf aiButton == 4  
		; Rotation
		Rotate_Menu()
	ElseIf aiButton == 5
		; Pickup
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		Delete()
	ElseIf aiButton == 6
		; Make Permanent (Options button removed, Make Permanent moved up)
		MenuUi_Make_Container_Permanent() 
	EndIf
EndFunction

;------------------------------------------------------------------------Z_Menu-----------------------------------------------------------------------
Function Z_Menu(Bool abFadeIn = False)
	Int aiButton = Z_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y, Z - 20.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y, Z - 10.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y, Z - 1.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y, Z + 1.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y, Z + 10.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y, Z + 20.0)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 7
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Z_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former “switch to SKSE” slot — no SKSE path. Return to menu.
		Menu()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------------Y_Menu--------------------------------------------------------------------------
Function Y_Menu(Bool abFadeIn = False)
	Int aiButton = Y_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y - 20.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y - 10.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y - 1.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y + 1.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y + 10.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y + 20.0, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 7
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Y_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former “switch to SKSE” slot — no SKSE path. Return to menu.
		Menu()
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------X_Menu-----------------------------------------------------------------------------------
Function X_Menu(Bool abFadeIn = False)
	Int aiButton = X_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X - 20.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X - 10.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X - 1.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X + 1.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X + 10.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X + 20.0, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 7
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		X_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former “switch to SKSE” slot — no SKSE path. Return to menu.
		Menu()
	EndIf
EndFunction

;--------------------------------------------------------------------------------------Rotate_Menu------------------------------------------------------------------------------- 
Function Rotate_Menu(Bool abFadeIn = False)
	Int aiButton = Rotate_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 20.0)
		Self.Enable()    
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 2
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 10.0)
		Self.Enable()   
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 3
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 1.0)
		Self.Enable()    
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 4
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 1.0)
		Self.Enable()    
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 5
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 10.0)
		Self.Enable()   
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 6
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 20.0)
		Self.Enable()    
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 7
		; Former movement-system toggle — no SKSE. Return to menu.
		Menu()
	EndIf
EndFunction

;-----------------------------------------------------Bury Container----------------------------------------------------------------------------------------
Function Bury_Container(Int aiButton = 0) 
	aiButton = MenuUi_Make_BuryContainer_Static.Show()

	If aiButton == 0
		Menu()

	ElseIf aiButton == 1
		If (Game.GetPlayer().GetItemCount(Shovel01) >= 1) || (Game.GetPlayer().GetItemCount(Shovel02) >= 1)
			Game.FadeOutGame(True, True, 2.0, 3.0)			
			Placeable_NPCHumanShovel.Play(Game.GetPlayer())
			Utility.Wait(1.0) 
			Placeable_NPCHumanShovel.Play(Game.GetPlayer())
			Utility.Wait(1.0)  
			Placeable_NPCHumanShovel.Play(Game.GetPlayer())
			Utility.Wait(1.0)
			Placeable_NPCHumanShovelDump.Play(Game.GetPlayer())
			Game.FadeOutGame(False, True, 5.0, 3.0)
			DisableNoWait(True)
			Disable(True)
			Placeable_A_DeleteAll.AddForm(PlaceAtMe(Activator_Dirt_Pile))   
			DeleteWhenAble()
			Delete()
		ElseIf Debug.MessageBox("You need a shovel to bury this Container.")
		EndIf
	EndIf 
EndFunction

;------------------------------------------------------------------------------------Options_Menu----------------------------------------------------------------------------
Function MenuUi_Options(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options.Show()
		If aiButton == 0
			; Back
		ElseIf aiButton == 1
			MenuUi_Options_PositionerMenu()
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu.Show()
		If aiButton == 0
			; Back
		ElseIf aiButton == 1
			; Former SKSE toggle slot — intentionally disabled
			Debug.Notification("Positioner toggle is unavailable.")
		ElseIf aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(Game.GetPlayer())
		EndIf
	EndIf
EndFunction

;------------------------------------------------- Make Container Permanent ---------------------------------------------------------------------------------
Function MenuUi_Make_Container_Permanent(Int aiButton = 0)
	aiButton = MenuUi_Make_Container_Permanent.Show()
	If aiButton == 0
		; Do Nothing
	ElseIf aiButton == 1
		DisableNoWait(True)
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(Permanent_ContainerAct))
		Debug.Notification("Permanent Container Placed")
		DeleteWhenAble() 
		Delete()
	ElseIf aiButton == 2
		(DummyActivator)
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(DummyActivator))
		Debug.Notification("Static Placed")
		DeleteWhenAble()
		Delete()
	EndIf
EndFunction