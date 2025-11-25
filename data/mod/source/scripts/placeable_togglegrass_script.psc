Scriptname Placeable_ToggleGrass_Script extends ActiveMagicEffect  

Message Property Placeable_AAA_ToggleGrass Auto
Message Property Placeable_AAA_ToggleGrass02 Auto

GlobalVariable Property Placeable_GrassDisabledGV Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor playerRef = Game.GetPlayer()
	if akTarget == playerRef
		int currentState = Placeable_GrassDisabledGV.GetValueInt()

		if currentState == 0
			; Grass currently enabled ? disable it and record state as disabled
			Utility.SetINIBool("bAllowCreateGrass:Grass", false)
			Placeable_GrassDisabledGV.SetValueInt(1)
			Debug.Notification("Grass : Off")
			Debug.Notification("Change cells to refresh grass.")
		else
			; Grass currently disabled ? enable it and record state as enabled
			Utility.SetINIBool("bAllowCreateGrass:Grass", true)
			Placeable_GrassDisabledGV.SetValueInt(0)
			Debug.Notification("Grass : On")
			Debug.Notification("Change cells to refresh grass.")
		endif
	endif
EndEvent

Function Toggle_GrassMenu(int aibutton = 0)
	; Deprecated: menu-based toggle removed.
	; Toggle is handled directly in OnEffectStart without message boxes.
EndFunction