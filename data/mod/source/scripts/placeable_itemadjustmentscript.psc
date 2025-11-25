Scriptname Placeable_ItemAdjustmentScript extends ObjectReference  

GlobalVariable Property Placeable_Positioner_SKSE_Global Auto

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
MiscObject property MiscObj auto
Static Property StaticDummy Auto
Activator Property Functional_Activator Auto
Spell Property Placeable_SKSE_Positioner_Toggle Auto

Spell Placeable_Auto_Level_Object_Global_Toggle_Spell
GlobalVariable Placeable_Auto_Leveling_Items

Armor Placeable_SSB_Indicator_Armor
MiscObject Placeable_SSB_Indicator_Check 
Spell Placeable_SSB_Indicator_Spell  ;Placeable Indicator

Static Placeable_SSB_Indicator
GlobalVariable Placeable_SSB_Indicator_Global_Var
Static Placeable_SSB_Indicator_XMarker
MiscObject Placeable_SSB_Activate_Effect

Formlist Placeable_Position_Reset_List
Formlist Placeable_Position_StorePosition_Info_List
FormList Placeable_A_DeleteAll
Static LoadScreenLogo
Actor PlayerRef

Message MenuUi_ItemAdjustmentScript_Hub

;----------------------------------------Auto - Object Leveling - System ----------------------------------------------------------------------------

