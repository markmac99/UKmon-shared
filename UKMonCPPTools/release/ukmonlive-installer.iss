; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "UKMonLive"
#define MyAppVersion "2.3.1.1"
#define MyAppPublisher "Mark McIntyre"
#define MyAppURL "https://ukmeteornetwork.co.uk/live/#/"
#define MyAppExeName "LiveUploader.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{BE21FB7A-65A6-4820-A573-0D1B8AC4CF25}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf}\{#MyAppName}
DisableProgramGroupPage=yes
InfoBeforeFile=LiveUploader_Notes.txt
OutputBaseFilename=UKMonLiveSetup
Compression=lzma
SolidCompression=yes
SignTool=Standard sign /f "e:\dev\certs\markmcintyreDS.pfx" /p Wombat33 /d $qUKMON Live Installer$q $f

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "LiveUploader.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "vc_redist.x86.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "aws-cpp-sdk-core.dll"; DestDir: "{app}"
Source: "aws-cpp-sdk-s3.dll"; DestDir: "{app}"  
Source: "aws-c-event-stream.dll"; DestDir: "{app}"
Source: "aws-c-common.dll"; DestDir: "{app}"
Source: "aws-checksums.dll"; DestDir: "{app}"
Source: "mfc140u.dll"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "msvcp140.dll"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "ucrtbase.dll"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "vcruntime140.dll"; DestDir: "{app}"; Flags: onlyifdoesntexist
Source: "ffmpeg.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "UKMonLive.ini"; DestDir: "{localappdata}\UKMON"; Flags: onlyifdoesntexist
;Source: "AUTH_UKMONLiveWatcher.ini"; DestDir: "{localappdata}"; Flags: onlyifdoesntexist; 
;Source: "UKMONLiveWatcher.ini"; DestDir: "{localappdata}"; Flags: onlyifdoesntexist
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[InstallDelete]
Type: Files; Name: "{app}\UKMonLiveCL.exe"

[Icons]
Name: "{userstartup}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commonprograms}\{#MyAppName}\{#MyAppName} Configuration"; Filename: "{win}\notepad.exe"; Parameters: "{localappdata}\UKMON\UKMonLive.ini"
Name: "{commonprograms}\{#MyAppName}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

#define VCmsg "Installing Microsoft Visual C++ Redistributable...."

[Run]
Filename: "{tmp}\vc_redist.x86.exe"; StatusMsg: "{#VCmsg}"; Check: not IsWin64 and not VCinstalled; Parameters: "/passive /quiet /norestart"
Filename: "{tmp}\vc_redist.x64.exe"; StatusMsg: "{#VCmsg}"; Check: IsWin64 and not VCinstalled; Parameters: "/passive /quiet /norestart"
;Filename: "{win}\notepad.exe"; Parameters: "{localappdata}\UKMONLiveWatcher.ini";

[Code]

function VCinstalled: Boolean;
 // By Michael Weiner <mailto:spam@cogit.net>
 // Function for Inno Setup Compiler
 // 13 November 2015
 // Returns True if Microsoft Visual C++ Redistributable is installed, otherwise False.
 // The programmer may set the year of redistributable to find; see below.
 var
  names: TArrayOfString;
  i: Integer;
  dName, key, year: String;
 begin
  // Year of redistributable to find; leave null to find installation for any year.
  year := '2015-2019';
  Result := False;
  key := 'Software\Microsoft\Windows\CurrentVersion\Uninstall';
  // Get an array of all of the uninstall subkey names.
  if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, key, names) then
   // Uninstall subkey names were found.
   begin
    i := 0
    while ((i < GetArrayLength(names)) and (Result = False)) do
     // The loop will end as soon as one instance of a Visual C++ redistributable is found.
     begin
      // For each uninstall subkey, look for a DisplayName value.
      // If not found, then the subkey name will be used instead.
      if not RegQueryStringValue(HKEY_LOCAL_MACHINE, key + '\' + names[i], 'DisplayName', dName) then
       dName := names[i];
      // See if the value contains both of the strings below.
      Log(dName)
      Result := (Pos(Trim('Visual C++ ' + year),dName) * Pos('Redistributable',dName) <> 0)
      Log('Result is ' + IntToStr(Integer(Result)))
      i := i + 1;
     end;
   end;
 end;
