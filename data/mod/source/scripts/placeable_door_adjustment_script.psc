Scriptname Placeable_Door_Adjustment_Script extends ObjectReference

Message Property MenuUi_Door_MainMenu Auto
Message Property MenuUi_Place_Door_Activator Auto
Message Property Z_Ui Auto
Message Property Y_Ui Auto
Message Property X_Ui Auto
Message Property Rotate_Ui Auto

MiscObject Property MiscObj Auto
Activator Property Activator01 Auto
Static Property StaticDummy Auto

;--------------------------------------------------------SKSE Properties (kept for CK wiring, but no longer used)---------
Actor Property PlayerREf Auto
GlobalVariable Property Placeable_Positioner_SKSE_Global Auto
Message Property MenuUi Auto
Message Property MenuUi_Door_MainMenu_SKSE Auto
Message Property MenuUi_MakeStatic Auto
Message Property MenuUi_MakeStatic_SKSE Auto
Message Property MenuUi_Options Auto
Message Property MenuUi_Options_SKSE Auto
Message Property MenuUi_Options_PositionerMenu Auto
Message Property MenuUi_Options_PositionerMenu_SKSE Auto

Message Property Z_Ui_SKSE Auto
Message Property Y_Ui_SKSE Auto
Message Property X_Ui_SKSE Auto
Message Property Rotate_Ui_SKSE Auto

Spell Property Placeable_SKSE_Positioner_Toggle Auto
ObjectReference Property Teleport_Activator Auto

FormList Placeable_A_DeleteAll

;----------------------------------------Auto - Object Leveling - System ----------------------------
Spell Placeable_Auto_Level_Object_Global_Toggle_Spell
GlobalVariable Placeable_Auto_Leveling_Items

Event OnInit()
	; Delete All FormList
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as FormList

	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagicks-CampfireUnleashed.Esm") as Spell
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagicks-CampfireUnleashed.Esm") as GlobalVariable

	if Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 0.0)
		GoToState("Auto_Level")
	endif
EndEvent

State Auto_Level
	Event OnBeginState()
		if Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 1.0)
			; Auto-Level OFF
		else
			Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Default
		endif
	EndEvent
EndState

Event OnLoad()
	BlockActivation()
EndEvent

;=============================== Activate -> always legacy menu ===============================
Event OnActivate(ObjectReference akActionRef)
	if akActionRef == Game.GetPlayer()
		Menu()
	endif
EndEvent

;=============================== MAIN ENTRY (legacy only) =====================================
Function Menu(int aiButton = 0)
	aiButton = MenuUi_Door_MainMenu.Show()

	; 0: Back/Exit (do nothing)
	if      aiButton == 1
		Z_Menu()
	elseif  aiButton == 2
		Y_Menu()
	elseif  aiButton == 3
		X_Menu()
	elseif  aiButton == 4
		Rotate_Menu()
	elseif  aiButton == 5    ; Pick up
		Self.Disable(true)
		Game.GetPlayer().AddItem(MiscObj)
		DeleteWhenAble()
		Delete()
	elseif  aiButton == 6    ; Place door
		MenuUi_PlaceActivator()
	endif
EndFunction

;------------------------------------------------------------------------Auto-Level_Button Function-----------------------------------------------------------------
Function Auto_Level_Button()
	if Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 1.0)
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
	else
		Debug.MessageBox("Object Auto-Level System Working. Turn off automated leveling in Campfire Unleashed options to re-enable this manual button.")
	endif
EndFunction

;---------------------------------------------------------------- Z (legacy) ---------------------------------------------------------------
Function Z_Menu(bool abFadeIn = false)
	int aiButton = Z_Ui.Show()

	if      aiButton == 0
		Menu()
	elseif  aiButton == 1
		SetPosition(X, Y, Z * 1 - 20)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 2
		SetPosition(X, Y, Z * 1 - 10)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 3
		SetPosition(X, Y, Z * 1 - 1)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 4
		SetPosition(X, Y, Z * 1 + 1)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 5
		SetPosition(X, Y, Z * 1 + 10)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 6
		SetPosition(X, Y, Z * 1 + 20)
		Self.Enable()
		Z_Menu(abFadeIn)
	elseif  aiButton == 7  ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Z_Menu(abFadeIn)
	elseif  aiButton == 8
		; Previously SKSE hand-off. Now just return to main menu.
		Menu()
	endif
EndFunction