Event OnInit() ; This event will run once, when the script is initialized
    RegisterForSingleUpdate(1.0)
     
    ;Caution
    ;===========================================Delete All Fomlist Property================================================
    Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as Formlist
    ;======================================================================================================================
    ;========================================Toggle Integer & SKSE Menu's==================================================
    Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell ;Auto Level Object Spell Formlist
    ;========================================Auto Level Objects============================================================
    Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable ; Auto Level Object Global Var Formlist
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator============================================================
    Placeable_SSB_Indicator_Armor = Game.GetFormFromFile(0x00F575F1, "LvxMagick - Skyrim - Settlement Builder.Esm") as Armor 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator CHECK (Misc_Obj)========================================
    Placeable_SSB_Indicator_Spell = Game.GetFormFromFile(0x00F74AF5, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator Global ================================================
    Placeable_SSB_Indicator_Global_Var = Game.GetFormFromFile(0x00F79BFB, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator XMarker ===============================================
    Placeable_SSB_Indicator_XMarker = Game.GetFormFromFile(0x00F79BFC, "LvxMagick - Skyrim - Settlement Builder.Esm") as Static 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator XMarker ===============================================
    Placeable_SSB_Activate_Effect = Game.GetFormFromFile(0x00F88F03, "LvxMagick - Skyrim - Settlement Builder.Esm") as MiscObject 
    ;=======================================================================================================================
    ;========================================Main UI Hub Message ===========================================================
    MenuUi_ItemAdjustmentScript_Hub = Game.GetFormFromFile(0x00F79BFE, "LvxMagick - Skyrim - Settlement Builder.Esm") as Message
    ;=======================================================================================================================
    ;========================================== Grab Activator=============================================================
    PlayerRef = Game.GetForm(0x14) As Actor
    ;========================================Toggle Integer & SKSE Menu's==================================================

    If (Placeable_Auto_Leveling_Items.GetValue() == 0)
        GoToState("Auto_Level")
    Else
        ; do nothing
    EndIf
EndEvent

State Auto_Level
    Event OnBeginState()
        If (Placeable_Auto_Leveling_Items.GetValue() == 1)
            ; debug.Notification("Object Auto-Leveled OFF")
        Else
            Self.SetAngle(0.0, 0.0, Self.GetAngleZ()) ; Default
            ; debug.Notification("Object Auto-Level System Working")
        EndIf
    EndEvent
EndState

;=====================================================================================================================
;---------------------------------------------------ACTIVATE -> ALWAYS MAIN HUB--------------------------------------|
;=====================================================================================================================

Event OnActivate(ObjectReference akActionRef)
    BlockActivation(self)
    Menu_Main_Hub()           ; unconditionally use the regular main hub
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
   
    RegisterForSingleUpdate(0) ; Send the first update immediately
EndEvent

String zKeyOldState = "" ; Store the old state so we can go back to it once we're done

; Z-Keying is the internal name that Bethesda gave to grabbing an object and moving it
State ZKeyingObject
    Event OnUpdate()
        If !CustomZKeying_HandleIsKeyPressed()
            return
        EndIf
        
        if !PlayerRef.isSneaking()
            float Angle_X = PlayerRef.GetPositionX()
            float Angle_Y = PlayerRef.GetPositionY()
            float Angle_Z = PlayerRef.GetPositionZ() + 180 ; Face the player at least!

            float Pos_X = PlayerRef.X + 100
            float Pos_Y = PlayerRef.Y + 100
            float Pos_Z = PlayerRef.Z + 100

            dummyMovementObject.TranslateTo(Pos_X, Pos_Y, Pos_Z, Angle_X, Angle_Y, Angle_Z, 200, 180)
        else
        EndIf

        CustomZKeying_HandleIsKeyPressed(true)
    EndEvent
EndState

Bool Function CustomZKeying_HandleIsKeyPressed(bool registerForUpdate = false)
    If Input.IsKeyPressed(Input.GetMappedKey("Activate")) ; Fetch it every time to prevent edge-case issues
        If registerForUpdate
            RegisterForSingleUpdate(0.1) ; Re-run this function in a tenth of a second
        EndIf
        return true
    Else ; Looks like we're done then.
        self.MoveTo(dummyMovementObject, abMatchRotation = True)
        self.EnableNoWait()
        dummyMovementObject.Disable()
        dummyMovementObject.Delete()

        ; Gracefully return to the previous state
        GoToState(zKeyOldState)
        zKeyOldState = ""
        return false
    EndIf
EndFunction

;=============================================================================================================================================
;---------------------------------------------------- (Move) - Activator With Blue Indicator)------------------------------------------------|
;=============================================================================================================================================

ObjectReference Move_Item
Function Move_Activator()
    Placeable_SSB_Indicator_Global_Var.SetValue(1) ; Fixed Script Bug
    Placeable_SSB_Indicator_Spell.cast(PlayerRef)
    Self.DisableNoWait() 
    Move_Activator_Update() ;Go to Update
EndFunction   

Function Move_Activator_Update()
    While(Placeable_SSB_Indicator_Global_Var.GetValue() == 1.0) 
        Debug.Notification("Press Crouch To Place Item")
        MyMainFunc()
        Utility.Wait(1.1)
        Cleanup()
    EndWhile
EndFunction

Function MyMainFunc()
  int i = Input.GetMappedKey("Sneak")
  RegisterForKey(i)
endFunction

Event OnKeyDown(int keycode)
   If PlayerRef.IsSneaking() ; extra check just in case
     Move_Item = PlayerRef.placeAtMe(Placeable_SSB_Indicator_XMarker)
     Move_Item.MoveTo(PlayerRef, 150.0 * Math.Sin(PlayerRef.GetAngleZ()), 150.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 128)
     Self.MoveTo(Move_Item)
     Self.SetAngle(0.0, 0.0, Self.GetAngleZ())  ;Level Object Angle

     float zOffset = Self.GetHeadingAngle(Game.GetPlayer())  ; Makes Object Face Player
     Self.SetAngle(Self.GetAngleX(), Self.GetAngleY(), Self.GetAngleZ() + zOffset)

     Self.EnableNoWait()    ;Teleports the Activator to the Placed Xmarker
   EndIf
endEvent

Function Cleanup()
  UnregisterForAllKeys()
endFunction

;________________________________________________________________________________________________________________________________
;                                                Main Hub Item Adjustment Script                                                | 
;_______________________________________________________________________________________________________________________________|

; ===========================
; UPDATED for new button order
; ===========================
Function Menu_Main_Hub(int aiButton = 0)
  aiButton = MenuUi_ItemAdjustmentScript_Hub.show()

  If aiButton == 0
    ; Done
  ElseIf aiButton == 1
    Menu()                        ; Position (legacy)
  ElseIf aiButton == 2
    Self.DisableNoWait()
    Game.GetPlayer().addItem(MiscObj)
    Delete()                      ; Pickup
  ElseIf aiButton == 3
    Make_Static()                 ; (Make Static)
  EndIf
EndFunction

; ===========================
; SKSE path retained but unreachable
; ===========================
Function Menu_Main_Hub_SKSE(int aiButton = 0)
  aiButton = MenuUi_ItemAdjustmentScript_Hub.show()

  If aiButton == 0
    ; Done
  ElseIf aiButton == 1
    MenuUI_SKSE()                 ; Position (SKSE)
  ElseIf aiButton == 2
    Self.DisableNoWait()
    Game.GetPlayer().addItem(MiscObj)
    Delete()                      ; Pickup
  ElseIf aiButton == 3
    Make_Static()                 ; (Make Static)
  EndIf
EndFunction

;________________________________________________________________________________________________________________________________
;                                                     Main Menu - Position (LEGACY ONLY)                                        | 
;_______________________________________________________________________________________________________________________________|

Function Menu(int aiButton = 0)
 aiButton = MenuUi.show()
 If aiButton ==  1
    Z_Menu()
ElseIf aiButton == 2
    Y_Menu()
ElseIf aiButton == 3
    X_Menu()
ElseIf aiButton == 4
    Rotate_Menu()
    Utility.wait(0.1)
ElseIf aiButton == 5
    Self.DisableNoWait()
    Game.GetPlayer().addItem(MiscObj)
    Delete()
ElseIf aiButton == 6   ; Options
    MenuUi_Options()
ElseIf aiButton == 7
    Make_Static()
ElseIf aibutton == 8
    ;Free_Movement_System()  
EndIf
EndFunction

;________________________________________________________________________________________________________________________________
;                                                     Main Menu SKSE - Position (retained)                                      | 
;_______________________________________________________________________________________________________________________________|

Function MenuUI_SKSE(bool abFadeIn = false)
 Int aiButton =  MenuUi_SKSE.show()       
 If aiButton == 1
    Z_Menu_SKSE()
ElseIf aiButton == 2
    Y_Menu_SKSE()
ElseIf aiButton == 3
    X_Menu_SKSE()
ElseIf aiButton == 4
    Rotate_Menu_SKSE()
    Utility.wait(0.1)
ElseIf aiButton == 5
    Self.DisableNoWait()
    game.getPlayer().addItem(MiscObj)
    Delete()
ElseIf aiButton == 6   ; Options
    Options()
ElseIf aiButton == 7
    Make_Static()
ElseIf aibutton == 8
    ;Free_Movement_System()  
EndIf
EndFunction

;------------------------------------------------------------------------Z_Menu (LEGACY ONLY PATH)-----------------------------------------------------------
Function Z_Menu(bool abFadeIn = false)
   Int aiButton =  Z_Ui.show()
   If aiButton == 0
     Menu()
   ElseIf aiButton == 1
     SetPosition(X, Y, Z*1 - 20)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 2
     SetPosition(X, Y, Z*1 - 10)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 3
     SetPosition(X, Y, Z*1 - 1)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 4
     SetPosition(X, Y, Z*1 + 1)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 5
     SetPosition(X, Y, Z*1 + 10)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 6
     SetPosition(X, Y, Z*1 + 20)
     Self.Enable()
     Z_Menu(abFadeIn)
   ElseIf aiButton == 7  ; Reset Object
     Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
     Self.Enable()
     Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
     Z_Menu(abFadeIn)
   ElseIf aiButton == 8
     ; legacy-only: no SKSE toggle or submenu, just stay in Z menu
     Z_Menu(abFadeIn)
   EndIf
EndFunction

;----------------------------------------------------------------------------------------------------Y_Menu (LEGACY ONLY PATH)---------------------------------------------------------
Function Y_Menu(bool abFadeIn = false)
   Int aiButton =  Y_Ui.show()
   If aiButton == 0
     Menu()
   ElseIf aiButton == 1
     SetPosition(X, Y*1 - 20, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 2
     SetPosition(X, Y*1 - 10, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 3
     SetPosition(X, Y*1 - 1, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 4
     SetPosition(X, Y*1 + 1, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 5
     SetPosition(X, Y*1 + 10, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 6
     SetPosition(X, Y*1 + 20, Z)
     Self.Enable()
     Y_Menu(abFadeIn)
   ElseIf aiButton == 7 ; Reset Object
     Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
     Self.Enable()
     Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
     Y_Menu(abFadeIn)
   ElseIf aiButton == 8
     ; legacy-only: no SKSE toggle or submenu, just stay in Y menu
     Y_Menu(abFadeIn)
   EndIf
EndFunction

;---------------------------------------------------------------------------------------------X_Menu (LEGACY ONLY PATH)---------------------------------------------------------------
Function X_Menu(bool abFadeIn = false)
   Int aiButton =  X_Ui.show()
   If aiButton == 0
     Menu()
   ElseIf aiButton == 1
     SetPosition(X*1 - 20, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 2
     SetPosition(X*1 - 10, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 3
     SetPosition(X*1 - 1, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 4
     SetPosition(X*1 + 1, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 5
     SetPosition(X*1 + 10, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 6
     SetPosition(X*1 + 20, Y, Z)
     Self.Enable()
     X_Menu(abFadeIn)
   ElseIf aiButton == 7  ; Reset Object
     Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
     Self.Enable()
     Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
     X_Menu(abFadeIn)
   ElseIf aiButton == 8
     ; legacy-only: no SKSE toggle or submenu, just stay in X menu
     X_Menu(abFadeIn)
   EndIf
EndFunction

;--------------------------------------------------------------------------------------Rotate_Menu (LEGACY ONLY PATH)-----------------------------------------------------------
Function Rotate_Menu(bool abFadeIn = false)
   Int aiButton =  Rotate_Ui.show()
   If aiButton == 0
       Menu()
   ElseIf aiButton == 1
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() - 20.0)
    Self.Enable()    
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 2
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() - 10.0)
    Self.Enable()   
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 3
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() - 1.0)
    Self.Enable()    
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 4
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() + 1.0)
    Self.Enable()    
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 5
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() + 10.0)
    Self.Enable()   
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 6
    Self.SetAngle(0.0, 0.0, self.GetAngleZ() + 20.0)
    Self.Enable()    
    Rotate_Menu(abFadeIn)
   ElseIf aiButton == 7    ; previously SKSE movement toggle ? SKSE rotate; now legacy-only
    Rotate_Menu(abFadeIn)
   EndIf
EndFunction

;------------------------------------------------------------------------------------Options_Menu----------------------------------------------------------------------------

Function MenuUi_Options( int aiButton = 0, bool abFadeOut = False)
   If aiButton != -1
     aiButton =  MenuUi_Options.show()
     If aiButton == 0
      Menu()
     ElseIf aiButton==1
      MenuUi_Options_PositionerMenu()
     EndIf
   EndIf
EndFunction

Function MenuUi_Options_PositionerMenu( int aiButton = 0, bool abFadeOut = False) ; Show Option Menu
  If aiButton != -1
    aiButton= MenuUi_Options_PositionerMenu.Show()
    If aibutton == 0
      MenuUi_Options()
    ElseIf aiButton== 1
      Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
    ElseIf aiButton == 2
      Placeable_Auto_Level_Object_Global_Toggle_Spell.Cast(PlayerRef)
    ElseIf aiButton == 3
      ; unused
    EndIf
  EndIf
EndFunction

;----------------------------------------------------------------------------Z_SKSE_Menu (retained, not called from legacy)------------------------------------
Function Z_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Z_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.DisableNoWait()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1, false,true)
   PositionObject.EnableNoWait()
   PositionObject.SetMotionType(4) ;static Settings

   If aiButton == 0
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
    PositionObject.DisableNoWait()
    PositionObject.Delete()
    Self.EnableNoWait()   
    MenuUi_SKSE() ; Back
ElseIf aiButton == 1
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), (PositionObject.GetPositionZ() - 5), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Z_Menu_SKSE(abFadeIn)
ElseIf aiButton == 2
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), (PositionObject.GetPositionZ() + 5), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Z_Menu_SKSE(abFadeIn)
ElseIf aiButton == 3  ;Reset Item
    Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
    PositionObject.Delete()
    Z_Menu_SKSE(abFadeIn)
ElseIf aiButton == 4
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Movement_System_Toggle() ; Reset Object
    Z_Menu() ; Back
Endif
EndFunction

;---------------------------------------------------------------------------------Function_Y_SKSE (retained, not called from legacy)---------------------------
Function Y_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Y_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.DisableNoWait()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1, false,true)
   PositionObject.EnableNoWait()
   PositionObject.SetMotionType(4) ;static Settings

   If aiButton == 0
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
    PositionObject.DisableNoWait()
    PositionObject.Delete()
    Self.EnableNoWait()   
    MenuUi_SKSE() ; Back
ElseIf aiButton == 1
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), (PositionObject.GetPositionY() - 5), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Y_Menu_SKSE(abFadeIn)
ElseIf aiButton == 2
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), (PositionObject.GetPositionY() + 5), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Y_Menu_SKSE(abFadeIn)
ElseIf aiButton == 3  ;Reset Item
    Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
    PositionObject.Delete()
    Y_Menu_SKSE(abFadeIn)
