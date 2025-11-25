Scriptname Placeable_Furniture_ItemAdjustment extends ObjectReference  

Message Property Menu_Action_Furniture Auto
Message Property MenuUi_Funiture_MainMenu Auto
Message Property  MenuUi_PositionSelect02 Auto
Message Property  Z_Ui Auto
Message Property   Y_Ui Auto
Message Property  X_Ui Auto
Message Property Rotate_Ui Auto
Message Property MenuUi_DeployFurnitureStatic_Act Auto

MiscObject property MiscObj auto

;---------------------------------------------------------------SKSE Properties--------------
Message Property Menu_Action_Furniture_SKSE Auto
Actor Property PlayerRef Auto
GlobalVariable Property Placeable_Positioner_SKSE_Global Auto
Message Property MenuUi Auto
Message Property MenuUi_SKSE Auto
Message Property MenuUi_MakeStatic Auto
Message Property MenuUi_MakeStatic_SKSE Auto
Message Property MenuUi_Options Auto
Message Property MenuUi_Options_SKSE Auto
Message Property  MenuUi_Options_PositionerMenu Auto
Message Property  MenuUi_Options_PositionerMenu_SKSE Auto
Message Property Z_Ui_SKSE Auto
Message Property Y_Ui_SKSE Auto
Message Property X_Ui_SKSE Auto
Message Property Rotate_Ui_SKSE Auto
Static Property StaticDummy Auto
Spell Property Placeable_SKSE_Positioner_Toggle Auto
Message Property MenuUi_Make_Furniture_Permanent Auto

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
Furniture Property Permanent_Furniture Auto

; ========================= NEW PROPERTIES (fill in CK) =========================
Furniture Property Placeable_Furniture_SmithForge01_Obj Auto  ; base form to match
Light     Property MyLightBulb                         Auto   ; bulb to spawn
Float     Property BulbZOffset                        = 0.0   Auto ; optional Z tweak
; ==============================================================================

