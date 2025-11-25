scriptName Placeable_MCM_Script extends SKI_ConfigBase

;-- Properties --------------------------------------
globalvariable property Placeable_SSB_Shortcut_Key_Var auto
globalvariable property Placeable_Positioner_SKSE_Global auto
actor property PlayerRef auto
message property placeable_AAA_Delete_All_03 auto
spell property Placeable_CampfireUnleashed_Start auto
formlist property Placeable_A_DeleteAll auto
message property placeable_AAA_Delete_All auto
message property placeable_AAA_Delete_All_01 auto
message property placeable_AAA_Delete_All_02 auto

;-- Variables ---------------------------------------
Float _sliderPercent = 50.0000
Int _toggle3OID_B
Int _myKey = -1
Int _keymapOID_K
Int _counter = 0
Bool _toggleState4 = false
Int _colorOID_C
Int _color = 16777215
Int _difficultyMenuOID_M
Int _curDifficulty = 0
Int _toggle2OID_B
Int _toggle4OID_B
Int _sliderFormatOID_S
Bool _toggleState3 = true
Bool _toggleState2 = true
Int _toggle1OID_B
Int _counterOID_T
Bool _toggleState5 = false
Int _textOID_T
String[] _difficultyList
Bool _toggleState1 = false
Int _textOID_T2

;-- Functions ---------------------------------------

function DeleteAllItemsInList(formlist akList, Bool abOnlyDisable, Bool abFade) global
	Int aiSize = akList.GetSize()
	Int i = 0
	if abOnlyDisable
		while i < aiSize
			(akList.GetAt(i) as objectreference).DisableNoWait(abFade)
			i += 1
		endWhile
	else
		while i < aiSize
			(akList.GetAt(i) as objectreference).Delete()
			i += 1
		endWhile
	endIf
endFunction

function OnOptionSliderAccept(Int a_option, Float a_value)
{Called when the user accepts a new slider value}
	if a_option == _sliderFormatOID_S
		_sliderPercent = a_value
		self.SetSliderOptionValue(a_option, a_value, "At {0}%", false)
	endIf
endFunction

function OnVersionUpdate(Int a_version)
{Called when a version update of this script has been detected}
	if a_version >= 2 && CurrentVersion < 2
		debug.Trace(self as String + ": Updating script to version 2", 0)
		_color = utility.RandomInt(0, 16777215)
	endIf
	if a_version >= 3 && CurrentVersion < 3
		debug.Trace(self as String + ": Updating script to version 3", 0)
		_myKey = input.GetMappedKey("Jump", 255)
	endIf
endFunction

function OnOptionKeyMapChange(Int a_option, Int a_keyCode, String a_conflictControl, String a_conflictName)
{Called when a key has been remapped}
	if a_option == _keymapOID_K
		Bool continue = true
		if a_conflictControl != ""
			String msg
			if a_conflictName != ""
				msg = "This key is already mapped to:\n'" + a_conflictControl + "'\n(" + a_conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n'" + a_conflictControl + "'\n\nAre you sure you want to continue?"
			endIf
			continue = self.ShowMessage(msg, true, "$Yes", "$No")
		endIf
		if continue
			_myKey = a_keyCode
			self.SetKeymapOptionValue(a_option, a_keyCode, false)
		endIf
	endIf
endFunction

function OnPageReset(String a_page)
{Called when a new page is selected, including the initial empty page}

	if a_page == ""
		self.LoadCustomContent("lvxmagick/mcm_logo_SSB.dds", 0.000000, 0.000000)
		return 
	else
		self.UnloadCustomContent()
	endIf

	if a_page == "Settlement Builder"
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddHeaderOption("", 0)

		; Start entry
		_textOID_T = self.AddTextOption("Skyrim - Settlement Builder", "Start", 0)

		; Optional keyboard shortcut toggle (still hidden because its AddToggleOption is commented in your version)
		; _toggle2OID_B = self.AddToggleOption("Keyboard Shortcut L for creative list", _toggleState2, 0)

		; HIDE SKSE POSITIONER TOGGLE FROM MCM (leave logic intact elsewhere)
		; _toggle3OID_B = self.AddToggleOption("Toggle SKSE positioner On or Off?", _toggleState3, 0)

		; HIDE DELETE-ALL ENTRY FROM MCM (leave Delete_All() usable from elsewhere)
		; _textOID_T2 = self.AddTextOption("Delete All Placed Items", "Activate?", 0)

		self.AddHeaderOption("", 0)

	elseIf a_page == "Another Page"
		self.SetTitleText("Custom title text")
		self.SetCursorFillMode(self.LEFT_TO_RIGHT)
		self.AddHeaderOption("Hitpoints", 0)
		self.AddEmptyOption()
		self.AddSliderOption("Player Endurance Multiplier", 10 as Float, "{0}", 0)
		self.AddSliderOption("NPC Endurance Multiplier", 7 as Float, "{0}", 0)
		self.AddSliderOption("Player Level Multiplier", 0 as Float, "{0}", 0)
		self.AddSliderOption("NPC Level Multiplier", 0 as Float, "{0}", 0)
	endIf