ElseIf aiButton == 4
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Movement_System_Toggle() ; Reset Object
    Y_Menu() ; Back
Endif
EndFunction

;----------------------------------------------------------------------------------Funtion_X_SKSE (retained, not called from legacy)--------------------------
Function X_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  X_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.DisableNoWait()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1, false,true)
   PositionObject.EnableNoWait()
   PositionObject.SetMotionType(4) ;static Settings

   If aiButton == 0
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
    PositionObject.DisableNoWait()
    PositionObject.Delete()
    Self.EnableNoWait()   
    MenuUi_SKSE() ; Back
ElseIf aiButton == 1
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo( (PositionObject.GetPositionX() - 5), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    X_Menu_SKSE(abFadeIn)
ElseIf aiButton == 2
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo( (PositionObject.GetPositionX() + 5), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    X_Menu_SKSE(abFadeIn)
ElseIf aiButton == 3  ;Reset Item
    Self.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    Self.SetAngle(0.0, 0.0, Self.GetAngleZ())
    PositionObject.Delete()
    X_Menu_SKSE(abFadeIn)
ElseIf aiButton == 4
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Movement_System_Toggle()
    X_Menu()
Endif
EndFunction

;--------------------------------------------------------------------------------Rotate_SKSE (retained, not called from legacy)--------------------------------
Function Rotate_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Rotate_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.DisableNoWait()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1, false,true)
   PositionObject.EnableNoWait()
   PositionObject.SetMotionType(4) ;static

   Utility.Wait(0.1)
   Self.DisableNoWait()

   If aiButton == 0
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
    PositionObject.DisableNoWait()
    PositionObject.Delete()
    Self.EnableNoWait()   
    MenuUi_SKSE() ; Back
ElseIf aiButton == 1
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() - 5, 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    Self.SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Rotate_Menu_SKSE(abFadeIn)
ElseIf aiButton == 2
    Int ActivateKey = Input.GetMappedKey("Activate")
    While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
        PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ() + 5, 500, 0)    
    EndWhile
    Utility.Wait(0.1)
    Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
    PositionObject.DisableNoWait()
    Self.SetAngle(PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ())
    Self.EnableNoWait()
    PositionObject.Delete()
    Rotate_Menu_SKSE(abFadeIn)
