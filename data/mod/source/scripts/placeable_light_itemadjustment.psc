ScriptName Placeable_Light_ItemAdjustment extends ObjectReference

; -- Properties (SKSE Positioner-related properties removed) -----------------
Float Property LightSize01 Auto
Message Property MenuUi_Lights_MainMenu_Position Auto
MiscObject Property MiscObj Auto
Float Property Hight03 Auto
{Hight For Light Source}
Float Property SetSize Auto
Message Property MenuUi_Lights_MainMenu Auto
FormList Property Placeable_Light_Candelabra01_Formlist Auto
Float Property Hight02_Fire Auto
{Hight For Fire Source}
Message Property Rotate_Ui Auto
FormList Property Placeable_Light__01Color_List Auto
Float Property Hight04 Auto
{Hight For Light Source}
Float Property LightSize02 Auto
Float Property Hight01_Light01 Auto
{Hight For Light Source}
FormList Property Placeable_Light_TempList Auto
Message Property MenuUi_Light_Intensity Auto
Message Property MenuUi_Light_Color Auto
Message Property Y_Ui Auto
Static  Property Static_Fire Auto
Actor   Property PlayerREf Auto
Static  Property Static04_Extra Auto
{Extra Static to Place}
Message Property Z_Ui Auto
Light   Property MyLight02 Auto
{Light Source}
Float Property Hight01_Light02 Auto
{Hight For Light Source}
Message Property X_Ui Auto
Static  Property StaticDummy Auto
Message Property MenuUi Auto
Light   Property MyLight05 Auto
{Light Source}
Static  Property Static03_Extra Auto
{Extra Static to Place}
Message Property MenuUi_Place_Light_Activator Auto
Activator Property Activator01 Auto
Static  Property Static01_Extra Auto
{Extra Static to Place}
Static  Property Static02_Extra Auto
{Extra Static to Place}
Static  Property Static05_Extra Auto
{Extra Static to Place}
Light   Property MyLight03 Auto
{Light Source}
Light   Property MyLight04 Auto
{Light Source}
Light   Property MyLight01 Auto
{Light Source}
Message Property MenuUi_Options Auto
Float Property Hight05 Auto
{Hight For Light Source}

; -- Variables ----------------------------------------------------------------
String zKeyOldState = ""
ObjectReference Grabbed_Object
Static MAGINVReanimate
Spell Placeable_Auto_Level_Object_Global_Toggle_Spell
ObjectReference Light_Delete
FormList MyTempFormlist
FormList brightList
Light newLight
Light MyTempLight
FormList Placeable_A_DeleteAll
GlobalVariable Placeable_Auto_Leveling_Items

; New refs used by replacement function
ObjectReference _placedLight01
ObjectReference _placedLight02
ObjectReference _placedFire

; -- Functions ----------------------------------------------------------------

Function Delete_Light_Function(FormList akList, Bool abOnlyDisable, Bool abFade) Global
	Int aiSize = akList.GetSize()
	Int i = 0
	If abOnlyDisable
		While i < aiSize
			(akList.GetAt(i) as ObjectReference).DisableNoWait(abFade)
			i += 1
		EndWhile
	Else
		While i < aiSize
			(akList.GetAt(i) as ObjectReference).Delete()
			i += 1
		EndWhile
	EndIf
EndFunction

Function OnInit()
	; LvxMagick dependencies
	Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell
	Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as FormList
	Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable
	; vanilla static for grab helper
	MAGINVReanimate = Game.GetFormFromFile(0x001097CC, "Skyrim.Esm") as Static

	If Placeable_Auto_Leveling_Items.GetValue() == 0.0
		GoToState("Auto_Level")
	EndIf
EndFunction

; =========================
; MAIN LIGHT MENU (re-indexed: Options button removed)
; Buttons (after XEdit edit):
;   0 = Done
;   1 = Position
;   2 = Pickup
;   3 = Deploy Light Source
; =========================
Function Menu()
	Int aiButton = MenuUi_Lights_MainMenu.Show()
	If aiButton == 1
		; Position
		Menu_Position()
	ElseIf aiButton == 2
		; Pickup (disable current, return misc, delete helper)
		Disable(True)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		DeleteWhenAble()
		Delete()
	ElseIf aiButton == 3
		; Deploy Light Source
		MenuUi_PlaceActivator(0)
	EndIf
