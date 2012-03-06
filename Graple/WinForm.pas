{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Forms Unit                              ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit WinForm;

interface

uses GlobalVars, Windows, Messages, GDIPAPI, GDIPOBJ, Skins, Controls, ButtonProc, BassUnit, BassPl, SysUtils{$IFDEF DEBUG}, DebugUnit{$ENDIF};

const SNAP_VALUE = 20;

type

  TSkinArray = array of WideString;

  TForm = class
    private
      Instance : Cardinal;
      WndClass : Atom;
      ClassName: LPCWSTR;
      wWidth   : integer;
      wHeight  : integer;
      wLeft     : integer;
      wTop      : integer;
      constructor Create(Inst:Cardinal);
      procedure SetX(x:integer);
      procedure SetY(y:integer);
      procedure SetWidth(w:integer);
      procedure SetHeight(h:integer);

      procedure OnMove(lParam:LPARAM);

      function RegClass:boolean; virtual; abstract;
      function CreateWnd:boolean; virtual; abstract;
    public
      Handle   : hWnd;
      property Left : integer read wLeft write SetX;
      property Top : integer read wTop write SetY;
      property Width : integer read wWidth write SetWidth;
      property Height : integer read wHeight write SetHeight;

      procedure Show;
      procedure Hide;
      procedure ClientResize(nWidth, nHeight:integer);
  end;

  TFakeForm = class(TForm)
    private
      hbmp:HBITMAP;
      backdc:HDC;

      procedure OnCreate(hWnd:HWND);
      procedure OnResizing(hWnd:HWND; lParam:LPARAM);

      function RegClass:boolean; override;
      function CreateWnd:boolean; override;
    public

      procedure Show;
      procedure Hide;

      class function CreateForm(Inst:Cardinal):TFakeForm;

      procedure RedrawControls(g:TGPGraphics);
      procedure RedrawSkin;
  end;

  TMainForm = class(TForm)
    private
      ControlList:TControlList;
      SkinList:TSkinArray;

      movecx, movecy:integer;

      Region:HRGN;

      procedure OnCreate(hWnd:HWND);
      procedure OnResizing(hWnd:HWND);

      procedure SearchSkins;

      function RegClass:boolean; override;
      function CreateWnd:boolean; override;
    public

      FakeForm:TFakeForm;

      procedure Show;
      procedure Hide;

      procedure OpenSysMenu;
      procedure ApplySkin(Name:string);
      procedure ApplySettings;

      class function CreateForm(Inst:Cardinal):TMainForm;

      procedure CreateControls;
  end;

implementation

var MForm: TMainForm;
    FForm: TFakeForm;

//------------------------------------------------------------------------------
//---------- TForm -------------------------------------------------------------
//------------------------------------------------------------------------------

constructor TForm.Create(Inst: Cardinal);
begin
  Instance:=Inst;
end;

procedure TForm.Show;
begin
  ShowWindow(Handle, SW_SHOWNORMAL);
end;

procedure TForm.Hide;
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TForm.SetX(x:integer);
begin
  MoveWindow(Handle, x, wTop, wWidth, wHeight, true);
end;

procedure TForm.SetY(y:integer);
begin
  MoveWindow(Handle, wLeft, y, wWidth, wHeight, true);
end;

procedure TForm.SetWidth(w:integer);
begin
  if w>=0 then
    begin
      MoveWindow(Handle, wLeft, wTop, w, wHeight, true);
      wWidth:=w;
    end;
end;

procedure TForm.SetHeight(h:integer);
begin
  if h>=0 then
    begin
      MoveWindow(Handle, wLeft, wTop, wWidth, h, true);
      wHeight:=h;
    end;
end;

procedure TForm.ClientResize(nWidth, nHeight:integer);
var rcClient, rcWindow:TRect;
    ptDiff:TPoint;
begin
  GetClientRect(Handle, rcClient);
  GetWindowRect(Handle, rcWindow);
  ptDiff.x := (rcWindow.right - rcWindow.left) - rcClient.right;
  ptDiff.y := (rcWindow.bottom - rcWindow.top) - rcClient.bottom;
  MoveWindow(Handle,rcWindow.left, rcWindow.top, nWidth + ptDiff.x, nHeight + ptDiff.y, true);
end;

procedure TForm.OnMove(lParam:LPARAM);
begin
  wLeft:=LoWord(lParam);
  wTop:=HiWord(lParam);
  MoveWindow(Handle, wLeft, wTop, wWidth, wHeight, false);
end;

//------------------------------------------------------------------------------
//---------- TFakeForm ---------------------------------------------------------
//------------------------------------------------------------------------------

function WndProc_FakeForm(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
var
  wp : PWINDOWPOS;
begin
  Result:=0;
  case msg of
    WM_CREATE: FForm.OnCreate(hWnd);
    //WM_MOVE:  FForm.OnMove(lParam);
    //WM_SIZING: FForm.OnResizing(hWnd, lParam);
    WM_SIZE:
      begin
        if wParam=SIZE_MINIMIZED then
          begin
            Result:=DefWindowProc(hWnd, msg, wParam, lParam);
            Exit;
          end;
        FForm.wWidth:=LoWord(lParam);
        FForm.wHeight:=HiWord(lParam);
        FForm.RedrawSkin;
      end;
    WM_WINDOWPOSCHANGED:
      begin
        wp:=Pointer(lParam);
        if (wp.flags and SWP_NOMOVE)<>SWP_NOMOVE then
          begin
            FForm.wLeft:=wp.x;
            FForm.wTop:=wp.y;
          end;
        if (wp.flags and SWP_NOSIZE)<>SWP_NOSIZE then
          begin
            FForm.wWidth:=wp.cx;
            FForm.wHeight:=wp.cy;
          end;
        MoveWindow(FForm.Handle, FForm.wLeft, FForm.wTop, FForm.wWidth, FForm.wHeight, true);
        if (wp.flags and SWP_NOSIZE)<>SWP_NOSIZE then
          FForm.RedrawSkin;
      end;
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;


procedure TFakeForm.OnCreate(hWnd:HWND);
begin
  Handle:=hWnd;
  SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) and not (WS_CAPTION or WS_MAXIMIZEBOX));
  SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TRANSPARENT or WS_EX_NOACTIVATE);
  MoveWindow(Handle, MForm.wLeft, MForm.wTop, MForm.wWidth, MForm.wHeight, false);
  RedrawSkin;
