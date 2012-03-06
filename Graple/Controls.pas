{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Controls Unit                           ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit Controls;

interface

uses Windows, Messages, SysUtils, GDIPAPI, GDIPOBJ;

const

  ID_FIRST            = -1;
  ID_LAST             = -2;

  ID_SYSBUT           = 200;
  ID_SYSBUT_CLOSE     = ID_SYSBUT + 1;
  ID_SYSBUT_MINIMIZE  = ID_SYSBUT + 2;
  ID_SYSBUT_BIND      = ID_SYSBUT + 3;
  ID_SYSBUT_SYSMENU   = ID_SYSBUT + 4;
  ID_SYSBUT_SETTINGS  = ID_SYSBUT + 5;
  ID_SYSBUT_UTILS     = ID_SYSBUT + 6;
  ID_SYSBUT_END       = ID_SYSBUT + 99;

  ID_BUTTON           = ID_SYSBUT + 300;
  ID_BUTTON_EMPTY     = ID_BUTTON + 1;
  ID_BUTTON_PLAY      = ID_BUTTON + 2;
  ID_BUTTON_PAUSE     = ID_BUTTON + 3;
  ID_BUTTON_PLAYPAUSE = ID_BUTTON + 4;
  ID_BUTTON_STOP      = ID_BUTTON + 5;
  ID_BUTTON_PREV      = ID_BUTTON + 6;
  ID_BUTTON_NEXT      = ID_BUTTON + 7;
  ID_BUTTON_OPEN      = ID_BUTTON + 8;
  ID_BUTTON_RANDOM    = ID_BUTTON + 9;
  ID_BUTTON_REPEAT    = ID_BUTTON + 10;
  ID_BUTTON_MUTE      = ID_BUTTON + 11;
  ID_BUTTON_EQON      = ID_BUTTON + 12;
  ID_BUTTON_EQSHOW    = ID_BUTTON + 13;
  ID_BUTTON_PLSHOW    = ID_BUTTON + 14;
  ID_BUTTON_ADD       = ID_BUTTON + 15;
  ID_BUTTON_DEL       = ID_BUTTON + 16;
  ID_BUTTON_NEW       = ID_BUTTON + 17;
  ID_BUTTON_LOAD      = ID_BUTTON + 18;
  ID_BUTTON_SAVE      = ID_BUTTON + 19;
  ID_BUTTON_END       = ID_BUTTON + 99;

  ID_TGLBUT           = ID_BUTTON + 300;
  ID_TGLBUT_EMPTY     = ID_TGLBUT + 1;
  ID_TGLBUT_RANDOM    = ID_TGLBUT + 2;
  ID_TGLBUT_REPEAT    = ID_TGLBUT + 3;
  ID_TGLBUT_MUTE      = ID_TGLBUT + 4;
  ID_TGLBUT_EQON      = ID_TGLBUT + 5;
  ID_TGLBUT_END       = ID_TGLBUT + 99;

  ID_STATIC           = ID_TGLBUT + 600;
  ID_STATIC_FILEINFO  = ID_STATIC + 1;
  ID_STATIC_TIME      = ID_STATIC + 2;
  ID_STATIC_VIS       = ID_STATIC + 3;
  ID_STATIC_SPECTRUM  = ID_STATIC + 4;
  ID_STATIC_LRLEVELS  = ID_STATIC + 5;
  ID_STATIC_ADDINFO   = ID_STATIC + 6;
  ID_STATIC_END       = ID_STATIC + 99;

  ID_TRACKBAR         = ID_STATIC + 100;
  ID_TRACKBAR_POS     = ID_TRACKBAR + 1;
  ID_TRACKBAR_VOL     = ID_TRACKBAR + 2;
  ID_TRACKBAR_BALANCE = ID_TRACKBAR + 3;
  ID_TRACKBAR_END     = ID_TRACKBAR + 99;

  ID_CUSTOM_CONTROL   = ID_SYSBUT + 10000;


  WM_CONTROL          = WM_USER;
  WM_REDRAWSKIN       = WM_USER + 1;
  WM_SETHOVER         = WM_USER + 2;
  WM_SETUNHOVER       = WM_USER + 3;
  WM_SETPRESSED       = WM_USER + 4;
  WM_SETUNPRESSED     = WM_USER + 5;
  WM_CONTROLINIT      = WM_USER + 6;
  WM_OPENSYSMENU      = WM_USER + 7;

  MENU_START          = 1000;
  MENU_EXIT           = MENU_START + 1;
  MENU_MINIMIZE       = MENU_START + 2;
  MENU_ABOUT          = MENU_START + 3;
  MENU_SKINS          = MENU_START + 4;

  MENU_SKINS_SUB      = MENU_START + 100;

type

  TWndProc = function(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
  TDrawProc = procedure(hWnd:HWND; g:TGPGraphics);


  TControl = class
    private
      chWnd:hWnd;
      phWnd:hWnd;
      CtrlId:integer;
      CName:WideString;
      cLeft:integer;
      cTop:integer;
      cWidth:integer;
      cHeight:integer;
      cHovered:boolean;
      cPressed:boolean;
      cWasPressed:boolean;
      cData:integer;
      DrawProc: TDrawProc;
      function  GetDrawProcAddr:Pointer;
      procedure SetLeft(l:integer);
      procedure SetTop(t:integer);
      procedure SetWidth(w:integer);
      procedure SetHeight(h:integer);
      class var WndClass:cardinal;
      class var Customid:integer;
    public
      property ControlId:integer read CtrlId;
      property Handle:hWnd read chWnd;
      property Parent:hWnd read phWnd;
      property Left:integer read cLeft write SetLeft;
      property Top:integer read cTop write SetTop;
      property Width:integer read cWidth write SetWidth;
      property Height:integer read cHeight write SetHeight;
      property Hovered:boolean read cHovered write cHovered;
      property Pressed:boolean read cPressed write cPressed;
      property WasPressed:boolean read cWasPressed write cWasPressed;
      property DrawProcedure:Pointer read GetDrawProcAddr;
      property Data:integer read cData write cData;
      property ClassName:WideString read CName;

      procedure CustomDraw(g:TGPGraphics);

      constructor Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil); virtual; abstract;
      procedure Free;
  end;

  TButton = class(TControl)
    public
      constructor Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil); override;
  end;

  TStatic = class(TControl)
    public
      constructor Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil; Clickable:boolean=false);
  end;

  TTrackBar = class(TControl)
    private
      sMax:Integer;
      sMin:Integer;
      sPosition:Integer;
      stmpPos:Integer;
      procedure SetMax(NewMax:integer);
      procedure SetMin(NewMin:integer);
      procedure SetPos(Pos:integer);
    public
      property Max:Integer read sMax write SetMax;
      property Min:Integer read sMin write SetMin;
      property Position:Integer read sPosition write SetPos;
      property TempPos:Integer read stmpPos write stmpPos;
      constructor Create(Parent:hWnd; Id:integer; WProc:TWndProc; Min, Max:integer; PaintProc:TDrawProc=nil);
  end;

  TToggleButton = class(TControl)
    private
      sToggled:boolean;
    public
      property Toggled:boolean read sToggled write sToggled;
      constructor Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil); override;
  end;

  PControlItem = ^TControlItem;
  TControlItem = record
    Control: TControl;
    Owner: cardinal;
    Next: PControlItem;
    Prev: PControlItem;
  end;

  TControlList = class
      fFirst : PControlItem;
      fLast  : PControlItem;
      fCount : integer;
      pFirst : PControlItem;
      pLast  : PControlItem;
      pCount : integer;

      function GetControl(Id:integer):PControlItem;
      function GetControlByHwnd(Id:integer):TControl;
      function GetPluginControl(Id:integer):PControlItem;
    public
      property First:PControlItem read fFirst;
      property Last:PControlItem read fLast;
      property FirstPl:PControlItem read pFirst;
      property LastPl:PControlItem read pLast;
      property Controls[Index:integer]:PControlItem read GetControl;
      property ControlsByHwnd[Index:integer]:TControl read GetControlByHwnd;
      property PluginControls[Index:integer]:PControlItem read GetPluginControl;
      property Count:integer read fCount;
      property CountPl:integer read pCount;

      procedure UnPressAll(Wnd:HWND);

      procedure AddControl(Ctrl:TControl; Owner:cardinal);
      procedure AddPluginControl(Ctrl:TControl; Owner:cardinal);
      procedure ClearForm;
      procedure ClearPlugin;
      procedure Clear;

      constructor Create;
      destructor Destroy; override;
  end;

