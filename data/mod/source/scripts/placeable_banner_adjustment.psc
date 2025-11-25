Scriptname Placeable_Banner_Adjustment extends ObjectReference

Actor Property PlayerREf Auto
; Removed SKSE positioner usage and related UI
;GlobalVariable Property Placeable_Auto_Leveling_Items Auto ; Default = (1.0)

Message Property MenuUi_Banner Auto
Message Property MenuUi_MakeStatic Auto
Message Property MenuUi_Options Auto
Message Property MenuUi_Options_PositionerMenu Auto

Message Property Z_Ui Auto
Message Property Y_Ui Auto
Message Property X_Ui Auto
Message Property Rotate_Ui Auto

MiscObject Property MiscObj Auto
Activator   Property My_Banner Auto

FormList Property Placeable_A_DeleteAll Auto

;---------------------------------------- Auto-Level System ----------------------------------------
Spell         Property Placeable_Auto_Level_Object_Global_Toggle_Spell Auto
GlobalVariable Property Placeable_Auto_Leveling_Items                  Auto

Event OnInit()
	; Delete-All FormList
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as FormList

	; Auto-Level toggle spell/global (Campfire Unleashed variant per source script)
	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagicks-CampfireUnleashed.Esm") as Spell
	Placeable_Auto_Leveling_Items                  = Game.GetFormFromFile(0x00DD0161, "LvxMagicks-CampfireUnleashed.Esm") as GlobalVariable

	If Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 0.0)
		GoToState("Auto_Level")
	EndIf
EndEvent

State Auto_Level
	Event OnBeginState()
		If Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 1.0)
			; Auto-Level OFF
		Else
			Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Default level
		EndIf
	EndEvent
EndState

Event OnActivate(ObjectReference akActionRef)
	Menu() ; Always use regular menu; no SKSE path
EndEvent

; --------------------------------------------------------------------------------------------
; Main Menu (reindexed after removing the old “Level Angle” button)
; Map: 0 Done, 1 Z(Height), 2 Y, 3 X, 4 Rotate, 5 Pickup, 6 Deploy Banner
; --------------------------------------------------------------------------------------------
Function Menu(int aiButton = 0)
	aiButton = MenuUi_Banner.Show()

	If aiButton == 1
		Z_Menu()
	ElseIf aiButton == 2
		Y_Menu()
	ElseIf aiButton == 3
		X_Menu()
	ElseIf aiButton == 4
		Rotate_Menu()
		Utility.Wait(0.1)

	ElseIf aiButton == 5 ; Pickup
		Self.Disable(true)
		Game.GetPlayer().AddItem(MiscObj)
		Delete()

	ElseIf aiButton == 6 ; Deploy Banner (Make Static)
		MenuUi_MakeStatic()
	EndIf
EndFunction

; Optional: not called from Menu (kept for external wiring)
Function Auto_Level_Button()
	If Placeable_Auto_Leveling_Items && (Placeable_Auto_Leveling_Items.GetValue() == 1.0)
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
	Else
		Debug.MessageBox("Object Auto-Level System Working. Turn off automated leveling in Campfire Unleashed options to re-enable this manual button.")
	EndIf
EndFunction

; ------------------------- Z / Y / X translate menus -------------------------
Function Z_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = Z_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X, Y, Z - 50)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X, Y, Z - 30)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X, Y, Z - 10)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X, Y, Z - 1)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X, Y, Z + 1)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X, Y, Z + 10)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X, Y, Z + 30)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X, Y, Z + 50)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

Function Y_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = Y_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X, Y - 50, Z)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X, Y - 30, Z)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X, Y - 10, Z)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X, Y - 1, Z)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X, Y + 1, Z)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X, Y + 10, Z)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X, Y + 30, Z)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X, Y + 50, Z)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

Function X_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		If aiButton != -1
			aiButton = X_Ui.Show()
			If aiButton == 0
				abMenu = False
				Menu()
			ElseIf aiButton == 1
				SetPosition(X - 50, Y, Z)
				Self.Enable()
			ElseIf aiButton == 2
				SetPosition(X - 30, Y, Z)
				Self.Enable()
			ElseIf aiButton == 3
				SetPosition(X - 10, Y, Z)
				Self.Enable()
			ElseIf aiButton == 4
				SetPosition(X - 1, Y, Z)
				Self.Enable()
			ElseIf aiButton == 5
				SetPosition(X + 1, Y, Z)
				Self.Enable()
			ElseIf aiButton == 6
				SetPosition(X + 10, Y, Z)
				Self.Enable()
			ElseIf aiButton == 7
				SetPosition(X + 30, Y, Z)
				Self.Enable()
			ElseIf aiButton == 8
				SetPosition(X + 50, Y, Z)
				Self.Enable()
			EndIf
		EndIf
	EndWhile
EndFunction

; ------------------------------ Rotate menu ------------------------------
Function Rotate_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
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

; ------------------------------ Options menus ------------------------------
Function MenuUi_Options(int aiButton = 0, bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options.Show()
		If aiButton == 0
			Menu()
		ElseIf aiButton == 1
			MenuUi_Options_PositionerMenu()
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu(int aiButton = 0, bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu.Show()
		If aiButton == 0
			MenuUi_Options()
		ElseIf aiButton == 1
			; Former SKSE positioner toggle — now disabled
			Debug.Notification("Positioner toggle requires SKSE and is disabled.")
		ElseIf aiButton == 2
			; Keep Auto-Level toggle
			If Placeable_Auto_Level_Object_Global_Toggle_Spell
				Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerREf)
			EndIf
		EndIf
	EndIf
EndFunction

; ------------------------------ Make Static (Deploy Banner) ------------------------------
Function MenuUi_MakeStatic(int aiButton = 0)
	aiButton = MenuUi_MakeStatic.Show()
	If aiButton == 1
		DisableNoWait(True)
		Self.Disable(true)
		If Placeable_A_DeleteAll
			Placeable_A_DeleteAll.AddForm(PlaceAtMe(My_Banner))
		Else
			PlaceAtMe(My_Banner)
		EndIf
		Delete()
	EndIf
EndFunction