end;

procedure TFakeForm.RedrawControls(g:TGPGraphics);
var p:PControlItem;
begin
  p:=MForm.ControlList.fFirst;
  while p<>nil do
    begin
      if p.Control.DrawProcedure<>nil then
        p.Control.CustomDraw(g)
      else
        if (p.Control is TToggleButton)and (p.Control as TToggleButton).Toggled then
          if p.Control.Pressed then
            if (Skin.Images[p.Control.ControlId+500]<>nil) then
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId+500)
            else
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId)
          else
            if p.Control.Hovered and (Skin.Images[p.Control.ControlId+400]<>nil) then
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId+400)
            else
              if (Skin.Images[p.Control.ControlId+300]<>nil) then
                Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId+300)
              else
                Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId)
        else
          if p.Control.Pressed then
            if (Skin.Images[p.Control.ControlId+200]<>nil) then
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId+200)
            else
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId)
          else
            if p.Control.Hovered and (Skin.Images[p.Control.ControlId+100]<>nil) then
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId+100)
            else
              Skin.SkinControl(g, p.Control.Handle, p.Control.ControlId);
      p:=p.Next;
    end;
end;

procedure TFakeForm.RedrawSkin;
var img: TGPBitmap;
    screendc: HDC;
    pt1, pt2 : TPoint;
    sz : TSize;
    bf : TBlendFunction;
    g:TGPGraphics;
begin
  img:=Skin.SkinMainForm(FForm.Handle);
  g:=TGPGraphics.Create(img);
  RedrawControls(g);
  g.Free;
  if (backdc<>0) then
    DeleteDC(backdc);
  if (hbmp<>0) then
    DeleteObject( hbmp );
  img.GetHBITMAP(0, hbmp);
  img.Free;
  screendc := GetDC(0);
  backdc := CreateCompatibleDC(screendc);
  SelectObject(backdc, hbmp);


  pt1.X:=MForm.Left;
  pt1.Y:=MForm.Top;
  pt2.X:=0;
  pt2.Y:=0;
  sz.cx := MForm.Width;
  sz.cy := MForm.Height;
  with bf do begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := $FF;
    AlphaFormat := AC_SRC_ALPHA;
  end;
  UpdateLayeredWindow(FForm.Handle, screendc, @pt1, @sz, backdc, @pt2,0, @bf,ULW_ALPHA);
  ReleaseDC(0,screendc);
  DeleteDC(screendc);
