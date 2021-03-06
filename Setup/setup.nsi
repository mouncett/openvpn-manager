; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "OpenVPN Manager"
!define PRODUCT_PUBLISHER "JoWiSoftware"
!define PRODUCT_WEB_SITE "http://openvpn.jowisoftware.de/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_FILE}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define MAIN_FILE 'OpenVPNManager.exe'
!define RELEASE_DIR "..\OpenVPNManager\bin\Release\"
!define OPENVPN_SETUP 'openvpn-2.2.2-install.exe'
!define LICENSE_FILE '..\license.txt'

!define DOT_NET_MAJOR 2
!define DOT_NET_MINOR 0
!define DOT_NET_REVISION 50727
!define DOTNET_DOWNLOAD_URL 'http://download.microsoft.com/download/5/6/7/567758a3-759e-473e-bf8f-52154438565a/dotnetfx.exe'
!define DOTNET_DOWNLOAD_URL64 'http://download.microsoft.com/download/a/3/f/a3f1bf98-18f3-4036-9b68-8e6de530ce0a/NetFx64.exe'

outfile test.exe
requestexecutionlevel user

!macro GetVersionLocal file basedef
!verbose push
!verbose 1
!tempfile _GetVersionLocal_nsi
!tempfile _GetVersionLocal_exe
!appendfile "${_GetVersionLocal_nsi}" 'Outfile "${_GetVersionLocal_exe}"$\nRequestexecutionlevel user$\n'
!appendfile "${_GetVersionLocal_nsi}" 'Section$\n!define D "$"$\n!define N "${D}\n"$\n'
!appendfile "${_GetVersionLocal_nsi}" 'GetDLLVersion "${file}" $2 $4$\n'
!appendfile "${_GetVersionLocal_nsi}" 'IntOp $1 $2 / 0x00010000$\nIntOp $2 $2 & 0x0000FFFF$\n'
!appendfile "${_GetVersionLocal_nsi}" 'IntOp $3 $4 / 0x00010000$\nIntOp $4 $4 & 0x0000FFFF$\n'
!appendfile "${_GetVersionLocal_nsi}" 'FileOpen $0 "${_GetVersionLocal_nsi}" w$\nStrCpy $9 "${N}"$\n'
!appendfile "${_GetVersionLocal_nsi}" 'FileWrite $0 "!define ${basedef}1 $1$9"$\nFileWrite $0 "!define ${basedef}2 $2$9"$\n'
!appendfile "${_GetVersionLocal_nsi}" 'FileWrite $0 "!define ${basedef}3 $3$9"$\nFileWrite $0 "!define ${basedef}4 $4$9"$\n'
!appendfile "${_GetVersionLocal_nsi}" 'FileClose $0$\nSectionend$\n'
!system '"${NSISDIR}\makensis" -NOCD -NOCONFIG "${_GetVersionLocal_nsi}"' = 0
!system '"${_GetVersionLocal_exe}" /S' = 0
!delfile "${_GetVersionLocal_exe}"
!undef _GetVersionLocal_exe
!include "${_GetVersionLocal_nsi}"
!delfile "${_GetVersionLocal_nsi}"
!undef _GetVersionLocal_nsi
!verbose pop
!macroend

!insertmacro GetVersionLocal "${RELEASE_DIR}${MAIN_FILE}" MyVer_
!define PRODUCT_VERSION "${MyVer_1}.${MyVer_2}.${MyVer_3}.${MyVer_4}"

VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "FileDescription" "Setup for ${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright" "� Jochen Wierum"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIProductVersion "${PRODUCT_VERSION}"

SetCompressor LZMA
requestexecutionlevel admin

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "${LICENSE_FILE}"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_FILE}"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\OpenVPN Manager"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails hide

Function un.onUninstSuccess
  HideWindow
FunctionEnd

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\de\OpenVPNManager.resources.dll"
  Delete "$INSTDIR\OpenVPN.dll"
  Delete "$INSTDIR\license.txt"
  Delete "$INSTDIR\${OPENVPN_SETUP}"
  Delete "$INSTDIR\${MAIN_FILE}.config"
  Delete "$INSTDIR\${MAIN_FILE}"

  RMDir "$INSTDIR\config"
  RMDir "$INSTDIR\log"
  RMDir "$INSTDIR\de"
  RMDir "$INSTDIR"

  Delete "$SMPROGRAMS\OpenVPN Manager\Uninstall.lnk"
  Delete "$DESKTOP\OpenVPN Manager.lnk"
  Delete "$SMPROGRAMS\OpenVPN Manager\OpenVPN Manager.lnk"

  RMDir "$SMPROGRAMS\OpenVPN Manager"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

!include "x64.nsh"

