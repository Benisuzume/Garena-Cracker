#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

;---------------------------------------------------------------------------
;
Global Const $AUTH_SERVER = 'auth.gtalk.garenanow.com'
Global Const $AUTH_PORT = 9200

Global Const $TALK_LOGIN_REQUSET_LEN = 45
Global $TALK_LOGIN_REQUSET_MESSAGE_TYPE
Global $TALK_LOGIN_REQUSET_UNKNOWN_1
Global $TALK_LOGIN_REQUSET_UNKNOWN_2

Global $TALK_LOGIN_RESPONSE_SUCCESS
Global $TALK_LOGIN_RESPONSE_INVALID_USERNAME
Global $TALK_LOGIN_RESPONSE_WRONG_PASSWORD

Global Enum $GTP_CRACKED, $GTP_INVALID_USERNAME, $GTP_WRONG_PASSWORD, $GTP_UNKNOWN, $GTP_FAILED, $GTP_INTERRUPTED

Global $bInterrupted = True
;
;---------------------------------------------------------------------------

Func Check($sUsername, $sPassword)
	Local Static $sIpAddress = TCPNameToIP($AUTH_SERVER)

	Local $iSocket = TCPConnect($sIpAddress, $AUTH_PORT)
	If @error Then
		Return SetError(1, 0, $GTP_FAILED)
	EndIf

	If $bInterrupted Then
		TCPCloseSocket($iSocket)
		Return $GTP_INTERRUPTED
	EndIf

	Local $iUsernameLen = StringLen($sUsername)

	Local $tLoginRequest = DllStructCreate( _
			'DWORD MessageLen;' & _
			'BYTE MessageType[2];' & _
			'BYTE UsernameLen;' & _
			'CHAR Username[' & $iUsernameLen & '];' & _
			'BYTE Unknown1[2];' & _
			'CHAR Password[32];' & _
			'BYTE Unknown2[8]')

	DllStructSetData($tLoginRequest, 'MessageLen', $TALK_LOGIN_REQUSET_LEN + $iUsernameLen)
	DllStructSetData($tLoginRequest, 'MessageType', $TALK_LOGIN_REQUSET_MESSAGE_TYPE)
	DllStructSetData($tLoginRequest, 'UsernameLen', $iUsernameLen)
	DllStructSetData($tLoginRequest, 'Username', $sUsername)
	DllStructSetData($tLoginRequest, 'Unknown1', $TALK_LOGIN_REQUSET_UNKNOWN_1)
	DllStructSetData($tLoginRequest, 'Password', $sPassword)
	DllStructSetData($tLoginRequest, 'Unknown2', $TALK_LOGIN_REQUSET_UNKNOWN_2)

	Local $iDataLen = DllStructGetSize($tLoginRequest)
	Local $tData = DllStructCreate('BYTE[' & $iDataLen & ']', DllStructGetPtr($tLoginRequest))

	If TCPSend($iSocket, DllStructGetData($tData, 1)) <> $iDataLen Then
		TCPCloseSocket($iSocket)
		Return SetError(2, 0, $GTP_FAILED)
	EndIf

	If $bInterrupted Then
		TCPCloseSocket($iSocket)
		Return $GTP_INTERRUPTED
	EndIf

	Local $dMessageLen = TCPRecv($iSocket, 4, 1)
	If @error Then
		TCPCloseSocket($iSocket)
		Return SetError(3, 0, $GTP_FAILED)
	EndIf

	If $bInterrupted Then
		TCPCloseSocket($iSocket)
		Return $GTP_INTERRUPTED
	EndIf

	If BinaryLen($dMessageLen) <> 4 Then
		Return SetError(4, 0, $GTP_UNKNOWN)
	EndIf

	Local $iMessageLen = Int($dMessageLen, 1)

	Local $dBuffer = TCPRecv($iSocket, $iMessageLen, 1)
	If @error Then
		TCPCloseSocket($iSocket)
		Return SetError(5, 0, $GTP_FAILED)
	EndIf

	TCPCloseSocket($iSocket)

	If BinaryLen($dBuffer) <> $iMessageLen Then
		Return SetError(6, 0, $GTP_UNKNOWN)
	EndIf

	If $iMessageLen = 3 Then
		Switch $dBuffer
			Case $TALK_LOGIN_RESPONSE_INVALID_USERNAME
				Return $GTP_INVALID_USERNAME

			Case $TALK_LOGIN_RESPONSE_WRONG_PASSWORD
				Return $GTP_WRONG_PASSWORD

			Case Else
				Return SetError(7, 0, $GTP_UNKNOWN)
		EndSwitch
	Else
		Local $tBuffer = DllStructCreate('BYTE[2]')
		DllStructSetData($tBuffer, 1, $dBuffer)

		If DllStructGetData($tBuffer, 1) = $TALK_LOGIN_RESPONSE_SUCCESS Then
			Return $GTP_CRACKED
		Else
			Return SetError(8, 0, $GTP_UNKNOWN)
		EndIf
	EndIf
EndFunc