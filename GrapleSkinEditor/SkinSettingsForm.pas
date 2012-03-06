unit SkinSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel6: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
  private
    { Private declarations }
  public
    F1Name, F2Name, F3Name:widestring;
    F1Size, F2Size, F3Size:Single;
    F1Style, F2Style, F3Style:integer;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    begin
      F1Name:=FontDialog1.Font.Name;
      F1Size:=FontDialog1.Font.Size;
      F1Style:=0;
      if (fsBold in FontDialog1.Font.Style) then
        F1Style:=F1Style or 1;
      if (fsItalic in FontDialog1.Font.Style) then
        F1Style:=F1Style or 2;
      if (fsUnderline in FontDialog1.Font.Style) then
        F1Style:=F1Style or 4;
      if (fsStrikeOut in FontDialog1.Font.Style) then
        F1Style:=F1Style or 8;
    end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    begin
      F2Name:=FontDialog1.Font.Name;
      F2Size:=FontDialog1.Font.Size;
      F2Style:=0;
      if (fsBold in FontDialog1.Font.Style) then
        F2Style:=F2Style or 1;
      if (fsItalic in FontDialog1.Font.Style) then
        F2Style:=F2Style or 2;
      if (fsUnderline in FontDialog1.Font.Style) then
        F2Style:=F2Style or 4;
      if (fsStrikeOut in FontDialog1.Font.Style) then
        F2Style:=F2Style or 8;
    end;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    begin
      F3Name:=FontDialog1.Font.Name;
      F3Size:=FontDialog1.Font.Size;
      F3Style:=0;
      if (fsBold in FontDialog1.Font.Style) then
        F3Style:=F3Style or 1;
      if (fsItalic in FontDialog1.Font.Style) then
        F3Style:=F3Style or 2;
      if (fsUnderline in FontDialog1.Font.Style) then
        F3Style:=F3Style or 4;
      if (fsStrikeOut in FontDialog1.Font.Style) then
        F3Style:=F3Style or 8;
    end;
end;

procedure TForm3.Panel1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Panel1.Color:=ColorDialog1.Color;
end;

procedure TForm3.Panel2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Panel2.Color:=ColorDialog1.Color;
end;

procedure TForm3.Panel6Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Panel6.Color:=ColorDialog1.Color;
end;

end.
