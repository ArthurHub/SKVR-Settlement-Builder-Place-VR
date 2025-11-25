Scriptname Placeable_Shrine_Adjustment_Script extends ObjectReference  

Message Property  Z_Ui Auto
Message Property  Y_Ui Auto
Message Property  X_Ui Auto
Message Property  Rotate_Ui Auto

MiscObject Property MiscObj Auto
Activator Property Activator01 Auto
Static Property StaticDummy Auto

; Temple Blessing Messages
Message Property MenuUi_Shrine_MainMenu Auto
Message Property MenuUi_Place_Shrine_Activator Auto
Message Property BlessingMessage Auto  
Message Property AltarRemoveMsg Auto  
Spell   Property TempleBlessing Auto 
Activator Property Shrine_Permanent Auto

;--------------------------------------------------------SKSE Properties (KEPT BUT NOT USED FOR FLOW)-----------------
Actor          Property PlayerREf Auto
GlobalVariable Property Placeable_Positioner_SKSE_Global Auto

Message Property MenuUi Auto
Message Property MenuUi_MakeStatic Auto

Message Property MenuUi_Options Auto
Message Property MenuUi_Options_SKSE Auto
Message Property MenuUi_Options_PositionerMenu Auto
Message Property MenuUi_Options_PositionerMenu_SKSE Auto

Message Property Z_Ui_SKSE Auto
Message Property Y_Ui_SKSE Auto
Message Property X_Ui_SKSE Auto
Message Property Rotate_Ui_SKSE Auto

Spell Property Placeable_SKSE_Positioner_Toggle Auto

Formlist Placeable_A_DeleteAll

;----------------------------------------Auto - Object Leveling - System ----------------------------------------------------------------------------
Spell          Placeable_Auto_Level_Object_Global_Toggle_Spell
GlobalVariable Placeable_Auto_Leveling_Items

Event OnInit()
	;===========================================Delete All Formlist Property================================================
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as Formlist
	;=======================================================================================================================

	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagicks-CampfireUnleashed.Esm") as Spell
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagicks-CampfireUnleashed.Esm") as GlobalVariable

	If Placeable_Auto_Leveling_Items.GetValue() == 0
		GoToState("Auto_Level")
	Else
		; Do nothing
	EndIf
EndEvent

State Auto_Level
	Event OnBeginState()
		If Placeable_Auto_Leveling_Items.GetValue() == 1
			; Auto-Leveled OFF
		Else
			Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Default
		EndIf
	EndEvent
EndState
;-------------------------------------------------------------------------------------------------------------------------------------------

Event OnLoad()
	BlockActivation()
EndEvent

;---------------------------------------------------ACTIVATE -> ALWAYS REGULAR MENU---------------------------------------------------
Event OnActivate(ObjectReference akActionRef)
	; Ignore SKSE presence and global; always use regular menu.
	Menu()
EndEvent

; ======================
; MAIN SHRINE MENU
; Button layout (unchanged, no re-indexing):
;   1 = Use shrine
;   2 = Z adjust
;   3 = Y adjust
;   4 = X adjust
;   5 = Rotate
;   6 = Pickup (return misc)
;   7 = Deploy permanent shrine
; ======================
Function Menu(Int aiButton = 0)
	aiButton = MenuUi_Shrine_MainMenu.Show()

	If aiButton == 1
		Use_Shrine()
	ElseIf aiButton == 2
		Z_Menu()
	ElseIf aiButton == 3
		Y_Menu()
	ElseIf aiButton == 4
		X_Menu()
	ElseIf aiButton == 5
		Rotate_Menu()
	ElseIf aiButton == 6    ; Pickup
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		DeleteWhenAble()
		Delete()
	ElseIf aiButton == 7    ; Deploy Shrine
		MenuUi_PlaceActivator_SKSE()
	EndIf
EndFunction

;------------------------------------------------------------------------Auto-Level_Button Function-----------------------------------------------------------------
Function Auto_Level_Button()
	If Placeable_Auto_Leveling_Items.GetValue() == 1
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
	Else
		Debug.MessageBox("Object Auto-Level System Working - No need to use button.. You can turn off Automated Leveling Objects in the Options - Campfire Unleashed Spells.. Then this button will be active again")
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function Z_Menu(Bool abMenu = True, Int aiButton = 0, Bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = Z_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X, Y, Z * 1 - 50)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X, Y, Z * 1 - 30)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X, Y, Z * 1 - 10)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X, Y, Z * 1 - 1)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X, Y, Z * 1 + 1)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X, Y, Z * 1 + 10)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X, Y, Z * 1 + 30)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X, Y, Z * 1 + 50)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

Function Y_Menu(Bool abMenu = True, Int aiButton = 0, Bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = Y_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X, Y * 1 - 50, Z)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X, Y * 1 - 30, Z)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X, Y * 1 - 10, Z)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X, Y * 1 - 1, Z)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X, Y * 1 + 1, Z)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X, Y * 1 + 10, Z)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X, Y * 1 + 30, Z)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X, Y * 1 + 50, Z)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

Function X_Menu(Bool abMenu = True, Int aiButton = 0, Bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = X_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X * 1 - 50, Y, Z)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X * 1 - 30, Y, Z)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X * 1 - 10, Y, Z)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X * 1 - 1, Y, Z)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X * 1 + 1, Y, Z)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X * 1 + 10, Y, Z)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X * 1 + 30, Y, Z)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X * 1 + 50, Y, Z)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