implementation

function StdProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
begin
  Result:=DefWindowProc(hWnd, msg, wParam, lParam);
end;

//------------------------------------------------------------------------------
//---------- TControl ----------------------------------------------------------
//------------------------------------------------------------------------------

procedure TControl.Free;
begin
  Destroy;
end;

function TControl.GetDrawProcAddr:Pointer;
begin
  Result:=@DrawProc;
end;

procedure  TControl.SetLeft(l:integer);
begin
  cLeft:=l;
  MoveWindow(chWnd, l, cTop, cWidth, cHeight, false);
end;

procedure  TControl.SetTop(t:integer);
begin
  cTop:=t;
  MoveWindow(chWnd, cLeft, t, cWidth, cHeight, false);
end;

procedure  TControl.SetWidth(w:integer);
begin
  cWidth:=w;
  MoveWindow(chWnd, cLeft, cTop, w, cHeight, true);
end;

procedure  TControl.SetHeight(h:integer);
begin
  cHeight:=h;
  MoveWindow(chWnd, cLeft, cTop, cWidth, h, true);
end;

procedure TControl.CustomDraw(g:TGPGraphics);
begin
  if @DrawProc<>nil then
    DrawProc(Handle, g);
end;

//------------------------------------------------------------------------------
//---------- TButton -----------------------------------------------------------
//------------------------------------------------------------------------------

