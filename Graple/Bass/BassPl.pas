{///////////////////////////////////////////////}
{/// Graple Audio Player                     ///}
{/// Bass Player Shell Unit                  ///}
{///////////////////////////////////////////////}
{/// Author: KOOL                            ///}
{/// Email: kool_91@mail.ru                  ///}
{/// License: GNU General Public License 3.0 ///}
{///////////////////////////////////////////////}

unit BassPl;

interface

uses Windows, SysUtils, Bass, B_ID3V1;

const
  psUnloaded  = 0;
  psPlaying   = 1;
  psPaused    = 2;
  psStopped   = 3;

  stNONE      = 0;
  stSOUND     = 1;
  stMUSIC     = 2;
  stNETRADIO  = 3;
  stUSER      = 4;
  stOTHER     = 255;

  BASS_EQ_BAND_COUNT = 18;

  BASS_FX_CHORUS      = 1;
  BASS_FX_COMPRESSOR  = 2;
  BASS_FX_DISTORTION  = 3;
  BASS_FX_ECHO        = 4;
  BASS_FX_FLANGER     = 5;
  BASS_FX_GARGLE      = 6;
  BASS_FX_REVERB      = 7;
  BASS_FX_I3DL2REVERB = 8;


  MSG_TYPE_CAPTION = 3;
  MSG_TYPE_BITRATE = 4;
  MSG_TYPE_TAGS = 6;
  MSG_TYPE_META = 7;
  MSG_TYPE_STATUS = 8;

  WM_INFO_UPDATE = 1024 + 101;
  WM_PLAYBACK_START = 1024 + 108;
  WM_PLAYBACK_PAUSE = 1024 + 109;
  WM_PLAYBACK_STOP = 1024 + 110;
  WM_PLAYBACK_END = 1024 + 111;
  WM_PLAYBACK_POS = 1024 + 112;
  WM_PLAYBACK_SETPOS = 1024 + 113;
  WM_PLAYBACK_STALL = 1024 + 114;
  WM_PLAYBACK_DOWNLOAD = 1024 + 115;

  EQBands : array[0..17] of FLOAT = (30, 60, 125, 175, 250, 310, 600, 1000, 1500, 2000, 3000, 4000, 6000, 8000, 10000, 12000, 14000, 16000);

type

  ProxyArr = array [0..99] of AnsiChar;
  PProxyArr = ^ProxyArr;

  VECTOR3D = BASS_3DVECTOR;

  TFileInfo = record
    Bitrate : integer;
    SampleRate : integer;
    Size : int64;
    Length : int64;
    Channels :integer;
  end;

  PPluginInfo = ^TPluginInfo;
  TPluginInfo = record
    Handle: HPLUGIN;
    Data: PBASS_PLUGININFO;
  end;

  TEQBand = record
    Handle : HFX;
    Info : BASS_DX8_PARAMEQ;
  end;

  TFX = record
    Chorus : BASS_DX8_CHORUS;
    Compressor : BASS_DX8_COMPRESSOR;
    Distortion : BASS_DX8_DISTORTION;
    Echo : BASS_DX8_ECHO;
    Flanger : BASS_DX8_FLANGER;
    Gargle : BASS_DX8_GARGLE;
    Reverb : BASS_DX8_REVERB;
    Reverb2 : BASS_DX8_I3DL2REVERB;
  end;

  TFXState = record
    Handle : HFX;
    Active : boolean;
  end;

  TBassPlayer = class
    private
      MusicStream : HSTREAM;
      StrType : byte;
      PauseSt : byte;
      PluginCount : word;
      PluginsInfo : array of TPluginInfo;
      EQ : array[0..BASS_EQ_BAND_COUNT-1] of TEQBand;
      FX : TFX;
      FXHandles : array[1..8] of TFXState;
      IsEQActive:boolean;
      EAX : SmallInt;
      Balance:float;
      Volume:float;
      Use3D:boolean;
      IsMuted:boolean;
      function  GetPluginsInfo(Index:integer):PPluginInfo;
      function  GetEQ(Index:integer):Float;
      procedure SetEQ(Index:integer; Gain:Float);
      function  GetEQFrequency(Index:integer):Float;
      procedure SetEQState(St:boolean);
      procedure ApplyEQ;
      procedure RemoveEQ;
      function  GetFXState(FXType:byte):boolean;
      procedure SetFXState(FXType:byte; St:boolean);
      procedure ApplyFX;  overload;
      procedure RemoveFX; overload;
      procedure ApplyFX(FXType:byte);  overload;
      procedure RemoveFX(FXType:byte); overload;
      procedure SetDefaultFX(FXType:byte);
      procedure SetEAXPreset(Preset:SmallInt);
      function  GetEAXSupport:boolean;
      function  Get3DPos:BASS_3DVECTOR;
      procedure Set3DPos(V:BASS_3DVECTOR);
      procedure SetMute(m:boolean);
      procedure ApplyAttributes;
      procedure ResetAttributes;
    public
      const EQCount = BASS_EQ_BAND_COUNT;

      property StreamType : byte read StrType;
      property PauseState : byte read PauseSt;
      property Plugins[Index: Integer] : PPluginInfo read GetPluginsInfo;
      property Equalizer[Index: Integer] : Float read GetEQ write SetEQ;
      property EQFrequencies[Index: Integer] : Float read GetEQFrequency;
      property EQActive : boolean read IsEQActive write SetEQState;
      property Effects : TFX read FX write FX;
      property FXActive[Index: byte] : boolean read GetFXState write SetFXState;
      property EAXPreset : SmallInt read EAX write SetEAXPreset;
      property EAXSupported : boolean read GetEAXSupport;
      property Position3D : BASS_3DVECTOR read Get3DPos write Set3DPos;
      property Enable3D : boolean read Use3D write Use3D;
      property Muted : boolean read IsMuted write SetMute;

      constructor Create(Hnd:Cardinal; Proxy:PProxyarr = nil);
      destructor  Destroy; override;

      procedure LoadPlugins(Dir:string);
      procedure UnloadPlugin(Index:integer);
      function  GetSupportedFormats(Ext:boolean = false; Filter:boolean = false; Glue:char = #0):string;
      procedure SetProxy(Proxy:PProxyarr);
      function  GetCPU:float;

      procedure GetChannelData(Data: Pointer; Format:Cardinal);
      function  GetSize:Int64;
      function  GetLength:Int64;
      function  GetBytePos:Int64;
      function  GetPos:Int64;
      function  GetTime(Pos:FLOAT; Reverse:boolean=false):int64;
      function  GetTimeStr(Pos:Float; Reverse:boolean=false):string;
      function  GetRLevel:word;
      function  GetLLevel:word;
      function  GetVolume(Actual:boolean=false):single;
      function  GetPan:single;
      procedure SetPosition(Pos:Int64);
      procedure SetVolume(Vol:single);
      procedure SetPan(Pan:single);
      function  GetInfo: TFileInfo; overload;
      function  GetInfo(F:string): TFileInfo; overload;

      function  OpenStream(Src:string):boolean;
      procedure CloseStream;
      function  Play(Src:string):boolean; overload;
      procedure Play(Restart : boolean = false); overload;
      procedure Pause;
      procedure PauseToggle;
      procedure Stop;

  end;

implementation

var ParentWnd : HWND;
    Pl:TBassPlayer;

//------------------------------------------------------------------------------
//--------------- COMMON -------------------------------------------------------
//------------------------------------------------------------------------------

procedure MetaSync(handle: HSYNC; channel, data, user: DWORD); stdcall;
var
  meta: PAnsiChar;
  p: Integer;
begin
  meta := BASS_ChannelGetTags(channel, BASS_TAG_META);
  if (meta <> nil) then
  begin
    p := Pos('StreamTitle=', String(AnsiString(meta)));
    if (p = 0) then
      Exit;
    p := p + 13;
    SendMessage(ParentWnd, WM_INFO_UPDATE, MSG_TYPE_META, DWORD(PAnsiChar(AnsiString(Copy(meta, p, Pos(';', String(meta)) - p - 1)))));
  end;
end;

procedure EndProc(handle: HSYNC; channel, data, user: DWORD); stdcall;
begin
{  case handle of
      BASS_SYNC_END: }
  Pl.PauseSt:=psStopped;
  SendMessage(ParentWnd, WM_PLAYBACK_END, 0, 0);

      {BASS_SYNC_POS: SendMessage(ParentWnd, WM_PLAYBACK_POS, data, 0);
      BASS_SYNC_SETPOS: SendMessage(ParentWnd, WM_PLAYBACK_SETPOS, data, 0);
      BASS_SYNC_STALL: SendMessage(ParentWnd, WM_PLAYBACK_STALL, data, 0);
      BASS_SYNC_DOWNLOAD: SendMessage(ParentWnd, WM_PLAYBACK_DOWNLOAD, 0, 0);
    end;}
end;

procedure StatusProc(buffer: Pointer; len, user: DWORD); stdcall;
begin
  if (buffer <> nil) and (len = 0) then
    SendMessage(ParentWnd, WM_INFO_UPDATE, MSG_TYPE_STATUS, DWORD(PAnsiChar(buffer)));
end;

//------------------------------------------------------------------------------
//--------------- PRIVATE ------------------------------------------------------
//------------------------------------------------------------------------------

function TBassPlayer.GetPluginsInfo(Index:integer):PPluginInfo;
begin
  if (Index>0)and(Index<PluginCount) then
    Result:=@PluginsInfo[Index]
  else
    Result:=nil;
end;

function TBassPlayer.GetEQ(Index:integer):Float;
begin
  if (Index>=0) and (Index<Length(EQ)) then
    Result:=EQ[Index].Info.fGain
  else
    Result:=0;
end;

procedure TBassPlayer.SetEQ(Index:integer; Gain:Float);
begin
  if (Index>=0) and (Index<Length(EQ)) then
    begin
      EQ[Index].Info.fGain:=Gain;
      BASS_FXSetParameters(EQ[Index].Handle, @EQ[Index].Info);
    end;
end;

function TBassPlayer.GetEQFrequency(Index:integer):Float;
begin
  if (Index>=0) and (Index<Length(EQ)) then
    Result:=EQ[Index].Info.fCenter
  else
    Result:=0;
end;

procedure TBassPlayer.SetEQState(St:boolean);
begin
  if St then
    ApplyEQ
  else
    RemoveEQ;
  IsEQActive := St;
end;

procedure TBassPlayer.ApplyEQ;
var i:integer;
begin
  for i:=0 to High(EQ) do
    begin
      EQ[i].Handle:=BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_PARAMEQ, 1);
      BASS_FXSetParameters(EQ[i].Handle, @EQ[i].Info);
    end;
end;

procedure TBassPlayer.RemoveEQ;
var i:integer;
begin
  for i:=0 to High(EQ) do
    BASS_ChannelRemoveFX (MusicStream, EQ[i].Handle);
end;

function TBassPlayer.GetFXState(FXType:byte):boolean;
begin
  if (FXType>8)or(FXType<1) then
    Result:=false
  else
    Result :=FXHandles[FXType].Active;
end;

procedure TBassPlayer.SetFXState(FXType:byte; St:boolean);
begin
  if (FXType>8)or(FXType<1) then
    Exit;
  if St then
    ApplyFX(FXType)
  else
    RemoveFX(FXType);
end;

procedure TBassPlayer.ApplyFX(FXType:byte);
var t:byte;
begin
  if (FXType>8)or(FXType<1) then
    Exit;
  if FXType=BASS_FX_REVERB then
    t:=8
  else
    if FXType=BASS_FX_I3DL2REVERB then
      t:=6
    else
      t:=FXType-1;
  FXHandles[FXType].Handle := BASS_ChannelSetFX(MusicStream, t, 1);
  FXHandles[FXType].Active := true;
end;

procedure TBassPlayer.RemoveFX(FXType:byte);
begin
  if (FXType>8)or(FXType<1) then
    Exit;
  BASS_ChannelRemoveFX(MusicStream, FXHandles[FXType].Handle);
  FXHandles[FXType].Handle := 0;
  FXHandles[FXType].Active := false;
end;

procedure TBassPlayer.ApplyFX;
begin
  if FXHandles[BASS_FX_CHORUS].Active then
    begin
      FXHandles[BASS_FX_CHORUS].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_CHORUS, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_CHORUS].Handle, @FX.Chorus);
    end;
  if FXHandles[BASS_FX_COMPRESSOR].Active then
    begin
      FXHandles[BASS_FX_COMPRESSOR].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_COMPRESSOR, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_COMPRESSOR].Handle, @FX.Compressor);
    end;
  if FXHandles[BASS_FX_DISTORTION].Active then
    begin
      FXHandles[BASS_FX_DISTORTION].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_DISTORTION, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_DISTORTION].Handle, @FX.Distortion);
    end;
  if FXHandles[BASS_FX_ECHO].Active then
    begin
      FXHandles[BASS_FX_ECHO].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_ECHO, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_ECHO].Handle, @FX.Echo);
    end;
  if FXHandles[BASS_FX_FLANGER].Active then
    begin
      FXHandles[BASS_FX_FLANGER].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_FLANGER, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_FLANGER].Handle, @FX.Flanger);
    end;
  if FXHandles[BASS_FX_GARGLE].Active then
    begin
      FXHandles[BASS_FX_GARGLE].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_GARGLE, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_GARGLE].Handle, @FX.Gargle);
    end;
  if FXHandles[BASS_FX_REVERB].Active then
    begin
      FXHandles[BASS_FX_REVERB].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_REVERB, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_REVERB].Handle, @FX.Reverb);
    end;
  if FXHandles[BASS_FX_I3DL2REVERB].Active then
    begin
      FXHandles[BASS_FX_I3DL2REVERB].Handle := BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_I3DL2REVERB, 1);
      BASS_FXSetParameters(FXHandles[BASS_FX_I3DL2REVERB].Handle, @FX.Reverb2);
    end;
