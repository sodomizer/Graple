{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Dialogs Unit                            ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit Dialogs;

interface

uses Windows, CommDlg;

function OpenFileDialog(var FileName:WideString; filter:WideString='All Files (*.*)'#0'*.*'; Parent:HWND=0):boolean;

implementation

function OpenFileDialog(var FileName:WideString; filter:WideString='All Files (*.*)'#0'*.*'; Parent:HWND=0):boolean;
var ofn:tagOFNW;
    buf:array[0..259] of WideChar;
begin
  Result:=false;
  buf[0]:=#0;
  ZeroMemory(@ofn, SizeOf(ofn));
  ofn.lStructSize := sizeof(ofn);
  ofn.hWndOwner := Parent;
  ofn.lpstrFile := buf;
  ofn.hInstance:=hInstance;
  ofn.lpstrFilter := PWideChar(Filter);
  ofn.nMaxFile := sizeof(buf);
  ofn.nFilterIndex := 1;
  ofn.lpstrFileTitle := nil;
  ofn.nMaxFileTitle := 0;
  ofn.lpstrInitialDir := nil;
  ofn.Flags := OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST;
  if GetOpenFileNameW(ofn) then
    begin
      FileName:=ofn.lpstrFile;
      Result:=true;
    end;
end;




end.