constructor TButton.Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil);
var wcWindowClass: TWndClassEx;
begin
  wcWindowClass.lpfnWndProc := @StdProc;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleBtn';
	wcWindowClass.hCursor := LoadCursor(0, IDC_HAND);
	wcWindowClass.hIcon := 0;
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.hIconSm:=0;
  wcWindowClass.cbSize:=SizeOf(wcWindowClass);

  CName:='GrapleBtn';
  WndClass:=RegisterClassEx(wcWindowClass);

  if Id<>ID_CUSTOM_CONTROL then
    begin
      CtrlId:=Id;
      chWnd := CreateWindowEx(0, 'GrapleBtn', nil, WS_CHILD or WS_VISIBLE{ or BS_PUSHBUTTON}, 0, 0, 0, 0, Parent, Id, hInstance, nil);
    end
  else
    begin
      TControl.CustomId:=TControl.CustomId+1;
      CtrlId:=TControl.CustomId;
      chWnd := CreateWindowEx(0, 'GrapleBtn', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, TControl.CustomId, hInstance, nil);
    end;
  if @WProc<>nil then
    SetWindowLong(chWnd, GWL_WNDPROC, LParam(@WProc));
  DrawProc:=PaintProc;
  phWnd:=Parent;
end;

//------------------------------------------------------------------------------
//---------- TStatic -----------------------------------------------------------
//------------------------------------------------------------------------------

constructor TStatic.Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil; Clickable:boolean=false);
var wcWindowClass: TWndClassEx;
    c:cardinal;