Event OnInIt()
    ;===========================================Delete All Fomlist Property================================================
    Placeable_A_DeleteAll = Game.GetFormFromFile(0x00E26327, "LvxMagick - Skyrim - Settlement Builder.Esm") as Formlist
    ;======================================================================================================================
    ;========================================Toggle Integer & SKSE Menu's==================================================
    Placeable_Auto_Level_Object_Global_Toggle_Spell = Game.GetFormFromFile(0x00DE456D, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell
    ;========================================Auto Level Objects============================================================
    Placeable_Auto_Leveling_Items = Game.GetFormFromFile(0x00DD0161, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator========================================================
    Placeable_SSB_Indicator_Armor = Game.GetFormFromFile(0x00F575F1, "LvxMagick - Skyrim - Settlement Builder.Esm") as Armor 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator CHECK (Misc_Obj)======================================
    Placeable_SSB_Indicator_Spell = Game.GetFormFromFile(0x00F74AF5, "LvxMagick - Skyrim - Settlement Builder.Esm") as Spell 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator Global ==============================================
    Placeable_SSB_Indicator_Global_Var = Game.GetFormFromFile(0x00F79BFB, "LvxMagick - Skyrim - Settlement Builder.Esm") as GlobalVariable 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator XMarker =============================================
    Placeable_SSB_Indicator_XMarker = Game.GetFormFromFile(0x00F79BFC, "LvxMagick - Skyrim - Settlement Builder.Esm") as Static 
    ;=======================================================================================================================
    ;========================================SSB Placeable Indicator XMarker =============================================
    Placeable_SSB_Activate_Effect = Game.GetFormFromFile(0x00F88F03, "LvxMagick - Skyrim - Settlement Builder.Esm") as MiscObject 
    ;=======================================================================================================================
EndEvent

;=====================================================================================================================
;--------------------------------------------------- SKSE INSTALLED CHECK (DISABLED – LEGACY ONLY) -------------------
;=====================================================================================================================
Event OnActivate(ObjectReference akActionRef)
    ; Always use the regular (non-SKSE) menu
    Menu()
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

            ; position a little in front/above
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

        ; Gracefully return to the previous state
        GoToState(zKeyOldState)
        zKeyOldState = ""
        return false
    EndIf
EndFunction

;=============================================================================================================================================
;---------------------------------------------------- (Move) - Activator With Blue Indicator)------------------------------------------------|
;=============================================================================================================================================
Objectreference Move_Item
Function Move_Activator()
    Placeable_SSB_Indicator_Global_Var.SetValue(1) ; Fixed Script Bug
    Placeable_SSB_Indicator_Spell.cast(PlayerRef)
    Self.DisableNoWait() 
    Move_Activator_Update() ;Go to Update
    Debug.Messagebox("Move Actavator Working")
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
     float zOffset = Self.GetHeadingAngle(Game.GetPlayer())  ; face player
     Self.SetAngle(Self.GetAngleX(), Self.GetAngleY(), Self.GetAngleZ() + zOffset)
     Self.EnableNoWait()
   EndIf
endEvent

Function Cleanup()
  UnregisterForAllKeys()
endFunction

;________________________________________________________________________________________________________________________________
;                                                        Main Menu                                                              | 
;_______________________________________________________________________________________________________________________________|
; RE-INDEXED after removing Button #1 (Level Object) and #5 (Move):
; 0 = Done, 1 = Position, 2 = Pickup, 3 = (Place Furniture / Make Furniture Permanent)
Function Menu(int aiButton = 0)
  aiButton = Menu_Action_Furniture.show()
  Utility.Wait(0.1)
  
  If aiButton == 0
    ; Done / Exit

  ElseIf aiButton == 1        ; Position
    Position()

  ElseIf aiButton == 2        ; Pickup Activator
    self.Disable(true)
    game.getPlayer().addItem(MiscObj)
    Disable()
    DeleteWhenAble()
    Delete()

  ElseIf aiButton == 3        ; Make Furniture Permanent
    MenuUi_Make_Furniture_Permanent()

  EndIf
EndFunction

;________________________________________________________________________________________________________________________________
;                                                        Main Menu SKSE (UNUSED)                                               | 
;_______________________________________________________________________________________________________________________________|
; Kept for compatibility, but no longer called from OnActivate and still uses SKSE menus.
Function Menu_SKSE(int aiButton = 0)
  aiButton = Menu_Action_Furniture_SKSE.show()
  Utility.Wait(0.1)
  
  If aiButton == 0
    ; Done / Exit

  ElseIf aiButton == 1        ; Position Select (SKSE path)
    Menu()

  ElseIf aiButton == 2        ; Pickup Activator
    self.Disable(true)
    game.getPlayer().addItem(MiscObj)
    Disable()
    DeleteWhenAble()
    Delete()

  ElseIf aiButton == 3        ; Make Furniture Permanent
    Furniture_Permanent()

  EndIf
ENdFunction

;_______________________________________________________________________________________________________________________________
;                                                        Positioner Menu (LEGACY ONLY)                                         | 
;_______________________________________________________________________________________________________________________________
; Integer Positioner menu (MenuUi):
; 1 = Z, 2 = Y, 3 = X, 4 = Rotate, 5 = Pick Up.
Function Position(Int aiButton = 0)
  aiButton = MenuUi.Show()

  If      aiButton == 1
    Z_Menu()
  ElseIf  aiButton == 2
    Y_Menu()
  ElseIf  aiButton == 3
    X_Menu()
  ElseIf  aiButton == 4  
    Rotate_Menu()
  ElseIf  aiButton == 5                                    ; Pick Up
    Self.Disable(True)
    Game.GetPlayer().AddItem(MiscObj)
    Delete()
  EndIf
EndFunction

;_______________________________________________________________________________________________________________________________
;                                                        Positioner Menu SKSE (UNUSED)                                         | 
;_______________________________________________________________________________________________________________________________|
; Kept for compatibility, but legacy menus are the only active path.
Function MenUui_SKSE(int aiButton = 0)
   aiButton = MenuUi_SKSE.show()       
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
     self.Disable(true)
     game.getPlayer().addItem(MiscObj)
     Delete()
   ElseIf aiButton == 6
     MenuUi_Options_SKSE()
   ElseIf aiButton == 7
     Furniture_Permanent()
   EndIf
EndFunction

;------------------------------------------------- Make Furniture Permanent ---------------------------------------------------------------------------------
Function MenuUi_Make_Furniture_Permanent(int aiButton = 0)
  aiButton = MenuUi_Make_Furniture_Permanent.show()
  If aiButton == 0
    ;Do Nothing

  ElseIf aiButton == 1              ;Make Container Permanent Static
    DisableNoWait(True)
    Disable(true)

    ; place new permanent furniture and track it
    ObjectReference newRef = PlaceAtMe(Permanent_Furniture)
    If Placeable_A_DeleteAll
      Placeable_A_DeleteAll.AddForm(newRef)
    EndIf
    Debug.Notification("Permanent Container Placed")

    ; ---- check base on the placed ref ----
    If newRef.GetBaseObject() == Placeable_Furniture_SmithForge01_Obj
      ObjectReference bulbRef = newRef.PlaceAtMe(MyLightBulb)
      If bulbRef
        bulbRef.SetPosition(newRef.GetPositionX(), newRef.GetPositionY(), newRef.GetPositionZ() + BulbZOffset)
        If Placeable_A_DeleteAll
          Placeable_A_DeleteAll.AddForm(bulbRef)
        EndIf
      EndIf
    EndIf

    DeleteWhenAble() 
    Delete()

  ElseIf aiButton == 2              ;Make Activator Static
    Disable(true)

    ; place new static and track it
    ObjectReference newRef = PlaceAtMe(StaticDummy)
    If Placeable_A_DeleteAll
      Placeable_A_DeleteAll.AddForm(newRef)
    EndIf
    Debug.Notification("Static Placed")

    ; ---- check base on the placed ref ----
    If newRef.GetBaseObject() == Placeable_Furniture_SmithForge01_Obj
      ObjectReference bulbRef = newRef.PlaceAtMe(MyLightBulb)
      If bulbRef
        bulbRef.SetPosition(newRef.GetPositionX(), newRef.GetPositionY(), newRef.GetPositionZ() + BulbZOffset)
        If Placeable_A_DeleteAll
          Placeable_A_DeleteAll.AddForm(bulbRef)
        EndIf
      EndIf
    EndIf

    DeleteWhenAble()
    Delete()
  EndIf
EndFunction

;------------------------------------------------------------------------Z_Menu-----------------------------------------------------------------------
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
     ; Legacy-only: SKSE Z_Menu path disabled
     Debug.Notification("SKSE positioner mode is disabled (legacy Z menu only).")
     Z_Menu(abFadeIn)
   EndIf
EndFunction

;----------------------------------------------------------------------------------------------------Y_Menu--------------------------------------------------------------------------
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
     ; Legacy-only: SKSE Y_Menu path disabled
     Debug.Notification("SKSE positioner mode is disabled (legacy Y menu only).")
     Y_Menu(abFadeIn)
   EndIf
EndFunction

;---------------------------------------------------------------------------------------------X_Menu-----------------------------------------------------------------------------------
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
     ; Legacy-only: SKSE X_Menu path disabled
     Debug.Notification("SKSE positioner mode is disabled (legacy X menu only).")
     X_Menu(abFadeIn)
   EndIf
EndFunction

;--------------------------------------------------------------------------------------Rotate_Menu------------------------------------------------------------------------------- 
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
   ElseIf aiButton == 7    ;-----System Movement Toggle (SKSE path disabled)
     Debug.Notification("SKSE positioner rotation mode is disabled (legacy rotate menu only).")
     Rotate_Menu(abFadeIn)
   EndIf
EndFunction

;----------------------------------------------------------------------------Z_SKSE_Menu (UNUSED, SKSE PATH)----------------------------------------------------------------------
Function Z_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Z_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.Disable()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
   PositionObject.SetMotionType(4) ;static

   If aiButton == 0
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
     PositionObject.Disable()
     PositionObject.Delete()
     Self.Enable()   
     Menu() ; Back
   ElseIf aiButton == 1
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), (PositionObject.GetPositionZ() - 5), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     Z_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 2
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo(PositionObject.GetPositionX(), PositionObject.GetPositionY(), (PositionObject.GetPositionZ() + 5), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     Z_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 3  ;Reset Item
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
     ; Movement_System_Toggle() ; SKSE toggle disabled
     Z_Menu_SKSE()
   EndIf
EndFunction

;---------------------------------------------------------------------------------Function_Y_SKSE (UNUSED, SKSE PATH)-------------------------------------------------
Function Y_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Y_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.Disable()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
   PositionObject.SetMotionType(4) ;static

   If aiButton == 0
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
     PositionObject.Disable()
     PositionObject.Delete()
     Self.Enable()   
     Menu() ; Back
   ElseIf aiButton == 1
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo(PositionObject.GetPositionX(), (PositionObject.GetPositionY() - 5), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     Y_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 2
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo(PositionObject.GetPositionX(), (PositionObject.GetPositionY() + 5), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     Y_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 3  ;Reset Item
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
     ; Movement_System_Toggle() ; SKSE toggle disabled
     Y_Menu_SKSE()
   EndIf
EndFunction

;----------------------------------------------------------------------------------Funtion_X_SKSE (UNUSED, SKSE PATH)-----------------------------------------------------------
Function X_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  X_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.Disable()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
   PositionObject.SetMotionType(4) ;static

   If aiButton == 0
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
     PositionObject.Disable()
     PositionObject.Delete()
     Self.Enable()   
     Menu() ; Back
   ElseIf aiButton == 1
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo( (PositionObject.GetPositionX() - 5), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     X_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 2
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
         PositionObject.TranslateTo( (PositionObject.GetPositionX() + 5), PositionObject.GetPositionY(), PositionObject.GetPositionZ(), PositionObject.GetAngleX(), PositionObject.GetAngleY(), PositionObject.GetAngleZ(), 500, 0)    
     EndWhile
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())
     PositionObject.Disable()
     Self.Enable()
     PositionObject.Delete()
     X_Menu_SKSE(abFadeIn)
   ElseIf aiButton == 3  ;Reset Item
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
     ; Movement_System_Toggle() ; SKSE toggle disabled
     X_Menu_SKSE()
   EndIf
EndFunction

;--------------------------------------------------------------------------------Rotate_SKSE (UNUSED, SKSE PATH)------------------------------------------------------------------
Function Rotate_Menu_SKSE(bool abFadeIn = false)
   Int aiButton =  Rotate_Ui_SKSE.show()

   Utility.Wait(0.1)
   Self.Disable()
   ObjectReference PositionObject = Self.PlaceAtMe(StaticDummy, 1)
   PositionObject.SetMotionType(4) ;static

   Utility.Wait(0.1)
   Self.Disable()

   If aiButton == 0
     Utility.Wait(0.1)
     Self.SetPosition(PositionObject.GetPositionX(), PositionObject.GetPositionY(), PositionObject.GetPositionZ())  
     PositionObject.Disable()
     PositionObject.Delete()
     Self.Enable()   
     MenuUi_SKSE() ; Back
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
     Int ActivateKey = Input.GetMappedKey("Activate")
     While Input.IsKeyPressed(ActivateKey) || Input.IsKeyPressed(256)
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
     ; Movement_System_Toggle() ; SKSE toggle disabled
     Rotate_Menu_SKSE()
   EndIf
EndFunction

;------------------------------------------------------------------------------------Options_Menu (LEGACY)----------------------------------------------------------------------------
Function MenuUi_Options( int aiButton = 0, bool abFadeOut = False)
 If aiButton != -1
   aiButton =  MenuUi_Options.show()
   If aiButton == 0
   ElseIf aiButton == 1
       MenuUi_Options_PositionerMenu()
   EndIf
 EndIf
EndFunction

Function MenuUi_Options_PositionerMenu( int aiButton = 0, bool abFadeOut = False)
  If aiButton != -1
    aiButton= MenuUi_Options_PositionerMenu.Show()
    If aibutton == 0
    ElseIf aiButton == 1
        ; SKSE positioner toggle disabled – legacy only
        Debug.Notification("SKSE positioner toggle is disabled (legacy menu only).")
        ; Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
    EndIf
  EndIf
EndFunction

;----------------------------------------------------------------------------------Options_SKSE (UNUSED)------------------------------------------------------------------------------
Function MenuUi_Options_SKSE(int aiButton = 0, bool abFadeOut = False)
   If aiButton != -1
       aiButton =  MenuUi_Options_SKSE.show()
       If aiButton == 0
       ElseIf aiButton== 1
           MenuUi_Options_PositionerMenu()
       EndIf
   EndIf
EndFunction

Function MenuUi_Options_PositionerMenu_SKSE(int aiButton = 0, bool abFadeOut = False)
    If aiButton != -1
        aiButton= MenuUi_Options_PositionerMenu_SKSE.Show()
        If aibutton == 0
        ElseIf aiButton== 1
            ; SKSE positioner toggle disabled – legacy only
            Debug.Notification("SKSE positioner toggle is disabled (legacy menu only).")
            ; Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
        EndIf
    EndIf
EndFunction

;________________________________________________________________________________________________________________________________
;                                                           Make Static                                                         | 
;_______________________________________________________________________________________________________________________________|
Function Make_Static(int aiButton = 0)
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

;-----------------------------------------------------------Deploy Furniture-----------------------
Function Furniture_Permanent(Bool abMenu = True, int aiButton = 0)
 If aiButton != -1
     aiButton = MenuUi_DeployFurnitureStatic_Act.show()
 ElseIf aiButton == 1
    DisableNoWait(True)
    Disable(true)

    ObjectReference newRef = PlaceAtMe(Permanent_Furniture)
    If Placeable_A_DeleteAll
      Placeable_A_DeleteAll.AddForm(newRef)
    EndIf

    ; ---- check base on the placed ref ----
    If newRef.GetBaseObject() == Placeable_Furniture_SmithForge01_Obj
      ObjectReference bulbRef = newRef.PlaceAtMe(MyLightBulb)
      If bulbRef
        bulbRef.SetPosition(newRef.GetPositionX(), newRef.GetPositionY(), newRef.GetPositionZ() + BulbZOffset)
        If Placeable_A_DeleteAll
          Placeable_A_DeleteAll.AddForm(bulbRef)
        EndIf
      EndIf
    EndIf

    Utility.Wait(1)
    Debug.MessageBox("If you need to pick up the Furniture after placement just crouch & Activate the Furniture again & it will give you a option to pick it up.. ")
    DeleteWhenAble()
    Delete()
 ElseIf aiButton == 2
    DisableNoWait(True)
    Disable(true)

    ObjectReference newRef = PlaceAtMe(StaticDummy)
    If Placeable_A_DeleteAll
      Placeable_A_DeleteAll.AddForm(newRef)
    EndIf

    ; ---- check base on the placed ref ----
    If newRef.GetBaseObject() == Placeable_Furniture_SmithForge01_Obj
      ObjectReference bulbRef = newRef.PlaceAtMe(MyLightBulb)
      If bulbRef
        bulbRef.SetPosition(newRef.GetPositionX(), newRef.GetPositionY(), newRef.GetPositionZ() + BulbZOffset)
        If Placeable_A_DeleteAll
          Placeable_A_DeleteAll.AddForm(bulbRef)
        EndIf
      EndIf
    EndIf

    Delete()
 EndIf
EndFunction 

;----------------------------------------Movement System Toggle Switch SKSE to Integer & Then Back-------------------------------------------
Function Movement_System_Toggle()
    ; SKSE-related toggle cast disabled – legacy integer positioner only
    Debug.Notification("SKSE movement toggle is disabled (legacy positioner only).")
    ; Placeable_SKSE_Positioner_Toggle.cast(PlayerRef)
EndFunction