Function DownloadDotnet ;// downloads .Net, returns download path in $0
  push $1
  
  StrCpy $0 "$TEMP\dotnetfx.exe"
  ${If} ${RunningX64}
    inetc::get /caption "Downloading .NET Framework 2.0" /canceltext "Cancel" "${DOTNET_DOWNLOAD_URL64}" $0 /end
  ${Else}
    inetc::get /caption "Downloading .NET Framework 2.0" /canceltext "Cancel" "${DOTNET_DOWNLOAD_URL}" $0 /end
  ${EndIf}

  Pop $1
  ${If} $1 != "OK"
    Delete $0
    Abort "Installation cancelled."
  ${EndIf}

  Pop $1
FunctionEnd

Function StartInstallation ;// kicks off the .Net installer
    push $1
    ExecWait '"$0"' $1
    pop $1
FunctionEnd

Function InstallDotnet
  Push $0
  ${If} ${FileExists} "$EXEDIR\dotnetfx.exe"
    StrCpy $0 "$EXEDIR\dotnetfx.exe"
    Call StartInstallation
  ${ElseIf} ${FileExists} "$EXEDIR\dotnetfx64.exe"
    StrCpy $0 "$EXEDIR\dotnetfx64.exe"
    Call StartInstallation
  ${Else}
    Call DownloadDotnet
    Call StartInstallation
    Delete $0
  ${EndIf}
  Pop $0
FunctionEnd

Function DotNetSearch
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $5

  StrCpy $0 "0"
  StrCpy $1 "SOFTWARE\Microsoft\.NETFramework"
  StrCpy $2 0

  StartEnum:
    EnumRegKey $3 HKLM "$1\policy" $2
    StrCmp $3 "" noDotNet notEmpty

  notEmpty:
    StrCpy $4 $3 1 0
    StrCmp $4 "v" +1 goNext
    
    StrCpy $4 $3 1 1
    IntCmp $4 ${DOT_NET_MAJOR} +1 goNext yesDotNetReg
    
    StrCpy $4 $3 1 3
    IntCmp $4 ${DOT_NET_MINOR} +1 goNext yesDotNetReg
    
    EnumRegValue $5 HKLM "$1\policy\$3" 0
    IntCmpU $5 ${DOT_NET_REVISION} yesDotNetReg goNext yesDotNetReg

  goNext:
    IntOp $2 $2 + 1
    goto StartEnum

  yesDotNetReg:
    EnumRegValue $2 HKLM "$1\policy\$3" 0
    StrCmp $2 "" noDotNet
    ReadRegStr $4 HKLM $1 "InstallRoot"
    StrCmp $4 "" noDotNet
    StrCpy $4 "$4$3.$2\mscorlib.dll"
    IfFileExists $4 yesDotNet noDotNet

  noDotNet:
    StrCpy $0 0
    Goto done

  yesDotNet:
    StrCpy $0 1

  done:
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Exch $0
FunctionEnd

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "OpenVPN Manager" SEC_MAIN
  SectionIn RO
  
  SetOutPath "-"
  SetOverwrite ifnewer

  File "${RELEASE_DIR}${MAIN_FILE}"
  CreateDirectory "$SMPROGRAMS\OpenVPN Manager"
  CreateShortCut "$SMPROGRAMS\OpenVPN Manager\OpenVPN Manager.lnk" "$INSTDIR\${MAIN_FILE}"
  CreateShortCut "$DESKTOP\OpenVPN Manager.lnk" "$INSTDIR\${MAIN_FILE}"
  File "${RELEASE_DIR}${MAIN_FILE}.config"
  File "${RELEASE_DIR}license.txt"
  File "${RELEASE_DIR}OpenVPN.dll"
  
  SetOutPath "$INSTDIR\de"
  File "${RELEASE_DIR}de\OpenVPNManager.resources.dll"

  SetOutPath "$INSTDIR\icons"
  File "${RELEASE_DIR}icons\*"

  SetOutPath "$INSTDIR\config"
  SetOutPath "$INSTDIR\log"
SectionEnd

Section ".NET Framework 2.0" SEC_DOTNET
  SetOutPath "-"
  SetOverwrite ifnewer

  Push $0
  call DotNetSearch

  Pop $0
  ${If} $0 == 0
    SetDetailsView hide
    Call InstallDotNet
    SetDetailsView show
  ${EndIf}
  
  Pop $0
SectionEnd

Section "OpenVPN 2.2" SEC_OPENVPN
  SetOutPath "-"
  SetOverwrite ifnewer
  
  File "${OPENVPN_SETUP}"
  ExecWait '$INSTDIR\${OPENVPN_SETUP}'
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\OpenVPN Manager\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${MAIN_FILE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${MAIN_FILE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

!include "lang.nsh"
