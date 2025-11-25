Scriptname Placeable_Container_Flora extends ObjectReference  

Actor Property PlayerRef Auto
ObjectReference Property Activate_Object Auto 

Message Property MenuUi_Action_Flora Auto
Message Property MenuUi_Plant_Flora_Static Auto

MiscObject Property Shovel01 Auto
MiscObject Property Shovel02 Auto
;Activator Property ContainerAct Auto
flora Property Plant01 Auto
Static Property StaticDummy Auto

Sound Property Placeable_NPCHumanShovel Auto
Sound Property Placeable_NPCHumanShovelDump Auto

; Positioner Properties

Message Property MenuUi Auto
Message Property MenuUi_SKSE Auto
Message Property MenuUi_MakeStatic Auto
Message Property MenuUi_MakeStatic_SKSE Auto
Message Property MenuUi_Options Auto
Message Property MenuUi_Options_SKSE Auto
Message Property  MenuUi_Options_PositionerMenu Auto
Message Property  MenuUi_Options_PositionerMenu_SKSE Auto
Message Property Z_Ui Auto
Message Property Y_Ui Auto
Message Property X_Ui Auto
Message Property Rotate_Ui Auto
Message Property Z_Ui_SKSE Auto
Message Property Y_Ui_SKSE Auto
Message Property X_Ui_SKSE Auto
Message Property Rotate_Ui_SKSE Auto
MiscObject Property MiscObj Auto
Activator Property Activator_FullGrown_Static Auto

FormList Placeable_Position_Reset_List
FormList Placeable_Position_StorePosition_Info_List
FormList Placeable_A_DeleteAll
Static LoadScreenLogo
Static MAGINVReanimate

;----------------------------------------Auto - Object Leveling - System ----------------------------------
Spell Placeable_Auto_Level_Object_Global_Toggle_Spell
Spell Placeable_SKSE_Positioner_Toggle
GlobalVariable Placeable_Auto_Leveling_Items
GlobalVariable Property Placeable_Positioner_SKSE_Global Auto

Event OnInit()
	PlayerRef = Game.GetForm(0x00000014) As Actor

	; Auto-Level Toggle Spell
	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell

	; Delete All Formlist
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as FormList 

	; Auto-Level Object
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable

	; Grab Activator
	MAGINVReanimate = Game.GetFormFromFile(0x001097CC, "Skyrim.Esm") as Static
EndEvent

Event OnActivate(ObjectReference akActionRef)
	BlockActivation(self)

	; LEGACY PATH ONLY – always use Menu(), ignore SKSE and global toggle.
	Menu()
EndEvent

;------------------------------------------------------(Menu)---------------------------------------
Function Menu(Int aiButton = 0)
	aiButton = MenuUi_Action_Flora.Show()
	self.BlockActivation()

	If aiButton == 0
		Activate_Object.Activate(Game.GetPlayer())
	ElseIf aiButton == 1
		Plant_Flora()
	ElseIf aiButton == 2
		MenuUi_PositionSelect_Container()
	ElseIf aiButton == 3
		self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		DeleteWhenAble()
		Delete()
	EndIf
EndFunction

;---------------------------------------------------(Menu SKSE - now unreachable from Activate)---
Function MenuUi_SKSE(Int aiButton = 0)
	aiButton = MenuUi_Action_Flora.Show()
	self.BlockActivation()

	If aiButton == 0
		Activate_Object.Activate(Game.GetPlayer())
	ElseIf aiButton == 1
		Plant_Flora()
	ElseIf aiButton == 2
		MenuUi_PositionSelect_Container_SKSE()
	ElseIf aiButton == 3
		self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		DeleteWhenAble()
		Delete()
	EndIf
EndFunction

Function MenuUi_PositionSelect_Container(Int aiButton = 0)
	aiButton = MenuUi.Show()
	;Debug.Notification("Legacy Positioner UI Active")
	If aiButton == 1
		Z_Menu()
	ElseIf aiButton == 2
		Y_Menu()
	ElseIf aiButton == 3
		X_Menu()
	ElseIf aiButton == 4
		Rotate_Menu()
		;Debug.Notification("Object is facing "+ GetAngleZ()+" Degrees")
		Utility.Wait(0.1)
	ElseIf aiButton == 5
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		Delete()
	ElseIf aiButton == 6
		MenuUi_Options()
	ElseIf aiButton == 7
		MenuUi_MakeStatic()
	ElseIf aiButton == 8
		; Former free-movement / SKSE switch – now just return to legacy menu
		Menu()
	EndIf
