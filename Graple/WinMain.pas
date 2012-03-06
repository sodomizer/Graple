{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Main Cycle Unit                         ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit WinMain;

interface

uses Windows, WinForm;

procedure MessageLoop;
function CreateWindows:boolean;

implementation

var MainWnd:TMainForm;

function CreateWindows:boolean;
begin
  MainWnd:=TMainForm.CreateForm(hInstance);
  MainWnd.Show;
  Result:=MainWnd<>nil;
end;

procedure MessageLoop;
var Mes:MSG;
begin
  while GetMessage(mes, 0, 0, 0) do
    begin
      TranslateMessage(mes);
      DispatchMessage(mes);
    end;
  DestroyWindow(MainWnd.Handle);
end;

end.