endFunction

; Skipped compiler generated GotoState

function OnOptionMenuOpen(Int a_option)
{Called when the user selects a menu option}
	if a_option == _difficultyMenuOID_M
		self.SetMenuDialogStartIndex(_curDifficulty)
		self.SetMenuDialogDefaultIndex(0)
		self.SetMenuDialogOptions(_difficultyList)
	endIf
endFunction

function Delete_All()
	Int aiButton = placeable_AAA_Delete_All.show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
	if aiButton == 0
		; Back / do nothing
	elseIf aiButton == 3
		game.FadeOutGame(true, true, 0 as Float, 2 as Float)
		utility.Wait(1 as Float)
		Placeable_MCM_Script.DeleteAllItemsInList(Placeable_A_DeleteAll, false, true)
		game.FadeOutGame(false, true, 3.00000, 2.00000)
	endIf
endFunction

function OnOptionHighlight(Int a_option)
{Called when the user highlights an option}

	if a_option == _toggle1OID_B
		; no text
	elseIf a_option == _toggle2OID_B
		; no text
	elseIf a_option == _toggle3OID_B
		; This will no longer be reachable because the option is hidden,
		; but the text is left intact for safety.
		self.SetInfoText("Turn on Interger or animated Movement...")
	endIf
endFunction

; Skipped compiler generated GetState

function OnOptionColorAccept(Int a_option, Int a_color)
{Called when a new color has been accepted}
	if a_option == _colorOID_C
		_color = a_color
		self.SetColorOptionValue(a_option, a_color, false)
	endIf
endFunction

function OnConfigInit()
	Pages = new String[2]
	Pages[0] = "Settlement Builder"
	_difficultyList = new String[4]
	_difficultyList[0] = "Casual"
	_difficultyList[1] = "Easy"
	_difficultyList[2] = "Normal"
	_difficultyList[3] = "Hard"
endFunction

Int function GetVersion()
	return 3
endFunction

function OnOptionColorOpen(Int a_option)
{Called when a color option has been selected}
	if a_option == _colorOID_C
		self.SetColorDialogStartColor(_color)
		self.SetColorDialogDefaultColor(16777215)
	endIf
endFunction

function OnOptionMenuAccept(Int a_option, Int a_index)
{Called when the user accepts a new menu entry}
	if a_option == _difficultyMenuOID_M
		_curDifficulty = a_index
		self.SetMenuOptionValue(a_option, _difficultyList[_curDifficulty], false)
	endIf
endFunction

function OnOptionSelect(Int a_option)
{Called when the user selects a non-dialog option}

	if a_option == _textOID_T
		debug.MessageBox("Close MCM Menu to Start Skyrim - Settlement Builder")
		self.SetTextOptionValue(a_option, "Close Menu", false)
		Placeable_CampfireUnleashed_Start.Cast(PlayerRef as objectreference, none)

	; HIDDEN FROM UI, BUT LOGIC LEFT INTACT
	elseIf a_option == _textOID_T2
		debug.MessageBox("Close MCM Menu to delete all placed items")
		self.SetTextOptionValue(a_option, "Close Menu", false)
		self.Delete_All()

	elseIf a_option == _toggle2OID_B
		_toggleState2 = !_toggleState2
		self.SetToggleOptionValue(a_option, _toggleState2, false)
		if Placeable_SSB_Shortcut_Key_Var.GetValue() == 0.000000
			Placeable_SSB_Shortcut_Key_Var.SetValue(1.00000)
		else
			Placeable_SSB_Shortcut_Key_Var.SetValue(0.000000)
		endIf

	; HIDDEN FROM UI, BUT LOGIC LEFT INTACT
	elseIf a_option == _toggle3OID_B
		_toggleState3 = !_toggleState3
		self.SetToggleOptionValue(a_option, _toggleState3, false)
		if Placeable_Positioner_SKSE_Global.GetValue() == 0.000000
			Placeable_Positioner_SKSE_Global.SetValue(1.00000)
		else
			Placeable_Positioner_SKSE_Global.SetValue(0.000000)
		endIf

	elseIf a_option == _toggle4OID_B
		_toggleState4 = !_toggleState4
		self.SetToggleOptionValue(a_option, _toggleState4, false)
	elseIf a_option == _counterOID_T
		_counter += 1
		self.SetTextOptionValue(a_option, _counter as String, false)
	endIf
endFunction

function OnOptionSliderOpen(Int a_option)
{Called when the user selects a slider option}
	if a_option == _sliderFormatOID_S
		self.SetSliderDialogStartValue(_sliderPercent)
		self.SetSliderDialogDefaultValue(50 as Float)
		self.SetSliderDialogRange(0 as Float, 100 as Float)
		self.SetSliderDialogInterval(2 as Float)
	endIf
endFunction