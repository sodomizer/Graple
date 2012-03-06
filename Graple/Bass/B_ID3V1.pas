{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// ID3 Tags Unit                           ///}
{///////////////////////////////////////////////}
{/// Author: Unknown                         ///}
{/// Email: Unknown                          ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit B_ID3V1;

interface

uses SysUtils;

type

  PID3V1TmpRec = ^TID3V1TmpRec;
  TID3V1TmpRec = packed record
    Tag: array[0..2] of AnsiChar;
    Title: array[0..29] of AnsiChar;
    Artist: array[0..29] of AnsiChar;
    Album: array[0..29] of AnsiChar;
    Year: array[0..3] of AnsiChar;
    Comment: array[0..29] of AnsiChar;
    Genre: Byte;
  end;

  TID3V1Rec = packed record
    Tag: AnsiString;
    Title: AnsiString;
    Artist: AnsiString;
    Album: AnsiString;
    Year: AnsiString;
    Comment: AnsiString;
    Genre: Byte;
  end;

function BASSID3ToID3V1Rec(PC: PAnsiChar): TID3V1Rec;

implementation

function BASSID3ToID3V1Rec(PC: PAnsiChar): TID3V1Rec;
var
TempID3V1: TID3V1TmpRec;
begin
  FillChar(Result, SizeOf(TID3V1Rec) - 1, #0);
  if (PC = nil) then
    Exit;
  TempID3V1 := PID3V1TmpRec(PC)^;
  if SameText(TempID3V1.Tag, 'TAG') then
    begin
      Result.Tag := TempID3V1.Tag;
      Result.Title := Trim(TempID3V1.Title);
      Result.Artist := Trim(TempID3V1.Artist);
      Result.Album := Trim(TempID3V1.Album);
      Result.Year := Trim(TempID3V1.Year);
      Result.Comment := Trim(TempID3V1.Comment);
      Result.Genre := TempID3V1.Genre;
    end;
end;

end.
