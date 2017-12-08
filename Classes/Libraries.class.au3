#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Libraries()
	;---------------------------------------------------------------------------
	;
	Local $sLibraries = @ScriptDir & '\Libraries\Libraries.dll'

	If FileExists($sLibraries) Then
		; --- Nothing to do
	Else
		Debug('Libraries.class | FileExists() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	Local $hLibraries = DllOpen($sLibraries)
	If $hLibraries = -1 Then
		Debug('Libraries.class | DllOpen() failed.', @ScriptLineNumber)
		Return SetError(2, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Libraries_Destructor')

		; --- Properties | Private
		.AddProperty('Libraries', $ELSCOPE_PRIVATE, $hLibraries)

		; --- Methods | Public
		.AddMethod('GetPackets', 'Libraries_GetPackets', False)
		.AddMethod('MD5', 'Libraries_MD5', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Libraries_Destructor($this)
	DllClose($this.Libraries)
EndFunc

Func Libraries_GetPackets($this)
	Local $tBuffer = DllStructCreate('BYTE p1[2];BYTE p2[2];BYTE p3[8];BYTE p4[2];BYTE p5[3];BYTE p6[3];')
	If @error Then
		Debug('Libraries.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(1, 0, '')
	EndIf

	DllCall($this.Libraries, 'NONE:cdecl', 'GetPackets', _
			'STRUCT*', $tBuffer)
	If @error Then
		Debug('Libraries.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(2, 0, '')
	EndIf

	$TALK_LOGIN_REQUSET_MESSAGE_TYPE = DllStructGetData($tBuffer, 'p1')
	$TALK_LOGIN_REQUSET_UNKNOWN_1 = DllStructGetData($tBuffer, 'p2')
	$TALK_LOGIN_REQUSET_UNKNOWN_2 = DllStructGetData($tBuffer, 'p3')
	$TALK_LOGIN_RESPONSE_SUCCESS = DllStructGetData($tBuffer, 'p4')
	$TALK_LOGIN_RESPONSE_INVALID_USERNAME = DllStructGetData($tBuffer, 'p5')
	$TALK_LOGIN_RESPONSE_WRONG_PASSWORD = DllStructGetData($tBuffer, 'p6')
EndFunc

Func Libraries_MD5($this, $sInput)
	If IsString($sInput) And StringLen($sInput) Then
		; --- Nothing to do
	Else
		Debug('Libraries.class | IsString() or StringLen() failed.', @ScriptLineNumber)
		Return SetError(1, 0, '')
	EndIf

	Local $tBuffer = DllStructCreate('BYTE[16]')
	If @error Then
		Debug('Libraries.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(2, 0, '')
	EndIf

	Local $avResult = DllCall($this.Libraries, 'BOOL:cdecl', 'MD5', _
			'STR', $sInput, _
			'STRUCT*', $tBuffer)
	If @error Or Not $avResult[0] Then
		Debug('Libraries.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(3, 0, '')
	EndIf

	Local $dResult = DllStructGetData($tBuffer, 1)
	Local $sResult = StringLower(StringTrimLeft($dResult, 2))

	Return $sResult
EndFunc