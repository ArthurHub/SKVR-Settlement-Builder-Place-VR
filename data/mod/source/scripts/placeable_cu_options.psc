Scriptname Placeable_CU_Options extends ActiveMagicEffect  

Actor Property PlayerRef Auto
Message Property Placeable_AAA_ManualMenu_Options Auto
Message Property ManualMenu  Auto  
Message Property ManualMenu_AddSpells  Auto  
Message Property ManualMenu_RemoveSpells  Auto
Message Property ManualMenu_AddSpells_FastCraft Auto
Message Property ManualMenu_AddSpells_FastCraft_P2 Auto
Message Property ManualMenu_RemoveSpells_FastCraft Auto
Message Property ManualMenu_RemoveSpells_FastCraft_P2 Auto
Message Property ManualMenu_AddSpells_Creative_Special Auto
Message Property ManualMenu_RemoveSpells_Creative_Special Auto
Message Property ManualMenu_AddSpells_Utilities Auto
Message Property ManualMenu_RemoveSpells_Utilities Auto

Spell Property CreativeModeSpell Auto
Spell Property CreativeCatalogueSpell Auto
Spell Property CreativeStorageSpell Auto
Spell Property TCLSpell Auto
Spell Property ToggleGrassSpell Auto
Spell Property SmithingSpell  Auto 
Spell Property AlchemySpell  Auto
Spell Property EnchantingSpell Auto 
Spell Property StaffEnchantingSpell Auto
Spell Property SmeltingSpell  Auto 
Spell Property CookingSpell  Auto 
Spell Property TanningSpell  Auto 
Spell Property StoreFrontSpell  Auto 
Spell Property ArmourerSpell  Auto   
Spell Property SharpeningSpell Auto
Spell Property BakingSpell Auto
Spell Property Dice01Spell Auto
Spell Property YesOrNoSpell Auto
Spell Property SKSE_PositionerSpell Auto
MiscObject Property CreativeCatalogueMisc Auto
  
Spell Property Placeable_Auto_Level_Object_Global_Toggle_Spell Auto
Spell Property Placeable_SKSE_Positioner_Toggle Auto
Spell Property Placeable_PowerConfig_Spell_02 Auto

Message Property placeable_AAA_Delete_All Auto
Message Property placeable_AAA_Delete_All_01 Auto
Message Property placeable_AAA_Delete_All_02 Auto
Message Property placeable_AAA_Delete_All_03 Auto ; Final Delete

FormList Property Placeable_A_DeleteAll Auto
{A list to delete the otems in}

Bool Property DisableInstead  Auto
{Disable the items instead?}