;---------------------------------------------------------------- Y (legacy) ---------------------------------------------------------------
Function Y_Menu(bool abFadeIn = false)
	int aiButton = Y_Ui.Show()

	if      aiButton == 0
		Menu()
	elseif  aiButton == 1
		SetPosition(X, Y * 1 - 20, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 2
		SetPosition(X, Y * 1 - 10, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 3
		SetPosition(X, Y * 1 - 1, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 4
		SetPosition(X, Y * 1 + 1, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 5
		SetPosition(X, Y * 1 + 10, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 6
		SetPosition(X, Y * 1 + 20, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	elseif  aiButton == 7 ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Y_Menu(abFadeIn)
	elseif  aiButton == 8
		; Previously SKSE hand-off. Now just return to main menu.
		Menu()
	endif
EndFunction

;---------------------------------------------------------------- X (legacy) ---------------------------------------------------------------
Function X_Menu(bool abFadeIn = false)
	int aiButton = X_Ui.Show()

	if      aiButton == 0
		Menu()
	elseif  aiButton == 1
		SetPosition(X * 1 - 20, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 2
		SetPosition(X * 1 - 10, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 3
		SetPosition(X * 1 - 1, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 4
		SetPosition(X * 1 + 1, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 5
		SetPosition(X * 1 + 10, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 6
		SetPosition(X * 1 + 20, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	elseif  aiButton == 7  ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		X_Menu(abFadeIn)
	elseif  aiButton == 8
		; Previously SKSE hand-off. Now just return to main menu.
		Menu()
	endif
EndFunction

;---------------------------------------------------------------- Rotate (legacy) ---------------------------------------------------------------
Function Rotate_Menu(bool abFadeIn = false)
	int aiButton = Rotate_Ui.Show()

	if      aiButton == 0
		Menu()
	elseif  aiButton == 1
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 20.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 2
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 10.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 3
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 1.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 4
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 1.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 5
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 10.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 6
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 20.0)
		Self.Enable()
		Rotate_Menu(abFadeIn)
	elseif  aiButton == 7
		; Previously SKSE hand-off. Now just return to main menu.
		Menu()
	endif
EndFunction

;------------------------------------------------------------------------------------Options_Menu (legacy)----------------------------------------------------------------------------
Function MenuUi_Options(int aiButton = 0, bool abFadeOut = false)
	if aiButton != -1
		aiButton = MenuUi_Options.Show()
		if      aiButton == 0
			; Back
		elseif  aiButton == 1
			MenuUi_Options_PositionerMenu()
		endif
	endif
EndFunction

Function MenuUi_Options_PositionerMenu(int aiButton = 0, bool abFadeOut = false)
	if aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu.Show()
		if      aiButton == 0
			; Back
		elseif  aiButton == 1
			; Former SKSE positioner toggle — now disabled
			Debug.Notification("Positioner toggle requires SKSE and is disabled.")
		elseif  aiButton == 2
			; Keep Auto-Level toggle (non-SKSE)
			if Placeable_Auto_Level_Object_Global_Toggle_Spell
				Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(Game.GetPlayer())
			endif
		endif
	endif
EndFunction

;--------------------------------------Place Door (legacy)------------------------------
Function MenuUi_PlaceActivator(int aiButton = 0)
	aiButton = MenuUi_Place_Door_Activator.Show()
	if aiButton == 1
		DisableNoWait(True)
		Self.Disable(true)
		if Placeable_A_DeleteAll
			Placeable_A_DeleteAll.AddForm(PlaceAtMe(Activator01))
		else
			PlaceAtMe(Activator01)
		endif
		Delete()
	endif
EndFunction

;========================================================================= 
; SKSE MAIN MENU / XYZ submenus (kept but unused)
;===========================================================================

Function MenuUi_SKSE(bool abFadeIn = false)
	; No longer called; legacy path only.
	int aiButton = MenuUi_Door_MainMenu_SKSE.Show()
	; Intentionally do nothing; SKSE menu is deprecated.
EndFunction

Function Z_Menu_SKSE(bool abFadeIn = false)
	; Deprecated SKSE path — no longer used.
EndFunction

Function Y_Menu_SKSE(bool abFadeIn = false)
	; Deprecated SKSE path — no longer used.
EndFunction

Function X_Menu_SKSE(bool abFadeIn = false)
	; Deprecated SKSE path — no longer used.
EndFunction

Function Rotate_Menu_SKSE(bool abFadeIn = false)
	; Deprecated SKSE path — no longer used.
EndFunction

Function MenuUi_Options_SKSE(int aiButton = 0, bool abFadeOut = false)
	if aiButton != -1
		; Deprecated SKSE options — no effect now.
		aiButton = MenuUi_Options_SKSE.Show()
	endif
EndFunction

Function MenuUi_Options_PositionerMenu_SKSE(int aiButton = 0, bool abFadeOut = false)
	if aiButton != -1
		; Deprecated SKSE positioner submenu — no effect.
		aiButton = MenuUi_Options_PositionerMenu_SKSE.Show()
	endif
EndFunction

Function MenuUi_PlaceActivator_SKSE(int aiButton = 0)
	; Deprecated SKSE variant; use MenuUi_PlaceActivator instead.
	aiButton = MenuUi_Place_Door_Activator.Show()
	if aiButton == 1
		DisableNoWait(True)
		Self.Disable(true)
		if Placeable_A_DeleteAll
			Placeable_A_DeleteAll.AddForm(PlaceAtMe(Activator01))
		else
			PlaceAtMe(Activator01)
		endif
		Delete()
	endif
EndFunction

;========================================================================= 
;                                                                                USE/OPEN DOOR
;==========================================================================
Function OpenDoor()
	Teleport_Activator.Activate(Game.GetPlayer())
	if Self.SetOpen()
		; Opened
	else
		Self.SetOpen(false)
	endif
EndFunction

;----------------------------------------Movement System Toggle (SKSE toggle disabled)----------------------------
Function Movement_System_Toggle()
	; Formerly called Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
	Debug.Notification("SKSE movement toggle is disabled; legacy positioner is always used.")
EndFunction