end;

procedure TBassPlayer.RemoveFX;
var i:byte;
begin
  for i:=1 to 8 do
    BASS_ChannelRemoveFX(MusicStream, FXHandles[i].Handle);
end;

procedure TBassPlayer.SetDefaultFX(FXType:byte);
begin

  if (FXType=0)or(FXType=BASS_FX_CHORUS) then
    with FX.Chorus do
      begin
        fWetDryMix:=50;
        fDepth:=30;
        fFeedback:=40;
        fFrequency:=1.3;
        lWaveform:=1;
        fDelay:=16;
        lPhase:=BASS_DX8_PHASE_90;
    end;

  if (FXType=0)or(FXType=BASS_FX_COMPRESSOR) then
    with FX.Compressor do
      begin
        fGain:=0;
        fAttack:=10;
        fRelease:=200;
        fThreshold:=-20;
        fRatio:=3;
        fPredelay:=4;
    end;

  if (FXType=0)or(FXType=BASS_FX_DISTORTION) then
    with FX.Distortion do
      begin
        fGain:=-18;
        fEdge:=15;
        fPostEQCenterFrequency:=2400;
        fPostEQBandwidth:=2400;
        fPreLowpassCutoff:=8000;
    end;

  if (FXType=0)or(FXType=BASS_FX_ECHO) then
    with FX.Echo do
      begin
        fWetDryMix:=50;
        fFeedback:=50;
        fLeftDelay:=500;
        fRightDelay:=500;
        lPanDelay:=false;
      end;

  if (FXType=0)or(FXType=BASS_FX_FLANGER) then
    with FX.Flanger do
      begin
        fWetDryMix:=50;
        fDepth:=100;
        fFeedback:=-50;
        fFrequency:=0.25;
        lWaveform:=1;
        fDelay:=2;
        lPhase:=BASS_DX8_PHASE_90;
      end;

  if (FXType=0)or(FXType=BASS_FX_GARGLE) then
    with FX.Gargle do
      begin
        dwRateHz:=250;
        dwWaveShape:=1;
      end;

  if (FXType=0)or(FXType=BASS_FX_REVERB) then
    with FX.Reverb do
      begin
        fInGain:=0;
        fReverbMix:=0;
        fReverbTime:=1000;
        fHighFreqRTRatio:=0.001;
      end;

  if (FXType=0)or(FXType=BASS_FX_I3DL2REVERB) then
    with FX.Reverb2 do
      begin
        lRoom:=-1000;
        lRoomHF:=-100;
        flRoomRolloffFactor:=0;
        flDecayTime:=1.49;
        flDecayHFRatio:=0.83;
        lReflections:=-2602;
        flReflectionsDelay:=0.007;
        lReverb:=200;
        flReverbDelay:=0.011;
        flDiffusion:=100;
        flDensity:=100;
        flHFReference:=5000;
      end;
