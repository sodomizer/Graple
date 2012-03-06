{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Control WndProc Unit                    ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit ButtonProc;

interface

uses Windows, Messages, Skins, GlobalVars, Controls, BassUnit, BassPl, SysUtils, GDIPAPI, GDIPOBJ;

var BProc_Controls:TControlList;

function CloseButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function MinimizeButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function SysMenuButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function PlayPauseButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function StopButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function OpenButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function StaticTimeWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function StaticInfoWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function TrackBarPosWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function TrackBarVolWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;
function MuteButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT; stdcall;


procedure StaticTimeDrawProc(hWnd:HWND; g:TGPGraphics);
procedure StaticInfoDrawProc(hWnd:HWND; g:TGPGraphics);
procedure StaticAddInfoDrawProc(hWnd:HWND; g:TGPGraphics);
procedure TrackBarPosDrawProc(hWnd:HWND; g:TGPGraphics);
procedure TrackBarVolDrawProc(hWnd:HWND; g:TGPGraphics);

implementation

function CommonProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
var me:tagTRACKMOUSEEVENT;
    pwnd:Cardinal;
begin
  Result:=0;

  pwnd:=GetParent(hWnd);

  case msg of
    WM_LBUTTONDOWN:
      begin
        if BProc_Controls<>nil then
          begin
            BProc_Controls.GetControlByHwnd(hWnd).WasPressed:=true;
            BProc_Controls.GetControlByHwnd(hWnd).Pressed:=true;
            SendMessage(pwnd, WM_REDRAWSKIN, 0, 0);
          end;
      end;
    WM_LBUTTONUP:
      begin
        if BProc_Controls<>nil then
          begin
            BProc_Controls.UnPressAll(pwnd);
            SendMessage(pwnd, WM_REDRAWSKIN, 0, 0);
          end;
      end;
    WM_CONTROLINIT:
      begin
        me.hwndTrack:=hWnd;
        me.dwHoverTime:=0;
        me.cbSize:=SizeOf(tagTRACKMOUSEEVENT);
        me.dwFlags:=TME_HOVER;
        TrackMouseEvent(me);
      end;
    WM_MOUSEMOVE:
      begin
        me.hwndTrack:=hWnd;
        me.dwHoverTime:=10;
        me.cbSize:=SizeOf(tagTRACKMOUSEEVENT);
        me.dwFlags:=TME_LEAVE;
        TrackMouseEvent(me);
        if BProc_Controls<>nil then
          begin
            if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
              begin
                BProc_Controls.GetControlByHwnd(hWnd).Pressed:=true;
                SendMessage(pwnd, WM_REDRAWSKIN, 0, 0);
              end
            else
              if not(BProc_Controls.GetControlByHwnd(hWnd).Hovered) then
                begin
                  BProc_Controls.GetControlByHwnd(hWnd).Hovered:=true;
                  SendMessage(pwnd, WM_REDRAWSKIN, 0, 0);
                end;
          end;
      end;
    WM_MOUSELEAVE:
      begin
        if BProc_Controls<>nil then
          begin
            BProc_Controls.GetControlByHwnd(hWnd).Hovered:=false;
            BProc_Controls.GetControlByHwnd(hWnd).Pressed:=false;
            SendMessage(pwnd, WM_REDRAWSKIN, 0, 0);
          end;
        me.dwFlags:=TME_HOVER;
        TrackMouseEvent(me);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function CloseButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;

  case msg of
    WM_LBUTTONDOWN:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          PostQuitMessage(0);
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_CONTROLINIT, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function MinimizeButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          ShowWindow(GetParent(hWnd), SW_SHOWMINIMIZED);
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function SysMenuButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then;
          SendMessage(GetParent(hWnd), WM_OPENSYSMENU, 0, 0);
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function PlayPauseButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          BP.PauseToggle;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function StopButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          BP.Stop;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

function OpenButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          OpenFile;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;


function StaticTimeWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE, WM_LBUTTONUP:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONDOWN:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).Data=0 then
          BProc_Controls.GetControlByHwnd(hWnd).Data:=1
        else
          BProc_Controls.GetControlByHwnd(hWnd).Data:=0;
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;
procedure StaticTimeDrawProc(hWnd:HWND; g:TGPGraphics);
var txt:string;
    s:TStatic;
    br:TGPBrush;
    sf:TGPStringFormat;
    Font: TGPFont;
    rct:TGPRectF;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TStatic;
  if (BP<>nil) and (BP.PauseState in [psPlaying, psPaused]) and (BP.StreamType<>stNETRADIO) then
    txt:=BP.GetTimeStr(-1, s.Data=1)
  else
    txt:='00:00';

  Font:=TGPFont.Create(Skin.MainFont.Name, s.Height-2, 0, UnitPixel);
  br:=TGPSolidBrush.Create(Skin.MainColor);

  sf:=TGPStringFormat.Create;
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);

  g.MeasureString(txt, -1, Font, MakeRect(s.Left+0.0, s.Top, s.Width, s.Height), sf, rct);
  g.DrawString(txt, -1, Font, MakeRect(s.Left+s.Width-rct.Width, s.Top, s.Width, s.Height), sf, br);

  Font.Free;

  sf.Free;
  br.Free;
