Scriptname Placeable_CampfireUnleased_Start extends ActiveMagicEffect  

Message Property Placeable_AAA_CampfireUnleashed_Start_Message Auto 
Message Property Placeable_AAA_ManualMenu_Welcome Auto

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

Sound Property StartFX01 Auto
Sound Property StartFX02 Auto
Spell Property CreativeModeSpell Auto
Spell Property CreativeCatalogueSpell Auto
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
Spell Property CreativeStorageSpell Auto
Spell Property SKSE_PositionerSpell Auto
Spell Property LightningSpell Auto
;Spell Property Placeable_PowerConfig_Spell_02 Auto
Spell Property Placeable_RecipesOff_Spell Auto
Spell Property Placeable_Options_Spell Auto
Book Property placeable___Campfire_Unleashed_Manual Auto
Spell Property Placeable_CampfireUnleashed_Start_Spell Auto

MiscObject Property CreativeCatalogueMisc Auto
Message Property ModMessage Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Menu01()
EndEvent

;----------------------------------------------------------------------------------------------
; MAIN MENU (start)
;----------------------------------------------------------------------------------------------
Function Menu01(int aiButton = 0)
	aiButton = Placeable_AAA_CampfireUnleashed_Start_Message.show()

	If aiButton == 0
		Utility.Wait(1)
		Menu()
		Game.GetPlayer().AddSpell(Placeable_RecipesOff_Spell, false)
		Game.GetPlayer().AddSpell(Placeable_Options_Spell, false)
		;Game.GetPlayer().AddSpell(Placeable_PowerConfig_Spell_02, false)
		Game.GetPlayer().AddItem(placeable___Campfire_Unleashed_Manual)
		Game.GetPlayer().AddSpell(Placeable_RecipesOff_Spell, false)
		Game.GetPlayer().RemoveSpell(Placeable_CampfireUnleashed_Start_Spell)
		Utility.Wait(0.2)
		Debug.Notification("Skyrim - Settlement Builder: Finished Loading")
	ElseIf aiButton == 1
		; Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