end;

function TFakeForm.RegClass:boolean;
var wcWindowClass: TWndClassEx;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, ' Registering main form class...');
  {$ENDIF}
  wcWindowClass.lpfnWndProc := @WndProc_FakeForm;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleFakeMain';
	wcWindowClass.hCursor := LoadCursor(0, IDC_ARROW);
	wcWindowClass.hIcon := LoadIcon(hInstance, 'icon');
  wcWindowClass.hIconSm := LoadIcon(hInstance, 'icon');
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.cbSize:=sizeof(wcWindowClass);

  ClassName:='GrapleFakeMain';
  WndClass:=RegisterClassEx(wcWindowClass);
  Result:=WndClass<>0;
end;

function TFakeForm.CreateWnd:boolean;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, '  Creating fake form window...');
  {$ENDIF}
  Handle:=CreateWindowEx(WS_EX_TOPMOST, ClassName, 'Graple', WS_OVERLAPPED, 0, 0, 0, 0, 0, 0, Instance, nil);
  Result := Handle<>0;
end;

class function TFakeForm.CreateForm(Inst:Cardinal):TFakeForm;
var F:TFakeForm;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Creating fake form...');
  {$ENDIF}
  Result:=nil;
  F:=TFakeForm.Create(Inst);
  FForm:=F;
  if not F.RegClass then
    F.Free
  else
    if not F.CreateWnd then
    {$IFDEF DEBUG}
      begin
        WriteLn(LogFile, '>> Error! Couldn''t create fake form!');
    {$ENDIF}
        F.Free
    {$IFDEF DEBUG}
      end
    {$ENDIF}
    else
        Result:=F;
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Fake form was created'#13#10);
  {$ENDIF}
end;

procedure TFakeForm.Show;
begin
  ShowWindow(Handle, SW_SHOWNORMAL);
end;

procedure TFakeForm.Hide;
begin
  ShowWindow(Handle, SW_HIDE);
end;

procedure TFakeForm.OnResizing(hWnd:HWND; lParam:LPARAM);
var Rct:PRect;
begin
  DWORD(Rct):=DWORD(lParam);
  FForm.SetWidth(Rct^.Right-Rct^.Left);
  FForm.SetHeight(Rct^.Bottom-Rct^.Top);
  RedrawSkin;
end;


//------------------------------------------------------------------------------
//---------- TMainForm ---------------------------------------------------------
//------------------------------------------------------------------------------


