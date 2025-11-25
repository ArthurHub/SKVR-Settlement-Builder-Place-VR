Scriptname Placeable_Collision_Off_Script extends ActiveMagicEffect  

GlobalVariable Property Placeable_CollisionDisabledGV Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Actor playerRef = Game.GetPlayer()
	if akTarget == playerRef
		int currentState = Placeable_CollisionDisabledGV.GetValueInt()

		if currentState == 0
			; Collision currently enabled ? disable it and record state as disabled
			Utility.SetINIBool("bDisablePlayerCollision:Havok", true)
			Placeable_CollisionDisabledGV.SetValueInt(1)
			Debug.Notification("Collision : Off")
		else
			; Collision currently disabled ? enable it and record state as enabled
			Utility.SetINIBool("bDisablePlayerCollision:Havok", false)
			Placeable_CollisionDisabledGV.SetValueInt(0)
			Debug.Notification("Collision : On")
		endif
	endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Intentionally left empty.
	; Toggle is handled entirely in OnEffectStart so the effect ending
	; does not automatically revert collision.
EndEvent