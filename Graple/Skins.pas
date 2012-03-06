{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Skins Unit                              ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit Skins;

interface

uses IniFiles, GDIPAPI, GDIPOBJ, Classes, SysUtils, ActiveX, Windows{$IFDEF DEBUG}, DebugUnit{$ENDIF};

const

  FILE_VERSION_MAJ              = 1;
  FILE_VERSION_MIN              = 0;

  SKIN_FIRST                    = -1;
  SKIN_LAST                     = -2;

  SKIN_MAIN                     = 0;
  SKIN_MAIN_BASE                = SKIN_MAIN;
  SKIN_MAIN_END                 = SKIN_MAIN+99;

  SKIN_WND                      = SKIN_MAIN + 100;
  SKIN_WND_FILL                 = SKIN_WND + 1;
  SKIN_WND_CORNER_UL            = SKIN_WND + 2;
  SKIN_WND_CORNER_BL            = SKIN_WND + 3;
  SKIN_WND_CORNER_UR            = SKIN_WND + 4;
  SKIN_WND_CORNER_BR            = SKIN_WND + 5;
  SKIN_WND_TOP                  = SKIN_WND + 6;
  SKIN_WND_BOTTOM               = SKIN_WND + 7;
  SKIN_WND_LEFT                 = SKIN_WND + 8;
  SKIN_WND_RIGHT                = SKIN_WND + 9;
  SKIN_WND_END                  = SKIN_WND + 99;

  SKIN_SYSBUT                   = SKIN_WND + 100;
  SKIN_SYSBUT_CLOSE             = SKIN_SYSBUT + 1;
  SKIN_SYSBUT_MINIMIZE          = SKIN_SYSBUT + 2;
  SKIN_SYSBUT_BIND              = SKIN_SYSBUT + 3;
  SKIN_SYSBUT_SYSMENU           = SKIN_SYSBUT + 4;
  SKIN_SYSBUT_SETTINGS          = SKIN_SYSBUT + 5;
  SKIN_SYSBUT_UTILS             = SKIN_SYSBUT + 6;
  SKIN_SYSBUT_END               = SKIN_SYSBUT + 99;

  SKIN_SYSBUT_HOVER             = SKIN_SYSBUT + 100;
  SKIN_SYSBUT_HOVER_CLOSE       = SKIN_SYSBUT_HOVER + 1;
  SKIN_SYSBUT_HOVER_MINIMIZE    = SKIN_SYSBUT_HOVER + 2;
  SKIN_SYSBUT_HOVER_BIND        = SKIN_SYSBUT_HOVER + 3;
  SKIN_SYSBUT_HOVER_SYSMENU     = SKIN_SYSBUT_HOVER + 4;
  SKIN_SYSBUT_HOVER_SETTINGS    = SKIN_SYSBUT_HOVER + 5;
  SKIN_SYSBUT_HOVER_UTILS       = SKIN_SYSBUT_HOVER + 6;
  SKIN_SYSBUT_HOVER_END         = SKIN_SYSBUT_HOVER + 99;

  SKIN_SYSBUT_PRESSED           = SKIN_SYSBUT_HOVER + 100;
  SKIN_SYSBUT_PRESSED_CLOSE     = SKIN_SYSBUT_PRESSED + 1;
  SKIN_SYSBUT_PRESSED_MINIMIZE  = SKIN_SYSBUT_PRESSED + 2;
  SKIN_SYSBUT_PRESSED_BIND      = SKIN_SYSBUT_PRESSED + 3;
  SKIN_SYSBUT_PRESSED_SYSMENU   = SKIN_SYSBUT_PRESSED + 4;
  SKIN_SYSBUT_PRESSED_SETTINGS  = SKIN_SYSBUT_PRESSED + 5;
  SKIN_SYSBUT_PRESSED_UTILS     = SKIN_SYSBUT_PRESSED + 6;
  SKIN_SYSBUT_PRESSED_END       = SKIN_SYSBUT_PRESSED + 99;

  SKIN_BUTTON                   = SKIN_SYSBUT_PRESSED + 100;
  SKIN_BUTTON_EMPTY             = SKIN_BUTTON + 1;
  SKIN_BUTTON_PLAY              = SKIN_BUTTON + 2;
  SKIN_BUTTON_PAUSE             = SKIN_BUTTON + 3;
  SKIN_BUTTON_PLAYPAUSE         = SKIN_BUTTON + 4;
  SKIN_BUTTON_STOP              = SKIN_BUTTON + 5;
  SKIN_BUTTON_PREV              = SKIN_BUTTON + 6;
  SKIN_BUTTON_NEXT              = SKIN_BUTTON + 7;
  SKIN_BUTTON_OPEN              = SKIN_BUTTON + 8;
  SKIN_BUTTON_RANDOM            = SKIN_BUTTON + 9;
  SKIN_BUTTON_REPEAT            = SKIN_BUTTON + 10;
  SKIN_BUTTON_MUTE              = SKIN_BUTTON + 11;
  SKIN_BUTTON_EQON              = SKIN_BUTTON + 12;
  SKIN_BUTTON_EQSHOW            = SKIN_BUTTON + 13;
  SKIN_BUTTON_PLSHOW            = SKIN_BUTTON + 14;
  SKIN_BUTTON_ADD               = SKIN_BUTTON + 15;
  SKIN_BUTTON_DEL               = SKIN_BUTTON + 16;
  SKIN_BUTTON_NEW               = SKIN_BUTTON + 17;
  SKIN_BUTTON_LOAD              = SKIN_BUTTON + 18;
  SKIN_BUTTON_SAVE              = SKIN_BUTTON + 19;
  SKIN_BUTTON_END               = SKIN_BUTTON + 99;

  SKIN_BUTTON_HOVER             = SKIN_BUTTON + 100;
  SKIN_BUTTON_HOVER_EMPTY       = SKIN_BUTTON_HOVER + 1;
  SKIN_BUTTON_HOVER_PLAY        = SKIN_BUTTON_HOVER + 2;
  SKIN_BUTTON_HOVER_PAUSE       = SKIN_BUTTON_HOVER + 3;
  SKIN_BUTTON_HOVER_PLAYPAUSE   = SKIN_BUTTON_HOVER + 4;
  SKIN_BUTTON_HOVER_STOP        = SKIN_BUTTON_HOVER + 5;
  SKIN_BUTTON_HOVER_PREV        = SKIN_BUTTON_HOVER + 6;
  SKIN_BUTTON_HOVER_NEXT        = SKIN_BUTTON_HOVER + 7;
  SKIN_BUTTON_HOVER_OPEN        = SKIN_BUTTON_HOVER + 8;
  SKIN_BUTTON_HOVER_RANDOM      = SKIN_BUTTON_HOVER + 9;
  SKIN_BUTTON_HOVER_REPEAT      = SKIN_BUTTON_HOVER + 10;
  SKIN_BUTTON_HOVER_MUTE        = SKIN_BUTTON_HOVER + 11;
  SKIN_BUTTON_HOVER_EQON        = SKIN_BUTTON_HOVER + 12;
  SKIN_BUTTON_HOVER_EQSHOW      = SKIN_BUTTON_HOVER + 13;
  SKIN_BUTTON_HOVER_PLSHOW      = SKIN_BUTTON_HOVER + 14;
  SKIN_BUTTON_HOVER_ADD         = SKIN_BUTTON_HOVER + 15;
  SKIN_BUTTON_HOVER_DEL         = SKIN_BUTTON_HOVER + 16;
  SKIN_BUTTON_HOVER_NEW         = SKIN_BUTTON_HOVER + 17;
  SKIN_BUTTON_HOVER_LOAD        = SKIN_BUTTON_HOVER + 18;
  SKIN_BUTTON_HOVER_SAVE        = SKIN_BUTTON_HOVER + 19;
  SKIN_BUTTON_HOVER_END         = SKIN_BUTTON_HOVER + 99;

  SKIN_BUTTON_PRESSED           = SKIN_BUTTON_HOVER + 100;
  SKIN_BUTTON_PRESSED_EMPTY     = SKIN_BUTTON_PRESSED + 1;
  SKIN_BUTTON_PRESSED_PLAY      = SKIN_BUTTON_PRESSED + 2;
  SKIN_BUTTON_PRESSED_PAUSE     = SKIN_BUTTON_PRESSED + 3;
  SKIN_BUTTON_PRESSED_PLAYPAUSE = SKIN_BUTTON_PRESSED + 4;
  SKIN_BUTTON_PRESSED_STOP      = SKIN_BUTTON_PRESSED + 5;
  SKIN_BUTTON_PRESSED_PREV      = SKIN_BUTTON_PRESSED + 6;
  SKIN_BUTTON_PRESSED_NEXT      = SKIN_BUTTON_PRESSED + 7;
  SKIN_BUTTON_PRESSED_OPEN      = SKIN_BUTTON_PRESSED + 8;
  SKIN_BUTTON_PRESSED_RANDOM    = SKIN_BUTTON_PRESSED + 9;
  SKIN_BUTTON_PRESSED_REPEAT    = SKIN_BUTTON_PRESSED + 10;
  SKIN_BUTTON_PRESSED_MUTE      = SKIN_BUTTON_PRESSED + 11;
  SKIN_BUTTON_PRESSED_EQON      = SKIN_BUTTON_PRESSED + 12;
  SKIN_BUTTON_PRESSED_EQSHOW    = SKIN_BUTTON_PRESSED + 13;
  SKIN_BUTTON_PRESSED_PLSHOW    = SKIN_BUTTON_PRESSED + 14;
  SKIN_BUTTON_PRESSED_ADD       = SKIN_BUTTON_PRESSED + 15;
  SKIN_BUTTON_PRESSED_DEL       = SKIN_BUTTON_PRESSED + 16;
  SKIN_BUTTON_PRESSED_NEW       = SKIN_BUTTON_PRESSED + 17;
  SKIN_BUTTON_PRESSED_LOAD      = SKIN_BUTTON_PRESSED + 18;
  SKIN_BUTTON_PRESSED_SAVE      = SKIN_BUTTON_PRESSED + 19;
  SKIN_BUTTON_PRESSED_END       = SKIN_BUTTON_PRESSED + 99;

  SKIN_TGLBUT                   = SKIN_BUTTON_PRESSED + 100;
  SKIN_TGLBUT_EMPTY             = SKIN_TGLBUT + 1;
  SKIN_TGLBUT_RANDOM            = SKIN_TGLBUT + 2;
  SKIN_TGLBUT_REPEAT            = SKIN_TGLBUT + 3;
  SKIN_TGLBUT_MUTE              = SKIN_TGLBUT + 4;
  SKIN_TGLBUT_EQON              = SKIN_TGLBUT + 5;
  SKIN_TGLBUT_END               = SKIN_TGLBUT + 99;

  SKIN_TGLBUT_HOVER             = SKIN_TGLBUT + 100;
  SKIN_TGLBUT_HOVER_EMPTY       = SKIN_TGLBUT_HOVER + 1;
  SKIN_TGLBUT_HOVER_RANDOM      = SKIN_TGLBUT_HOVER + 2;
  SKIN_TGLBUT_HOVER_REPEAT      = SKIN_TGLBUT_HOVER + 3;
  SKIN_TGLBUT_HOVER_MUTE        = SKIN_TGLBUT_HOVER + 4;
  SKIN_TGLBUT_HOVER_EQON        = SKIN_TGLBUT_HOVER + 5;
  SKIN_TGLBUT_HOVER_END         = SKIN_TGLBUT_HOVER + 99;

  SKIN_TGLBUT_PRESSED           = SKIN_TGLBUT_HOVER + 100;
  SKIN_TGLBUT_PRESSED_EMPTY     = SKIN_TGLBUT_PRESSED + 1;
  SKIN_TGLBUT_PRESSED_RANDOM    = SKIN_TGLBUT_PRESSED + 2;
  SKIN_TGLBUT_PRESSED_REPEAT    = SKIN_TGLBUT_PRESSED + 3;
  SKIN_TGLBUT_PRESSED_MUTE      = SKIN_TGLBUT_PRESSED + 4;
  SKIN_TGLBUT_PRESSED_EQON      = SKIN_TGLBUT_PRESSED + 5;
  SKIN_TGLBUT_PRESSED_END       = SKIN_TGLBUT_PRESSED + 99;

  SKIN_TGLBUT_TOGGLED                 = SKIN_TGLBUT_PRESSED + 100;
  SKIN_TGLBUT_TOGGLED_EMPTY           = SKIN_TGLBUT_TOGGLED + 1;
  SKIN_TGLBUT_TOGGLED_RANDOM          = SKIN_TGLBUT_TOGGLED + 2;
  SKIN_TGLBUT_TOGGLED_REPEAT          = SKIN_TGLBUT_TOGGLED + 3;
  SKIN_TGLBUT_TOGGLED_MUTE            = SKIN_TGLBUT_TOGGLED + 4;
  SKIN_TGLBUT_TOGGLED_EQON            = SKIN_TGLBUT_TOGGLED + 5;
  SKIN_TGLBUT_TOGGLED_END             = SKIN_TGLBUT_TOGGLED + 99;

  SKIN_TGLBUT_TOGGLED_HOVER           = SKIN_TGLBUT_TOGGLED + 100;
  SKIN_TGLBUT_TOGGLED_HOVER_EMPTY     = SKIN_TGLBUT_TOGGLED_HOVER + 1;
  SKIN_TGLBUT_TOGGLED_HOVER_RANDOM    = SKIN_TGLBUT_TOGGLED_HOVER + 2;
  SKIN_TGLBUT_TOGGLED_HOVER_REPEAT    = SKIN_TGLBUT_TOGGLED_HOVER + 3;
  SKIN_TGLBUT_TOGGLED_HOVER_MUTE      = SKIN_TGLBUT_TOGGLED_HOVER + 4;
  SKIN_TGLBUT_TOGGLED_HOVER_EQON      = SKIN_TGLBUT_TOGGLED_HOVER + 5;
  SKIN_TGLBUT_TOGGLED_HOVER_END       = SKIN_TGLBUT_TOGGLED_HOVER + 99;

  SKIN_TGLBUT_TOGGLED_PRESSED         = SKIN_TGLBUT_TOGGLED_HOVER + 100;
  SKIN_TGLBUT_TOGGLED_PRESSED_EMPTY   = SKIN_TGLBUT_TOGGLED_PRESSED + 1;
  SKIN_TGLBUT_TOGGLED_PRESSED_RANDOM  = SKIN_TGLBUT_TOGGLED_PRESSED + 2;
  SKIN_TGLBUT_TOGGLED_PRESSED_REPEAT  = SKIN_TGLBUT_TOGGLED_PRESSED + 3;
  SKIN_TGLBUT_TOGGLED_PRESSED_MUTE    = SKIN_TGLBUT_TOGGLED_PRESSED + 4;
  SKIN_TGLBUT_TOGGLED_PRESSED_EQON    = SKIN_TGLBUT_TOGGLED_PRESSED + 5;
  SKIN_TGLBUT_TOGGLED_PRESSED_END     = SKIN_TGLBUT_TOGGLED_PRESSED + 99;

  SKIN_STATIC                   = SKIN_TGLBUT_TOGGLED_PRESSED + 100;
  SKIN_STATIC_FILEINFO          = SKIN_STATIC + 1;
  SKIN_STATIC_TIME              = SKIN_STATIC + 2;
  SKIN_STATIC_VIS               = SKIN_STATIC + 3;
  SKIN_STATIC_SPECTRUM          = SKIN_STATIC + 4;
  SKIN_STATIC_LRLEVELS          = SKIN_STATIC + 5;
  SKIN_STATIC_ADDINFO           = SKIN_STATIC + 6;
  SKIN_STATIC_END               = SKIN_STATIC + 99;

  SKIN_TRACKBAR                 = SKIN_STATIC + 100;
  SKIN_TRACKBAR_POS             = SKIN_TRACKBAR + 1;
  SKIN_TRACKBAR_VOL             = SKIN_TRACKBAR + 2;
  SKIN_TRACKBAR_BALANCE         = SKIN_TRACKBAR + 3;
  SKIN_TRACKBAR_END             = SKIN_TRACKBAR + 99;

  SKIN_TRACKBAR_LSIDE           = SKIN_TRACKBAR + 100;
  SKIN_TRACKBAR_LSIDE_POS       = SKIN_TRACKBAR_LSIDE + 1;
  SKIN_TRACKBAR_LSIDE_VOL       = SKIN_TRACKBAR_LSIDE + 2;
  SKIN_TRACKBAR_LSIDE_BALANCE   = SKIN_TRACKBAR_LSIDE + 3;
  SKIN_TRACKBAR_LSIDE_END       = SKIN_TRACKBAR_LSIDE + 99;

  SKIN_TRACKBAR_RSIDE           = SKIN_TRACKBAR_LSIDE + 100;
  SKIN_TRACKBAR_RSIDE_POS       = SKIN_TRACKBAR_RSIDE + 1;
  SKIN_TRACKBAR_RSIDE_VOL       = SKIN_TRACKBAR_RSIDE + 2;
  SKIN_TRACKBAR_RSIDE_BALANCE   = SKIN_TRACKBAR_RSIDE + 3;
  SKIN_TRACKBAR_RSIDE_END       = SKIN_TRACKBAR_RSIDE + 99;

  SKIN_MENUITEM                 = SKIN_TRACKBAR_RSIDE + 100;
  SKIN_MENUITEM_BG              = SKIN_MENUITEM + 1;
  SKIN_MENUITEM_NORMAL          = SKIN_MENUITEM + 2;
  SKIN_MENUITEM_HOVER           = SKIN_MENUITEM + 3;
  SKIN_MENUITEM_CHECK           = SKIN_MENUITEM + 4;
  SKIN_MENUITEM_SEPERATOR       = SKIN_MENUITEM + 5;
  SKIN_MENUITEM_END             = SKIN_MENUITEM + 99;

  SKIN_FLAG_NORMAL              = 0;
  SKIN_FLAG_ROT90               = 1;
  SKIN_FLAG_ROT180              = 2;
  SKIN_FLAG_FLIPH               = 4;
  SKIN_FLAG_FLIPV               = 6;
  SKIN_FLAG_NOIMG               = $80;

  SKIN_FLAG_TILE                = 5;
  SKIN_FLAG_TILEFLIPX           = 4;
  SKIN_FLAG_TILEFLIPY           = 3;
  SKIN_FLAG_TILEFLIPXY          = 2;
  SKIN_FLAG_CLAMP               = 1;
  SKIN_FLAG_STRETCH             = 0;


var Path:string;

type

  {TPoint = record
    X: Longint;
    Y: Longint;
  end; }

  TSFont=record
    Name:string;
    Size:Single;
    Style:integer;
  end;

  PSImage = ^TSImage;
  TSImage = packed record
    ID: integer;
    Image: TGPBitmap;
    Pos:  TPoint;
    Size: TPoint;
    ZOrder: byte;
    Color: TRGBQuad;
    Tile: 0..5;
    Next: PSImage;
    Prev: PSImage;
  end;

  PPSImage = ^TPSImage;
  TPSImage = packed record
    Ref:  PSImage;
    Next: PPSImage;
    Prev: PPSImage;
  end;

  TPSImageList = class
    private
      ImgCount : integer;
      ImgFirst : PPSImage;
      ImgLast : PPSImage;
      function GetImage(Id:integer):PSImage;
      function IsEmpty:boolean;
    public
      property First:PPSImage read ImgFirst;
      property Last:PPSImage read ImgLast;
      property Images[Index:integer]:PSImage read GetImage;  default;
      property Empty:boolean read IsEmpty;

      procedure AddRef(Ref:PSImage);

      procedure Clear;

      constructor Create;
      destructor Destroy; override;
      procedure Free;
  end;

  TSImageList = class
    private
      ImgCount : integer;
      ImgFirst : PSImage;
      ImgLast : PSImage;
      function GetImage(Id:integer):PSImage;
      function IsEmpty:boolean;
    public
      property First:PSImage read ImgFirst;
      property Last:PSImage read ImgLast;
      property Images[Index:integer]:PSImage read GetImage;  default;
      property Empty:boolean read IsEmpty;

      function  GetRefList:TPSImageList;
      function  GetSorted:TPSImageList;
      procedure AddImage(Id:integer; Pos, Size:TPoint; ZOrder:byte; ReplColor:TRGBQuad; img:TGPBitmap); overload;
      procedure AddImage(Img:PSImage); overload;
      function  Copy:TSImageList;
      procedure Clear;

      constructor Create;
      destructor Destroy; override;
      procedure Free;
  end;

  TSkin = class
    private
      ImgList:TSImageList;
      SortedList:TPSImageList;

      sFileName:string;

      sAuthor:AnsiString;
      sName:AnsiString;
      sDescription:AnsiString;
      sVersion:AnsiString;

      sMainFont, sFont2, sFont3:TSFont;
      sMainColor, sColor2, sColor3:TGPColor;

      function GetFirstSorted:PSImage;
      procedure GetAsIStream(Src:TFileStream; var Str:IStream); overload;
      procedure GetAsIStream(Src:TFileStream; var Str:IStream; Start, Size:int64); overload;
      function GetImage(Id:integer):PSImage;
    public
      property FileName:String read sFileName;

      property Author:AnsiString read sAuthor;
      property Name:AnsiString read sName;
      property Description:AnsiString read sDescription;
      property Version:AnsiString read sVersion;

      property MainFont:TSFont read sMainFont;
      property Font2:TSFont read sFont2;
      property Font3:TSFont read sFont3;

      property MainColor:TGPColor read sMainColor;
      property Color2:TGPColor read sColor2;
      property Color3:TGPColor read sColor3;

      property Images[Index:integer]:PSImage read GetImage;
      property SortedFirst:PSImage read GetFirstSorted;

      function LoadFromFile(FileName:string):boolean;

      function SkinMainForm(hWnd:HWND):TGPBitmap;
      function SkinForm(hWnd:HWND):TGPBitmap;
      procedure SkinControl(g:TGPGraphics; hWnd:HWND; Id:integer);

      constructor Create;
      destructor Destroy; override;
  end;

function RegionFromImage(Img:TGPBitmap):HRGN;

implementation

function RegionFromImage(Img:TGPBitmap):HRGN;
var
  TmpRgn: HRGN;
  x, y: integer;
  Col: Cardinal;
begin
  Result:=0;
  if (Img=nil)or(Img.GetWidth=0) or (Img.GetHeight=0) then
    Exit;

  Result := CreateRectRgn(0, 0, Img.GetWidth, Img.GetHeight);

  for x:=0 to Img.GetWidth-1 do
  for y:=0 to Img.GetHeight-1 do
    begin
      img.GetPixel(x, y, Col);
      if (Col shr 24)<10 then
        begin
          TmpRgn := CreateRectRgn(x, y, x+1, y+1);
          CombineRgn(Result, Result, TmpRgn, RGN_DIFF);
          DeleteObject(TmpRgn);
        end;
    end;
end;

//------------------------------------------------------------------------------
//---------- TSImageList -------------------------------------------------------
//------------------------------------------------------------------------------

constructor TSImageList.Create;
begin
  ImgCount:=0;
  ImgFirst:=nil;
  ImgLast:=nil;
end;

destructor TSImageList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TSImageList.Free;
begin
  Destroy;
end;

function TSImageList.IsEmpty;
begin
  Result:=ImgCount=0;
end;

function TSImageList.GetImage(Id:integer):PSImage;
var p:PSImage;
begin
  if Id=SKIN_FIRST then
    begin
      Result:=ImgFirst;
      Exit;
    end
  else
    if Id=SKIN_LAST then
      begin
        Result:=ImgLast;
        Exit;
      end
    else
      Result:=nil;
  p:=ImgFirst;
  while p<>nil do
    begin
      if p.ID=Id then
        begin
          Result:=p;
          Break;
        end;
      p:=p.Next;
    end;
end;

procedure TSImageList.AddImage(Id:integer; Pos, Size:TPoint; ZOrder:byte; ReplColor:TRGBQuad; img:TGPBitmap);
var p:PSImage;
begin
  New(p);
  p.ID:=Id;
  p.Pos:=Pos;
  p.Size:=Size;
  p.ZOrder:=ZOrder;
  p.Color:=ReplColor;
  p.Image:=img;
  p.Prev:=ImgLast;
  if p.Prev<>nil then
    p.Prev.Next:=p;
  p.Next:=nil;
  ImgLast:=p;
  if ImgFirst=nil then
    ImgFirst:=p;
  ImgCount:=ImgCount+1;
end;

procedure TSImageList.Clear;
var p,d:PSImage;
begin
  p:=ImgFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      if d<>nil then
        begin
          if d.Image<>nil then
            d.Image.Free;
          Dispose(d);
        end;
    end;
  ImgFirst:=nil;
  ImgLast:=nil;
  ImgCount:=0;
end;


////////////////////////////////////////////////////////////////////////////////
// BUG /////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function TSImageList.GetSorted:TPSImageList;
var n,s, tmp:PPSImage;
begin
  Result:=GetRefList;
  if Result.ImgFirst=nil then
    Exit;
  n:=Result.ImgFirst.Next;
  while (n<>nil) do
    begin
      s:=n.Next;
      while (n.Prev<>nil) and (n.Ref.ZOrder<n.Prev.Ref.ZOrder) do
        begin
          tmp:=n.Prev;
          n.Prev.Prev.Next:=n;
          tmp.Next:=n.Next;
          n.Prev:=tmp.Prev;
          tmp.Prev:=n;
          n.Next:=tmp;
          if n.Prev=nil then
            Result.ImgFirst:=n;
          if tmp.Next=nil then
            Result.ImgLast:=tmp;
        end;
     n:=s;
    end;
end;

procedure TSImageList.AddImage(Img:PSImage);
begin
  if Img=nil then
    Exit;

  Img.Prev:=ImgLast;
  if Img.Prev<>nil then
    Img.Prev.Next:=Img;
  Img.Next:=nil;
  ImgLast:=Img;
  if ImgFirst=nil then
    ImgFirst:=Img;
  ImgCount:=ImgCount+1;
end;

function TSImageList.Copy:TSImageList;
var p, d, f:PSImage;
begin
  Result:=TSImageList.Create;
  p:=ImgFirst;
  f:=nil;
  while p<>nil do
    begin
      New(d);
      d.ID:=p.ID;
      d.Image:=p.Image;
      d.Pos:=p.Pos;
      d.Size:=p.Size;
      d.ZOrder:=p.ZOrder;
      d.Color:=p.Color;
      d.Tile:=p.Tile;
      d.Next:=nil;
      d.Prev:=f;
      if d.Prev<>nil then
        d.Prev.Next:=d;
      Result.AddImage(d);
      f:=d;
      p:=p.Next;
    end;
end;

function TSImageList.GetRefList:TPSImageList;
var p:PSImage;
begin
  Result:=TPSImageList.Create;
  p:=ImgFirst;
  while p<>nil do
    begin
      Result.AddRef(p);
      p:=p.Next;
    end;
end;


//------------------------------------------------------------------------------
//---------- TPSImageList ------------------------------------------------------
//------------------------------------------------------------------------------

constructor TPSImageList.Create;
begin
  ImgCount:=0;
  ImgFirst:=nil;
  ImgLast:=nil;
end;

destructor TPSImageList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TPSImageList.Free;
begin
  Destroy;
end;

function TPSImageList.IsEmpty;
begin
  Result:=ImgCount=0;
end;

procedure TPSImageList.AddRef(Ref:PSImage);
var p:PPSImage;
begin
  if Ref=nil then
    Exit;

  New(p);
  p.Ref:=Ref;
  P.Prev:=ImgLast;
  if P.Prev<>nil then
    P.Prev.Next:=P;
  P.Next:=nil;
  ImgLast:=P;
  if ImgFirst=nil then
    ImgFirst:=P;
  ImgCount:=ImgCount+1;
end;

function TPSImageList.GetImage(Id:integer):PSImage;
var p:PPSImage;
begin
  if Id=SKIN_FIRST then
    begin
      Result:=ImgFirst.Ref;
      Exit;
    end
  else
    if Id=SKIN_LAST then
      begin
        Result:=ImgLast.Ref;
        Exit;
      end
    else
      Result:=nil;
  p:=ImgFirst;
  while p<>nil do
    begin
      if p.Ref.ID=Id then
        begin
          Result:=p.Ref;
          Break;
        end;
      p:=p.Next;
    end;
end;

procedure TPSImageList.Clear;
var p,d:PPSImage;
begin
  p:=ImgFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      if d<>nil then
        Dispose(d);
    end;
  ImgFirst:=nil;
  ImgLast:=nil;
  ImgCount:=0;
end;

//------------------------------------------------------------------------------
//---------- TSkin -------------------------------------------------------------
//------------------------------------------------------------------------------

constructor TSkin.Create;
begin
  ImgList:=TSImageList.Create;
end;

destructor TSkin.Destroy;
begin
  ImgList.Clear;
  ImgList.Destroy;
  if SortedList<>nil then
    SortedList.Free;
end;

function TSkin.GetImage(Id:integer):PSImage;
begin
  if ImgList<>nil then
    Result:=ImgList.GetImage(Id)
  else
    Result:=nil;
end;

function TSkin.GetFirstSorted:PSImage;
begin
  if SortedList<>nil then
    Result:=SortedList.First.Ref
  else
    Result:=nil;
end;


function TSkin.SkinMainForm(hWnd:HWND):TGPBitmap;
var img: TGPBitmap;
    g:TGPGraphics;
    si:PSImage;
    Rect:TRect;
    X, Y:integer;
begin
  GetWindowRect(hWnd, Rect);
  img := TGPBitmap.Create(Rect.Right-Rect.Left, Rect.Bottom-Rect.Top, PixelFormat32bppARGB);
  //if ImgList[SKIN_MAIN_BASE]<>nil then
  //  img := ImgList[SKIN_MAIN_BASE].Image.Clone(0, 0, ImgList[SKIN_MAIN_BASE].Image.GetWidth, ImgList[SKIN_MAIN_BASE].Image.GetHeight, ImgList[SKIN_MAIN_BASE].Image.GetPixelFormat)
  //else
  //  img := TGPBitmap.Create();

  g:=TGPGraphics.Create(img);
  g.DrawImage(ImgList[SKIN_MAIN_BASE].Image, 0, 0);

  if SortedList[SKIN_FIRST]<>nil then
    si:=SortedList[SKIN_FIRST].Next
  else
    si:=nil;

  while (si<>nil) do
    begin
      if (si.ID>SKIN_MAIN)and(si.ID<SKIN_MAIN_END) then
        begin
          if si.Pos.X>=0 then
            X:=si.Pos.X
          else
            //X:=img.GetWidth+si.Pos.X;
            X:=(Rect.Right-Rect.Left)+si.Pos.X;
          if si.Pos.Y>=0 then
            Y:=si.Pos.Y
          else
            //Y:=img.GetHeight+si.Pos.Y;
            Y:=(Rect.Bottom-Rect.Top)+si.Pos.Y;
          g.DrawImage(si.Image, X, Y, si.Size.X, si.Size.Y);
        end;
      si:=si.Next;
    end;
  g.Free;
  Result:=img;
end;

function TSkin.SkinForm(hWnd:HWND):TGPBitmap;
var img: TGPBitmap;
    g:TGPGraphics;
    si:PSImage;
    Rect:TRect;
    X, Y:integer;
    Br:TGPBrush;
    Rct:TGPRect;
    Att:TGPImageAttributes;
begin
  GetWindowRect(hWnd, Rect);
  img := TGPBitmap.Create(Rect.Right-Rect.Left, Rect.Bottom-Rect.Top, PixelFormat32bppARGB);

  g:=TGPGraphics.Create(img);
  g.SetInterpolationMode(InterpolationModeBilinear);
  Att:=TGPImageAttributes.Create;

  if SortedList[SKIN_FIRST]<>nil then
    si:=SortedList[SKIN_FIRST].Next
  else
    si:=nil;

  while (si<>nil) do
    begin
      if (si.ID>SKIN_WND)and(si.ID<SKIN_WND_END) then
        begin
          if si.Pos.X>=0 then
            X:=si.Pos.X
          else
            X:=(Rect.Right-Rect.Left)+si.Pos.X;
          if si.Pos.Y>=0 then
            Y:=si.Pos.Y
          else
            Y:=(Rect.Bottom-Rect.Top)+si.Pos.Y;
          if si.Tile>0 then
            Att.SetWrapMode(WrapMode(5-si.Tile), Cardinal(si.Color));
          case si.ID of
            SKIN_WND_TOP, SKIN_WND_BOTTOM:
              if si.Image<>nil then
                begin
                  Rct.X:=X;
                  if si.ID=SKIN_WND_TOP then
                    Rct.Y:=Y-1
                  else
                    Rct.Y:=Y;
                  Rct.Width:=(Rect.Right-Rect.Left-Abs(si.Pos.X))+si.Size.X;
                  Rct.Height:=si.Size.Y;
                  if si.Tile>0 then
                    g.DrawImage(si.Image, Rct, 0, 0, Rct.Width-1, Rct.Height-1, UnitPixel, Att)
                  else
                    g.DrawImage(si.Image, X, Y, Rct.Width, si.Size.Y);
                end
              else
                begin
                  Br:=TGPSolidBrush.Create(Cardinal(si.Color));
                  g.FillRectangle(Br, X, Y, (Rect.Right-Rect.Left-Abs(si.Pos.X))+si.Size.X, si.Size.Y);
                  Br.Free;
                end;
            SKIN_WND_LEFT, SKIN_WND_RIGHT:
              if si.Image<>nil then
                begin
                  if si.ID=SKIN_WND_LEFT then
                    Rct.X:=X-1
                  else
                    Rct.X:=X;
                  Rct.Y:=Y;
                  Rct.Width:=si.Size.X;
                  Rct.Height:=(Rect.Bottom-Rect.Top-Abs(si.Pos.Y))+si.Size.Y;
                  if si.Tile>0 then
                    g.DrawImage(si.Image, Rct, 0, 0, Rct.Width-1, Rct.Height-1, UnitPixel, Att)
                  else
                    g.DrawImage(si.Image, X, Y, si.Size.X, Rct.Height);
                end
              else
                begin
                  Br:=TGPSolidBrush.Create(Cardinal(si.Color));
                  g.FillRectangle(Br, X, Y, si.Size.X, (Rect.Bottom-Rect.Top-Abs(si.Pos.Y))+si.Size.Y);
                  Br.Free;
                end;
            SKIN_WND_FILL:
              if si.Image<>nil then
                begin
                  Rct.X:=X;
                  Rct.Y:=Y;
                  Rct.Width:=(Rect.Right-Rect.Left-Abs(si.Pos.X))+si.Size.X;
                  Rct.Height:=(Rect.Bottom-Rect.Top-Abs(si.Pos.Y))+si.Size.Y;
                  if si.Tile>0 then
                    g.DrawImage(si.Image, Rct, 0, 0, Rct.Width-1, Rct.Height-1, UnitPixel, Att)
                  else
                    g.DrawImage(si.Image, X, Y, Rct.Width, Rct.Height);
                end
              else
                begin
                  Br:=TGPSolidBrush.Create(Cardinal(si.Color));
                  g.FillRectangle(Br, X, Y, (Rect.Right-Rect.Left-Abs(si.Pos.X))+si.Size.X, (Rect.Bottom-Rect.Top-Abs(si.Pos.Y))+si.Size.Y);
                  Br.Free;
                end
            else
              if si.Image<>nil then
                g.DrawImage(si.Image, X, Y, si.Size.X, si.Size.Y)
              else
                begin
                  Br:=TGPSolidBrush.Create(Cardinal(si.Color));
                  g.FillRectangle(Br, X, Y, si.Size.X, si.Size.Y);
                  Br.Free;
                end;
          end;
        end;
      si:=si.Next;
    end;
  Att.Free;
  g.Free;
  Result:=img;
end;

procedure TSkin.SkinControl(g:TGPGraphics; hWnd:HWND; Id:integer);
var si:PSImage;
    Rect:TRECT;
    X, Y:integer;
begin
  GetWindowRect(GetParent(hWnd), Rect);
  si:=SortedList.First.Ref;
  while si<>nil do
    begin
      if si.ID=Id then
        begin
          if si.Pos.X>=0 then
            X:=si.Pos.X
          else
            X:=(Rect.Right-Rect.Left)+si.Pos.X;
          if si.Pos.Y>=0 then
            Y:=si.Pos.Y
          else
            Y:=(Rect.Bottom-Rect.Top)+si.Pos.Y;
          g.DrawImage(si.Image, X, Y, si.Size.X, si.Size.Y);
        end;
      si:=si.Next;
    end;
end;



procedure TSkin.GetAsIStream(Src:TFileStream; var Str:IStream);
var MemStream:TMemoryStream;
    Sz:Int64;
begin
  Src.Read(Sz, SizeOf(Int64));
  MemStream:=TMemoryStream.Create;
  MemStream.CopyFrom(Src, Sz);
  Str:=TStreamAdapter.Create(MemStream, soOwned);
end;

procedure TSkin.GetAsIStream(Src:TFileStream; var Str:IStream; Start, Size:int64);
var MemStream:TMemoryStream;
    Pos:int64;
begin
  Pos:=Src.Position;
  Src.Seek(Start, soFromBeginning);
  MemStream:=TMemoryStream.Create;
  MemStream.CopyFrom(Src, Size);
  Src.Seek(Pos, soFromBeginning);
  Str:=TStreamAdapter.Create(MemStream, soOwned);
end;

function TSkin.LoadFromFile(FileName:string):boolean;

type  TableItem=record
        Start:int64;
        Size:int64;
      end;

var S:TFileStream;
    IStr:IStream;
    i, l:integer;
    str:AnsiString;
    maj, min, flags:byte;
    p:PSImage;
    IndexTable:array of TableItem;
begin
  Result:=false;
  ImgList.Clear;
  if SortedList<>nil then
    begin
      SortedList.Clear;
      //SortedList.Free;
      SortedList:=nil;
    end;

  {$IFDEF DEBUG}
    WriteLn(LogFile, ' Started to load skin...');
  {$ENDIF}

  try
    S:=nil;
    if not FileExists(Path+'Skins\'+FileName)then
    {$IFDEF DEBUG}
      begin
        WriteLn(LogFile, '>> Error! File '+FileName+' not exists!');
    {$ENDIF}
        Exit;
    {$IFDEF DEBUG}
      end;
    {$ENDIF}

    sFileName:=FileName;

    S:=TFileStream.Create(Path+'Skins\'+FileName, fmOpenRead);

    {$IFDEF DEBUG}
      WriteLn(LogFile, '  Reading skin file...');
    {$ENDIF}

    //Signature
    SetLength(str, 7);
    S.Read(str[1], 7);
    if Str='GRPLSKN' then
      begin
        //File Version
        S.Read(maj, SizeOf(Byte));
        S.Read(min, SizeOf(Byte));
        if (maj>FILE_VERSION_MAJ)or((maj=FILE_VERSION_MAJ) and (min>FILE_VERSION_MIN)) then
          begin
            S.Free;
            MessageBox(0, 'Version of the skin file is newer than the program supports!', 'Error!', MB_ICONERROR);
            Exit;
          end;

        //Skin Name
        S.Read(l, SizeOf(Integer));
        SetLength(sName, l);
        S.Read(sName[1], l);

        //Skin Description
        S.Read(l, SizeOf(Integer));
        SetLength(sDescription, l);
        S.Read(sDescription[1], l);

        //Skin Author
        S.Read(l, SizeOf(Integer));
        SetLength(sAuthor, l);
        S.Read(sAuthor[1], l);

        //Skin Version
        S.Read(l, SizeOf(Integer));
        SetLength(sVersion, l);
        S.Read(sVersion[1], l);

        //Reserved
        S.Read(l, SizeOf(Integer));
        S.Read(l, SizeOf(Integer));
        S.Read(l, SizeOf(Integer));

        //Fonts & Colors
        if maj>=1 then
          begin
            S.Read(l, SizeOf(Integer));
            SetLength(sMainFont.Name, l);
            S.Read(sMainFont.Name[1], l*2);
            S.Read(sMainFont.Size, SizeOf(Single));
            S.Read(sMainFont.Style, SizeOf(TFontStyle));

            S.Read(l, SizeOf(Integer));
            SetLength(sFont2.Name, l);
            S.Read(sFont2.Name[1], l*2);
            S.Read(sFont2.Size, SizeOf(Single));
            S.Read(sFont2.Style, SizeOf(TFontStyle));

            S.Read(l, SizeOf(Integer));
            SetLength(sFont3.Name, l);
            S.Read(sFont3.Name[1], l*2);
            S.Read(sFont3.Size, SizeOf(Single));
            S.Read(sFont3.Style, SizeOf(TFontStyle));

            S.Read(sMainColor, SizeOf(TGPColor));
            S.Read(sColor2, SizeOf(TGPColor));
            S.Read(sColor3, SizeOf(TGPColor));
          end;

        //Image Index Table Count
        S.Read(l, SizeOf(Integer));
        SetLength(IndexTable, l);
        for i:=0 to l-1 do
          begin
            //Size
            S.Read(IndexTable[i].Size, SizeOf(Int64));
            //Start
            S.Read(IndexTable[i].Start, SizeOf(Int64));
          end;

        //Skin Items
        S.Read(l, SizeOf(Integer));
        for i:=0 to l-1 do
          begin
            New(p);
            //ID
            S.Read(p.Id,  SizeOf(Integer));
            if (i=0)and(p.Id<>0) then
              begin
                S.Free;
                MessageBox(0, 'Skin file is missing main window image data!', 'Error!', MB_ICONERROR);
                Exit;
              end;
            //Position
            S.Read(p.Pos.X, SizeOf(Integer));
            S.Read(p.Pos.Y, SizeOf(Integer));
            //Size
            S.Read(p.Size.X, SizeOf(Integer));
            S.Read(p.Size.Y, SizeOf(Integer));
            //Order
            S.Read(p.ZOrder, SizeOf(Byte));
            //Flags
            S.Read(flags, SizeOf(Byte));
            //If Using Image
            if (flags and SKIN_FLAG_NOIMG)=0 then
              begin
                p.Tile:=(flags shr 3) and $07;
                S.Read(l, SizeOf(Integer));
                GetAsIStream(S,IStr, IndexTable[l].Start, IndexTable[l].Size);
                p.Image:=TGPBitmap.Create(IStr);
                p.Image.RotateFlip(RotateFlipType(flags and $07));
                p.Color.rgbBlue:=0;
                p.Color.rgbGreen:=0;
                p.Color.rgbRed:=0;
                p.Color.rgbReserved:=0;
              end
            //Not Using Image
            else
              p.Image:=nil;
            S.Read(p.Color, SizeOf(TRGBQuad));
            ImgList.AddImage(p);
          end;
        SortedList:=ImgList.GetSorted;
        S.Free;
        Result:=true;
      end;
  except
    on Exception do
      begin
        {$IFDEF DEBUG}
          WriteLn(LogFile, '>> Error! Catched exception while reading skin file!');
        {$ENDIF}
        if S<>nil then
          S.Free;
        MessageBox(0, ' Error occured while reading skin file!', 'Error!', MB_ICONERROR);
        Halt(1);
      end;
  end;
end;

end.