ElseIf aiButton == 3
    PositionObject.DisableNoWait()
    Self.EnableNoWait()
    PositionObject.Delete()
    Movement_System_Toggle()
    Rotate_Menu()
Endif
EndFunction

;-----------------------------------------------------------------------------------------------------------------Options (SKSE PATH, UNREACHABLE FROM LEGACY)------------------------
Function Options(int aiButton = 0, bool abFadeOut = False)
 If aiButton != -1
    aiButton =  MenuUi_Options_SKSE.show()
    If aiButton == 0
        MenuUi_SKSE()  
    ElseIf aiButton==1
        MenuUi_Options_PositionerMenu()
    ElseIf aiButton == 2
        Placeable_Auto_Level_Object_Global_Toggle_Spell.cast(PlayerRef)
    ElseIf aiButton == 3
        Debug.Notification("Use the Skyrim Settelement Builder Options: Lesser Power To Delete All")
    EndIf   
 EndIf
EndFunction

Function Options_Positioner_Menu(int aiButton = 0, bool abFadeOut = False) ; Show Option Menu
    If aiButton != -1
        aiButton= MenuUi_Options_PositionerMenu_SKSE.Show()
        If aibutton == 0
         Options()
     ElseIf aiButton==1
        Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
    EndIf
EndIf
EndFunction

;________________________________________________________________________________________________________________________________
;                                                           Make Static                                                         | 
;_______________________________________________________________________________________________________________________________|
Function Make_Static(int aiButton = 0) ;Make Static
  aiButton = MenuUi_MakeStatic.show()
  If aiButton == 1
    DisableNoWait(true)
    Disable(true)
    Placeable_A_DeleteAll.AddForm(PlaceatMe(StaticDummy))     
    Delete()
    Utility.Wait(0.1)
    Utility.Wait(0.1)
  Else 
  EndIf
EndFunction 

;----------------------------------------Movement System Toggle Switch SKSE <-> Integer ----------------------------------------------------------

Function Movement_System_Toggle()
    Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
EndFunction