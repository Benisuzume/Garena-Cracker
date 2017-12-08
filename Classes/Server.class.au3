#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Server()
	;---------------------------------------------------------------------------
	;
	Local $sMachineId = $oLibraries.MD5(DriveGetSerial(@HomeDrive) & _
			@UserName & _
			@CPUArch & _
			@OSArch & _
			@OSVersion & _
			@OSBuild & _
			@IPAddress1)
	If @error Then
		Debug('Server.class | MD5() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $pCurl = Curl_Easy_Init()
	If $pCurl Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Init() failed.', @ScriptLineNumber)
		Return SetError(2, 0, Null)
	EndIf

	Curl_Easy_Setopt($pCurl, $CURLOPT_URL, 'http://faridaghili.ir/garenacracker/')
	Curl_Easy_Setopt($pCurl, $CURLOPT_FORBID_REUSE, 1)
	Curl_Easy_Setopt($pCurl, $CURLOPT_WRITEFUNCTION, Curl_DataWriteCallback())
	Curl_Easy_Setopt($pCurl, $CURLOPT_WRITEDATA, $pCurl)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $mResult[]
	$mResult['Valid'] = 1
	$mResult['Invalid'] = 2
	$mResult['Expired'] = 3
	$mResult['Locked'] = 4
	$mResult['Limit'] = 5
	$mResult['InternetError'] = 6

	Local $mRequest[]
	$mRequest['Login'] = 1
	$mRequest['Logout'] = 2
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Server_Destructor')

		; --- Properties | Private
		.AddProperty('Curl', $ELSCOPE_PRIVATE, $pCurl)
		.AddProperty('MachineId', $ELSCOPE_PRIVATE, $sMachineId)
		.AddProperty('Password', $ELSCOPE_PRIVATE, '')

		; --- Properties | Read-only
		.AddProperty('Result', $ELSCOPE_READONLY, $mResult)
		.AddProperty('Request', $ELSCOPE_READONLY, $mRequest)
		.AddProperty('Username', $ELSCOPE_READONLY, '')
		.AddProperty('Version', $ELSCOPE_READONLY, 0.0)
		.AddProperty('RemainingDays', $ELSCOPE_READONLY, 0)

		; --- Methods | Public
		.AddMethod('Login', 'Server_Login', False)
		.AddMethod('CheckIn', 'Server_CheckIn', False)
		.AddMethod('Logout', 'Server_Logout', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_Destructor($this)
	#forceref $this

	; Curl_Easy_Cleanup($this.Curl)
EndFunc

Func Server_Login($this, $sUsername, $sPassword)
	;---------------------------------------------------------------------------
	;
	If StringLen($sPassword) <> 32 Then
		$sPassword = $oLibraries.MD5($sPassword)
		If @error Then
			Debug('Server.class | MD5() failed.', @ScriptLineNumber)
			Return $this.Result['InternetError']
		EndIf
	EndIf

	Local $oRequest = ObjCreate('Scripting.Dictionary')
	$oRequest.Add('request', $this.Request['Login'])
	$oRequest.Add('username', $sUsername)
	$oRequest.Add('password', $sPassword)
	$oRequest.Add('machineId', $this.MachineId)

	Local $oJson = Json_Encode($oRequest)
	Curl_Easy_Setopt($this.Curl, $CURLOPT_COPYPOSTFIELDS, $oJson)

	If Curl_Easy_Perform($this.Curl) = $CURLE_OK Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Perform() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	Local $dResponse = Curl_Data_Get($this.Curl)
	Local $sResponse = BinaryToString($dResponse)

	Curl_Data_Cleanup($this.Curl)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oResponse = Json_Decode($sResponse)
	If IsObj($oResponse) And $oResponse.Exists('Result') Then
		; --- Nothing to do
	Else
		Return $this.Result['InternetError']
	EndIf

	If $oResponse.Item('Result') = $this.Result['Valid'] Then
		; --- Nothing to do
	Else
		Switch $oResponse.Item('Result')
			Case $this.Result['Invalid'], $this.Result['Expired'], $this.Result['Locked'], $this.Result['Limit']
				Return $oResponse.Item('Result')

			Case Else
				Return $this.Result['InternetError']
		EndSwitch
	EndIf

	If _WinAPI_CreateMutex($APP_NAME & ': Authenticated') Then
		; --- Nothing to do
	Else
		Debug('Server.class | _WinAPI_CreateMutex() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	$this.Username = $sUsername
	$this.Password = $sPassword

	$this.Version = $oResponse.Item('Version')
	$this.RemainingDays = $oResponse.Item('RemainingDays')

	Return $this.Result['Valid']
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_CheckIn($this)
	Return $this.Login($this.Username, $this.Password)
EndFunc

Func Server_Logout($this)
	;---------------------------------------------------------------------------
	;
	Local $oRequest = ObjCreate('Scripting.Dictionary')
	$oRequest.Add('request', $this.Request['Logout'])
	$oRequest.Add('username', $this.Username)
	$oRequest.Add('machineId', $this.MachineId)

	Local $oJson = Json_Encode($oRequest)
	Curl_Easy_Setopt($this.Curl, $CURLOPT_COPYPOSTFIELDS, $oJson)

	If Curl_Easy_Perform($this.Curl) = $CURLE_OK Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Perform() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	Curl_Data_Cleanup($this.Curl)

	Return $this.Result['Valid']
	;s
	;---------------------------------------------------------------------------
EndFunc