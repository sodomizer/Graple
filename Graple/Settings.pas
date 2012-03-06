{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Settings Unit                           ///}
{///////////////////////////////////////////////}
{/// Author: KOOL, CodeGear                  ///}
{/// Email: kool_91@mail.ru                  ///}
{/// URL: codegear.com                       ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}
unit Settings;

interface

uses Windows, SysUtils;

type

  TSettings = class
    private
      FFileName:string;
      function ReadString(const Section, Ident, Default: string): string;
      procedure WriteString(const Section, Ident, Value: string);
      function ReadInteger(const Section, Ident: string; Default: Longint): Longint;
      procedure WriteInteger(const Section, Ident: string; Value: Longint);
      function ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
      procedure WriteBool(const Section, Ident: string; Value: Boolean);
      function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
      function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
      function ReadFloat(const Section, Name: string; Default: Double): Double;
      function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
      procedure WriteDate(const Section, Name: string; Value: TDateTime);
      procedure WriteDateTime(const Section, Name: string; Value: TDateTime);
      procedure WriteFloat(const Section, Name: string; Value: Double);
      procedure WriteTime(const Section, Name: string; Value: TDateTime);
    public
      SkinName:string;
      MainForm : record
        X:integer;
        Y:integer;
      end;
      procedure LoadFromFile(FileName:string);
      procedure SaveToFile(FileName:string);
  end;

implementation

function TSettings.ReadString(const Section, Ident, Default: string): string;
var
  Buffer: array[0..2047] of Char;
begin

  SetString(Result, Buffer, GetPrivateProfileString(PChar(Section),
    PChar(Ident), PChar(Default), Buffer, Length(Buffer), PChar(FFileName)));
end;

procedure TSettings.WriteString(const Section, Ident, Value: string);
begin
  WritePrivateProfileString(PChar(Section), PChar(Ident), PChar(Value), PChar(FFileName));
end;

function TSettings.ReadInteger(const Section, Ident: string; Default: Longint): Longint;
var
  IntStr: string;
begin
  IntStr := ReadString(Section, Ident, '');
  if (Length(IntStr) > 2) and (IntStr[1] = '0') and
     ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
    IntStr := '$' + Copy(IntStr, 3, Maxint);
  Result := StrToIntDef(IntStr, Default);
end;

procedure TSettings.WriteInteger(const Section, Ident: string; Value: Longint);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TSettings.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

function TSettings.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDate(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TSettings.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDateTime(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TSettings.ReadFloat(const Section, Name: string; Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Section, Name, '');
  Result := Default;
  if FloatStr <> '' then
  try
    Result := StrToFloat(FloatStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TSettings.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  TimeStr: string;
begin
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  if TimeStr <> '' then
  try
    Result := StrToTime(TimeStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

procedure TSettings.WriteDate(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateToStr(Value));
end;

procedure TSettings.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateTimeToStr(Value));
end;

procedure TSettings.WriteFloat(const Section, Name: string; Value: Double);
begin
  WriteString(Section, Name, FloatToStr(Value));
end;

procedure TSettings.WriteTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, TimeToStr(Value));
end;

procedure TSettings.WriteBool(const Section, Ident: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(Section, Ident, Values[Value]);
end;


//------------------------------------------------------------------------------

procedure TSettings.LoadFromFile(FileName:string);
var px, py:string;
begin
  FFileName:=FileName;
  SkinName:=ReadString('Skin', 'Name', 'Eternity.gsk');
  px:=ReadString('MainForm', 'PosX', 'center');
  py:=ReadString('MainForm', 'PosY', 'center');
  MainForm.X:=StrToIntDef(px, -1);
  MainForm.Y:=StrToIntDef(py, -1);
end;

procedure TSettings.SaveToFile(FileName:string);
begin
  FFileName:=FileName;
  WriteString('Skin', 'Name', SkinName);
  WriteInteger('MainForm', 'PosX', MainForm.X);
  WriteInteger('MainForm', 'PosY', MainForm.Y);
end;

end.