end;

procedure TBassPlayer.SetEAXPreset(Preset:SmallInt);
begin
  if not Use3D  then
    Exit;
  if (Preset<=0)or(Preset>=EAX_ENVIRONMENT_COUNT) then
    Preset:=0;
  EAX:=Preset;
  BASS_SetEAXParameters(Preset, 0, 0, 0);
  BASS_SetEAXPreset(Preset);
end;

function TBassPlayer.GetEAXSupport:boolean;
begin
  Result:=BASS_SetEAXParameters(-1, 0.0, -1.0, -1.0);
end;

function TBassPlayer.Get3DPos:BASS_3DVECTOR;
var dummy:BASS_3DVECTOR;
begin
  BASS_ChannelGet3DPosition(MusicStream, Result, dummy, dummy);
end;

procedure TBassPlayer.Set3DPos(V:BASS_3DVECTOR);
var dummy:BASS_3DVECTOR;
begin
  if not Use3D  then
    Exit;
  if V.X>0 then
    dummy.x:=1
  else
    dummy.x:=-1;
  if V.Y>0 then
    dummy.y:=1
  else
    dummy.y:=-1;
  dummy.z:=0;
  V.x:=V.x*3;
  V.y:=V.y*3;
  if BASS_ChannelSet3DPosition(MusicStream, V, dummy, dummy)then
    BASS_Apply3D;