end;


{function StaticInfoWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE, WM_LBUTTONUP, WM_LBUTTONDOWN:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;
procedure StaticInfoDrawProc(hWnd:HWND; g:TGPGraphics);
var txt:string;
    s:TStatic;
    br:TGPBrush;
    sf:TGPStringFormat;
    Font: TGPFont;
    rct:TGPRectF;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TStatic;
  if (BP<>nil)and(FInfo<>'') then
    txt:=FInfo
  else
    txt:='Media not loaded';

  Font:=TGPFont.Create(Skin.Font2.Name, s.Height-2, Skin.MainFont.Style, UnitPixel);
  br:=TGPSolidBrush.Create(Skin.Color2);

  sf:=TGPStringFormat.Create;
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);

  g.MeasureString(txt, -1, Font, MakeRect(s.Left+0.0, s.Top, s.Width, s.Height), sf, rct);
  g.DrawString(txt, -1, Font, MakeRect(s.Left, s.Top, rct.Width, rct.Height), sf, br);

  Font.Free;

  sf.Free;
  br.Free;
end;      }

function StaticInfoWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
type
  PTxtData=^TTxtData;
  TTxtData = record
    Pos:integer;
    TmpX:integer;
  end;
var p: PTxtData;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT:
      begin
        New(p);
        p^.Pos:=0;
        p^.TmpX:=0;
        BProc_Controls.GetControlByHwnd(hWnd).Data:=DWORD(p);
        Result:=CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_DESTROY:
      begin
        p:=PTxtData(BProc_Controls.GetControlByHwnd(hWnd).Data);
        Dispose(p);
      end;
    WM_LBUTTONDOWN:
      begin
        BProc_Controls.GetControlByHwnd(hWnd).WasPressed:=true;
        PTxtData(BProc_Controls.GetControlByHwnd(hWnd).Data).TmpX:=LoWord(lParam);
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_MOUSEMOVE:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          begin
            p:=PTxtData(BProc_Controls.GetControlByHwnd(hWnd).Data);
            p.Pos:=p.Pos+p.TmpX-LoWord(lParam);
            p.TmpX:=LoWord(lParam);
            CommonProc(hWnd, msg, wParam, lParam);
          end;
      end;
    WM_MOUSEHOVER, WM_MOUSELEAVE, WM_LBUTTONUP:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;
procedure StaticInfoDrawProc(hWnd:HWND; g:TGPGraphics);
type
  PTxtData=^TTxtData;
  TTxtData = record
    Pos:integer;
    TmpX:integer;
  end;

var txt:string;
    s:TStatic;
    br:TGPBrush;
    sf:TGPStringFormat;
    Font: TGPFont;
    g2:TGPGraphics;
    bm:TGPBitmap;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TStatic;
  if (BP<>nil)and(FInfo<>'') then
    txt:=FInfo
  else
    txt:='Media not loaded';

  Font:=TGPFont.Create(Skin.Font2.Name, s.Height-2, Skin.MainFont.Style, UnitPixel);
  br:=TGPSolidBrush.Create(Skin.Color2);

  sf:=TGPStringFormat.Create;
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);

  bm:=TGPBitmap.Create(s.Width, s.Height+1);
  g2:=TGPGraphics.Create(bm);
  g2.SetTextRenderingHint(TextRenderingHintAntiAlias);
  g2.DrawString(txt, -1, Font, MakePoint(-PTxtData(s.Data).Pos, 0.0), sf, br);
  g2.Free;
  g.DrawImage(bm, MakeRect(s.Left, s.Top, s.Width, s.Height));
  bm.Free;

  Font.Free;

  sf.Free;
  br.Free;
end;

procedure StaticAddInfoDrawProc(hWnd:HWND; g:TGPGraphics);
var fi:TFileInfo;
    txt:string;
    s:TStatic;
    br:TGPBrush;
    sf:TGPStringFormat;
    Font: TGPFont;
    rct:TGPRectF;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TStatic;
  if (BP<>nil)and (BP.PauseState<>psUnloaded)and(BP.StreamType<>stNETRADIO) then
    begin
      fi:=BP.GetInfo;
      txt:=Format('%d Hz %d Kbps %d:%.2d', [fi.SampleRate, fi.Bitrate, fi.Length div 60, fi.Length mod 60]);
    end
  else
    txt:='';


  Font:=TGPFont.Create(Skin.Font3.Name, s.Height-2, Skin.MainFont.Style, UnitPixel);
  br:=TGPSolidBrush.Create(Skin.Color3);

  sf:=TGPStringFormat.Create;
  g.SetTextRenderingHint(TextRenderingHintAntiAlias);

  g.MeasureString(txt, -1, Font, MakeRect(s.Left+0.0, s.Top, s.Width, s.Height), sf, rct);
  g.DrawString(txt, -1, Font, MakePoint(s.Left+0.0, s.Top), sf, br);

  Font.Free;

  sf.Free;
  br.Free;
