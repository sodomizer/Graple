{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Global Vars Unit                        ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit GlobalVars;

interface

uses Skins, Windows, BassPl, SysUtils, Settings{$IFDEF DEBUG}, DebugUnit{$ENDIF};

var Path:string;
    Settings:TSettings;
    Skin:TSkin;
    BP:TBassPlayer;

implementation

initialization
  Path:=ExtractFilePath(ParamStr(0));

  {$IFDEF DEBUG}
    AssignFile(LogFile, Path+'debug.log');
    Rewrite(LogFile);
  {$ENDIF}

  Settings:=TSettings.Create;
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Settings object was created');
  {$ENDIF}
  Settings.LoadFromFile(Path+'config.ini');
  {$IFDEF DEBUG}
    WriteLn(LogFile, ' Settings were loaded');
  {$ENDIF}
  Skin:=TSkin.Create;
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Skin object was created');
  {$ENDIF}
  Skins.Path := Path;
  if not Skin.LoadFromFile(Settings.SkinName) then
  {$IFDEF DEBUG}
    begin
      WriteLn(LogFile, '>> Error! Skin '+Settings.SkinName+' was not loaded!');
  {$ENDIF}
    PostQuitMessage(1);
  {$IFDEF DEBUG}
    end;
    WriteLn(LogFile, ' Skin '+Settings.SkinName+' was loaded'#13#10);
  {$ENDIF}

finalization
  {$IFDEF DEBUG}
    CloseFile(LogFile);
  {$ENDIF}

  Settings.Free;
  Skin.Free;
  if BP<>nil then
    BP.Free;

end.