end;

procedure TBassPlayer.SetMute(m:boolean);
begin
  IsMuted:=m;
  if m then
    BASS_ChannelSetAttribute(MusicStream, BASS_ATTRIB_VOL, 0)
  else
    BASS_ChannelSetAttribute(MusicStream, BASS_ATTRIB_VOL, Volume);
end;

procedure TBassPlayer.ApplyAttributes;
begin
  SetMute(IsMuted);
  BASS_ChannelSetAttribute(MusicStream, BASS_ATTRIB_PAN, Balance);
  if Use3D and BASS_ChannelSet3DAttributes(MusicStream, BASS_3DMODE_NORMAL, 0, 0, -1, -1, 0) then
    BASS_Apply3D;
end;

procedure TBassPlayer.ResetAttributes;
begin
  Volume:=1;
  Balance:=0;
  ApplyAttributes;
end;


//------------------------------------------------------------------------------
//--------------- PUBLIC -------------------------------------------------------
//------------------------------------------------------------------------------

constructor TBassPlayer.Create(Hnd:Cardinal; Proxy:PProxyarr = nil);
var i:integer;
begin

	if (HiWord(BASS_GetVersion) <> BASSVERSION) then
    raise Exception.Create('Incorrect version of BASS.DLL!');

	if not BASS_Init(-1, 44100, BASS_DEVICE_3D, Hnd, nil) then
		raise Exception.Create('Error initializing audio!');

  BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);
  BASS_SetConfig(BASS_CONFIG_NET_PREBUF, 0);
  BASS_SetConfigPtr(BASS_CONFIG_NET_PROXY, proxy);

  for i:=0 to High(EQ) do
    begin
      EQ[i].Info.fBandwidth:=9;
      EQ[i].Info.fGain:=0;
      EQ[i].Info.fCenter:= EQBands[Round(i*Length(EQBands)/Length(EQ))];
      EQ[i].Handle:=BASS_ChannelSetFX(MusicStream, BASS_FX_DX8_PARAMEQ, 1);
    end;

  SetDefaultFX(0);

  BASS_Set3DFactors(1, 1, 1);
  BASS_Apply3D;

  ParentWnd := Hnd;
  MusicStream := 0;
  PauseSt := 0;
  PluginCount := 0;
  Volume := 1;
  Balance := 0;
  Pl:=Self;
