; Inno Setup script. Build the program first (launcher\build.ps1), then compile this with:
;   iscc launcher\PeakCut.iss
; The result is dist\PeakCut-Setup.exe. It installs for the current user only, so it needs no administrator password.
; The user's videos and clips live in %LOCALAPPDATA%\PeakCut and are left alone when PeakCut is uninstalled.

#define AppName "PeakCut"
#ifndef AppVersion
  #define AppVersion "1.0.1"
#endif

[Setup]
AppId={{6B1F4E0A-3C52-4D8B-9A7E-5C0D2F8A41B7}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=Aniket886
VersionInfoVersion={#AppVersion}
VersionInfoProductName={#AppName}
AppPublisherURL=https://github.com/Aniket886/Peak-Cut
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
Compression=lzma2
SolidCompression=yes
OutputDir=..\dist
OutputBaseFilename=PeakCut-Setup
SetupIconFile=peakcut.ico
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\PeakCut.exe
WizardStyle=modern
DisableProgramGroupPage=yes

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Shortcuts:"

[Files]
Source: "..\dist\PeakCut\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\PeakCut.exe"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\PeakCut.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\PeakCut.exe"; Description: "Start PeakCut now"; Flags: nowait postinstall skipifsilent