end;


function TrackBarPosWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
var tmp, max, max2:integer;
    sz:int64;
    s:TControl;
begin
  Result:=0;
  s:=BProc_Controls.GetControlByHwnd(hWnd);
  case msg of
    WM_CONTROLINIT, WM_MOUSEHOVER, WM_MOUSELEAVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_MOUSEMOVE:
      begin
        tmp:=LoWord(lParam);
        max:=s.Width;
        max2:=(s as TTrackBar).Max;
        if s.WasPressed then
          (s as TTrackBar).TempPos:=Round(max2*tmp/max);
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_LBUTTONDOWN:
      begin
        s.WasPressed:=true;
        tmp:=LoWord(lParam);
        max:=s.Width;
        max2:=(s as TTrackBar).Max;
        (s as TTrackBar).TempPos:=Round(max2*tmp/max);
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          begin
            sz:=BP.GetSize;
            tmp:=(s as TTrackBar).TempPos;
            max:=(s as TTrackBar).Max;
            BP.SetPosition(Round(sz*tmp/max));
          end;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;
procedure TrackBarPosDrawProc(hWnd:HWND; g:TGPGraphics);
var ps:single;
    s:TTrackBar;
    br, br2:TGPBrush;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TTrackBar;
  if (BP<>nil)and(BP.PauseState in [psPlaying, psPaused])and(BP.StreamType<>stNETRADIO) then
    begin
      ps:=BP.GetPos/BP.GetLength;
    end
  else
    ps:=0;

  br:=TGPSolidBrush.Create(Skin.MainColor);
  br2:=TGPSolidBrush.Create(Skin.Color3);

  g.FillRectangle(br2, s.Left, s.Top, s.Width, s.Height);
  g.FillRectangle(br, s.Left, s.Top, s.Width*ps, s.Height);

  br2.Free;
  br.Free;
end;

function TrackBarVolWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
var tmp, max, max2:integer;
begin
  Result:=0;
  case msg of
    WM_CONTROLINIT, WM_MOUSEHOVER, WM_MOUSELEAVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_MOUSEMOVE:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          begin
            tmp:=LoWord(lParam);
            max:=BProc_Controls.GetControlByHwnd(hWnd).Width;
            max2:=(BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).Max;
            (BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).TempPos:=Round(max2*tmp/max);
            BP.SetVolume(tmp/max);
          end;
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_LBUTTONDOWN:
      begin
        BProc_Controls.GetControlByHwnd(hWnd).WasPressed:=true;
        tmp:=LoWord(lParam);
        max:=BProc_Controls.GetControlByHwnd(hWnd).Width;
        max2:=(BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).Max;
        (BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).TempPos:=Round(max2*tmp/max);
        CommonProc(hWnd, msg, wParam, lParam);
      end;
    WM_LBUTTONUP:
      begin
        if BProc_Controls.GetControlByHwnd(hWnd).WasPressed then
          begin
            tmp:=(BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).TempPos;
            max:=(BProc_Controls.GetControlByHwnd(hWnd) as TTrackBar).Max;
            BP.SetVolume(tmp/max);
          end;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;
procedure TrackBarVolDrawProc(hWnd:HWND; g:TGPGraphics);
var ps:single;
    s:TTrackBar;
    br, br2:TGPBrush;
begin
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TTrackBar;
  if (BP<>nil)and not(BP.Muted)and(BP.StreamType<>stNETRADIO) then
    begin
      ps:=BP.GetVolume;
    end
  else
    ps:=0;

  br:=TGPSolidBrush.Create(Skin.MainColor);
  br2:=TGPSolidBrush.Create(Skin.Color3);

  g.FillRectangle(br2, s.Left, s.Top, s.Width, s.Height);
  g.FillRectangle(br, s.Left, s.Top, s.Width*ps, s.Height);

  br2.Free;
  br.Free;
end;


function MuteButtonWndProc(hWnd:HWND; msg:UINT; wParam:WPARAM; lParam:LPARAM):LRESULT;
var s:TToggleButton;
begin
  Result:=0;
  s:=(BProc_Controls.GetControlByHwnd(hWnd)) as TToggleButton;
  case msg of
    WM_CONTROLINIT, WM_LBUTTONDOWN, WM_MOUSEHOVER, WM_MOUSELEAVE, WM_MOUSEMOVE:
      Result:=CommonProc(hWnd, msg, wParam, lParam);
    WM_LBUTTONUP:
      begin
        if s.WasPressed then
          begin
            s.Toggled:=not s.Toggled;
            BP.Muted:=s.Toggled;
          end;
        CommonProc(hWnd, msg, wParam, lParam);
      end
    else
      Result:=DefWindowProc(hWnd, msg, wParam, lParam);
  end;
end;

end.