EndFunction

;------------------------------------------------------------------------Auto-Level_Button (unused)----
Function Auto_Level_Button()
	If (Placeable_Auto_Leveling_Items.GetValue() == 1)
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
	Else
		Debug.MessageBox("Object Auto-Level System Working - No need to use button.. You can turn off Automated Leveling Objects in the Options - Campfire Unleashed Spells.. Then this button will be active again")
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------------------Z_Menu--------------------------------
Function Z_Menu(Bool abFadeIn = False)
	Int aiButton = Z_Ui.Show()

	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y, Z * 1 - 20)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y, Z * 1 - 10)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y, Z * 1 - 1)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y, Z * 1 + 1)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y, Z * 1 + 10)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y, Z * 1 + 20)
		Self.Enable()
		Z_Menu(abFadeIn)
	ElseIf aiButton == 7  ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Z_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former SKSE movement-system toggle – now just go back to legacy menu
		Menu()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------------Y_Menu------------------------------------
Function Y_Menu(Bool abFadeIn = False)
	Int aiButton = Y_Ui.Show()

	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y * 1 - 20, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y * 1 - 10, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y * 1 - 1, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y * 1 + 1, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y * 1 + 10, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y * 1 + 20, Z)
		Self.Enable()
		Y_Menu(abFadeIn)
	ElseIf aiButton == 7 ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		Y_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former SKSE movement-system toggle – now just go back to legacy menu
		Menu()
	EndIf
EndFunction

;---------------------------------------------------------------------------------------------X_Menu-------------------------------------------
Function X_Menu(Bool abFadeIn = False)
	Int aiButton = X_Ui.Show()

	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X * 1 - 20, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X * 1 - 10, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X * 1 - 1, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X * 1 + 1, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X * 1 + 10, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X * 1 + 20, Y, Z)
		Self.Enable()
		X_Menu(abFadeIn)
	ElseIf aiButton == 7  ; Reset Object
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		X_Menu(abFadeIn)
	ElseIf aiButton == 8
		; Former SKSE movement-system toggle – now just go back to legacy menu
		Menu()
	EndIf
EndFunction

;--------------------------------------------------------------------------------------Rotate_Menu---------------------------------------------
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
		; Former movement-system toggle – now just return to legacy menu
		Menu()
	EndIf
EndFunction

