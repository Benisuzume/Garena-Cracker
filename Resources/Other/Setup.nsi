;--------------------------------

	!include "MUI2.nsh"

	!define MUI_NAME "Garena Cracker"
	!define MUI_VERSION "2.5"

;--------------------------------

	Name "${MUI_NAME}"
	OutFile "Garena-Cracker-${MUI_VERSION}-Setup.exe"

	InstallDir "$PROGRAMFILES\${MUI_NAME}"
	InstallDirRegKey HKCU "Software\${MUI_NAME}" "Path"

	RequestExecutionLevel admin

;--------------------------------

	!define MUI_BRANDINGTEXT "www.GarenaCracker.com"
	!define MUI_ABORTWARNING

	!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
	!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"

	!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
	!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"

	ShowInstDetails "nevershow"
	ShowUninstDetails "nevershow"

	!define MUI_FINISHPAGE_RUN "$INSTDIR\${MUI_NAME}.exe"
	!define MUI_FINISHPAGE_RUN_TEXT "Run ${MUI_NAME}"

;--------------------------------

	!insertmacro MUI_PAGE_WELCOME
	!insertmacro MUI_PAGE_DIRECTORY
	!insertmacro MUI_PAGE_INSTFILES
	!insertmacro MUI_PAGE_FINISH

	!insertmacro MUI_UNPAGE_WELCOME
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES
	!insertmacro MUI_UNPAGE_FINISH

;--------------------------------

	!insertmacro MUI_LANGUAGE "English"

;--------------------------------

Section
	SetOutPath "$INSTDIR"
	WriteRegStr HKCU "Software\${MUI_NAME}" "Path" $INSTDIR

	File /r "C:\Users\Farid\Desktop\Garena Cracker\Release\*"
	CreateShortCut "$DESKTOP\${MUI_NAME}.lnk" "$INSTDIR\${MUI_NAME}.exe" ""

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}" "DisplayName" "${MUI_NAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}" "DisplayVersion" "${MUI_VERSION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}" "DisplayIcon" "$INSTDIR\${MUI_NAME}.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}" "Publisher" "www.GarenaCracker.com"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"

	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

;--------------------------------
Section "Uninstall"
	Delete "$DESKTOP\${MUI_NAME}.lnk"
	Delete "$INSTDIR\Uninstall.exe"
	RMDir /r "$INSTDIR"

	DeleteRegValue HKCU "Software\${MUI_NAME}" "Path"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_NAME}"
SectionEnd