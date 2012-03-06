unit Skins;

interface

uses Windows, StringHashTable, SysUtils, Classes, ActiveX, GDIImageList, GDIPAPI, GDIPOBJ, GDIPUTIL;

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


  SKIN_CUSTOM                   = 10000;


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

var ConstTable:TStringHashTable;

type

  TableItem=record
    Start:int64;
    Size:int64;
  end;

  TSFont=record
    Name:string;
    Size:Single;
    Style:integer;
  end;

  PSImage = ^TSImage;
  TSImage = packed record
    ID: integer;
    ElementName:AnsiString;
    ImageIndex: integer;
    Pos:  TPoint;
    Size: TPoint;
    ZOrder: byte;
    Color: TRGBQuad;
    Tile: 0..5;
    FlipRotate: 0..7;
    Next: PSImage;
    Prev: PSImage;
  end;

  TSImageList = class
    private
      ImgCount : integer;
      ImgFirst : PSImage;
      ImgLast : PSImage;
      function GetImageById(Id:integer):PSImage;
      function GetImage(Index:integer):PSImage;
      function IsEmpty:boolean;
    public
      property First:PSImage read ImgFirst;
      property Last:PSImage read ImgLast;
      property Images[Index:integer]:PSImage read GetImage;  default;
      property ImagesById[Index:integer]:PSImage read GetImageById;
      property Count:integer read ImgCount;
      property Empty:boolean read IsEmpty;

      procedure AddImage(ElName:AnsiString; Id:integer; Pos, Size:TPoint; ZOrder:byte; Tile, FlipRotate:byte; ReplColor:TRGBQuad; imgIndex:integer); overload;
      procedure AddImage(Img:PSImage); overload;
      procedure RemoveImage(Index:integer);
      function Clone(Index:integer):boolean;
      procedure Clear;

      constructor Create;
      destructor Destroy; override;
      procedure Free;
  end;

  TSkin = class
    private
      ImgList:TSImageList;
      sAuthor:AnsiString;
      sName:AnsiString;
      sDescription:AnsiString;
      sVersion:AnsiString;

      sMainFont, sFont2, sFont3:TSFont;
      sMainColor, sColor2, sColor3:TGPColor;

    public
      property Images:TSImageList read ImgList;
      property Author:AnsiString read sAuthor write sAuthor;
      property Name:AnsiString read sName write sName;
      property Description:AnsiString read sDescription write sDescription;
      property Version:AnsiString read sVersion write sVersion;

      property MainFont:TSFont read sMainFont write sMainFont;
      property Font2:TSFont read sFont2 write sFont2;
      property Font3:TSFont read sFont3 write sFont3;

      property MainColor:TGPColor read sMainColor write sMainColor;
      property Color2:TGPColor read sColor2 write sColor2;
      property Color3:TGPColor read sColor3 write sColor3;

      function LoadFromFile(FileName:string; ImageList:TGDIImageList):boolean;
      function SaveToFile(FileName:string; ImageList:TGDIImageList):boolean;
      procedure NewSkin;

      constructor Create;
      destructor Destroy; override;
  end;

  function TColorToARGB(Color:Cardinal; Opacity:byte=255):TGPColor;

implementation

function TColorToARGB(Color:Cardinal; Opacity:byte=255):TGPColor;
begin
  Result:=(Opacity shl 24) or (ColorRefToARGB(Color) and $00ffffff);
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

function TSImageList.GetImageById(Id:integer):PSImage;
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

function TSImageList.GetImage(Index:integer):PSImage;
var p:PSImage;
    i:integer;
begin
  Result:=nil;
  if (Index<0)or(Index>=ImgCount) then
    Exit;

  i:=0;
  p:=ImgFirst;
  while p<>nil do
    begin
      if i=Index then
        begin
          Result:=p;
          Break;
        end;
      i:=i+1;
      p:=p.Next;
    end;
end;

