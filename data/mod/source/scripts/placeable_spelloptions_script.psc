Scriptname Placeable_SpellOptions_Script extends activemagiceffect  

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
;Spell Property Dice01Spell Auto
;Spell Property YesOrNoSpell Auto
Spell Property SKSE_PositionerSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Menu()
EndEvent

;----------------------------------------------------------------------------------------------
; MAIN MENU
;----------------------------------------------------------------------------------------------
Function Menu(int aiButton = 0)
	aiButton = ManualMenu.Show()

	If aiButton == 1
		ManualMenu_AddSpells()   ; Adds All Spells
	ElseIf aiButton == 2
		ManualMenu_RemoveSpells() ; Removes All Spells
	ElseIf aiButton == 3
		; Back / Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells(int aiButton = 0) ; Add All Spells
	aiButton = ManualMenu_AddSpells.Show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(CreativeModeSpell) 
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell)

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
		;Game.GetPlayer().AddSpell(SKSE_PositionerSpell)
		;Game.GetPlayer().AddSpell(Dice01Spell)   ; Dice
		;Game.GetPlayer().AddSpell(YesOrNoSpell)
		Debug.MessageBox("All Powers Added")
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(CreativeModeSpell)
		Game.GetPlayer().AddSpell(CreativeCatalogueSpell)
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
	aiButton = ManualMenu_RemoveSpells.Show()

	If aiButton == 1 ; Remove All Powers
		Game.GetPlayer().RemoveSpell(CreativeModeSpell) 
		Debug.Notification("Option: Creative Mode Removed")
		Game.GetPlayer().RemoveSpell(CreativeCatalogueSpell)
		Debug.Notification("Option: Creative Catalogue Removed")

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
		Game.GetPlayer().RemoveSpell(CreativeStorageSpell)
		Debug.Notification("Creative Crafting: Creative Storage Removed")
		Game.GetPlayer().RemoveSpell(EnchantingSpell)
		Debug.Notification("Creative Crafting: Enchanting Removed")
		Game.GetPlayer().RemoveSpell(AlchemySpell)
		Debug.Notification("Creative Crafting: Alchemy Removed")
		Game.GetPlayer().RemoveSpell(CookingSpell)
		Debug.Notification("Creative Crafting: Cooking Removed")
		Game.GetPlayer().RemoveSpell(BakingSpell)
		Debug.Notification("Creative Crafting: Baking Removed")

		;Game.GetPlayer().RemoveSpell(Dice01Spell)
		;Debug.Notification("Creative Special: Dice Removed")
		;Game.GetPlayer().RemoveSpell(YesOrNoSpell)

		Game.GetPlayer().RemoveSpell(SKSE_PositionerSpell)    
		Debug.Notification("Option: Toggle - Integer/Animated Positioner Removed")

		Debug.MessageBox("All Powers Removed")
	ElseIf aiButton == 2 ; Remove Creative Mode
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
	aiButton = ManualMenu_RemoveSpells_FastCraft.Show()

	If aiButton == 1
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
	aiButton = ManualMenu_RemoveSpells_FastCraft_P2.Show()

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
	aiButton = ManualMenu_RemoveSpells_Creative_Special.Show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(StoreFrontSpell)  
		Debug.Notification("Creative Special: Store Front- Removed")
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(CreativeStorageSpell)  
		Debug.Notification("Creative Special: Creative Storage - Removed")
	ElseIf aiButton == 3
		; Back / Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD FAST CRAFTING SPELLS MAIN MENU
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_FastCraft(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_FastCraft.Show()

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
	aiButton = ManualMenu_AddSpells_FastCraft_P2.Show()

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
	aiButton = ManualMenu_AddSpells_Creative_Special.Show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(StoreFrontSpell)  
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(CreativeStorageSpell)  
	ElseIf aiButton == 3
		; Back / Do nothing
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; ADD CREATIVE UTILITIES SPELLS  (RE-INDEXED: removed SKSE Positioner button)
; In-game after XEdit removal: 0=Back, 1=TCL, 2=Toggle Grass
;----------------------------------------------------------------------------------------------
Function ManualMenu_AddSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_AddSpells_Utilities.Show()

	If aiButton == 1
		Game.GetPlayer().AddSpell(TCLSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().AddSpell(ToggleGrassSpell)
	EndIf
EndFunction

;----------------------------------------------------------------------------------------------
; REMOVE CREATIVE UTILITIES SPELLS  (RE-INDEXED: removed SKSE Positioner button)
; In-game after XEdit removal: 0=Back, 1=TCL, 2=Toggle Grass
;----------------------------------------------------------------------------------------------
Function ManualMenu_RemoveSpells_Utilities(int aiButton = 0)
	aiButton = ManualMenu_RemoveSpells_Utilities.Show()

	If aiButton == 1
		Game.GetPlayer().RemoveSpell(TCLSpell)
	ElseIf aiButton == 2
		Game.GetPlayer().RemoveSpell(ToggleGrassSpell)
	EndIf
EndFunction