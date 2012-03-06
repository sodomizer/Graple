unit GDIImageList;

interface

uses GDIPAPI, GDIPOBJ;

type

  PGDImage = ^TGDImage;
  TGDImage = packed record
    Image: TGPBitmap;
    Next: PGDImage;
    Prev: PGDImage;
  end;

  TGDIImageList = class
    private
      ImgCount : integer;
      ImgFirst : PGDImage;
      ImgLast : PGDImage;
      function GetImage(Index:integer):TGPBitmap;
      procedure SetImage(Index:integer; Im:TGPBitmap);
      function GetImgFirst:TGPBitmap;
      function GetImgLast:TGPBitmap;
      function IsEmpty:boolean;
    public
      property First:TGPBitmap read GetImgFirst;
      property Last:TGPBitmap read GetImgLast;
      property Images[Index:integer]:TGPBitmap read GetImage write SetImage;  default;
      property Count:integer read ImgCount;
      property Empty:boolean read IsEmpty;

      procedure AddImage(Img:TGPBitmap); overload;
      procedure RemoveImage(Index:Integer);
      procedure FreeAndRemoveImage(Index:integer);
      procedure Clear;
      procedure FreeAndClear;

      constructor Create;
      destructor Destroy(Free:boolean=true);
      procedure Free;
  end;

implementation

constructor TGDIImageList.Create;
begin
  ImgCount:=0;
  ImgFirst:=nil;
  ImgLast:=nil;
end;

destructor TGDIImageList.Destroy(Free:boolean=true);
begin
  if Free then
    FreeAndClear
  else
    Clear;
  inherited Destroy;
end;

procedure TGDIImageList.Free;
begin
  Destroy;
end;

function TGDIImageList.IsEmpty;
begin
  Result:=ImgCount=0;
end;

function TGDIImageList.GetImage(Index:integer):TGPBitmap;
var p:PGDImage;
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
          Result:=p.Image;
          Break;
        end;
      i:=i+1;
      p:=p.Next;
    end;
end;

procedure TGDIImageList.SetImage(Index:integer; Im:TGPBitmap);
var p:PGDImage;
    i:integer;
begin
  if (Index<0)or(Index>=ImgCount) then
    Exit;

  i:=0;
  p:=ImgFirst;
  while p<>nil do
    begin
      if i=Index then
        begin
          p.Image:=Im;
          Break;
        end;
      i:=i+1;
      p:=p.Next;
    end;
end;

function TGDIImageList.GetImgFirst:TGPBitmap;
begin
  Result:=ImgFirst.Image;
end;

function TGDIImageList.GetImgLast:TGPBitmap;
begin
  Result:=ImgLast.Image;
end;

procedure TGDIImageList.Clear;
var p,d:PGDImage;
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

procedure TGDIImageList.FreeAndClear;
var p,d:PGDImage;
begin
  p:=ImgFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      if d<>nil then
        begin
          d.Image.Free;
          Dispose(d);
        end;
    end;
  ImgFirst:=nil;
  ImgLast:=nil;
  ImgCount:=0;
end;

procedure TGDIImageList.AddImage(Img:TGPBitmap);
var p:PGDImage;
begin
  if Img=nil then
    Exit;

  New(p);
  p.Image:=Img;
  p.Prev:=ImgLast;
  if p.Prev<>nil then
    p.Prev.Next:=p;
  p.Next:=nil;
  ImgLast:=p;
  if ImgFirst=nil then
    ImgFirst:=p;
  ImgCount:=ImgCount+1;
end;

procedure TGDIImageList.RemoveImage(Index:integer);
var p:PGDImage;
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

procedure TGDIImageList.FreeAndRemoveImage(Index:integer);
var p:PGDImage;
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

  p.Image.Free;
  Dispose(p);

  ImgCount:=ImgCount-1;
end;

end.