;------------------------------------------------------------------------------------Options_Menu----------------------------------------------
Function MenuUi_Options(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options.Show()
		If aiButton == 0
			Menu()
		ElseIf aiButton == 1
			MenuUi_Options_PositionerMenu()
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu.Show()
		If aiButton == 0
			MenuUi_Options()
		ElseIf aiButton == 1
			; SKSE Positioner toggle disabled
			Debug.Notification("Positioner toggle is unavailable.")
		ElseIf aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		ElseIf aiButton == 3
			; no-op
		EndIf
	EndIf
EndFunction

;-------------------------------------------------------------------------------------------SKSE Main Menu (unreachable)----------------------
Function MenuUi_PositionSelect_Container_SKSE(Bool abFadeIn = False)
	Int aiButton = MenuUi_SKSE.Show()

	If aiButton == 1
		Z_Menu_SKSE()
	ElseIf aiButton == 2
		Y_Menu_SKSE()
	ElseIf aiButton == 3
		X_Menu_SKSE()
	ElseIf aiButton == 4
		Rotate_Menu_SKSE()
		Utility.Wait(0.1)
	ElseIf aiButton == 5
		Self.Disable(True)
		Game.GetPlayer().AddItem(MiscObj)
		Delete()
	ElseIf aiButton == 6
		MenuUi_Options_SKSE()
	ElseIf aiButton == 7
		MenuUi_MakeStatic()
	ElseIf aiButton == 8
		; Free_Movement_System()  (unused)
	EndIf
EndFunction

;----------------------------------------------------------------------------Z_SKSE_Menu (unreachable)---------------------------------------
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
		MenuUi_SKSE()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() - 5, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
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
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ() + 5, PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 3
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		PositionObject.Disable()
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		PositionObject.Delete()
		Z_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 4
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Movement_System_Toggle()
		Z_Menu()
	EndIf
EndFunction

;---------------------------------------------------------------------------------Y_Menu_SKSE (unreachable)-----------------------------------
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
		MenuUi_SKSE()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() - 5, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
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
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY() + 5, PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 3
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		PositionObject.Disable()
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		PositionObject.Delete()
		Y_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 4
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Movement_System_Toggle()
		Y_Menu()
	EndIf
EndFunction

;----------------------------------------------------------------------------------X_Menu_SKSE (unreachable)---------------------------------
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
		MenuUi_SKSE()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX() - 5, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
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
			PositionObject.TranslateTo(PositionObject.GetPositionX() + 5, PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 3
		Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
		PositionObject.Disable()
		Self.Enable()
		Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
		PositionObject.Delete()
		X_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 4
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Movement_System_Toggle()
		X_Menu()
	EndIf
EndFunction

;--------------------------------------------------------------------------------Rotate_SKSE (unreachable)-----------------------------------
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
		MenuUi_SKSE()
	ElseIf aiButton == 1
		Int ActivateKey = Input.GetMappedKey("Activate")
		While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() - 5, 500, 0)
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
			PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() + 5, 500, 0)
		EndWhile
		Utility.Wait(0.1)
		Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
		PositionObject.Disable()
		Self.SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
		Self.Enable()
		PositionObject.Delete()
		Rotate_Menu_SKSE(abFadeIn)
	ElseIf aiButton == 3
		PositionObject.Disable()
		Self.Enable()
		PositionObject.Delete()
		Movement_System_Toggle()
		Rotate_Menu()
	EndIf
EndFunction

;-----------------------------------------------------------------------------------------------------------------Options_SKSE (unreachable)-----------------
Function MenuUi_Options_SKSE(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_SKSE.Show()
		If aiButton == 0
			MenuUi_SKSE()
		ElseIf aiButton == 1
			MenuUi_Options_PositionerMenu()
		ElseIf aiButton == 2
			Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
		ElseIf aiButton == 3
			Debug.Notification("Use the Skyrim Settlement Builder Options: Lesser Power To Delete All")
		EndIf
	EndIf
EndFunction

Function MenuUi_Options_PositionerMenu_SKSE(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options_PositionerMenu_SKSE.Show()
		If aiButton == 0
			MenuUi_Options_SKSE()
		ElseIf aiButton == 1
			; SKSE Positioner toggle disabled here as well
			Debug.Notification("Positioner toggle is unavailable.")
		EndIf
	EndIf
EndFunction

;----------------------------------------Movement System Toggle Switch SKSE to Integer & Back-----------------------
Function Movement_System_Toggle()
	; Formerly: Placeable_SKSE_Positioner_Toggle.Cast(PlayerRef)
	; Now disabled to keep this script SKSE-free at runtime.
	Debug.Notification("Movement system toggle is unavailable.")
EndFunction

;--------------------------------------------------------------------------------------------Static_Menu---------------
Function MenuUi_MakeStatic(Int aiButton = 0)
	aiButton = MenuUi_MakeStatic.Show()

	If aiButton == 1
		DisableNoWait(True)
		Disable(True)
		Placeable_A_DeleteAll.AddForm(PlaceAtMe(Activator_FullGrown_Static))
		Delete()
		Utility.Wait(0.1)
	EndIf
EndFunction 

;=================================================================PLANT FLORA=========================================
Function Plant_Flora(Int aiButton = 0)
	aiButton = MenuUi_Plant_Flora_Static.Show()

	If aiButton == 0
		Menu()
	ElseIf aiButton == 1    ; Plant Crop
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
			Placeable_A_DeleteAll.AddForm(PlaceAtMe(Plant01))
			DeleteWhenAble()
			Delete()
		ElseIf Debug.MessageBox("You need a shovel to plant this crop.")
		EndIf
	EndIf
EndFunction