EndFunction

Function Menu_Position()
	Int aiButton = MenuUi_Lights_MainMenu_Position.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		Z_Menu(False)
	ElseIf aiButton == 2
		Y_Menu(False)
	ElseIf aiButton == 3
		X_Menu(False)
	ElseIf aiButton == 4
		Rotate_Menu(False)
	ElseIf aiButton == 5
		Auto_Level_Button()
	ElseIf aiButton == 6
		Disable(True)
		Game.GetPlayer().AddItem(MiscObj, 1, False)
		DeleteWhenAble()
		Delete()
	EndIf
EndFunction

Function Z_Menu(Bool abFadeIn)
	Int aiButton = Z_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y, Z - 20.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y, Z - 10.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y, Z - 1.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y, Z + 1.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y, Z + 10.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y, Z + 20.0)
		Enable(False)
		Z_Menu(abFadeIn)
	ElseIf aiButton == 7
		MoveTo(PlayerREf, 120.0 * Math.Sin(PlayerREf.GetAngleZ()), 120.0 * Math.Cos(PlayerREf.GetAngleZ()), PlayerREf.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		Z_Menu(abFadeIn)
	EndIf
EndFunction

Function Y_Menu(Bool abFadeIn)
	Int aiButton = Y_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X, Y - 20.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X, Y - 10.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X, Y - 1.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X, Y + 1.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X, Y + 10.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X, Y + 20.0, Z)
		Enable(False)
		Y_Menu(abFadeIn)
	ElseIf aiButton == 7
		MoveTo(PlayerREf, 120.0 * Math.Sin(PlayerREf.GetAngleZ()), 120.0 * Math.Cos(PlayerREf.GetAngleZ()), PlayerREf.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		Y_Menu(abFadeIn)
	EndIf
EndFunction

Function X_Menu(Bool abFadeIn)
	Int aiButton = X_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetPosition(X - 20.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetPosition(X - 10.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetPosition(X - 1.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetPosition(X + 1.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetPosition(X + 10.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetPosition(X + 20.0, Y, Z)
		Enable(False)
		X_Menu(abFadeIn)
	ElseIf aiButton == 7
		MoveTo(PlayerREf, 120.0 * Math.Sin(PlayerREf.GetAngleZ()), 120.0 * Math.Cos(PlayerREf.GetAngleZ()), PlayerREf.GetHeight() - 35.0, True)
		Enable(False)
		SetAngle(0.0, 0.0, GetAngleZ())
		X_Menu(abFadeIn)
	EndIf
EndFunction

Function Rotate_Menu(Bool abFadeIn)
	Int aiButton = Rotate_Ui.Show()
	If aiButton == 0
		Menu()
	ElseIf aiButton == 1
		SetAngle(0.0, 0.0, GetAngleZ() - 20.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 2
		SetAngle(0.0, 0.0, GetAngleZ() - 10.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 3
		SetAngle(0.0, 0.0, GetAngleZ() - 1.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 4
		SetAngle(0.0, 0.0, GetAngleZ() + 1.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 5
		SetAngle(0.0, 0.0, GetAngleZ() + 10.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	ElseIf aiButton == 6
		SetAngle(0.0, 0.0, GetAngleZ() + 20.0)
		Enable(False)
		Rotate_Menu(abFadeIn)
	EndIf
EndFunction

Function MenuUi_Options(Int aiButton = 0, Bool abFadeOut = False)
	If aiButton != -1
		aiButton = MenuUi_Options.Show()
		If aiButton == 0
			Menu()
		ElseIf aiButton == 1
			; repurposed: run auto-level toggle directly
			Auto_Level_Button()
		ElseIf aiButton == 2
			; optional: also run auto-level toggle if your message layout expects a second option
			Auto_Level_Button()
		EndIf
	EndIf
EndFunction

; ===== REPLACED FUNCTION (placement; same as user’s latest but tracked for delete-all) =====
Function MenuUi_PlaceActivator(Int aiButton = 0)
	aiButton = MenuUi_Place_Light_Activator.Show()
	If aiButton == 1
		DisableNoWait(True)
		Disable(True)

		ObjectReference dummy = PlaceAtMe(StaticDummy)
		If Placeable_A_DeleteAll && dummy
			Placeable_A_DeleteAll.AddForm(dummy)
		EndIf

		Float lx = GetPositionX()
		Float ly = GetPositionY()
		Float lz1 = GetPositionZ() + Hight01_Light01
		Float lz2 = GetPositionZ() + Hight01_Light02

		_placedLight01 = PlaceAtMe(MyLight01)
		If _placedLight01
			_placedLight01.SetPosition(lx, ly, lz1)
			If Placeable_A_DeleteAll
				Placeable_A_DeleteAll.AddForm(_placedLight01)
			EndIf
		EndIf

		_placedLight02 = PlaceAtMe(MyLight02)
		If _placedLight02
			_placedLight02.SetPosition(lx, ly, lz2)
			If Placeable_A_DeleteAll
				Placeable_A_DeleteAll.AddForm(_placedLight02)
			EndIf
		EndIf

		Float fx = GetPositionX()
		Float fy = GetPositionY()
		Float fz1 = GetPositionZ() + Hight02_Fire

		_placedFire = PlaceAtMe(Static_Fire)
		If _placedFire
			_placedFire.SetPosition(fx, fy, fz1)
			If Placeable_A_DeleteAll
				Placeable_A_DeleteAll.AddForm(_placedFire)
			EndIf
		EndIf
	EndIf
EndFunction
; ==== end placement function ====

Function Auto_Level_Button()
	If Placeable_Auto_Leveling_Items.GetValue() == 1.0
		SetAngle(0.0, 0.0, GetAngleZ())
	Else
		Debug.MessageBox("Object Auto-Level System Working - No need to use button.. You can turn off Automated Leveling Objects in the Options - Campfire Unleashed Spells.. Then this button will be active again")
	EndIf
EndFunction

Event OnLoad()
	; Example: could precompute positions; kept minimal
	Float LX = GetPositionX()
	Float LY = GetPositionY()
	Float LZ1 = GetPositionZ() + Hight01_Light01
EndEvent

Event OnActivate(ObjectReference akActionRef)
	; Always use regular menu (no SKSE Positioner path)
	Menu()
EndEvent

Event OnGrab()
	DisableNoWait(False)
	Grabbed_Object = PlaceAtMe(MAGINVReanimate, 1, False, False)
	Grabbed_Object.SetMotionType(4, True) ; kMotion_Keyframed
	zKeyOldState = GetState()
	GoToState("ZKeyingObject")
	RegisterForSingleUpdate(0.0)
EndEvent

Bool Function CustomZKeying_HandleIsKeyPressed(Bool registerForUpdate = False)
	If Input.IsKeyPressed(Input.GetMappedKey("Activate"))
		If registerForUpdate
			RegisterForSingleUpdate(0.1)
		EndIf
		Return True
	Else
		MoveTo(Grabbed_Object, 0.0, 0.0, 0.0, True)
		SetAngle(0.0, 0.0, GetAngleZ())
		EnableNoWait(False)
		Grabbed_Object.Disable(False)
		Grabbed_Object.Delete()
		GoToState(zKeyOldState)
		zKeyOldState = ""
		Return False
	EndIf
EndFunction

State Auto_Level
	Event OnBeginState()
		If Placeable_Auto_Leveling_Items.GetValue() == 1.0
			; do nothing (auto-leveling disabled)
		Else
			SetAngle(0.0, 0.0, GetAngleZ())
		EndIf
	EndEvent
EndState

State ZKeyingObject
	Event OnUpdate()
		If !CustomZKeying_HandleIsKeyPressed(False)
			Return
		EndIf
		If !PlayerREf.IsSneaking()
			Float Pos_X = PlayerREf.X + 100.0
			Float Pos_Y = PlayerREf.Y + 100.0
			Float Pos_Z = PlayerREf.Z + 1.0
			Grabbed_Object.TranslateTo(Pos_X, Pos_Y, Pos_Z, X, Y, Z, 200.0, 180.0)
		EndIf
		CustomZKeying_HandleIsKeyPressed(True)
	EndEvent
EndState