#NoTrayIcon
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include 'Header.au3'

;---------------------------------------------------------------------------
;
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Out, Release\Garena Cracker.exe)
#pragma compile(Icon, Resources\Icon.ico)
#pragma compile(CompanyName, www.FaridAghili.ir)
#pragma compile(FileDescription, Garena Cracker)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(InternalName, Garena Cracker)
#pragma compile(LegalCopyright, Copyright © 2016 FaridAghili.ir. All rights reserved.)
#pragma compile(OriginalFilename, Garena Cracker.exe)
#pragma compile(ProductName, Garena Cracker)
#pragma compile(ProductVersion, 1.0.0.0)

;~ #AutoIt3Wrapper_Run_Au3Stripper=y
;~ #Au3Stripper_Parameters=/pe /sf=1 /sv=1 /rm /rsln

#AutoIt3Wrapper_Res_File_Add=Resources\CLOSE_PNG.png, RT_RCDATA, CLOSE_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\ICON_PNG.png, RT_RCDATA, ICON_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\LOGO_PNG.png, RT_RCDATA, LOGO_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\MINIMIZE_PNG.png, RT_RCDATA, MINIMIZE_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\MINIMIZE_TO_TRAY_PNG.png, RT_RCDATA, MINIMIZE_TO_TRAY_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\TOOLBAR_SEPARATOR_PNG.png, RT_RCDATA, TOOLBAR_SEPARATOR_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\TOOLBAR_STRIP_PNG.png, RT_RCDATA, TOOLBAR_STRIP_PNG

#AutoIt3Wrapper_Res_Remove=RT_ICON, 1, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 7, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 8, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 9, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 10, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 11, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 12, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 313, 2057
#AutoIt3Wrapper_Res_Remove=RT_GROUPICON, 169, 2057

#AutoIt3Wrapper_Run_After=Resources\Other\SignTheFile.au3
;
;---------------------------------------------------------------------------

Func EntryPoint()
	;---------------------------------------------------------------------------
	;
	$hMutex = _WinAPI_CreateMutex($APP_NAME & ': Running')

	If _WinAPI_GetLastError() = $ERROR_ALREADY_EXISTS Then
		_WinAPI_CloseHandle($hMutex)
		Exit
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	If IsDotNetFramework4Installed() Then
		; --- Nothing to do
	Else
		SplashTextOn($APP_NAME, 'Downloading Microsoft .NET Framework 4 Client Profile...', 400, 50, Default, Default, BitOR($DLG_NOTITLE, $DLG_TEXTVCENTER), 'Tahoma', 10)

		Local $sUrl = 'http://download.microsoft.com/download/5/6/2/562A10F9-C9F4-4313-A044-9C94E0A8FAC8/dotNetFx40_Client_x86_x64.exe'
		Local $sFilePath = @DesktopDir & '\Microsoft .NET Framework 4 Client Profile.exe'

		InetGet($sUrl, $sFilePath, BitOR($INET_IGNORESSL, $INET_FORCEBYPASS), $INET_DOWNLOADWAIT)
		If @error Then
			MsgBox(BitOR($MB_OK, $MB_ICONERROR), $APP_NAME, 'Unable to download Microsoft .NET Framework 4 Client Profile.')
			Exit
		EndIf

		SplashOff()
		ShellExecute($sFilePath)
		Exit
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	OnAutoItExitRegister(ExitPoint)

	TCPStartup()
	If @error Then
		Return SetError(1, 0, 'TCPStartup()')
	EndIf

	_GDIPlus_Startup()
	If @error Then
		Return SetError(2, 0, '_GDIPlus_Startup()')
	EndIf

	AutoItObject_Startup(@ScriptDir & '\Libraries\AutoItObject.dll')
	If @error Then
		Return SetError(3, 0, 'AutoItObject_Startup()')
	EndIf

	$oErrorHandler = ObjEvent('AutoIt.Error', ComErrorHandler)
	If @error Then
		Return SetError(4, 0, 'ObjEvent()')
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$oSettings = Settings()
	$oMessage = Message()

	$oLibraries = Libraries()
	If @error Then
		Return SetError(5, 0, 'Libraries.class')
	EndIf

	$oLibraries.GetPackets()

	$oServer = Server()
	If @error Then
		Return SetError(6, 0, 'Server.class')
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$frmLogin = Login()

	While True
		Sleep(1000)
	WEnd
	;
	;---------------------------------------------------------------------------
EndFunc

Func ExitPoint()
	$oLibraries = Null
	$oServer = Null

	_GDIPlus_Shutdown()
	TCPShutdown()
	_WinAPI_CloseHandle($hMutex)
EndFunc

Func ComErrorHandler()
	MsgBox(BitOR($MB_OK, $MB_ICONERROR), $APP_NAME, 'Unfortunately ' & $APP_NAME & ' has stopped working.' & @CRLF & @CRLF & _
			'Error Number:' & @TAB & '0x' & Hex($oErrorHandler.number, 8) & @CRLF & _
			'Line Number:' & @TAB & $oErrorHandler.scriptline & @CRLF & _
			'Description:' & @TAB & $oErrorHandler.windescription)
	Exit
EndFunc

Global $sEntryPoint = EntryPoint()
If @error Then
	Debug('Garena Cracker | ' & $sEntryPoint & ' failed.', @ScriptLineNumber)
EndIf