begin
  wcWindowClass.lpfnWndProc := @StdProc;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleStatic';
  wcWindowClass.hCursor := LoadCursor(0, IDC_ARROW);
	wcWindowClass.hIcon := 0;
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.hIconSm:=0;
  wcWindowClass.cbSize:=SizeOf(wcWindowClass);

  CName:='GrapleStatic';
  WndClass:=RegisterClassEx(wcWindowClass);

  if not Clickable then
    c:=WS_EX_TRANSPARENT
  else
    c:=0;

  if Id<>ID_CUSTOM_CONTROL then
    begin
      CtrlId:=Id;
      chWnd := CreateWindowEx(c, 'GrapleStatic', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, Id, hInstance, nil);
    end
  else
    begin
      TControl.CustomId:=TControl.CustomId+1;
      CtrlId:=TControl.CustomId;
      chWnd := CreateWindowEx(c, 'GrapleStatic', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, TControl.CustomId, hInstance, nil);
    end;
  if @WProc<>nil then
    SetWindowLong(chWnd, GWL_WNDPROC, LParam(@WProc));
  DrawProc:=PaintProc;
  phWnd:=Parent;
end;


//------------------------------------------------------------------------------
//---------- TTrackBar ---------------------------------------------------------
//------------------------------------------------------------------------------

constructor TTrackBar.Create(Parent:hWnd; Id:integer; WProc:TWndProc; Min, Max:integer; PaintProc:TDrawProc=nil);
var wcWindowClass: TWndClassEx;
begin
  wcWindowClass.lpfnWndProc := @StdProc;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleTrackbar';
	wcWindowClass.hCursor := LoadCursor(0, IDC_HAND);
	wcWindowClass.hIcon := 0;
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.hIconSm:=0;
  wcWindowClass.cbSize:=SizeOf(wcWindowClass);

  CName:='GrapleTrackbar';
  WndClass:=RegisterClassEx(wcWindowClass);

  if Id<>ID_CUSTOM_CONTROL then
    begin
      CtrlId:=Id;
      chWnd := CreateWindowEx(0, 'GrapleTrackbar', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, Id, hInstance, nil);
    end
  else
    begin
      TControl.CustomId:=TControl.CustomId+1;
      CtrlId:=TControl.CustomId;
      chWnd := CreateWindowEx(0, 'GrapleTrackbar', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, TControl.CustomId, hInstance, nil);
    end;
  if @WProc<>nil then
    SetWindowLong(chWnd, GWL_WNDPROC, LParam(@WProc));
  DrawProc:=PaintProc;
  sMin:=Min;
  sMax:=Max;
  sPosition:=sMin;
  phWnd:=Parent;
end;

procedure TTrackBar.SetMax(NewMax:integer);
begin
  sMax:=NewMax;
  if sPosition>sMax then
    sPosition:=sMax;
  SendMessage(phWnd, WM_REDRAWSKIN, 0, 0);
end;

procedure TTrackBar.SetMin(NewMin:integer);
begin
  sMin:=NewMin;
  if sPosition<sMin then
    sPosition:=sMin;
  SendMessage(phWnd, WM_REDRAWSKIN, 0, 0);
end;

procedure TTrackBar.SetPos(Pos:integer);
begin
  if Pos<sMin then
    sPosition:=sMin
  else
    if Pos>sMax then
      sPosition:=sMax
    else
      sPosition:=Pos;
  SendMessage(phWnd, WM_REDRAWSKIN, 0, 0);
end;


//------------------------------------------------------------------------------
//---------- TToggleButton -----------------------------------------------------
//------------------------------------------------------------------------------

constructor TToggleButton.Create(Parent:hWnd; Id:integer; WProc:TWndProc; PaintProc:TDrawProc=nil);
var wcWindowClass: TWndClassEx;
begin
  wcWindowClass.lpfnWndProc := @StdProc;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleTglBtn';
	wcWindowClass.hCursor := LoadCursor(0, IDC_HAND);
	wcWindowClass.hIcon := 0;
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.hIconSm:=0;
  wcWindowClass.cbSize:=SizeOf(wcWindowClass);

  CName:='GrapleTglBtn';
  WndClass:=RegisterClassEx(wcWindowClass);

  if Id<>ID_CUSTOM_CONTROL then
    begin
      CtrlId:=Id;
      chWnd := CreateWindowEx(0, 'GrapleTglBtn', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, Id, hInstance, nil);
    end
  else
    begin
      TControl.CustomId:=TControl.CustomId+1;
      CtrlId:=TControl.CustomId;
      chWnd := CreateWindowEx(0, 'GrapleTglBtn', nil, WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, Parent, TControl.CustomId, hInstance, nil);
    end;
  if @WProc<>nil then
    SetWindowLong(chWnd, GWL_WNDPROC, LParam(@WProc));
  DrawProc:=PaintProc;
  phWnd:=Parent;
