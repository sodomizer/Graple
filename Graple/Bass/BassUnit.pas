{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Bass Helper Unit                        ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit BassUnit;

interface

uses Windows, Dialogs, BassPl, GlobalVars{$IFDEF DEBUG}, DebugUnit{$ENDIF};

var
  FInfo:string;
  FName:string;
  BP:TBassPlayer;
  PlayTimerId:HWND;

procedure Initialize(Hnd:Cardinal);
procedure OpenFile; overload;
procedure OpenFile(FileName:string); overload;

implementation

var
  Parent:HWND;

procedure Initialize(Hnd:Cardinal);
begin
  BP:=TBassPlayer.Create(Hnd);
  {$IFDEF DEBUG}
    if BP<>nil then
      WriteLn(LogFile, 'Bass player object was created')
    else
      WriteLn(LogFile, '>> Error! Bass player object was not created!');
  {$ENDIF}
  Parent:=Hnd;
  {$IFDEF DEBUG}
    WriteLn(LogFile, ' Bass player begins to load plugins');
  {$ENDIF}
  BP.LoadPlugins(Path+'Plugins\');
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Bass player plugins were loaded'#13#10);
  {$ENDIF}
end;

procedure OpenFile; overload;
var s:Widestring;
begin
  if (BP<>nil) and OpenFileDialog(s, 'All Supported Files'+#0+BP.GetSupportedFormats(true, false)+#0+BP.GetSupportedFormats(true, true)+#0+'All Files (*.*)'+#0+'*.*'+#0, Parent) then
    begin
      FName:=s;
      FInfo:=FName;
      BP.OpenStream(s);
      BP.Play;
      SetForegroundWindow(Parent);
    end;
end;

procedure OpenFile(FileName:string); overload;
begin
  if BP<>nil then
    begin
      FName:=FileName;
      FInfo:=FName;
      BP.OpenStream(FileName);
      BP.Play;
      SetForegroundWindow(Parent);
    end;
end;

procedure TogglePlayPause;
begin
  if BP<>nil then
    begin
      BP.PauseToggle;
    end;
end;

initialization

finalization

if BP<>nil then
  BP.Free;

end.
