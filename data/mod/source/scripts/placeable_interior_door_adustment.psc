ScriptName Placeable_Interior_Door_Adustment extends ObjectReference

;-- Properties --------------------------------------
Message Property Y_Ui Auto
Message Property Z_Ui_SKSE Auto
Message Property MenuUi_SKSE Auto
Message Property MenuUi_Make_Door_Permanent Auto
Message Property Rotate_Ui_SKSE Auto
MiscObject Property MiscObj Auto
Message Property MenuUi Auto
Message Property Z_Ui Auto
Message Property X_Ui Auto
Message Property Rotate_Ui Auto
Message Property X_Ui_SKSE Auto
Int Property Distance = 150 Auto ; {Default is set to 150}
Message Property MenuUi_MakeStatic Auto
Static Property StaticDummy Auto
Message Property Menu_Action_Door Auto ; <-- your Menu_Action_Basement message record
Message Property MenuUi_Options_SKSE Auto
Message Property MenuUi_Options_PositionerMenu_SKSE Auto
Message Property MenuUi_Options Auto
GlobalVariable Property Placeable_Positioner_SKSE_Global Auto
Spell Property Placeable_SKSE_Positioner_Toggle Auto
Message Property MenuUi_Options_PositionerMenu Auto
Activator Property Permanent_Door Auto ; {Places Door .Act}
Message Property MenuUi_MakeStatic_SKSE Auto
Message Property Y_Ui_SKSE Auto

;-- Variables ---------------------------------------
GlobalVariable Placeable_Auto_Leveling_Items
Static Placeable_SSB_Indicator
Spell Placeable_Auto_Level_Object_Global_Toggle_Spell
ObjectReference Move_Item
MiscObject Placeable_SSB_Activate_Effect
Formlist Placeable_Position_Reset_List
Spell Placeable_SSB_Indicator_Spell
Armor Placeable_SSB_Indicator_Armor
Formlist Placeable_Position_StorePosition_Info_List
String zKeyOldState = ""
ObjectReference dummyMovementObject
Actor PlayerRef
Static LoadScreenLogo
Formlist Placeable_A_DeleteAll
GlobalVariable Placeable_SSB_Indicator_Global_Var
MiscObject Placeable_SSB_Indicator_Check
Static Placeable_SSB_Indicator_XMarker

;-- Functions ---------------------------------------

Function OnInit()
	Placeable_A_DeleteAll = Game.GetFormFromFile(14836519, "LvxMagick - Skyrim - Settlement Builder.Esm") As Formlist
	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(14566765, "LvxMagick - Skyrim - Settlement Builder.Esm") As Spell
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(14483809, "LvxMagick - Skyrim - Settlement Builder.Esm") As GlobalVariable
	Placeable_SSB_Indicator_Armor = Game.GetFormFromFile(16086513, "LvxMagick - Skyrim - Settlement Builder.Esm") As Armor
	Placeable_SSB_Indicator_Spell = Game.GetFormFromFile(16206581, "LvxMagick - Skyrim - Settlement Builder.Esm") As Spell
	Placeable_SSB_Indicator_Global_Var = Game.GetFormFromFile(16227323, "LvxMagick - Skyrim - Settlement Builder.Esm") As GlobalVariable
	Placeable_SSB_Indicator_XMarker = Game.GetFormFromFile(16227324, "LvxMagick - Skyrim - Settlement Builder.Esm") As Static
	Placeable_SSB_Activate_Effect = Game.GetFormFromFile(16289539, "LvxMagick - Skyrim - Settlement Builder.Esm") As MiscObject
	PlayerRef = Game.GetForm(0x14) As Actor
	If Placeable_Auto_Leveling_Items.GetValue() == 0.0
		GotoState("Auto_Level")
	EndIf
EndFunction