procedure TMainForm.CreateControls;
  function GetXPos(X:integer):integer;
  begin
    if X>=0 then
      Result:=X
    else
      Result:=wWidth+X;
  end;
  function GetYPos(Y:integer):integer;
  begin
    if Y>=0 then
      Result:=Y
    else
      Result:=wHeight+Y;
  end;
  function GetXSize(sX, X:integer):integer;
  begin
    if sX>=0 then
      Result:=sX
    else
      Result:=wWidth+sX-X;
  end;
  function GetYSize(sY, Y:integer):integer;
  begin
    if sY>=0 then
      Result:=sY
    else
      Result:=wHeight+sY-Y;
  end;
  procedure AddButton(ID, SKIN_ID:integer; Proc:TWndProc);
  var B:TControl;
      p:PSImage;
  begin
    B:=TButton.Create(Handle, ID, Proc);
    p:=Skin.Images[SKIN_ID];
    if p<>nil then
      begin
        B.Left:=GetXPos(p.Pos.X);
        B.Top:=GetYPos(p.Pos.Y);
        B.Width:=GetXSize(p.Size.X, B.Left);
        B.Height:=GetYSize(p.Size.Y, B.Top);
      end
    else
      begin
        B.Left:=0;
        B.Top:=0;
        B.Width:=0;
        B.Height:=0;
      end;
    ControlList.AddControl(B, Handle);
  end;
  procedure AddStatic(ID, SKIN_ID:integer; Proc:TWndProc; DrawProc:TDrawProc; Clickable:boolean=false);
  var B:TControl;
      p:PSImage;
  begin
    B:=TStatic.Create(Handle, ID, Proc, DrawProc, Clickable);
    p:=Skin.Images[SKIN_ID];
    if p<>nil then
      begin
        B.Left:=GetXPos(p.Pos.X);
        B.Top:=GetYPos(p.Pos.Y);
        B.Width:=GetXSize(p.Size.X, B.Left);
        B.Height:=GetYSize(p.Size.Y, B.Top);
      end
    else
      begin
        B.Left:=0;
        B.Top:=0;
        B.Width:=0;
        B.Height:=0;
      end;
    ControlList.AddControl(B, Handle);
  end;
  procedure AddTrackBar(ID, SKIN_ID:integer; Proc:TWndProc; DrawProc:TDrawProc; Min, Max:integer);
  var B:TControl;
      p:PSImage;
  begin
    B:=TTrackBar.Create(Handle, ID, Proc, Min, Max, DrawProc);
    p:=Skin.Images[SKIN_ID];
    if p<>nil then
      begin
        B.Left:=GetXPos(p.Pos.X);
        B.Top:=GetYPos(p.Pos.Y);
        B.Width:=GetXSize(p.Size.X, B.Left);
        B.Height:=GetYSize(p.Size.Y, B.Top);
      end
    else
      begin
        B.Left:=0;
        B.Top:=0;
        B.Width:=0;
        B.Height:=0;
      end;
    ControlList.AddControl(B, Handle);
  end;
  procedure AddToggleButton(ID, SKIN_ID:integer; Proc:TWndProc);
  var B:TControl;
      p:PSImage;
  begin
    B:=TToggleButton.Create(Handle, ID, Proc);
    p:=Skin.Images[SKIN_ID];
    if p<>nil then
      begin
        B.Left:=GetXPos(p.Pos.X);
        B.Top:=GetYPos(p.Pos.Y);
        B.Width:=GetXSize(p.Size.X, B.Left);
        B.Height:=GetYSize(p.Size.Y, B.Top);
      end
    else
      begin
        B.Left:=0;
        B.Top:=0;
        B.Width:=0;
        B.Height:=0;
      end;
    ControlList.AddControl(B, Handle);
  end;
begin
  if ControlList=nil then
    ControlList:=TControlList.Create;
  BProc_Controls:=ControlList;

  AddButton(ID_SYSBUT_CLOSE, SKIN_SYSBUT_CLOSE, CloseButtonWndProc);
  AddButton(ID_SYSBUT_MINIMIZE, SKIN_SYSBUT_MINIMIZE, MinimizeButtonWndProc);
  AddButton(ID_SYSBUT_SYSMENU, SKIN_SYSBUT_SYSMENU, SysMenuButtonWndProc);
  AddButton(ID_BUTTON_PLAYPAUSE, SKIN_BUTTON_PLAYPAUSE, PlayPauseButtonWndProc);
  AddButton(ID_BUTTON_STOP, SKIN_BUTTON_STOP, StopButtonWndProc);
  AddButton(ID_BUTTON_OPEN, SKIN_BUTTON_OPEN, OpenButtonWndProc);

  AddStatic(ID_STATIC_TIME, SKIN_STATIC_TIME, StaticTimeWndProc, StaticTimeDrawProc, true);
  AddStatic(ID_STATIC_FILEINFO, SKIN_STATIC_FILEINFO, StaticInfoWndProc, StaticInfoDrawProc, true);
  AddStatic(ID_STATIC_ADDINFO, SKIN_STATIC_ADDINFO, nil, StaticAddInfoDrawProc);

  AddTrackBar(ID_TRACKBAR_POS, SKIN_TRACKBAR_POS, TrackBarPosWndProc, TrackBarPosDrawProc, 0, 10000);
  AddTrackBar(ID_TRACKBAR_VOL, SKIN_TRACKBAR_VOL, TrackBarVolWndProc, TrackBarVolDrawProc, 0, 100);

  AddToggleButton(ID_TGLBUT_MUTE, ID_TGLBUT_MUTE, MuteButtonWndProc);
end;

procedure TMainForm.OnCreate(hWnd:HWND);
begin
  Handle:=hWnd;
  SetWindowLong(hWnd, GWL_STYLE, GetWindowLong(hWnd, GWL_STYLE) and not (WS_BORDER or WS_MAXIMIZE or WS_CAPTION or WS_MAXIMIZEBOX) or WS_MINIMIZEBOX);
  SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(hWnd, 0, 1, LWA_ALPHA);
  ApplySkin(Skin.FileName);
  CreateControls;
  Initialize(hWnd);
  ApplySettings;
  if ParamStr(1)<>'' then
    OpenFile(ParamStr(1));
