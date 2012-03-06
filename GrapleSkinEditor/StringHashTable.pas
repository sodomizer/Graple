unit StringHashTable;

interface

type

  PStringHashItem = ^StringHashItem;
  StringHashItem = record
    Key:integer;
    Value:String;
    Next:PStringHashItem;
  end;

  TStringHashTable = class
    private
      fFirst:PStringHashItem;
      function GetValue(Id:integer):string;
    public
      property Values[Index:integer]:string read GetValue;
      function AddItem(Key:integer; Value:string):boolean;
      procedure Clear;

      constructor Create;
  end;

implementation

function TStringHashTable.GetValue(Id:integer):string;
var p:PStringHashItem;
begin
  Result:='';
  p:=fFirst;
  while p<>nil do
    begin
      if p.Key=Id then
        begin
          Result:=p.Value;
          Exit;
        end;
      p:=p.Next;
    end;
end;

function TStringHashTable.AddItem(Key:integer; Value:string):boolean;
var p, d:PStringHashItem;
begin
  Result:=false;
  p:=fFirst;
  if p<>nil then
    while p.Next<>nil do
      if p.Key<>Key then
        p:=p.Next
      else
        Exit;
  New(d);
  d.Key:=Key;
  d.Value:=Value;
  d.Next:=nil;
  if p<>nil then
    p.Next:=d
  else
    fFirst:=d;
  Result:=true;
end;

procedure TStringHashTable.Clear;
var p, d:PStringHashItem;
begin
  p:=fFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      d.Value:='';
      Dispose(d);
    end;
  fFirst:=nil;
end;

constructor TStringHashTable.Create;
begin
  fFirst:=nil;
end;

end.