Bool Function CustomZKeying_HandleIsKeyPressed(Bool registerForUpdate = False)
	If Input.IsKeyPressed(Input.GetMappedKey("Activate", 255))
		If registerForUpdate
			RegisterForSingleUpdate(0.1)
		EndIf
		Return True
	Else
		MoveTo(dummyMovementObject, 0.0, 0.0, 0.0, True)
		EnableNoWait(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		SetPosition(X, Y, PlayerRef.GetPositionZ())
		dummyMovementObject.Disable(False)
		dummyMovementObject.Delete()
		GotoState(zKeyOldState)
		zKeyOldState = ""
		Return False
	EndIf
EndFunction

Function MenuUi_SKSE(Bool abFadeIn = False)
	Int aiButton = MenuUi_SKSE.Show()
	If      aiButton == 1
		Z_Menu_SKSE(False)
	ElseIf  aiButton == 2
		Y_Menu_SKSE(False)
	ElseIf  aiButton == 3
		X_Menu_SKSE(False)
	ElseIf  aiButton == 4
		Rotate_Menu_SKSE(False)
		Utility.Wait(0.1)
	ElseIf  aiButton == 5
		DisableNoWait(False)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		Delete()
	ElseIf  aiButton == 6
		Options(0, False)
	ElseIf  aiButton == 7
		Make_Static(0)
	ElseIf  aiButton == 8
		; (unused)
	EndIf
EndFunction

Function Movement_System_Toggle()
	; SKSE positioner toggle disabled in VR/legacy path
	; Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
EndFunction

Function Make_Static(Int aiButton = 0)
	aiButton = MenuUi_MakeStatic.Show()
	If aiButton == 1
		DisableNoWait(True)
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(StaticDummy) As Form)
		Delete()
		Utility.Wait(0.1)
	EndIf
EndFunction