end;


function WndProc_MainForm(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
var
  wr : PRECT;
  wp : PWINDOWPOS;
  rct:TRECT;
  cur:TPoint;
begin
  Result:=0;
  case msg of
    WM_CREATE: MForm.OnCreate(hWnd);
    WM_MOVE:  begin
                MForm.OnMove(lParam);
                if FForm<>nil then
                  SendMessage(FForm.Handle, Msg, wParam, lParam);
              end;
    WM_SIZING:  begin
                  MForm.OnResizing(hWnd);
                  if FForm<>nil then
                    SendMessage(FForm.Handle, Msg, wParam, lParam);
                end;
    WM_SIZE:
      begin
        if wParam=SIZE_MINIMIZED then
          begin
            Result:=DefWindowProc(hWnd, msg, wParam, lParam);
            Exit;
          end;
        MForm.wWidth:=LoWord(lParam);
        MForm.wHeight:=HiWord(lParam);
        if FForm<>nil then
          SendMessage(FForm.Handle, Msg, wParam, lParam);
      end;
    WM_ENTERSIZEMOVE:
      begin
        GetWindowRect(MForm.Handle, Rct);
        GetCursorPos(cur);
        MForm.movecx:=cur.x-Rct.left;
        MForm.movecy:=cur.y-Rct.top;
      end;
    WM_MOVING:
      begin
        Result:=1;
        wr:=Pointer(lParam);

        GetCursorPos(cur);
        OffsetRect(wr^, cur.x-(wr.Left+MForm.movecx), cur.y-(wr.Top+MForm.movecy));

        SystemParametersInfo(SPI_GETWORKAREA, 0, Rct, 0);

        if Abs(Rct.Right-(wr.Right))<SNAP_VALUE then
          OffsetRect(wr^, Rct.Right-(wr.Right), 0)
        else
          if Abs(wr.Left)<SNAP_VALUE then
            OffsetRect(wr^, -wr.Left, 0);

          if Abs(Rct.Bottom-(wr.Bottom))<SNAP_VALUE then
            OffsetRect(wr^, 0, Rct.Bottom-(wr.Bottom))
          else
            if Abs(wr.Top)<SNAP_VALUE then
              OffsetRect(wr^, 0, -wr.Top);

          MForm.wLeft:=wr.Left;
          MForm.wTop:=wr.Top;
          Settings.MainForm.X:=wr.Left;
          Settings.MainForm.Y:=wr.Top;
        end;
    WM_WINDOWPOSCHANGED:
      begin
        wp:=Pointer(lParam);
        if (wp.flags and SWP_NOMOVE)=0 then
          begin
            MForm.wLeft:=wp.x;
            MForm.wTop:=wp.y;
            Settings.MainForm.X:=wp.x;
            Settings.MainForm.Y:=wp.y;
          end;
        if (wp.flags and SWP_NOSIZE)=0 then
          begin
            MForm.wWidth:=wp.cx;
            MForm.wHeight:=wp.cy;
          end;
        if FForm<>nil then
          SendMessage(FForm.Handle, Msg, wParam, lParam);
      end;
    WM_OPENSYSMENU:
      begin
        MForm.OpenSysMenu;
      end;
    WM_COMMAND:
      begin
        case LoWord(wParam) of
          MENU_EXIT:  PostQuitMessage(0);
          MENU_MINIMIZE: ShowWindow(hWnd, SW_MINIMIZE);
          MENU_ABOUT: MessageBox(hWnd, 'Graple Audio Player'#13#10'Version 0.2', 'About Graple...', MB_ICONINFORMATION);
        end;
        if (LoWord(wParam)>=MENU_SKINS_SUB)and(LoWord(wParam)<MENU_SKINS_SUB+Length(MForm.SkinList)) then
          MForm.ApplySkin(MForm.SkinList[LoWord(wParam)-MENU_SKINS_SUB]);
      end;
    WM_LBUTTONDOWN:
      begin
        SendMessage(hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
      end;
    WM_REDRAWSKIN:
      if FForm<>nil then
        FForm.RedrawSkin;
    WM_LBUTTONUP:
      if MForm.ControlList<>nil then
        MForm.ControlList.UnPressAll(hWnd);
    WM_PLAYBACK_START:
      begin
        PlayTimerId:=SetTimer(hWnd, 0, 100, nil);
      end;
    WM_PLAYBACK_STOP:
      begin
        KillTimer(PlayTimerId, 0);
      end;
    WM_INFO_UPDATE:
      begin
        case wParam of
          MSG_TYPE_META, MSG_TYPE_TAGS:  FInfo:=String(PAnsiChar(lParam));
        end;
      end;
    WM_TIMER:
      begin
        if FForm<>nil then
          FForm.RedrawSkin;
      end;
    WM_CLOSE:
      begin
        PostQuitMessage(0);
      end;
    WM_DESTROY:
      begin
        Settings.SaveToFile(Path+'config.ini');
      end;
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
  //Setting ZOrder
  if FForm<>nil then
    SetWindowPos(FForm.Handle, MForm.Handle, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
end;

class function TMainForm.CreateForm(Inst:Cardinal):TMainForm;
var M:TMainForm;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Creating main form...');
  {$ENDIF}
  Result:=nil;
  M:=TMainForm.Create(Inst);
  MForm:=M;
  if not M.RegClass then
    M.Free
  else
    if not M.CreateWnd then
    {$IFDEF DEBUG}
      begin
        WriteLn(LogFile, '>> Error! Couldn''t create main form!'#13#10);
    {$ENDIF}
        M.Free
    {$IFDEF DEBUG}
        end
    {$ENDIF}
    else
        Result:=M;
  {$IFDEF DEBUG}
    WriteLn(LogFile, 'Main form was created');
  {$ENDIF}
  M.FakeForm:=TFakeForm.CreateForm(Inst);
end;

function TMainForm.RegClass:boolean;
var wcWindowClass: TWndClassEx;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, ' Registering main form class...');
  {$ENDIF}
  wcWindowClass.lpfnWndProc := @WndProc_MainForm;
	wcWindowClass.style := CS_HREDRAW or CS_VREDRAW;
	wcWindowClass.hInstance := hInstance;
 	wcWindowClass.lpszClassName := 'GrapleMain';
	wcWindowClass.hCursor := LoadCursor(0, IDC_ARROW);
	wcWindowClass.hIcon := LoadIcon(hInstance, 'icon');
  wcWindowClass.hIconSm := LoadIcon(hInstance, 'icon');
	wcWindowClass.hbrBackground := COLOR_APPWORKSPACE;
  wcWindowClass.lpszMenuName:=nil;
  wcWindowClass.cbClsExtra:=0;
  wcWindowClass.cbWndExtra:=0;
  wcWindowClass.cbSize:=sizeof(wcWindowClass);

  ClassName:='GrapleMain';
  WndClass:=RegisterClassEx(wcWindowClass);
  Result:=WndClass<>0;
end;

function TMainForm.CreateWnd:boolean;
begin
  {$IFDEF DEBUG}
    WriteLn(LogFile, '  Creating main form window...');
  {$ENDIF}
  Handle:=CreateWindowEx(WS_EX_TOPMOST, ClassName, 'Graple', WS_OVERLAPPED, 0, 0, 0, 0, 0, 0, Instance, nil);
  Result := Handle<>0;
end;

procedure TMainForm.SearchSkins;
var SR:TSearchRec;
begin
  SetLength(SkinList, 0);
  if FindFirst(Path+'Skins\*.gsk', faAnyFile, SR)=0 then
    repeat
      if (SR.Name<>'.')and(SR.Name<>'..') then
        begin
          SetLength(SkinList, Length(SkinList)+1);
          SkinList[High(SkinList)]:=SR.Name;
        end;
    until FindNext(SR)<>0;
  FindClose(SR);
end;

procedure TMainForm.OpenSysMenu;
var SkinMenu, SysMenu:HMENU;
    Curs: Windows.TPOINT;
    i:integer;
begin
  GetCursorPos(Curs);
  SysMenu:=CreatePopupMenu();
  AppendMenu(SysMenu,MF_STRING, MENU_ABOUT, 'About...');

  SkinMenu:=CreatePopupMenu;
  SearchSkins;
  if Length(SkinList)>0 then
    for i:=0 to High(SkinList) do
      if SkinList[i]=Settings.SkinName then
        AppendMenu(SkinMenu, MF_STRING or MF_CHECKED, MENU_SKINS_SUB+i, @SkinList[i][1])
      else
        AppendMenu(SkinMenu, MF_STRING, MENU_SKINS_SUB+i, @SkinList[i][1])
    else
      AppendMenu(SkinMenu, MF_STRING, MENU_SKINS, 'No skins');

  AppendMenu(SysMenu, MF_STRING or MF_POPUP, SkinMenu, 'Skins');
  AppendMenu(SysMenu, MF_SEPARATOR, 0, Nil);
  AppendMenu(SysMenu, MF_STRING, MENU_MINIMIZE, 'Minimize');
  AppendMenu(SysMenu, MF_STRING, MENU_EXIT, 'Exit');

  TrackPopupMenuEx(SysMenu,TPM_VERTICAL,Curs.x,Curs.y,Handle,nil);
  DestroyMenu(SkinMenu);
  DeleteObject(SysMenu);
end;

procedure TMainForm.ApplySkin(Name:string);
begin
  if Name<>Settings.SkinName then
  if not Skin.LoadFromFile(Name) then
    Halt(1);
  Settings.SkinName:=Name;
  SetWidth(Skin.Images[SKIN_MAIN_BASE].Image.GetWidth);
  SetHeight(Skin.Images[SKIN_MAIN_BASE].Image.GetHeight);
  SetWindowRgn(Handle, 0, false);
  DeleteObject(Region);
  Region:=RegionFromImage(Skin.Images[SKIN_MAIN_BASE].Image);
  SetWindowRgn(Handle, Region, true);
  OnResizing(Handle);
end;

procedure TMainForm.ApplySettings;
var Rct:TRECT;
begin
  //Desktop Center
  //GetWindowRect(GetDesktopWindow, Rct);
  //Screen Center
  Rct.Right:=GetSystemMetrics(SM_CXSCREEN);
  Rct.Bottom:=GetSystemMetrics(SM_CYSCREEN);
  if Settings.MainForm.X<0 then
    Settings.MainForm.X:=(Rct.Right - wWidth) div 2;
  if Settings.MainForm.Y<0 then
    Settings.MainForm.Y:=(Rct.Bottom - wHeight) div 2;
  MoveWindow(Handle, Settings.MainForm.X, Settings.MainForm.Y, wWidth, wHeight, false);
end;

procedure TMainForm.Show;
begin
  ShowWindow(Handle, SW_SHOWNORMAL);
  FForm.Show
end;

procedure TMainForm.Hide;
begin
  ShowWindow(Handle, SW_HIDE);
  FForm.Hide;
end;

procedure TMainForm.OnResizing(hWnd: HWND);
var p:PControlItem;

  function GetXPos(X:integer):integer;
  begin
    if X>=0 then
      Result:=X
    else
      Result:=wWidth+X;
  end;
  function GetYPos(Y:integer):integer;
  begin
    if Y>=0 then
      Result:=Y
    else
      Result:=wHeight+Y;
  end;
  function GetXSize(sX, X:integer):integer;
  begin
    if sX>=0 then
      Result:=sX
    else
      Result:=wWidth+sX-X;
  end;
  function GetYSize(sY, Y:integer):integer;
  begin
    if sY>=0 then
      Result:=sY
    else
      Result:=wHeight+sY-Y;
  end;

begin
  if ControlList=nil then
    Exit;
  p:=ControlList.fFirst;
  while p<>nil do
    if Skin.Images[P.Control.ControlId]<>nil then
      begin
        P.Control.Left:=GetXPos(Skin.Images[P.Control.ControlId].Pos.X);
        P.Control.Top:=GetYPos(Skin.Images[P.Control.ControlId].Pos.Y);
        P.Control.Width:=GetXSize(Skin.Images[P.Control.ControlId].Size.X, P.Control.Left);
        P.Control.Height:=GetYSize(Skin.Images[P.Control.ControlId].Size.Y, P.Control.Top);
        p:=p.Next;
      end
    else
      begin
        P.Control.Left:=0;
        P.Control.Top:=0;
        P.Control.Width:=0;
        P.Control.Height:=0;
        p:=p.Next;
      end;
  FForm.RedrawSkin;
end;

end.
