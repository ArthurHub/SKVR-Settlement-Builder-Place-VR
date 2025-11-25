Scriptname Placeable_Gate_Adjustment_Script extends ObjectReference

; ==============================
; Messages (non-SKSE)
; ==============================
Message Property MenuUi_Door_MainMenu Auto
Message Property MenuUi_Place_Door_Activator Auto
Message Property Z_Ui Auto
Message Property Y_Ui Auto
Message Property X_Ui Auto
Message Property Rotate_Ui Auto
Message Property MenuUi_Options Auto ; restored to fix compile

; ==============================
; Objects
; ==============================
MiscObject Property MiscObj Auto
Activator Property Activator01 Auto
Static Property StaticDummy Auto

; ==============================
; Lifecycle
; ==============================
Event OnLoad()
	BlockActivation()
EndEvent

; ==============================
; Activate -> always open regular menu
; ==============================
Event OnActivate(ObjectReference akActionRef)
	if akActionRef == Game.GetPlayer()
		Menu()
	endif
EndEvent

; ==============================
; Main menu (regular)
; ==============================
Function Menu(int aiButton = 0)
	aiButton = MenuUi_Door_MainMenu.Show()

	if aiButton == 1
		Z_Menu()
	elseif aiButton == 2
		Y_Menu()
	elseif aiButton == 3
		X_Menu()
	elseif aiButton == 4
		Rotate_Menu()
	elseif aiButton == 5
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Level object angle
	elseif aiButton == 6 ; Pickup
		Self.Disable(true)
		Game.GetPlayer().AddItem(MiscObj)
		DeleteWhenAble()
		Delete()
	elseif aiButton == 7 ; Options (no SKSE submenu)
		MenuUi_Options_Menu()
	elseif aiButton == 8 ; Place Gate
		MenuUi_PlaceActivator()
	endif
EndFunction

; ==============================
; Axis menus (regular)
; ==============================
Function Z_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		if aiButton != -1
			aiButton = Z_Ui.Show()
			if aiButton == 0
				abMenu = False
				Menu()
			elseif aiButton == 1
				SetPosition(X, Y, Z*1 - 50)
				Self.Enable()
			elseif aiButton == 2
				SetPosition(X, Y, Z*1 - 30)
				Self.Enable()
			elseif aiButton == 3
				SetPosition(X, Y, Z*1 - 10)
				Self.Enable()
			elseif aiButton == 4
				SetPosition(X, Y, Z*1 - 1)
				Self.Enable()
			elseif aiButton == 5
				SetPosition(X, Y, Z*1 + 1)
				Self.Enable()
			elseif aiButton == 6
				SetPosition(X, Y, Z*1 + 10)
				Self.Enable()
			elseif aiButton == 7
				SetPosition(X, Y, Z*1 + 30)
				Self.Enable()
			elseif aiButton == 8
				SetPosition(X, Y, Z*1 + 50)
				Self.Enable()
			endif
		endif
	EndWhile
EndFunction

Function Y_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		if aiButton != -1
			aiButton = Y_Ui.Show()
			if aiButton == 0
				abMenu = False
				Menu()
			elseif aiButton == 1
				SetPosition(X, Y*1 - 50, Z)
				Self.Enable()
			elseif aiButton == 2
				SetPosition(X, Y*1 - 30, Z)
				Self.Enable()
			elseif aiButton == 3
				SetPosition(X, Y*1 - 10, Z)
				Self.Enable()
			elseif aiButton == 4
				SetPosition(X, Y*1 - 1, Z)
				Self.Enable()
			elseif aiButton == 5
				SetPosition(X, Y*1 + 1, Z)
				Self.Enable()
			elseif aiButton == 6
				SetPosition(X, Y*1 + 10, Z)
				Self.Enable()
			elseif aiButton == 7
				SetPosition(X, Y*1 + 30, Z)
				Self.Enable()
			elseif aiButton == 8
				SetPosition(X, Y*1 + 50, Z)
				Self.Enable()
			endif
		endif
	EndWhile
EndFunction

Function X_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		if aiButton != -1
			aiButton = X_Ui.Show()
			if aiButton == 0
				abMenu = False
				Menu()
			elseif aiButton == 1
				SetPosition(X*1 - 50, Y, Z)
				Self.Enable()
			elseif aiButton == 2
				SetPosition(X*1 - 30, Y, Z)
				Self.Enable()
			elseif aiButton == 3
				SetPosition(X*1 - 10, Y, Z)
				Self.Enable()
			elseif aiButton == 4
				SetPosition(X*1 - 1, Y, Z)
				Self.Enable()
			elseif aiButton == 5
				SetPosition(X*1 + 1, Y, Z)
				Self.Enable()
			elseif aiButton == 6
				SetPosition(X*1 + 10, Y, Z)
				Self.Enable()
			elseif aiButton == 7
				SetPosition(X*1 + 30, Y, Z)
				Self.Enable()
			elseif aiButton == 8
				SetPosition(X*1 + 50, Y, Z)
				Self.Enable()
			endif
		endif
	EndWhile
EndFunction

Function Rotate_Menu(Bool abMenu = True, int aiButton = 0, bool abFadeOut = False)
	While abMenu
		if aiButton != -1
			aiButton = Rotate_Ui.Show()
			if aiButton == 0
				abMenu = False
				Menu()
			elseif aiButton == 1
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 50.0)
				Self.Enable()
			elseif aiButton == 2
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 30.0)
				Self.Enable()
			elseif aiButton == 3
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 10.0)
				Self.Enable()
			elseif aiButton == 4
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() - 1.0)
				Self.Enable()
			elseif aiButton == 5
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 1.0)
				Self.Enable()
			elseif aiButton == 6
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 10.0)
				Self.Enable()
			elseif aiButton == 7
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 30.0)
				Self.Enable()
			elseif aiButton == 8
				Self.SetAngle(0.0, 0.0, Self.GetAngleZ() + 50.0)
				Self.Enable()
			endif
		endif
	EndWhile
EndFunction

; ==============================
; Options (no SKSE routing)
; ==============================
Function MenuUi_Options_Menu(int aiButton = 0, bool abFadeOut = False)
	if aiButton != -1
		aiButton = MenuUi_Options.Show()
		; #0 Back — no-op
		; #1 previously opened SKSE submenu — now intentionally a no-op
	endif
EndFunction

; ==============================
; Place Activator (regular)
; ==============================
Function MenuUi_PlaceActivator(int aiButton = 0)
	aiButton = MenuUi_Place_Door_Activator.Show()
	if aiButton == 1
		DisableNoWait(True)
		Self.Disable(true)
		Self.PlaceAtMe(Activator01)
		Self.DeleteWhenAble()
		Delete()
	endif
EndFunction