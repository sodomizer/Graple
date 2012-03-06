unit spectrum_vis;
{ Spectrum Visualyzation by Alessandro Cappellozza
  version 0.8 05/2002
  http://digilander.iol.it/Kappe/audioobject
}

interface
  uses Windows, Graphics, SysUtils, CommonTypes, Classes;

const
  // BASS_ChannelGetData flags
  BASS_DATA_AVAILABLE = 0;        // query how much data is buffered
  BASS_DATA_FLOAT     = $40000000; // flag: return floating-point sample data
  BASS_DATA_FFT256    = $80000000; // 256 sample FFT
  BASS_DATA_FFT512    = $80000001; // 512 FFT
  BASS_DATA_FFT1024   = $80000002; // 1024 FFT
  BASS_DATA_FFT2048   = $80000003; // 2048 FFT
  BASS_DATA_FFT4096   = $80000004; // 4096 FFT
  BASS_DATA_FFT8192   = $80000005; // 8192 FFT
  BASS_DATA_FFT_INDIVIDUAL = $10; // FFT flag: FFT for each channel, else all combined
  BASS_DATA_FFT_NOWINDOW = $20;   // FFT flag: no Hanning window
  BASS_DATA_FFT_REMOVEDC = $40;   // FFT flag: pre-remove DC bias

 type TSpectrum = Class(TObject)
    private
      VisBuff : TBitmap;
      BackBmp : TBitmap;

      BkgColor : TColor;
      SpecHeight : Integer;
      PenColor : TColor;
      PeakColor: TColor;
      DrawType : Integer;
      DrawRes  : Integer;
      FrmClear : Boolean;
      UseBkg   : Boolean;
      PeakFall : Integer;
      LineFall : Integer;
      ColWidth : Integer;
      ShowPeak : Boolean;

       FFTPeacks  : array [0..128] of Integer;
       FFTFallOff : array [0..128] of Integer;

    public
     Constructor Create (Width, Height : Integer);
     procedure Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);
     procedure SetBackGround (Active : Boolean; BkgCanvas : TGraphic);

     property BackColor : TColor read BkgColor write BkgColor;
     property Height : Integer read SpecHeight write SpecHeight;
     property Width  : Integer read ColWidth write ColWidth;
     property Pen  : TColor read PenColor write PenColor;
     property Peak : TColor read PeakColor write PeakColor;
     property Mode : Integer read DrawType write DrawType;
     property Res  : Integer read DrawRes write DrawRes;
     property FrameClear : Boolean read FrmClear write FrmClear;
     property PeakFallOff: Integer read PeakFall write PeakFall;
     property LineFallOff: Integer read LineFall write LineFall;
     property DrawPeak   : Boolean read ShowPeak write ShowPeak;
  end;

 var Spectrum : TSpectrum;

implementation

     Constructor TSpectrum.Create(Width, Height : Integer);
      begin
        VisBuff := TBitmap.Create;
        BackBmp := TBitmap.Create;

          VisBuff.Width := Width;
          VisBuff.Height := Height;
          BackBmp.Width := Width;
          BackBmp.Height := Height;

          BkgColor := clBlack;
          SpecHeight := 100;
          PenColor := clWhite;
          PeakColor := clYellow;
          DrawType := 0;
          DrawRes  := 1;
          FrmClear := True;
          UseBkg := False;
          PeakFall := 1;
          LineFall := 3;
          ColWidth := 5;
          ShowPeak := True; 
      end;

     procedure TSpectrum.SetBackGround (Active : Boolean; BkgCanvas : TGraphic);
      begin
        UseBkg := Active;
        BackBmp.Canvas.Draw(0, 0, BkgCanvas);
      end;

     procedure TSpectrum.Draw(HWND : THandle; FFTData : TFFTData; X, Y : Integer);
        var i, YPos : LongInt; YVal : Single;
       begin

       if FrmClear then begin
          VisBuff.Canvas.Pen.Color := BkgColor;
          VisBuff.Canvas.Brush.Color := BkgColor;
          VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height);
           if UseBkg then VisBuff.Canvas.CopyRect(Rect(0, 0, BackBmp.Width, BackBmp.Height), BackBmp.Canvas, Rect(0, 0, BackBmp.Width, BackBmp.Height));
       end;

        VisBuff.Canvas.Pen.Color := PenColor;
         for i := 0 to 128 do begin
           YVal := Abs(FFTData[(i * DrawRes) + 5]);
           YPos := Trunc((YVal) * 500);
           if YPos > Height then YPos := SpecHeight;

           if YPos >= FFTPeacks[i] then FFTPeacks[i] := YPos
              else FFTPeacks[i] := FFTPeacks[i] - PeakFall;

           if YPos >= FFTFallOff[i] then FFTFallOff[i] := YPos
              else FFTFallOff[i] := FFTFallOff[i] - LineFall;

              if (VisBuff.Height - FFTPeacks[i]) > VisBuff.Height then FFTPeacks[i] := 0;
              if (VisBuff.Height - FFTFallOff[i]) > VisBuff.Height then FFTFallOff[i] := 0;

              case DrawType of
                0 : begin
                       VisBuff.Canvas.MoveTo(X + i, Y + VisBuff.Height);
                       VisBuff.Canvas.LineTo(X + i, Y + VisBuff.Height - FFTFallOff[i]);
                       if ShowPeak then VisBuff.Canvas.Pixels[X + i, Y + VisBuff.Height - FFTPeacks[i]] := Pen;
                    end;

                1 : begin
                     if ShowPeak then VisBuff.Canvas.Pen.Color := PeakColor;
                     if ShowPeak then VisBuff.Canvas.MoveTo(X + i * (ColWidth + 1), Y + VisBuff.Height - FFTPeacks[i]);
                     if ShowPeak then VisBuff.Canvas.LineTo(X + i * (ColWidth + 1) + ColWidth, Y + VisBuff.Height - FFTPeacks[i]);

                     VisBuff.Canvas.Pen.Color := PenColor;
                     VisBuff.Canvas.Brush.Color := PenColor;
                     VisBuff.Canvas.Rectangle(X + i * (ColWidth + 1), Y + VisBuff.Height - FFTFallOff[i], X + i * (ColWidth + 1) + ColWidth, Y + VisBuff.Height);
                    end;
              end;
         end;

          BitBlt(HWND, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy)
       end;
end.

