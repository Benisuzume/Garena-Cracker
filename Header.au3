#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

;---------------------------------------------------------------------------
;
AutoItSetOption('GUICloseOnESC', 0)
AutoItSetOption('GUIDataSeparatorChar', '½')
AutoItSetOption('GUIOnEventMode', 1)
AutoItSetOption('MustDeclareVars', 1)
AutoItSetOption('TCPTimeout', 10000)
AutoItSetOption('TrayMenuMode', 1)
AutoItSetOption('TrayOnEventMode', 1)
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
Global Const $APP_NAME = 'Garena Cracker'
Global Const $APP_VERSION = 1.0

Global Const $TIME_25_MINUTES = 1500000
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
Global $oErrorHandler = Null

Global $oGarenaTalk = Null
Global $oLibraries = Null
Global $oMessage = Null
Global $oServer = Null
Global $oSettings = Null

Global $frmAbout = Null
Global $frmLogin = Null
Global $frmMain = Null
Global $frmMyAccount = Null

Global $oUsernames = ObjCreate('Scripting.Dictionary')
$oUsernames.CompareMode = 1

Global $oPasswords = ObjCreate('Scripting.Dictionary')
$oPasswords.CompareMode = 0

Global $hMutex = 0
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
#include <GuiListView.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <WinAPITheme.au3>

#include <APIErrorsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <InetConstants.au3>
#include <StringConstants.au3>
#include <TrayConstants.au3>

#include 'Includes\AutoItObject.au3'
#include 'Includes\Curl.au3'
#include 'Includes\Functions.au3'
#include 'Includes\Garena Talk.au3'
#include 'Includes\Json.au3'
#include 'Includes\MouseEventHandler.au3'

#include 'Classes\Libraries.class.au3'
#include 'Classes\Message.class.au3'
#include 'Classes\Server.class.au3'
#include 'Classes\Settings.class.au3'
#include 'Classes\Timer.class.au3'

#include 'Forms\About.form.au3'
#include 'Forms\Login.form.au3'
#include 'Forms\Main.form.au3'
;
;---------------------------------------------------------------------------