Function Rotate_Menu(Bool abFadeIn = False)
	Int aiButton = Rotate_Ui.Show()
	If      aiButton == 0
		Menu(0)
	ElseIf  aiButton == 1
		SetAngle(0.0, 0.0, GetAngleZ() - 20.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 2
		SetAngle(0.0, 0.0, GetAngleZ() - 10.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 3
		SetAngle(0.0, 0.0, GetAngleZ() - 1.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 4
		SetAngle(0.0, 0.0, GetAngleZ() + 1.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 5
		SetAngle(0.0, 0.0, GetAngleZ() + 10.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 6
		SetAngle(0.0, 0.0, GetAngleZ() + 20.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf  aiButton == 7
		; Former SKSE jump disabled
		; Movement_System_Toggle()
		; Rotate_Menu_SKSE(False)
		Rotate_Menu(abFadeIn)
	EndIf
EndFunction

Function Cleanup()
	UnregisterForAllKeys()
EndFunction

Function Rotate_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Rotate_Ui_SKSE.Show()
	Utility.Wait(0.1)
	DisableNoWait(False)
	ObjectReference PositionObject = PlaceAtMe(StaticDummy, 1, False, True)
	PositionObject.EnableNoWait(False)
	PositionObject.SetMotionType(4, True)
	Utility.Wait(0.1)
	DisableNoWait(False)

	If      aiButton == 0
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		PositionObject.Delete()
		EnableNoWait(False)
		MenuUi_SKSE(False)

	ElseIf  aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() - 5.0, 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Rotate_Menu_SKSE(abFadeIn)

	ElseIf  aiButton == 2
		Int activatekey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(activatekey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() + 5.0, 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
		EnableNoWait(False)
		PositionObject.Delete()
		Rotate_Menu_SKSE(abFadeIn)

	ElseIf  aiButton == 3
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Movement_System_Toggle()
		Rotate_Menu(False)
	EndIf
EndFunction

Function MyMainFunc()
	Int i = Input.GetMappedKey("Sneak", 255)
	RegisterForKey(i)
EndFunction

; =======================
;  RE-INDEXED MAIN MENUS
; =======================

Function Menu_Main_Hub(Int aiButton = 0)
	aiButton = Menu_Action_Door.Show()

	; aiButton == 0 : Done / Exit (unchanged)
	If      aiButton == 0
		; do nothing

	; Former button #2 is now #1: open the Positioner menu
	ElseIf  aiButton == 1
		Menu(0)

	; Former button #3 is now #2: pick up
	ElseIf  aiButton == 2
		DisableNoWait(False)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		Delete()

	; Former button #4 is now #3: make permanent
	ElseIf  aiButton == 3
		Make_Permanent(0)
	EndIf
EndFunction

Function Menu_Main_Hub_SKSE(Int aiButton = 0)
	aiButton = Menu_Action_Door.Show()

	If      aiButton == 0
		; do nothing

	; Former button #2 is now #1: open SKSE positioner
	ElseIf  aiButton == 1
		MenuUi_SKSE(False)

	; Former button #3 is now #2: pick up
	ElseIf  aiButton == 2
		DisableNoWait(False)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		Delete()

	; Former button #4 is now #3: make permanent
	ElseIf  aiButton == 3
		Make_Permanent(0)
	EndIf
EndFunction

; ===== (unchanged helpers below, except SKSE links cut on legacy side) =====

Function Move_Activator()
	Placeable_SSB_Indicator_Global_Var.SetValue(1.0)
	Placeable_SSB_Indicator_Spell.Cast(PlayerRef)
	DisableNoWait(False)
	Move_Activator_Update()
EndFunction

Event OnGrab()
	DisableNoWait(False)
	dummyMovementObject = PlaceAtMe(Placeable_SSB_Activate_Effect, 1, False, False)
	dummyMovementObject.SetMotionType(4, True)
	zKeyOldState = GetState()
	GotoState("ZKeyingObject")
	RegisterForSingleUpdate(0.0)
EndEvent

Function X_Menu(Bool abFadeIn = False)
	Int aiButton = X_Ui.Show()
	If      aiButton == 0
		Menu(0)
	ElseIf  aiButton == 1
		SetPosition(X * 1.0 - 20.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 2
		SetPosition(X * 1.0 - 10.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 3
		SetPosition(X * 1.0 - 1.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 4
		SetPosition(X * 1.0 + 1.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 5
		SetPosition(X * 1.0 + 10.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 6
		SetPosition(X * 1.0 + 20.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf  aiButton == 7
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		X_Menu(abFadeIn)
	; ElseIf  aiButton == 8
	;	SKSE jump disabled: Movement_System_Toggle() / X_Menu_SKSE(False)
	EndIf
EndFunction

Function Y_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Y_Ui_SKSE.Show()
	Utility.Wait(0.1)
	DisableNoWait(False)
	ObjectReference PositionObject = PlaceAtMe(StaticDummy, 1, False, True)
	PositionObject.EnableNoWait(False)
	PositionObject.SetMotionType(4, True)
	If      aiButton == 0
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		PositionObject.Delete()
		EnableNoWait(False)
		MenuUi_SKSE(False)
	ElseIf  aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() - 5.0, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 2
		Int activatekey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(activatekey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() + 5.0, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 3
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 4
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Movement_System_Toggle()
		Y_Menu(False)
	EndIf
EndFunction

Function Z_Menu(Bool abFadeIn = False)
	Int aiButton = Z_Ui.Show()
	If      aiButton == 0
		Menu(0)
	ElseIf  aiButton == 1
		SetPosition(X, Y, Z * 1.0 - 20.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 2
		SetPosition(X, Y, Z * 1.0 - 10.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 3
		SetPosition(X, Y, Z * 1.0 - 1.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 4
		SetPosition(X, Y, Z * 1.0 + 1.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 5
		SetPosition(X, Y, Z * 1.0 + 10.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 6
		SetPosition(X, Y, Z * 1.0 + 20.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf  aiButton == 7
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		Z_Menu(abFadeIn)
	; ElseIf  aiButton == 8
	;	SKSE jump disabled: Movement_System_Toggle() / Z_Menu_SKSE(False)
	EndIf
EndFunction

Function Z_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Z_Ui_SKSE.Show()
	Utility.Wait(0.1)
	DisableNoWait(False)
	ObjectReference PositionObject = PlaceAtMe(StaticDummy, 1, False, True)
	PositionObject.EnableNoWait(False)
	PositionObject.SetMotionType(4, True)
	If      aiButton == 0
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		PositionObject.Delete()
		EnableNoWait(False)
		MenuUi_SKSE(False)
	ElseIf  aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() - 5.0, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 2
		Int activatekey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(activatekey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() + 5.0, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 3
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 4
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Movement_System_Toggle()
		Z_Menu(False)
	EndIf
EndFunction

Function Options(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_SKSE.Show()
		If      aiButton == 0
			MenuUi_SKSE(False)
		ElseIf  aiButton == 1
			Options_Positioner_Menu(0, False)
		ElseIf  aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		ElseIf  aiButton == 3
			Debug.Notification("Use the Skyrim Settelement Builder Options: Lesser Power To Delete All")
		EndIf
	EndIf
EndFunction

Function MenuUi_Options(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options.Show()
		If      aiButton == 0
			Menu(0)
		ElseIf  aiButton == 1
			MenuUi_Options_PositionerMenu(0, False)
		EndIf
	EndIf
EndFunction

Function X_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = X_Ui_SKSE.Show()
	Utility.Wait(0.1)
	DisableNoWait(False)
	ObjectReference PositionObject = PlaceAtMe(StaticDummy, 1, False, True)
	PositionObject.EnableNoWait(False)
	PositionObject.SetMotionType(4, True)
	If      aiButton == 0
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		PositionObject.Delete()
		EnableNoWait(False)
		MenuUi_SKSE(False)
	ElseIf  aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX() - 5.0, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 2
		Int activatekey = Input.GetMappedKey("Activate", 255)
		While Input.IsKeyPressed(activatekey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX() + 5.0, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 3
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf  aiButton == 4
		PositionObject.DisableNoWait(False)
		EnableNoWait(False)
		PositionObject.Delete()
		Movement_System_Toggle()
		X_Menu(False)
	EndIf
EndFunction

Function Y_Menu(Bool abFadeIn = False)
	Int aiButton = Y_Ui.Show()
	If      aiButton == 0
		Menu(0)
	ElseIf  aiButton == 1
		SetPosition(X, Y * 1.0 - 20.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 2
		SetPosition(X, Y * 1.0 - 10.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 3
		SetPosition(X, Y * 1.0 - 1.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 4
		SetPosition(X, Y * 1.0 + 1.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 5
		SetPosition(X, Y * 1.0 + 10.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 6
		SetPosition(X, Y * 1.0 + 20.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf  aiButton == 7
		MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		Y_Menu(abFadeIn)
	; ElseIf  aiButton == 8
	;	SKSE jump disabled: Movement_System_Toggle() / Y_Menu_SKSE(False)
	EndIf
EndFunction

Function Menu(Int aiButton = 0)
	aiButton = MenuUi.Show()
	If      aiButton == 1
		Z_Menu(False)
	ElseIf  aiButton == 2
		Y_Menu(False)
	ElseIf  aiButton == 3
		X_Menu(False)
	ElseIf  aiButton == 4
		Rotate_Menu(False)
		Utility.Wait(0.1)
	ElseIf  aiButton == 5
		DisableNoWait(False)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		Delete()
	ElseIf  aiButton == 6
		MenuUi_Options(0, False)
	ElseIf  aiButton == 7
		Make_Static(0)
	ElseIf  aiButton == 8
		; (unused)
	EndIf
EndFunction

Function Move_Activator_Update()
	While Placeable_SSB_Indicator_Global_Var.GetValue() == 1.0
		Debug.Notification("Press Crouch To Place Item")
		MyMainFunc()
		Utility.Wait(1.1)
		Cleanup()
	EndWhile
EndFunction

Event OnKeyDown(Int keycode)
	If PlayerRef.IsSneaking()
		Move_Item = PlayerRef.PlaceAtMe(Placeable_SSB_Indicator_XMarker, 1, False, False)
		Move_Item.MoveTo(PlayerRef, Distance * Math.Sin(PlayerRef.GetAngleZ()), Distance * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 128.0, True)
		MoveTo(Move_Item, 0.0, 0.0, 0.0, True)
		EnableNoWait(False)
		SetAngle(0.0, 0.0, GetAngleZ())
	EndIf
EndEvent

Function Options_Positioner_Menu(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu_SKSE.Show()
		If      aiButton == 0
			Options(0, False)
		ElseIf  aiButton == 1
			; SKSE positioner toggle disabled
			; Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
			Debug.Notification("Positioner toggle requires SKSE and is disabled.")
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu.Show()
		If      aiButton == 0
			MenuUi_Options(0, False)
		ElseIf  aiButton == 1
			; SKSE positioner toggle disabled
			; Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
			Debug.Notification("Positioner toggle requires SKSE and is disabled.")
		ElseIf  aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		ElseIf  aiButton == 3
			; (unused)
		EndIf
	EndIf
EndFunction

Event OnActivate(ObjectReference akActionRef)
	If Game.GetPlayer().IsSneaking()
		Debug.Notification("You can't access this menu while crouched")
		Return
	EndIf
	SKSE_Checker()
EndEvent

Function Make_Permanent(Int aiButton = 0)
	aiButton = MenuUi_Make_Door_Permanent.Show()
	If      aiButton == 0
		; do nothing
	ElseIf  aiButton == 1
		DisableNoWait(True)
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(Permanent_Door) As Form)
		Debug.Notification("Permanent Door Placed")
		DeleteWhenAble()
		Delete()
	ElseIf  aiButton == 2
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(StaticDummy) As Form)
		Debug.Notification("Static Placed")
		DeleteWhenAble()
		Delete()
	EndIf
EndFunction

Function SKSE_Checker()
	; Force legacy hub only, regardless of SKSE presence or globals
	Menu_Main_Hub(0)
EndFunction

;-- States ------------------------------------------
State ZKeyingObject
	Event OnUpdate()
		If !CustomZKeying_HandleIsKeyPressed(False)
			Return
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
		CustomZKeying_HandleIsKeyPressed(True)
	EndEvent
EndState

State Auto_Level
	Event OnBeginState()
		If Placeable_Auto_Leveling_Items.GetValue() == 1.0
			; off
		Else
			SetAngle(0.0, 0.0, GetAngleZ())
		EndIf
	EndEvent
EndState