Function Menu(int aiButton = 0)
	aiButton = Placeable_AAA_ManualMenu_Welcome.show()
	; WELCOME MENU
	If aiButton == 0
		; Do Nothing
	ElseIf aiButton == 1
		ManualMenu_AddSpells()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells(int aiButton = 0) ;Add All Spells
	aiButton = ManualMenu_AddSpells.show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(CreativeModeSpell, false)
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell, false)
		Game.GetPlayer().AddItem(CreativeCatalogueMisc, 1)

		Game.GetPlayer().AddSpell(TCLSpell, false)
		Game.GetPlayer().AddSpell(ToggleGrassSpell, false)

		Game.GetPlayer().AddSpell(StoreFrontSpell, false)
		Game.GetPlayer().AddSpell(SmithingSpell, false)
		Game.GetPlayer().AddSpell(SharpeningSpell, false)
		Game.GetPlayer().AddSpell(SmeltingSpell, false)
		Game.GetPlayer().AddSpell(ArmourerSpell, false)
		Game.GetPlayer().AddSpell(TanningSpell, false)
		Game.GetPlayer().AddSpell(StaffEnchantingSpell, false)
		Game.GetPlayer().AddSpell(CreativeStorageSpell, false)
		Game.GetPlayer().AddSpell(EnchantingSpell, false)
		Game.GetPlayer().AddSpell(AlchemySpell, false)
		Game.GetPlayer().AddSpell(CookingSpell, false)
		Game.GetPlayer().AddSpell(BakingSpell, false)
		; Game.GetPlayer().AddSpell(SKSE_PositionerSpell, false) ; removed from “All Powers”
		Game.GetPlayer().AddSpell(Dice01Spell, false)
		Game.GetPlayer().AddSpell(YesOrNoSpell, false)
		Debug.MessageBox("All Powers Added")
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(CreativeModeSpell, false)
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell, false)
		Game.GetPlayer().AddItem(CreativeCatalogueMisc, 1)
	ElseIf aiButton == 3
		ManualMenu_AddSpells_FastCraft()
	ElseIf aiButton == 4
		ManualMenu_AddSpells_Utilities()
	ElseIf aiButton == 5
		ManualMenu_AddSpells_Creative_Special()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells.show()

	If aiButton == 1 ;Remove All Powers
		Game.GetPlayer().RemoveSpell(CreativeModeSpell)
		Game.GetPlayer().RemoveSpell(CreativeCatalogueSpell)
		Game.GetPlayer().RemoveItem(CreativeCatalogueMisc, 1)
		Game.GetPlayer().RemoveSpell(TCLSpell)
		Game.GetPlayer().RemoveSpell(ToggleGrassSpell)
		Game.GetPlayer().RemoveSpell(StoreFrontSpell)
		Game.GetPlayer().RemoveSpell(SmithingSpell)
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Game.GetPlayer().RemoveSpell(SmeltingSpell)
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Game.GetPlayer().RemoveSpell(TanningSpell)
		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)
		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Game.GetPlayer().RemoveSpell(CookingSpell)
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Game.GetPlayer().RemoveSpell(Dice01Spell)
		Game.GetPlayer().RemoveSpell(YesOrNoSpell)
		Game.GetPlayer().RemoveSpell(SKSE_PositionerSpell)
		Debug.MessageBox("All Powers Removed")
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(CreativeModeSpell)
		Debug.Notification("Crafting Menu: Creative Mode Removed")
	ElseIf aiButton == 3
		ManualMenu_RemoveSpells_FastCraft()
	ElseIf aiButton == 4
		ManualMenu_RemoveSpells_Utilities()
	ElseIf aiButton == 5
		ManualMenu_RemoveSpells_Creative_Special()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE FAST CRAFT SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_FastCraft(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_FastCraft.show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(SmithingSpell)
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Game.GetPlayer().RemoveSpell(SmeltingSpell)
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Game.GetPlayer().RemoveSpell(TanningSpell)
		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Game.GetPlayer().RemoveSpell(CookingSpell)
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Debug.Notification("All Crafting Menus - Removed")
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(SmithingSpell)
		Debug.Notification("Creative Crafting: Smithing - Removed")
	ElseIf aiButton == 3
		Game.GetPlayer().RemoveSpell(SharpeningSpell)
		Debug.Notification("Creative Crafting: Sharpening - Removed")
	ElseIf aiButton == 4
		Game.GetPlayer().RemoveSpell(SmeltingSpell)
		Debug.Notification("Creative Crafting: Smelting - Removed")
	ElseIf aiButton == 5
		Game.GetPlayer().RemoveSpell(ArmourerSpell)
		Debug.Notification("Creative Crafting: Armourer - Removed")
	ElseIf aiButton == 6 
		Game.GetPlayer().RemoveSpell(TanningSpell)
		Debug.Notification("Creative Crafting: Tanning - Removed")
	ElseIf aiButton == 7 
		ManualMenu_RemoveSpells_FastCraft_P2()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE FAST CRAFTING SPELLS - PAGE 2
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_FastCraft_P2(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_FastCraft_P2.show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(StaffEnchantingSpell)
		Debug.Notification("Staff Enchanting- Removed")
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Debug.Notification("Enchanting- Removed")
	ElseIf aiButton == 3
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Debug.Notification("Alchemy- Remove")
	ElseIf aiButton == 4
		Game.GetPlayer().RemoveSpell(CookingSpell)
	ElseIf aiButton == 5
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Debug.Notification("Baking - Removed")
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE CREATIVE SPECIAL SPELLS
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_Creative_Special(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_Creative_Special.show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(StoreFrontSpell)
		Debug.Notification("Creative Special: Store Front- Removed")
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(CreativeStorageSpell)
		Debug.Notification("Creative Special: Creative Storage - Removed")
	ElseIf aiButton == 3
		; Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD FAST CRAFTING SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_FastCraft(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_FastCraft.show()

	If aiButton == 1
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
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(SmithingSpell)
	ElseIf aiButton == 3
		Game.GetPlayer().AddSpell(SharpeningSpell)
	ElseIf aiButton == 4
		Game.GetPlayer().AddSpell(SmeltingSpell)
	ElseIf aiButton == 5
		Game.GetPlayer().AddSpell(ArmourerSpell)
	ElseIf aiButton == 6 
		Game.GetPlayer().AddSpell(TanningSpell)
	ElseIf aiButton == 7 
		ManualMenu_AddSpells_FastCraft_P2()
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD FAST CRAFTING SPELLS - PAGE 2
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_FastCraft_P2(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_FastCraft_P2.show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(StaffEnchantingSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(EnchantingSpell)
	ElseIf aiButton == 3
		Game.GetPlayer().AddSpell(AlchemySpell)
	ElseIf aiButton == 4
		Game.GetPlayer().AddSpell(CookingSpell)
	ElseIf aiButton == 5
		Game.GetPlayer().AddSpell(BakingSpell)
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD CREATIVE SPECIAL SPELLS
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_Creative_Special(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_Creative_Special.show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(StoreFrontSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(CreativeStorageSpell)
	ElseIf aiButton == 3
		; Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD CREATIVE UTILITIES SPELLS  (RE-INDEXED: Positioner button removed)
; New mapping: 1 = Add TCL, 2 = Add Toggle Grass
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_Utilities.show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(TCLSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(ToggleGrassSpell)
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE CREATIVE UTILITIES SPELLS  (RE-INDEXED: Positioner button removed)
; New mapping: 1 = Remove TCL, 2 = Remove Toggle Grass
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_Utilities.show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(TCLSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(ToggleGrassSpell)
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; INI Scripts
;----------------------------------------------------------------------------------------------
Event OnPlayerLoadGame()
	Utility.SetINIBool("bDisablePlayerCollision:Havok", false)
EndEvent