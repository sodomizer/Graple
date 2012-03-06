{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Main Unit                               ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

program Graple;

uses
  SysUtils,
  WinMain in 'WinMain.pas',
  GlobalVars in 'GlobalVars.pas',
  Skins in 'Skins.pas',
  Controls in 'Controls.pas',
  ButtonProc in 'ButtonProc.pas',
  Bass in 'Bass\Bass.pas',
  BassPl in 'Bass\BassPl.pas',
  Dialogs in 'Dialogs.pas',
  BassUnit in 'Bass\BassUnit.pas',
  Settings in 'Settings.pas',
  B_ID3V1 in 'Bass\B_ID3V1.pas' {$IFDEF DEBUG},
  DebugUnit in 'DebugUnit.pas' {$ENDIF},
  Playlist in 'Playlist.pas';

{$R 'Graple.res'}

begin
  Path:=ExtractFilePath(Paramstr(0));
  if CreateWindows then
  {$IFDEF DEBUG}
    begin
      WriteLn(LogFile, #13#10'Entering message loop...');
  {$ENDIF}
      MessageLoop;
  {$IFDEF DEBUG}
    end;
  {$ENDIF}
end.