procedure TSImageList.AddImage(ElName:AnsiString; Id:integer; Pos, Size:TPoint; ZOrder:byte; Tile, FlipRotate:byte; ReplColor:TRGBQuad; imgIndex:integer);
var p:PSImage;
begin
  New(p);
  p.ElementName:=ElName;
  p.ID:=Id;
  p.Pos:=Pos;
  p.Size:=Size;
  p.ZOrder:=ZOrder;
  p.Tile:=Tile;
  p.FlipRotate:=FlipRotate;
  p.Color:=ReplColor;
  p.ImageIndex:=imgIndex;
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
        Dispose(d);
    end;
  ImgFirst:=nil;
  ImgLast:=nil;
  ImgCount:=0;
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

procedure TSImageList.RemoveImage(Index:integer);
var p:PSImage;
    i:integer;
begin
  if (Index<0)or(Index>=ImgCount) then
    Exit;

  i:=0;
  p:=ImgFirst;
  while p<>nil do
    begin
      if i=Index then
        Break;
      i:=i+1;
      p:=p.Next;
    end;

  if p.Prev<>nil then
    p.Prev.Next:=p.Next
  else
    ImgFirst:=p.Next;
  if p.Next<>nil then
    p.Next.Prev:=p.Prev
  else
    ImgLast:=p.Prev;

  Dispose(p);

  ImgCount:=ImgCount-1;
end;

function TSImageList.Clone(Index:integer):boolean;
var p, d:PSImage;
    i:integer;
begin
  Result:=false;
  if (Index<0)or(Index>=ImgCount) then
    Exit;

  i:=0;
  p:=ImgFirst;
  while p<>nil do
    begin
      if i=Index then
        Break;
      i:=i+1;
      p:=p.Next;
    end;
  if p=nil then
    Exit;

  New(d);
  d^:=p^;

  d.Next:=nil;
  ImgLast.Next:=d;
  d.Prev:=ImgLast;
  ImgLast:=d;

  Result:=true;

  ImgCount:=ImgCount+1;
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
  ImgList.Free;
end;

procedure TSkin.NewSkin;
var p:PSImage;
begin
  ImgList.Clear;
  sAuthor:='';
  sName:='';
  sDescription:='';
  sVersion:='';
  New(p);
  p.ElementName:='Main Background';
  p.ID:=SKIN_MAIN_BASE;
  p.ImageIndex:=-1;
  p.Pos.X:=0;
  p.Pos.Y:=0;
  p.Size.X:=0;
  p.Size.Y:=0;
  p.ZOrder:=0;
  p.Color.rgbBlue:=0;
  p.Color.rgbGreen:=0;
  p.Color.rgbRed:=0;
  p.Color.rgbReserved:=255;
  p.Tile:=SKIN_FLAG_STRETCH;
  p.FlipRotate:=SKIN_FLAG_NORMAL;
  ImgList.AddImage(p);
end;

function TSkin.LoadFromFile(FileName:string; ImageList:TGDIImageList):boolean;

  procedure GetAsIStream(Src:TFileStream; var Str:IStream; Start, Size:int64);
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

var S:TFileStream;
    IStr:IStream;
    i, l:integer;
    str:AnsiString;
    maj, min, flags:byte;
    p:PSImage;
    IndexTable:TableItem;
    sz:Single;
begin
  Result:=false;
  ImgList.Clear;

  try
    S:=nil;
    if not FileExists(FileName)then
      Exit;

    if ImageList<>nil then
      ImageList.FreeAndClear
    else
      ImageList.Create;

    S:=TFileStream.Create(FileName, fmOpenRead);

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
        for i:=0 to l-1 do
          begin
            //Size
            S.Read(IndexTable.Size, SizeOf(Int64));
            //Start
            S.Read(IndexTable.Start, SizeOf(Int64));

            GetAsIStream(S,IStr, IndexTable.Start, IndexTable.Size);
            ImageList.AddImage(TGPBitmap.Create(IStr));
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
            p.ElementName:=ConstTable.Values[p.Id];
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
                p.FlipRotate:=flags and $07;
                S.Read(l, SizeOf(Integer));
                p.ImageIndex:=l;
                p.Color.rgbBlue:=0;
                p.Color.rgbGreen:=0;
                p.Color.rgbRed:=0;
                p.Color.rgbReserved:=0;
              end
            //Not Using Image
            else
              begin
                p.ImageIndex:=-1;
                p.Tile:=0;
                p.FlipRotate:=0;
              end;
            S.Read(p.Color, SizeOf(TRGBQuad));
            ImgList.AddImage(p);
          end;
        S.Free;
        Result:=true;
      end;
  except
    on Exception do
      begin
        if S<>nil then
          S.Free;
        MessageBox(0, 'Error occured while reading skin file!', 'Error!', MB_ICONERROR);
      end;
  end;