end;

destructor TBassPlayer.Destroy;
begin
  CloseStream;
  SetLength(PluginsInfo, 0);
  BASS_Free;
  BASS_PluginFree(0);
  inherited Destroy;
end;

function TBassPlayer.GetCPU:float;
begin
  Result:=BASS_GetCPU;
end;

procedure TBassPlayer.GetChannelData(Data: Pointer; Format:Cardinal);
begin
  BASS_ChannelGetData(MusicStream, Data, Format);
end;


function TBassPlayer.GetSize:Int64;
begin
  Result:=BASS_ChannelGetLength(MusicStream, BASS_POS_BYTE);
end;

function TBassPlayer.GetLength:Int64;
begin
  Result:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, GetSize));
end;

function TBassPlayer.GetBytePos:Int64;
begin
  Result:=BASS_ChannelGetPosition(MusicStream, BASS_POS_BYTE);
end;

function TBassPlayer.GetPos:Int64;
begin
  Result:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, GetBytePos));
end;

function TBassPlayer.GetTime(Pos:FLOAT; Reverse:boolean=false):int64;
begin
  if Pos>1 then
    Pos:=1;
  if Pos<0 then
    Pos:=0;
  if Reverse then
    Result:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, Trunc(GetSize*(1-Pos))))
  else
    Result:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, Trunc(GetSize*Pos)));
