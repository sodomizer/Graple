unit ElementForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Skins, GDIPAPI, GDIPOBJ;

type
  TForm2 = class(TForm)
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel6: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ListBox1: TListBox;
    ColorDialog1: TColorDialog;
    Button3: TButton;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Panel6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button3Click(Sender: TObject);
begin
  ListBox1.ItemIndex:=-1;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
var i:integer;
begin
  ComboBox2.Clear;
  case ComboBox1.ItemIndex of
    0:  for i:=SKIN_MAIN to SKIN_MAIN_END do
          ComboBox2.Items.Add(ConstTable.Values[i]);
    1 :  for i:=SKIN_WND_FILL to SKIN_WND_END do
          ComboBox2.Items.Add(ConstTable.Values[i]);
    2, 3, 4:
        begin
          for i:=SKIN_SYSBUT_CLOSE to SKIN_SYSBUT_END do
            ComboBox2.Items.Add(ConstTable.Values[i]);
        end;
    5, 6, 7:
        begin
          for i:=SKIN_BUTTON_EMPTY to SKIN_BUTTON_END do
            ComboBox2.Items.Add(ConstTable.Values[i]);
        end;
    8, 9, 10, 11, 12, 13:
        begin
          for i:=SKIN_TGLBUT_EMPTY to SKIN_TGLBUT_END do
            ComboBox2.Items.Add(ConstTable.Values[i]);
        end;
    14:
        begin
          for i:=SKIN_STATIC_FILEINFO to SKIN_STATIC_END do
            ComboBox2.Items.Add(ConstTable.Values[i]);
        end;
    15:
        begin
          for i:=SKIN_TRACKBAR_POS to SKIN_TRACKBAR_END do
            ComboBox2.Items.Add(ConstTable.Values[i]);
        end;
    16:
        begin
          Edit1.Enabled:=true;
          ComboBox2.Enabled:=false;
        end;
  end;
  if ComboBox1.ItemIndex<>16 then
    begin
      ComboBox2.Enabled:=true;
      ComboBox2.ItemIndex:=0;
      Edit1.Enabled:=False;
    end;
end;

procedure TForm2.Edit1Exit(Sender: TObject);
var v:integer;
begin
  if not (TryStrToInt(Edit1.Text, v) and (v>=10000)) then
    begin
      Beep;
      Edit1.SetFocus;
    end;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, #9]) then
    Key:=#0;
end;

procedure TForm2.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', '-', #8, #9]) then

end;

procedure TForm2.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var g:TGPGraphics;
    b:TGPBrush;
    p:TGPPen;
    i:TGPBitmap;
    aspect:single;
    nw, nh:integer;
begin
  g:=TGPGraphics.Create((Control as TListBox).Canvas.Handle);
  if Form1.ToggleBackGround1.Checked then
    b:=TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(clBlack)))
  else
    b:=TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(clWindow)));
  g.FillRectangle(b, Rect.Left, Rect.Top, Rect.Right-Rect.Left, Rect.Bottom-Rect.Top);
  i:=Form1.ImgList.Images[Index];
  if i<>nil then
    begin
      aspect:=i.GetHeight/i.GetWidth;
      nw:=Round((Control as TListBox).ItemHeight/aspect);
      if nw>(Control as TListBox).Width then
        nw:=(Control as TListBox).Width;
      nh:=Round(nw*aspect);
      if nw=(Control as TListBox).Width then
        g.DrawImage(i, Rect.Left, Rect.Top+(Rect.Bottom-Rect.Top-nh) div 2, nw, nh)
      else
        g.DrawImage(i, (Rect.Right-Rect.Left-nw) div 2, Rect.Top, nw, nh);
    end;
  if Index=ListBox1.ItemIndex then
    begin
      if not Form1.ToggleBackGround1.Checked then
        p:=TGPPen.Create(ColorRefToARGB(ColorToRGB(clBlack)))
      else
        p:=TGPPen.Create(ColorRefToARGB(ColorToRGB(clWindow)));
      g.DrawRectangle(p, Rect.Left, Rect.Top, Rect.Right-Rect.Left-1, Rect.Bottom-Rect.Top-1);
      p.Free;
    end;
  b.Free;
  g.Free;
end;

procedure TForm2.Panel6Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Panel6.Color:=ColorDialog1.Color;
end;

end.