end;

function TSkin.SaveToFile(FileName:string; ImageList:TGDIImageList):boolean;
var s, s2:TFileStream;
    str:AnsiString;
    str2:string;
    ff:TGPFontFamily;
    l, i:integer;
    Tbl:array of TableItem;
    b:byte;
    p:PSImage;
    pos:int64;
    sz:single;
    encoderClsid:TGUID;
begin
  s:=TFileStream.Create(FileName, fmCreate);
  Str:='GRPLSKN';
  l:=Length(Str);
  s.Write(Str[1], l);

  //Version
  b:=FILE_VERSION_MAJ;
  s.Write(b, SizeOf(Byte));
  b:=FILE_VERSION_MIN;
  s.Write(b, SizeOf(Byte));

  //Skin Name
  l:=Length(sName);
  S.Write(l, SizeOf(Integer));
  S.Write(sName[1], l);

  //Skin Description
  l:=Length(sDescription);
  S.Write(l, SizeOf(Integer));
  S.Write(sDescription[1], l);

  //Skin Author
  l:=Length(sAuthor);
  S.Write(l, SizeOf(Integer));
  S.Write(sAuthor[1], l);

  //Skin Version
  l:=Length(sVersion);
  S.Write(l, SizeOf(Integer));
  S.Write(sVersion[1], l);

  //Reserved
  l:=0;
  S.Write(l, SizeOf(Integer));
  S.Write(l, SizeOf(Integer));
  S.Write(l, SizeOf(Integer));

  //Fonts & Colors
  if FILE_VERSION_MAJ>=1 then
    begin
      l:=Length(sMainFont.Name);
      S.Write(l, SizeOf(Integer));
      S.Write(sMainFont.Name[1], l*2);
      S.Write(sMainFont.Size, SizeOf(Single));
      S.Write(sMainFont.Style, SizeOf(Integer));

      l:=Length(sFont2.Name);
      S.Write(l, SizeOf(Integer));
      S.Write(sFont2.Name[1], l*2);
      S.Write(sFont2.Size, SizeOf(Single));
      S.Write(sFont2.Style, SizeOf(Integer));

      l:=Length(sFont3.Name);
      S.Write(l, SizeOf(Integer));
      S.Write(sFont3.Name[1], l*2);
      S.Write(sFont3.Size, SizeOf(Single));
      S.Write(sFont3.Style, SizeOf(Integer));

      S.Write(sMainColor, SizeOf(TGPColor));
      S.Write(sColor2, SizeOf(TGPColor));
      S.Write(sColor3, SizeOf(TGPColor));
    end;


  //Images
  l:=ImageList.Count;
  s.Write(l, SizeOf(Integer));//Count
  SetLength(Tbl, l);

  pos:=s.Position;
  l:=0;
  for i:=0 to ImageList.Count-1 do
    begin
      s.Write(l, SizeOf(Integer));
      s.Write(l, SizeOf(Integer));
      s.Write(l, SizeOf(Integer));
      s.Write(l, SizeOf(Integer));
    end;

  //Elements
  l:=Images.Count;
  s.Write(l, SizeOf(Integer));//Count

  p:=Images.First;
  while p<>nil do
    begin
      s.Write(p.ID, SizeOf(Integer));//Id
      s.Write(p.Pos.X, SizeOf(Integer));//X
      s.Write(p.Pos.Y, SizeOf(Integer));//Y
      s.Write(p.Size.X, SizeOf(Integer));//sX
      s.Write(p.Size.Y, SizeOf(Integer));//sY
      s.Write(p.ZOrder, SizeOf(Byte));//ZOrder
      l:=p.Tile shl 3 or p.FlipRotate;
      if p.ImageIndex<0 then
        l:=l or SKIN_FLAG_NOIMG;
      s.Write(l, SizeOf(Byte));//flags
      if p.ImageIndex>=0 then
        s.Write(p.ImageIndex, SizeOf(Integer));//img index
      s.Write(p.Color, SizeOf(TRGBQuad));//color
      p:=p.Next;
    end;

  GetEncoderClsid('image/png', encoderClsid);
  for i:=0 to ImageList.Count-1 do
    begin
      Tbl[i].Start:=s.Position;
      ImageList.Images[i].Save(ExtractFilePath(ParamStr(0))+'~$temp.tmp', encoderClsid);
      s2:=TFileStream.Create(ExtractFilePath(ParamStr(0))+'~$temp.tmp', fmOpenRead);
      s.CopyFrom(s2, s2.Size);
      Tbl[i].Size:=s2.Size;
      s2.Free;
    end;

  s.Seek(pos, soFromBeginning);
  for i:=0 to ImageList.Count-1 do
    begin
      s.Write(Tbl[i].Size, SizeOf(Int64));
      s.Write(Tbl[i].Start, SizeOf(Int64));
    end;

  s.Free;