end;

function TBassPlayer.GetTimeStr(Pos:Float; Reverse:boolean=false):string;
var t:int64;
begin
  if Pos>1 then
    Pos:=1;
  if Pos<0 then
    if Pos=-1 then
      Pos:=GetBytePos/GetSize
    else
      Pos:=0;
  if Reverse then
    t:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, Trunc(GetSize*(1-Pos))))
  else
    t:=Trunc(BASS_ChannelBytes2Seconds(MusicStream, Trunc(GetSize*Pos)));
  Result:=Format('%.2d:%.2d', [t div 60, t mod 60]);
  if Reverse then
    Result:='-'+Result;
end;

function TBassPlayer.GetRLevel:word;
begin
  Result:=HiWord(BASS_ChannelGetLevel(MusicStream));
end;

function TBassPlayer.GetLLevel:word;
begin
  Result:=LoWord(BASS_ChannelGetLevel(MusicStream));
end;

function TBassPlayer.GetVolume(Actual:boolean=false):Single;
begin
  if Actual then
    BASS_ChannelGetAttribute(MusicStream, BASS_ATTRIB_VOL, Result)
  else
    Result:=Volume;
end;

function TBassPlayer.GetPan:Single;
begin
  BASS_ChannelGetAttribute(MusicStream, BASS_ATTRIB_PAN, Result);
end;

procedure TBassPlayer.SetPosition(Pos:Int64);
begin
  BASS_ChannelSetPosition(MusicStream, Pos, BASS_POS_BYTE);
end;

procedure TBassPlayer.SetVolume(Vol:single);
begin
  Volume:=Vol;
  if not IsMuted then
    BASS_ChannelSetAttribute(MusicStream, BASS_ATTRIB_VOL, Vol);
end;

procedure TBassPlayer.SetPan(Pan:single);
begin
  BASS_ChannelSetAttribute(MusicStream, BASS_ATTRIB_PAN, Pan);
  Balance:=Pan;
end;

function TBassPlayer.GetInfo: TFileInfo;
var CI:BASS_CHANNELINFO;
begin
  Result.Size := BASS_ChannelGetLength(MusicStream, BASS_POS_BYTE);
  Result.Length:= Trunc(BASS_ChannelBytes2Seconds(MusicStream, Result.Size));
  if Result.Length<>0 then
    Result.Bitrate:= Round(BASS_StreamGetFilePosition(MusicStream, BASS_FILEPOS_END) / (125 * Result.Length) + 0.5)
  else
    Result.Bitrate:=0;
  BASS_ChannelGetInfo(MusicStream, CI);
  Result.SampleRate:=CI.freq;
  Result.Channels:=CI.chans;
end;

function TBassPlayer.GetInfo(F:string): TFileInfo;
var CI:BASS_CHANNELINFO;
    S:HSTREAM;