Bool Property FadeItems  Auto
{If we're disabling, should we also fade them?}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Menu()
EndEvent

;----------------------------------------------------------------------------------------------
; MAIN MENU  (RE-INDEXED: Positioner and Auto-Level entries removed)
; New mapping in message:
;   0 = Do Nothing
;   1 = Add & Remove Spells
;   2 = Remove All Placed Items
;----------------------------------------------------------------------------------------------
Function Menu(int aiButton = 0)
	aiButton = Placeable_AAA_ManualMenu_Options.show()

	if aiButton == 1
		; Add & Remove Spells
		Placeable_PowerConfig_Spell_02.Cast(Game.GetPlayer())
	elseif aiButton == 2
		; Remove All Placed Items
		Delete_All()
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; ADD SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells(int aiButton = 0) ;Add All Spells
	aiButton = ManualMenu_AddSpells.show()

	if aiButton == 1
		Game.GetPlayer().AddSpell(CreativeModeSpell) 
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell)
		Game.GetPlayer().AddItem(CreativeCatalogueMisc, 1)

		Game.GetPlayer().AddSpell(TCLSpell)
		Game.GetPlayer().AddSpell(ToggleGrassSpell)
  
		Game.GetPlayer().AddSpell(StoreFrontSpell)
		Game.GetPlayer().AddSpell(SmithingSpell) 
		Game.GetPlayer().AddSpell(SharpeningSpell) 
		Game.GetPlayer().AddSpell(SmeltingSpell)
		Game.GetPlayer().AddSpell(ArmourerSpell) 
		Game.GetPlayer().AddSpell(TanningSpell) 
		Game.GetPlayer().AddSpell(StaffEnchantingSpell)
		Game.GetPlayer().AddSpell(CreativeStorageSpell)
		Game.GetPlayer().AddSpell(EnchantingSpell)
		Game.GetPlayer().AddSpell(AlchemySpell)
		Game.GetPlayer().AddSpell(CookingSpell)
		Game.GetPlayer().AddSpell(BakingSpell) 
		; Game.GetPlayer().AddSpell(SKSE_PositionerSpell)
		Game.GetPlayer().AddSpell(Dice01Spell)   ; Dice
		Game.GetPlayer().AddSpell(YesOrNoSpell)
		Debug.MessageBox("All Powers Added")
	elseif aiButton == 2
		Game.GetPlayer().AddSpell(CreativeModeSpell)
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell)
		Game.GetPlayer().AddItem(CreativeCatalogueMisc, 1)
	elseif aiButton == 3
		ManualMenu_AddSpells_FastCraft()
	elseif aiButton == 4
		ManualMenu_AddSpells_Utilities() 
	elseif aiButton == 5
		ManualMenu_AddSpells_Creative_Special() 
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells.show()

	if aiButton == 1 ;Remove All Powers
		Game.GetPlayer().RemoveSpell(CreativeModeSpell) 
		Debug.Notification("Option: Creative Mode Removed")
		Game.GetPlayer().RemoveSpell(CreativeCatalogueSpell)
		Debug.Notification("Option: Creative Catalogue Removed")
		Game.GetPlayer().RemoveItem(CreativeCatalogueMisc, 1)

		Game.GetPlayer().RemoveSpell(TCLSpell) 
		Debug.Notification("Creative Utility: Toggle Collision Layer Removed")
          
		Game.GetPlayer().RemoveSpell(ToggleGrassSpell) 
		Debug.Notification("Creative Utility: Toggle Grass Removed")

		Game.GetPlayer().RemoveSpell(StoreFrontSpell) 
		Debug.Notification("Creative Crafting: Store Front Removed")

		Game.GetPlayer().RemoveSpell(SmithingSpell) 
		Debug.Notification("Creative Crafting: Smithing Removed")
          
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Debug.Notification("Creative Crafting: Sharpening Removed")       

		Game.GetPlayer().RemoveSpell(SmeltingSpell)
		Debug.Notification("Creative Crafting: Smelting Removed")
        
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Debug.Notification("Creative Crafting: Armourer Removed")

		Game.GetPlayer().RemoveSpell(TanningSpell) 
		Debug.Notification("Creative Crafting: Tanning Removed")

		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)
		Debug.Notification("Creative Crafting: Staff Enchanting Removed")

		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Debug.Notification("Creative Crafting: Enchanting Removed")
        
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Debug.Notification("Creative Crafting: Alchemy Removed")

		Game.GetPlayer().RemoveSpell(CookingSpell)
		Debug.Notification("Creative Crafting: Cooking Removed")
       
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Debug.Notification("Creative Crafting: Baking Removed")

		Game.GetPlayer().RemoveSpell(Dice01Spell)   ; Dice
		Debug.Notification("Creative Special: Dice Removed")

		Game.GetPlayer().RemoveSpell(YesOrNoSpell)
		Game.GetPlayer().RemoveSpell(SKSE_PositionerSpell)    
		Debug.Notification("Option: Toggle - Integer/Animated Positioner Removed")

		Debug.MessageBox("All Powers Removed")
	elseif aiButton == 2 ;Remove Creative Mode
		Game.GetPlayer().RemoveSpell(CreativeModeSpell) 
		Debug.Notification("Crafting Menu: Creative Mode Removed")
	elseif aiButton == 3
		ManualMenu_RemoveSpells_FastCraft()
	elseif aiButton == 4
		ManualMenu_RemoveSpells_Utilities() 
	elseif aiButton == 5
		ManualMenu_RemoveSpells_Creative_Special() 
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE FAST CRAFT SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_FastCraft(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_FastCraft.show()

	if aiButton == 1
		Game.GetPlayer().RemoveSpell(SmithingSpell) 
		Debug.Notification("Creative Crafting: Smithing Removed")
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Debug.Notification("Creative Crafting: Sharpening Removed")       
		Game.GetPlayer().RemoveSpell(SmeltingSpell)
		Debug.Notification("Creative Crafting: Smelting Removed")
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Debug.Notification("Creative Crafting: Armourer Removed")
		Game.GetPlayer().RemoveSpell(TanningSpell) 
		Debug.Notification("Creative Crafting: Tanning Removed")
		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Debug.Notification("Creative Crafting: Enchanting Removed")
		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)
		Debug.Notification("Creative Crafting:Staff Enchanting Removed")
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Debug.Notification("Creative Crafting: Alchemy Removed")
		Game.GetPlayer().RemoveSpell(CookingSpell)
		Debug.Notification("Creative Crafting: Cooking Removed")
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Debug.Notification("Creative Crafting: Baking Removed")
		Debug.MessageBox("All Crafting Menus - Removed")
	elseif aiButton == 2
		Game.GetPlayer().RemoveSpell(SmithingSpell)  
		Debug.Notification("Creative Crafting: Smithing - Removed")
	elseif aiButton == 3
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Debug.Notification("Creative Crafting: Sharpening - Removed")
	elseif aiButton == 4
		Game.GetPlayer().RemoveSpell(SmeltingSpell)  
		Debug.Notification("Creative Crafting: Smelting - Removed")
	elseif aiButton == 5
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Debug.Notification("Creative Crafting: Armourer - Removed")
	elseif aiButton == 6 
		Game.GetPlayer().RemoveSpell(TanningSpell)
		Debug.Notification("Creative Crafting: Tanning - Removed")
	elseif aiButton == 7 
		ManualMenu_RemoveSpells_FastCraft_P2()
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE FAST CRAFTING SPELLS - PAGE 2
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_FastCraft_P2(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_FastCraft_P2.show()

	if aiButton == 1
		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)  
		Debug.Notification("Staff Enchanting- Removed")
	elseif aiButton == 2
		Game.GetPlayer().RemoveSpell(EnchantingSpell)  
		Debug.Notification("Enchanting- Removed")
	elseif aiButton == 3
		Game.GetPlayer().RemoveSpell(AlchemySpell)  
		Debug.Notification("Alchemy- Remove")
	elseif aiButton == 4
		Game.GetPlayer().RemoveSpell(CookingSpell)
	elseif aiButton == 5
		Game.GetPlayer().RemoveSpell(BakingSpell)  
		Debug.Notification("Baking - Removed")
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE CREATIVE SPECIAL SPELLS
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_Creative_Special(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_Creative_Special.show()

	if aiButton == 1
		Game.GetPlayer().RemoveSpell(StoreFrontSpell)  
		Debug.Notification("Creative Special: Store Front- Removed")
	elseif aiButton == 2
		Game.GetPlayer().RemoveSpell(CreativeStorageSpell)  
		Debug.Notification("Creative Special: Creative Storage - Removed")
	elseif aiButton == 3
		; Do nothing
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; ADD FAST CRAFTING SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_FastCraft(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_FastCraft.show()

	if aiButton == 1
		Game.GetPlayer().AddSpell(SmithingSpell) 
		Game.GetPlayer().AddSpell(SharpeningSpell)
		Game.GetPlayer().AddSpell(SmeltingSpell) 
		Game.GetPlayer().AddSpell(ArmourerSpell)
		Game.GetPlayer().AddSpell(TanningSpell)
		Game.GetPlayer().AddSpell(StaffEnchantingSpell)
		Game.GetPlayer().AddSpell(EnchantingSpell) 
		Game.GetPlayer().AddSpell(AlchemySpell)
		Game.GetPlayer().AddSpell(CookingSpell)
		Game.GetPlayer().AddSpell(BakingSpell)
		Debug.MessageBox("All Crafting Menus Added")
	elseif aiButton == 2
		Game.GetPlayer().AddSpell(SmithingSpell)  
	elseif aiButton == 3
		Game.GetPlayer().AddSpell(SharpeningSpell)
	elseif aiButton == 4
		Game.GetPlayer().AddSpell(SmeltingSpell)  
	elseif aiButton == 5
		Game.GetPlayer().AddSpell(ArmourerSpell)
	elseif aiButton == 6 
		Game.GetPlayer().AddSpell(TanningSpell)
	elseif aiButton == 7 
		ManualMenu_AddSpells_FastCraft_P2()
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; ADD FAST CRAFTING SPELLS - PAGE 2
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_FastCraft_P2(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_FastCraft_P2.show()

	if aiButton == 1
		Game.GetPlayer().AddSpell(StaffEnchantingSpell)  
	elseif aiButton == 2
		Game.GetPlayer().AddSpell(EnchantingSpell)  
	elseif aiButton == 3
		Game.GetPlayer().AddSpell(AlchemySpell)  
	elseif aiButton == 4
		Game.GetPlayer().AddSpell(CookingSpell)
	elseif aiButton == 5
		Game.GetPlayer().AddSpell(BakingSpell)  
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; ADD CREATIVE SPECIAL SPELLS
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_Creative_Special(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_Creative_Special.show()

	if aiButton == 1
		Game.GetPlayer().AddSpell(StoreFrontSpell)  
	elseif aiButton == 2
		Game.GetPlayer().AddSpell(CreativeStorageSpell)  
	elseif aiButton == 3
		; Do nothing
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; ADD CREATIVE UTILITIES SPELLS  (RE-INDEXED: Positioner button removed from message)
; New mapping: 1 = Add TCLSpell, 2 = Add ToggleGrassSpell
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_Utilities.show()

	if aiButton == 1
		Game.GetPlayer().AddSpell(TCLSpell)
	elseif aiButton == 2
		Game.GetPlayer().AddSpell(ToggleGrassSpell)
	endif
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE CREATIVE UTILITIES SPELLS  (RE-INDEXED: Positioner button removed from message)
; New mapping: 1 = Remove TCLSpell, 2 = Remove ToggleGrassSpell
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_Utilities.show()

	if aiButton == 1
		Game.GetPlayer().RemoveSpell(TCLSpell)
	elseif aiButton == 2
		Game.GetPlayer().RemoveSpell(ToggleGrassSpell)
	endif
EndFunction

;================== Delete All ==================
Function Delete_All()
	int aiButton = placeable_AAA_Delete_All.show()
	; Message layout (after removing "Nope" button in xEdit):
	; 0 = Back
	; 1 = No
	; 2 = Yes  (perform delete)

	if aiButton == 0
		; Back
		Menu()
	elseif aiButton == 2 ; Yes
		Game.FadeOutGame(true, true, 0, 2)
		Utility.Wait(1)
		DeleteAllItemsInList(Placeable_A_DeleteAll, false, true)
		Game.FadeOutGame(false, true, 3.0, 2.0) 
	else
		; No / anything else: do nothing
	endif
EndFunction

Function DeleteAllItemsInList(FormList akList, Bool abOnlyDisable = false, Bool abFade = true) Global
	Int aiSize = akList.GetSize()
	Int i = 0
	if abOnlyDisable
		while i < aiSize
			(akList.GetAt(i) as ObjectReference).DisableNoWait(abFade)
			i += 1
		EndWhile
	else
		while i < aiSize
			(akList.GetAt(i) as ObjectReference).Delete()
			i += 1
		EndWhile
	endif
EndFunction