end;


var i:integer;

initialization

ConstTable:=TStringHashTable.Create;
with ConstTable do
begin
  AddItem(SKIN_MAIN_BASE,     'Main Image');
  for i:=1 to SKIN_MAIN_END do
    AddItem(i, 'Main Custom '+IntToStr(i));

  AddItem(SKIN_WND_FILL,      'Window Filling');
  AddItem(SKIN_WND_CORNER_UL, 'Window UL Corner');
  AddItem(SKIN_WND_CORNER_BL, 'Window BL Corner');
  AddItem(SKIN_WND_CORNER_UR, 'Window UR Corner');
  AddItem(SKIN_WND_CORNER_BR, 'Window BR Corner');
  AddItem(SKIN_WND_TOP,       'Window Top Border');
  AddItem(SKIN_WND_BOTTOM,    'Window Bottom Border');
  AddItem(SKIN_WND_LEFT,      'Window Left Border');
  AddItem(SKIN_WND_RIGHT,     'Window Right Border');
  for i:=SKIN_WND_RIGHT+1 to SKIN_WND_END do
    AddItem(i, 'Window Custom '+IntToStr(i-SKIN_WND));


  AddItem(SKIN_SYSBUT_CLOSE,      'Close System Button');
  AddItem(SKIN_SYSBUT_MINIMIZE,   'Minimize System Button');
  AddItem(SKIN_SYSBUT_BIND,       'Bind System Button');
  AddItem(SKIN_SYSBUT_SYSMENU,    'Menu System Button');
  AddItem(SKIN_SYSBUT_SETTINGS ,  'Settings System Button');
  AddItem(SKIN_SYSBUT_UTILS,      'Utils System Button');
  for i:=SKIN_SYSBUT_UTILS+1 to SKIN_SYSBUT_END do
    AddItem(i, 'System Button Custom '+IntToStr(i-SKIN_SYSBUT));

  AddItem(SKIN_SYSBUT_HOVER_CLOSE,      'Close System Button Hovered');
  AddItem(SKIN_SYSBUT_HOVER_MINIMIZE,   'Minimize System Button Hovered');
  AddItem(SKIN_SYSBUT_HOVER_BIND,       'Bind System Button Hovered');
  AddItem(SKIN_SYSBUT_HOVER_SYSMENU,    'Menu System Button Hovered');
  AddItem(SKIN_SYSBUT_HOVER_SETTINGS ,  'Settings System Button Hovered');
  AddItem(SKIN_SYSBUT_HOVER_UTILS,      'Utils System Button Hovered');
  for i:=SKIN_SYSBUT_HOVER_UTILS+1 to SKIN_SYSBUT_HOVER_END do
    AddItem(i, 'System Button Hover Custom '+IntToStr(i-SKIN_SYSBUT_HOVER));

  AddItem(SKIN_SYSBUT_PRESSED_CLOSE,      'Close System Button Pressed');
  AddItem(SKIN_SYSBUT_PRESSED_MINIMIZE,   'Minimize System Button Pressed');
  AddItem(SKIN_SYSBUT_PRESSED_BIND,       'Bind System Button Pressed');
  AddItem(SKIN_SYSBUT_PRESSED_SYSMENU,    'Menu System Button Pressed');
  AddItem(SKIN_SYSBUT_PRESSED_SETTINGS ,  'Settings System Button Pressed');
  AddItem(SKIN_SYSBUT_PRESSED_UTILS,      'Utils System Button Pressed');
  for i:=SKIN_SYSBUT_PRESSED_UTILS+1 to SKIN_SYSBUT_PRESSED_END do
    AddItem(i, 'System Button Pressed Custom '+IntToStr(i-SKIN_SYSBUT_PRESSED));

  AddItem(SKIN_BUTTON_EMPTY,      'Empty Button');
  AddItem(SKIN_BUTTON_PLAY,       'Play Button');
  AddItem(SKIN_BUTTON_PAUSE,      'Pause Button');
  AddItem(SKIN_BUTTON_PLAYPAUSE,  'Play/Pause Button');
  AddItem(SKIN_BUTTON_STOP,       'Stop Button');
  AddItem(SKIN_BUTTON_PREV,       'Prev Button');
  AddItem(SKIN_BUTTON_NEXT,       'Next Button');
  AddItem(SKIN_BUTTON_OPEN,       'Open Button');
  AddItem(SKIN_BUTTON_RANDOM,     'Random Button');
  AddItem(SKIN_BUTTON_REPEAT,     'Repeat Button');
  AddItem(SKIN_BUTTON_MUTE,       'Mute Button');
  AddItem(SKIN_BUTTON_EQON,       'EQ On/Off Button');
  AddItem(SKIN_BUTTON_EQSHOW,     'EQ Show Button');
  AddItem(SKIN_BUTTON_PLSHOW,     'PL Show Button');
  AddItem(SKIN_BUTTON_ADD,        'Add Button');
  AddItem(SKIN_BUTTON_DEL,        'Del Button');
  AddItem(SKIN_BUTTON_NEW,        'New Button');
  AddItem(SKIN_BUTTON_LOAD,       'Load Button');
  AddItem(SKIN_BUTTON_SAVE,       'Save Button');
  for i:=SKIN_BUTTON_SAVE+1 to SKIN_BUTTON_END do
    AddItem(i, 'Button Custom '+IntToStr(i-SKIN_BUTTON));

  AddItem(SKIN_BUTTON_HOVER_EMPTY,      'Empty Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_PLAY,       'Play Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_PAUSE,      'Pause Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_PLAYPAUSE,  'Play/Pause Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_STOP,       'Stop Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_PREV,       'Prev Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_NEXT,       'Next Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_OPEN,       'Open Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_RANDOM,     'Random Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_REPEAT,     'Repeat Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_MUTE,       'Mute Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_EQON,       'EQ On/Off Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_EQSHOW,     'EQ Show Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_PLSHOW,     'PL Show Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_ADD,        'Add Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_DEL,        'Del Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_NEW,        'New Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_LOAD,       'Load Button Hovered');
  AddItem(SKIN_BUTTON_HOVER_SAVE,       'Save Button Hovered');
  for i:=SKIN_BUTTON_HOVER_SAVE+1 to SKIN_BUTTON_HOVER_END do
    AddItem(i, 'System Button Hover Custom '+IntToStr(i-SKIN_BUTTON_HOVER));

  AddItem(SKIN_BUTTON_PRESSED_EMPTY,      'Empty Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_PLAY,       'Play Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_PAUSE,      'Pause Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_PLAYPAUSE,  'Play/Pause Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_STOP,       'Stop Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_PREV,       'Prev Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_NEXT,       'Next Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_OPEN,       'Open Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_RANDOM,     'Random Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_REPEAT,     'Repeat Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_MUTE,       'Mute Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_EQON,       'EQ On/Off Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_EQSHOW,     'EQ Show Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_PLSHOW,     'PL Show Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_ADD,        'Add Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_DEL,        'Del Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_NEW,        'New Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_LOAD,       'Load Button Pressed');
  AddItem(SKIN_BUTTON_PRESSED_SAVE,       'Save Button Pressed');
  for i:=SKIN_BUTTON_PRESSED_SAVE+1 to SKIN_BUTTON_PRESSED_END do
    AddItem(i, 'System Button Pressed Custom '+IntToStr(i-SKIN_BUTTON_PRESSED));

  AddItem(SKIN_TGLBUT_EMPTY,     'Empty Toggle Button');
  AddItem(SKIN_TGLBUT_RANDOM,    'Random Toggle Button');
  AddItem(SKIN_TGLBUT_REPEAT,    'Repeat Toggle Button');
  AddItem(SKIN_TGLBUT_MUTE,      'Mute Toggle Button');
  AddItem(SKIN_TGLBUT_EQON,      'EQ On/Off Toggle Button');
  for i:=SKIN_TGLBUT_EQON+1 to SKIN_TGLBUT_END do
    AddItem(i, 'Toggle Button Custom '+IntToStr(i-SKIN_TGLBUT));

  AddItem(SKIN_TGLBUT_HOVER_EMPTY,     'Empty Toggle Button Hovered');
  AddItem(SKIN_TGLBUT_HOVER_RANDOM,    'Random Toggle Button Hovered');
  AddItem(SKIN_TGLBUT_HOVER_REPEAT,    'Repeat Toggle Button Hovered');
  AddItem(SKIN_TGLBUT_HOVER_MUTE,      'Mute Toggle Button Hovered');
  AddItem(SKIN_TGLBUT_HOVER_EQON,      'EQ On/Off Toggle Button Hovered');
  for i:=SKIN_TGLBUT_HOVER_EQON+1 to SKIN_TGLBUT_HOVER_END do
    AddItem(i, 'Toggle Button Hovered Custom '+IntToStr(i-SKIN_TGLBUT_HOVER));

  AddItem(SKIN_TGLBUT_PRESSED_EMPTY,     'Empty Toggle Button Pressed');
  AddItem(SKIN_TGLBUT_PRESSED_RANDOM,    'Random Toggle Button Pressed');
  AddItem(SKIN_TGLBUT_PRESSED_REPEAT,    'Repeat Toggle Button Pressed');
  AddItem(SKIN_TGLBUT_PRESSED_MUTE,      'Mute Toggle Button Pressed');
  AddItem(SKIN_TGLBUT_PRESSED_EQON,      'EQ On/Off Toggle Button Pressed');
  for i:=SKIN_TGLBUT_PRESSED_EQON+1 to SKIN_TGLBUT_PRESSED_END do
    AddItem(i, 'Toggle Button Pressed Custom '+IntToStr(i-SKIN_TGLBUT_PRESSED));

  AddItem(SKIN_TGLBUT_TOGGLED_EMPTY,     'Empty Toggle Button Toggled');
  AddItem(SKIN_TGLBUT_TOGGLED_RANDOM,    'Random Toggle Button Toggled');
  AddItem(SKIN_TGLBUT_TOGGLED_REPEAT,    'Repeat Toggle Button Toggled');
  AddItem(SKIN_TGLBUT_TOGGLED_MUTE,      'Mute Toggle Button Toggled');
  AddItem(SKIN_TGLBUT_TOGGLED_EQON,      'EQ On/Off Toggle Button Toggled');
  for i:=SKIN_TGLBUT_TOGGLED_EQON+1 to SKIN_TGLBUT_TOGGLED_END do
    AddItem(i, 'Toggle Button Toggled Custom '+IntToStr(i-SKIN_TGLBUT_TOGGLED));

  AddItem(SKIN_TGLBUT_TOGGLED_HOVER_EMPTY,     'Empty Toggle Button Toggled Hovered');
  AddItem(SKIN_TGLBUT_TOGGLED_HOVER_RANDOM,    'Random Toggle Button Toggled Hovered');
  AddItem(SKIN_TGLBUT_TOGGLED_HOVER_REPEAT,    'Repeat Toggle Button Toggled Hovered');
  AddItem(SKIN_TGLBUT_TOGGLED_HOVER_MUTE,      'Mute Toggle Button Toggled Hovered');
  AddItem(SKIN_TGLBUT_TOGGLED_HOVER_EQON,      'EQ On/Off Toggle Button Toggled Hovered');
  for i:=SKIN_TGLBUT_TOGGLED_HOVER_EQON+1 to SKIN_TGLBUT_TOGGLED_HOVER_END do
    AddItem(i, 'Toggle Button Toggled Hovered Custom '+IntToStr(i-SKIN_TGLBUT_TOGGLED_HOVER));

  AddItem(SKIN_TGLBUT_TOGGLED_PRESSED_EMPTY,     'Empty Toggle Button Toggled Pressed');
  AddItem(SKIN_TGLBUT_TOGGLED_PRESSED_RANDOM,    'Random Toggle Button Toggled Pressed');
  AddItem(SKIN_TGLBUT_TOGGLED_PRESSED_REPEAT,    'Repeat Toggle Button Toggled Pressed');
  AddItem(SKIN_TGLBUT_TOGGLED_PRESSED_MUTE,      'Mute Toggle Button Toggled Pressed');
  AddItem(SKIN_TGLBUT_TOGGLED_PRESSED_EQON,      'EQ On/Off Toggle Button Toggled Pressed');
  for i:=SKIN_TGLBUT_TOGGLED_PRESSED_EQON+1 to SKIN_TGLBUT_TOGGLED_PRESSED_END do
    AddItem(i, 'Toggle Button Toggled Pressed Custom '+IntToStr(i-SKIN_TGLBUT_TOGGLED_PRESSED));

  AddItem(SKIN_STATIC_FILEINFO,     'File Info Static');
  AddItem(SKIN_STATIC_TIME,         'Time Static');
  AddItem(SKIN_STATIC_VIS,          'Visualization Static');
  AddItem(SKIN_STATIC_SPECTRUM,     'Spectrum Static');
  AddItem(SKIN_STATIC_LRLEVELS,     'LR Levels Static');
  AddItem(SKIN_STATIC_ADDINFO,      'Additional Info Static');
  for i:=SKIN_STATIC_ADDINFO+1 to SKIN_STATIC_END do
    AddItem(i, 'Static Custom '+IntToStr(i-SKIN_STATIC));

  AddItem(SKIN_TRACKBAR_POS,     'Position Trackbar');
  AddItem(SKIN_TRACKBAR_VOL,     'Volume Trackbar');
  AddItem(SKIN_TRACKBAR_BALANCE, 'Balance Trackbar');
  for i:=SKIN_TRACKBAR_BALANCE+1 to SKIN_TRACKBAR_END do
    AddItem(i, 'Trackbar Custom '+IntToStr(i-SKIN_TRACKBAR));

  AddItem(SKIN_TRACKBAR_LSIDE_POS,     'Position Trackbar LSide');
  AddItem(SKIN_TRACKBAR_LSIDE_VOL,     'Volume Trackbar LSide');
  AddItem(SKIN_TRACKBAR_LSIDE_BALANCE, 'Balance Trackbar LSide');
  for i:=SKIN_TRACKBAR_LSIDE_BALANCE+1 to SKIN_TRACKBAR_LSIDE_END do
    AddItem(i, 'Trackbar Custom LSide '+IntToStr(i-SKIN_TRACKBAR_LSIDE));

  AddItem(SKIN_TRACKBAR_RSIDE_POS,     'Position Trackbar RSide');
  AddItem(SKIN_TRACKBAR_RSIDE_VOL,     'Volume Trackbar RSide');
  AddItem(SKIN_TRACKBAR_RSIDE_BALANCE, 'Balance Trackbar RSide');
  for i:=SKIN_TRACKBAR_RSIDE_BALANCE+1 to SKIN_TRACKBAR_RSIDE_END do
    AddItem(i, 'Trackbar Custom RSide '+IntToStr(i-SKIN_TRACKBAR_RSIDE));

  AddItem(SKIN_MENUITEM_BG,         'Menu Item Background');
  AddItem(SKIN_MENUITEM_NORMAL,     'Menu Item Normal');
  AddItem(SKIN_MENUITEM_HOVER,      'Menu Item Hover');
  AddItem(SKIN_MENUITEM_CHECK,      'Menu Item Check');
  AddItem(SKIN_MENUITEM_SEPERATOR,  'Menu Item Separator');
  for i:=SKIN_MENUITEM_SEPERATOR+1 to SKIN_MENUITEM_END do
    AddItem(i, 'Menu Item Custom '+IntToStr(i-SKIN_MENUITEM));

end;

finalization

  ConstTable.Free;

end.