begin
  S:=BASS_StreamCreateFile(false, PChar(F), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  if S=0 then
    Exit;
  Result.Size := BASS_ChannelGetLength(MusicStream, BASS_POS_BYTE);
  Result.Length:= Trunc(BASS_ChannelBytes2Seconds(MusicStream, Result.Size));
  if Result.Length<>0 then
    Result.Bitrate:= Round(BASS_StreamGetFilePosition(MusicStream, BASS_FILEPOS_END) / (125 * Result.Length) + 0.5)
  else
    Result.Bitrate:=0;
  BASS_ChannelGetInfo(MusicStream, CI);
  Result.SampleRate:=CI.freq;
  Result.Channels:=CI.chans;
  BASS_StreamFree(S);
end;



function TBassPlayer.OpenStream(Src:string):boolean;
var url:AnsiString;
    tags: PAnsiChar;
    flag3d:Cardinal;
    ID3: TID3V1Rec;
begin
  if PauseSt<>psUnloaded then
    CloseStream;
  if Use3D then
    flag3d:=BASS_SAMPLE_MONO or BASS_SAMPLE_3D
  else
    flag3d:=0;
  MusicStream := BASS_StreamCreateFile(False, PChar(Src), 0, 0, flag3d {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  if MusicStream=0 then
    begin
      SetLength(url, Length(Src));
      UnicodeToUtf8(PAnsiChar(url), PWideChar(Src), Length(Src));
      MusicStream := BASS_StreamCreateURL(PAnsiChar(url), 0, flag3d or BASS_STREAM_STATUS, @StatusProc, nil);
      if MusicStream=0 then
        begin
          MusicStream := BASS_MusicLoad(false, PChar(Src), 0, 0, flag3d or BASS_MUSIC_RAMP {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF}, 0);
          if MusicStream<>0 then
            begin
              StrType := stMUSIC;
              PauseSt := psStopped;
            end;
        end
      else
        begin
          tags := BASS_ChannelGetTags(MusicStream, BASS_TAG_ICY);
          if (tags = nil) then
            tags := BASS_ChannelGetTags(MusicStream, BASS_TAG_HTTP);
          if (tags <> nil) then
            while (tags^ <> #0) do
            begin
              if (Copy(tags, 1, 9) = 'icy-name:') then
                SendMessage(ParentWnd, WM_INFO_UPDATE, MSG_TYPE_CAPTION, DWORD(PAnsiChar(Copy(tags, 10, MaxInt))))
              else if (Copy(tags, 1, 7) = 'icy-br:') then
                SendMessage(ParentWnd, WM_INFO_UPDATE, MSG_TYPE_BITRATE, DWORD(PAnsiChar('bitrate: ' + Copy(tags, 8, MaxInt))));
              tags := tags + Length(tags) + 1;
            end;
          MetaSync(0, MusicStream, 0, 0);
          BASS_ChannelSetSync(MusicStream, BASS_SYNC_META, 0, @MetaSync, nil);
          StrType := stNETRADIO;
          PauseSt := psStopped;
        end;
    end
  else
    begin
      StrType := stSOUND;
      PauseSt := psStopped;
      ID3 := BASSID3ToID3V1Rec(BASS_ChannelGetTags(MusicStream, BASS_TAG_ID3));
      if ID3.Tag<>'' then
        SendMessage(ParentWnd, WM_INFO_UPDATE, MSG_TYPE_TAGS, DWORD(PAnsiChar(ID3.Artist+' - '+ID3.Title+' - '+ID3.Album)));
      BASS_ChannelSetSync(MusicStream, BASS_SYNC_END, 0, @EndProc, nil);
    end;
  Result := PauseSt=psStopped;
end;

procedure TBassPlayer.CloseStream;
begin
  BASS_ChannelStop(MusicStream);
  BASS_StreamFree(MusicStream);
  BASS_MusicFree(MusicStream);
  MusicStream := 0;
  StrType := stNONE;
  PauseSt := psUnloaded;
end;

procedure TBassPlayer.LoadPlugins(Dir:string);
var fd: TWin32FindData;
    fh: THandle;
    plug: HPLUGIN;
begin
  fh := FindFirstFile(PChar(Dir + 'bass*.dll'), fd);
  if (fh <> INVALID_HANDLE_VALUE) then
  try
    repeat
      plug := BASS_PluginLoad(PWideChar(Dir+fd.cFileName), 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
      if Plug <> 0 then
      begin
        PluginCount:=PluginCount+1;
        SetLength(PluginsInfo, PluginCount);
        PluginsInfo[PluginCount-1].Handle := plug;
        PluginsInfo[PluginCount-1].Data := BASS_PluginGetInfo(Plug);
      end;
    until FindNextFile(fh, fd) = false;
  finally
    Windows.FindClose(fh);
  end;
end;

procedure TBassPlayer.UnloadPlugin(Index:integer);
var i:integer;
begin
  if Index=-1 then
    begin
      BASS_PluginFree(0);
      SetLength(PluginsInfo, 0);
      PluginCount:=0;
    end
  else
    if (Index>-1)and(Index<PluginCount) then
      begin
        BASS_PluginFree(PluginsInfo[Index].Handle);
        for i:=Index to PluginCount-2 do
          PluginsInfo[i]:=PluginsInfo[i+1];
        PluginCount:=PluginCount-1;
        SetLength(PluginsInfo, PluginCount);
      end;
end;

function TBassPlayer.GetSupportedFormats(Ext:boolean = false; Filter:boolean = false; Glue:char = #0):string;
var i, j:integer;
begin
  if Ext then
    if Filter then
      Result:='MPEG Audio (*.mp3;*.mp2;*.mp1)' + Glue + '*.mp3;*.mp2;*.mp1' + Glue +
              'OGG (*.ogg)' + Glue + '*.ogg' + Glue +
              'Microsoft Wave (*.wav)' + Glue + '*.wav' + Glue +
              'Audio Interchange File Format (*.aif; *.aiff; *.aifc)' + Glue + '*.aif;*.aiff;*.aifc'
    else
      Result:='*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.aif;*.aiff;*.aifc'
  else
    Result:='MPEG Audio, OGG, Microsoft Wave, Audio Interchange File Format';

  for i:=0 to PluginCount-1 do
    begin
      for j:=0 to PluginsInfo[i].Data.formatc-1 do
        if Ext then
          if Filter then
            Result := Result +  Glue  + PluginsInfo[i].Data.Formats[j].name+' ('+PluginsInfo[i].Data.formats[j].exts+')' + Glue + PluginsInfo[i].Data.formats[j].exts
          else
            Result:=Result+';'+PluginsInfo[i].Data.formats[j].exts
        else
          Result:=Result+', '+PluginsInfo[i].Data.formats[j].name;
    end;
end;

procedure TBassPlayer.SetProxy(Proxy:PProxyarr);
begin
  BASS_SetConfigPtr(BASS_CONFIG_NET_PROXY, proxy);
end;

function TBassPlayer.Play(Src: string):boolean;
begin
  Result:=false;
  CloseStream;
  if OpenStream(Src)then
    begin
      if IsEQActive then
        ApplyEQ;
      ApplyAttributes;
      ApplyFX;
      BASS_ChannelPlay(MusicStream, false);
      PauseSt := psPlaying;
      SendMessage(ParentWnd, WM_PLAYBACK_START, 0, 0);
      Result:=true;
    end;
end;

procedure TBassPlayer.Play(Restart : boolean = false);
begin
  if PauseSt=psUnloaded then
    Exit;
  if PauseSt=psStopped then
  begin
    ApplyFX;
    if IsEQActive then
      ApplyEQ;
  end;
  ApplyAttributes;
  BASS_ChannelPlay(MusicStream, Restart);
  PauseSt := psPlaying;
  SendMessage(ParentWnd, WM_PLAYBACK_START, 0, 0);
end;

procedure TBassPlayer.Pause;
begin
  BASS_ChannelPause(MusicStream);
  PauseSt := psPaused;
  SendMessage(ParentWnd, WM_PLAYBACK_PAUSE, 0, 0);
end;

procedure TBassPlayer.PauseToggle;
begin
  if PauseSt=psUnloaded then
    Exit;
  if PauseSt=psPlaying then
    Pause
  else
    Play(PauseSt=psStopped);
end;

procedure TBassPlayer.Stop;
begin
  if PauseSt=psUnloaded then
    Exit;
  BASS_ChannelStop(MusicStream);
  RemoveEQ;
  RemoveFX;
  PauseSt := psStopped;
  SendMessage(ParentWnd, WM_PLAYBACK_STOP, 0, 0);
end;

end.