Function Rotate_Menu(Bool abMenu = True, Int aiButton = 0, Bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = Rotate_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 50.0)
				Self.Enable()
			ElseIf aiButton == 2
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 30.0)
				Self.Enable()
			ElseIf aiButton == 3
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 10.0)
				Self.Enable()
			ElseIf aiButton == 4
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 1.0)
				Self.Enable()
			ElseIf aiButton == 5
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 1.0)
				Self.Enable()
			ElseIf aiButton == 6
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 10.0)
				Self.Enable()
			ElseIf aiButton == 7
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 30.0)
				Self.Enable()
			ElseIf aiButton == 8
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 50.0)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

;------------------------------------------------------------------------------------Options_Menu (legacy – still available if wired in)----------------------------------------------------------------------------
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
			Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
		ElseIf aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		EndIf
	EndIf
EndFunction

;--------------------------------------Place Shrine (non-SKSE)------------------------------
Function MenuUi_PlaceActivator(Int aiButton = 0)
	aiButton = MenuUi_Place_Shrine_Activator.Show()
	If aiButton == 1
		DisableNoWait(True)
		Self.Disable(True)
		Self.PlaceAtMe(Shrine_Permanent)
		Self.DeleteWhenAble()
		Delete()
	EndIf
EndFunction 

;========================================================================= 
;--------------------------- SKSE BLOCK (kept for compatibility, unreachable from Activate) ---
;===========================================================================

Function MenuUi_SKSE(Bool abFadeIn = False)
	Int aiButton = MenuUi_Shrine_MainMenu.Show()
	If aiButton == 1
		Use_Shrine() 
	ElseIf aiButton == 2
		Z_Menu_SKSE()
	ElseIf aiButton == 3
		Y_Menu_SKSE()
	ElseIf aiButton == 4
		X_Menu_SKSE()
	ElseIf aiButton == 5
		Rotate_Menu_SKSE()
		Utility.Wait(0.1)
	ElseIf aiButton == 6
		Auto_Level_Button()
	ElseIf aiButton == 7
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		Delete()
	ElseIf aiButton == 8
		MenuUi_Options_SKSE()
	ElseIf aiButton == 9
		MenuUi_PlaceActivator_SKSE() 
	EndIf
EndFunction

;----------------------------------------------------------------------------Z_SKSE_Menu----------------------------------------------------------------------
Function Z_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Z_Ui_SKSE.Show()
	Utility.Wait(0.1)
	Self.Disable()
	ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
	PositionObject.SetMotionType(4)

	If aiButton == 0
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		PositionObject.Delete()
		Self.Enable()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() - 5.0, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 2
		Int ActivateKey2 = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey2) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() + 5.0, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	EndIf
EndFunction

;---------------------------------------------------------------------------------Y_SKSE---------------------------------------------------
Function Y_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Y_Ui_SKSE.Show()
	Utility.Wait(0.1)
	Self.Disable()
	ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
	PositionObject.SetMotionType(4)

	If aiButton == 0
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		PositionObject.Delete()
		Self.Enable()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() - 5.0, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 2
		Int ActivateKey2 = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey2) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() + 5.0, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	EndIf
EndFunction

;----------------------------------------------------------------------------------X_SKSE-----------------------------------------------------------
Function X_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = X_Ui_SKSE.Show()
	Utility.Wait(0.1)
	Self.Disable()
	ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
	PositionObject.SetMotionType(4)

	If aiButton == 0
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		PositionObject.Delete()
		Self.Enable()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX() - 5.0, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 2
		Int ActivateKey2 = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey2) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX() + 5.0, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	EndIf
EndFunction

;--------------------------------------------------------------------------------Rotate_SKSE------------------------------------------------------------------
Function Rotate_Menu_SKSE(Bool abFadeIn = False)
	Int aiButton = Rotate_Ui_SKSE.Show()
	Utility.Wait(0.1)
	Self.Disable()
	ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
	PositionObject.SetMotionType(4)

	Utility.Wait(0.1)
	Self.Disable()

	If aiButton == 0
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		PositionObject.Delete()
		Self.Enable()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() - 5.0, 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		Self.SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Rotate_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 2
		Int ActivateKey2 = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey2) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() + 5.0, 500.0, 0.0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
		Self.Enable()
		PositionObject.Delete()
		Rotate_Menu_SKSE(abFadeIn)
	EndIf
EndFunction

;-----------------------------------------------------------------------------------------------------------------Options_SKSE------------------------------------------------------------------------------
Function MenuUi_Options_SKSE(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_SKSE.Show()
		If aiButton == 0
			; Back
		ElseIf aiButton == 1
			MenuUi_Options_PositionerMenu()
		ElseIf aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu_SKSE(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu_SKSE.Show()
		If aiButton == 0
			; Back
		ElseIf aiButton == 1
			Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
		EndIf
	EndIf
EndFunction

;--------------------------------------Place Shrine (SKSE variant – used by Menu button 7 for delete-all support)------------------------------
Function MenuUi_PlaceActivator_SKSE(Int aiButton = 0)
	aiButton = MenuUi_Place_Shrine_Activator.Show()
	If aiButton == 1
		DisableNoWait(True)
		Self.Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(Shrine_Permanent))
		Delete()
	EndIf
EndFunction 

;========================================================================= 
;                                                                                USE SHRINE
;==========================================================================

Function Use_Shrine()
	TempleBlessing.Cast(Self, PlayerRef)
	AltarRemoveMsg.Show()
	BlessingMessage.Show()
EndFunction