end;


//------------------------------------------------------------------------------
//---------- TControlList ------------------------------------------------------
//------------------------------------------------------------------------------

constructor TControlList.Create;
begin
  fFirst:=nil;
  fLast:=nil;
  pFirst:=nil;
  pLast:=nil;
end;

destructor TControlList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TControlList.GetControl(Id:integer):PControlItem;
var p:PControlItem;
begin
  if Id=ID_FIRST then
    begin
      Result:=fFirst;
      Exit;
    end
  else
    if Id=ID_LAST then
      begin
        Result:=fLast;
        Exit;
      end
    else
      Result:=nil;
  p:=fFirst;
  while p<>nil do
    begin
      if p.Control.ControlId=Id then
        begin
          Result:=p;
          Break;
        end;
      p:=p.Next;
    end;
end;

function TControlList.GetControlByHwnd(Id:integer):TControl;
var p:PControlItem;
begin
  Result:=nil;
  p:=fFirst;
  while p<>nil do
    begin
      if p.Control.chWnd=Id then
        begin
          Result:=p.Control;
          Break;
        end;
      p:=p.Next;
    end;
end;

function TControlList.GetPluginControl(Id:integer):PControlItem;
var p:PControlItem;
begin
  if Id=ID_FIRST then
    begin
      Result:=pFirst;
      Exit;
    end
  else
    if Id=ID_LAST then
      begin
        Result:=pLast;
        Exit;
      end
    else
      Result:=nil;
  p:=pFirst;
  while p<>nil do
    begin
      if p.Control.ControlId=Id then
        begin
          Result:=p;
          Break;
        end;
      p:=p.Next;
    end;
end;

procedure TControlList.UnPressAll(Wnd:HWND);
var p:PControlItem;
begin
  p:=fFirst;
  while p<>nil do
    begin
      p.Control.WasPressed:=false;
      p.Control.Pressed:=false;
      p:=p.Next;
    end;
  SendMessage(Wnd, WM_REDRAWSKIN, 0, 0);
end;

procedure TControlList.AddControl(Ctrl:TControl; Owner:cardinal);
var p:PControlItem;
begin
  New(p);
  p.Control:=Ctrl;
  p.Owner:=Owner;
  p.Prev:=fLast;
  if p.Prev<>nil then
    p.Prev.Next:=p;
  p.Next:=nil;
  fLast:=p;
  if fFirst=nil then
    fFirst:=p;
  fCount:=fCount+1;
  SendMessage(Ctrl.Handle, WM_CONTROLINIT, 0, 0);
end;

procedure TControlList.AddPluginControl(Ctrl:TControl; Owner:cardinal);
var p:PControlItem;
begin
  New(p);
  p.Control:=Ctrl;
  p.Owner:=Owner;
  p.Prev:=pLast;
  if p.Prev<>nil then
    p.Prev.Next:=p;
  p.Next:=nil;
  pLast:=p;
  if pFirst=nil then
    pFirst:=p;
  pCount:=pCount+1;
end;

procedure TControlList.ClearForm;
var p,d:PControlItem;
begin
  p:=fFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      if d<>nil then
        Dispose(d);
    end;
  fFirst:=nil;
  fLast:=nil;
  fCount:=0;
end;

procedure TControlList.ClearPlugin;
var p,d:PControlItem;
begin
  p:=pFirst;
  while p<>nil do
    begin
      d:=p;
      p:=p.Next;
      if d<>nil then
        Dispose(d);
    end;
  pFirst:=nil;
  pLast:=nil;
  pCount:=0;
end;

procedure TControlList.Clear;
begin
  ClearForm;
  ClearPlugin;
end;

initialization

TControl.Customid := ID_CUSTOM_CONTROL;

end.
