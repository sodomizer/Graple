unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, GDIImageList, GDIPAPI, GDIPOBJ, ExtDlgs,
  ComCtrls, Skins;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Elements1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    Modify1: TMenuItem;
    Images1: TMenuItem;
    Add2: TMenuItem;
    Delete2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    ListBox2: TListBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel6: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    SkinOptions1: TMenuItem;
    N2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Replace1: TMenuItem;
    Clone1: TMenuItem;
    N3: TMenuItem;
    ToggleBackground1: TMenuItem;
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure Modify1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure SkinOptions1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure Clone1Click(Sender: TObject);
    procedure ToggleBackground1Click(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    Pressed:boolean;
    PrevIndex:integer;
    function EditElement(Index:integer):boolean;
  public
    Skin:TSkin;
    ImgList:TGDIImageList;
    FName:string;
  end;

var
  Form1: TForm1;

implementation

uses ElementForm, SkinSettingsForm;

{$R *.dfm}

procedure TForm1.Add1Click(Sender: TObject);
var p:TPoint;
    c:TRGBQuad;
begin
  p.X:=0;
  p.Y:=0;
  c.rgbBlue:=0;
  c.rgbGreen:=0;
  c.rgbRed:=0;
  c.rgbReserved:=255;
  ListBox2.Items.Add('New Element');
  Skin.Images.AddImage('New Element', 0, p, p, 0, 0, 0, c, -1);
  if not EditElement(ListBox2.Count-1) then
    begin
      Skin.Images.RemoveImage(ListBox2.Count-1);
      ListBox2.Items.Delete(ListBox2.Count-1);
    end;
end;

procedure TForm1.Add2Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    begin
      ImgList.AddImage(TGPBitmap.Create(OpenPictureDialog1.FileName));
      ListBox1.Items.Add(OpenPictureDialog1.FileName);
    end;
end;

procedure TForm1.Clone1Click(Sender: TObject);
var i:integer;
    p:TSImage;
begin
  i:=ListBox2.ItemIndex;
  if (i<0)or(i>=ListBox2.Count) then
    Exit;

  if Skin.Images.Clone(i) then
    begin
      ListBox2.Items.Add('New Element');
      if not EditElement(ListBox2.Count-1) then
        begin
          Skin.Images.RemoveImage(ListBox2.Count-1);
          ListBox2.Items.Delete(ListBox2.Count-1);
        end;
    end;
end;

procedure TForm1.Delete1Click(Sender: TObject);
var i:integer;
begin
  i:=ListBox2.ItemIndex;
  if (i<1)or(i>=ListBox2.Count) then
    Exit;
  ListBox2.Items.Delete(i);
  Skin.Images.RemoveImage(i);
end;

procedure TForm1.Delete2Click(Sender: TObject);
var i:integer;
    p:PSImage;
begin
  i:=ListBox1.ItemIndex;
  if (i>-1)and(i<ListBox1.Count) then
    begin
      ListBox1.Items.Delete(i);
      ImgList.FreeAndRemoveImage(i);
      p:=Skin.Images.First;
      while p<>nil do
        begin
          if p.ImageIndex=i then
            p.ImageIndex:=-1
          else
            if p.ImageIndex>i then
              p.ImageIndex:=p.ImageIndex-1;
          p:=p.Next;
        end;
    end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenPictureDialog1.Filter:= 'All Images(*.png;*.gif;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.png;*.gif;*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf|'+
                              'Portable Network Graphics (*.png)|*.png|'+
                              'GIF Image (*.gif)|*.gif|'+
                              'JPEG Image File (*.jpg;*.jpeg)|*.jpg;*.jpeg|'+
                              'Bitmaps (*.bmp)|*.bmp|'+
                              'Icons (*.ico)|*.ico|'+
                              'Enhanced Metafiles (*.emf)|*.emf|'+
                              'Metafiles (*.wmf)|*.wmf';
  Skin:=TSkin.Create;
  ImgList:=TGDIImageList.Create;
  New1.Click;
end;

procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var g:TGPGraphics;
    b:TGPBrush;
    p:TGPPen;
    i:TGPBitmap;
    aspect:single;
    nw, nh:integer;
begin
  g:=TGPGraphics.Create((Control as TListBox).Canvas.Handle);
  if ToggleBackGround1.Checked then
    b:=TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(clBlack)))
  else
    b:=TGPSolidBrush.Create(ColorRefToARGB(ColorToRGB(clWindow)));
  g.FillRectangle(b, Rect.Left, Rect.Top, Rect.Right-Rect.Left, Rect.Bottom-Rect.Top);
  i:=ImgList.Images[Index];
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
      if not ToggleBackGround1.Checked then
        p:=TGPPen.Create(ColorRefToARGB(ColorToRGB(clBlack)))
      else
        p:=TGPPen.Create(ColorRefToARGB(ColorToRGB(clWindow)));
      g.DrawRectangle(p, Rect.Left, Rect.Top, Rect.Right-Rect.Left-1, Rect.Bottom-Rect.Top-1);
      p.Free;
    end;
  b.Free;
  g.Free;
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Pressed:=true;
  PrevIndex:=ListBox1.ItemIndex;
  ListBox1.Repaint;
end;

procedure TForm1.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Pressed and (PrevIndex<>ListBox1.ItemIndex) then
    begin
      PrevIndex:=ListBox1.ItemIndex;
      ListBox1.Repaint;
    end;
end;

procedure TForm1.ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Pressed:=false;
end;

procedure TForm1.ListBox2Click(Sender: TObject);
begin
  if not ((ListBox2.ItemIndex>-1)and(ListBox2.ItemIndex<ListBox2.Count)) then
    Exit;
  Label13.Caption:=ConstTable.Values[Skin.Images.Images[ListBox2.ItemIndex].ID] +' ('+IntToStr(Skin.Images.Images[ListBox2.ItemIndex].ID)+')';
  Label14.Caption:=IntToStr(Skin.Images.Images[ListBox2.ItemIndex].ImageIndex);
  Label7.Caption:=Format('X: %6d    Y: %6d', [Skin.Images.Images[ListBox2.ItemIndex].Pos.X, Skin.Images.Images[ListBox2.ItemIndex].Pos.Y]);
  Label8.Caption:=Format('W: %6d    H: %6d', [Skin.Images.Images[ListBox2.ItemIndex].Size.X, Skin.Images.Images[ListBox2.ItemIndex].Size.Y]);
  Label15.Caption:=IntToStr(Skin.Images.Images[ListBox2.ItemIndex].ZOrder);
  Panel6.Color:=Cardinal(Skin.Images.Images[ListBox2.ItemIndex].Color);
  case Skin.Images.Images[ListBox2.ItemIndex].Tile of
    SKIN_FLAG_STRETCH: Label16.Caption:='Stretch';
    SKIN_FLAG_CLAMP:   Label16.Caption:='Clamp';
    SKIN_FLAG_TILEFLIPXY:   Label16.Caption:='Tile Flip XY';
    SKIN_FLAG_TILEFLIPY:   Label16.Caption:='Tile Flip X';
    SKIN_FLAG_TILEFLIPX:   Label16.Caption:='Tile Flip Y';
    SKIN_FLAG_TILE:   Label16.Caption:='Tile';
  end;
  if Skin.Images.Images[ListBox2.ItemIndex].FlipRotate=SKIN_FLAG_NORMAL then
    Label17.Caption:='Normal'
  else
    begin
      Label17.Caption:='Rotate';
      if (Skin.Images.Images[ListBox2.ItemIndex].FlipRotate and SKIN_FLAG_ROT90)=SKIN_FLAG_ROT90 then
        Label17.Caption:=Label17.Caption+' 90';
      if (Skin.Images.Images[ListBox2.ItemIndex].FlipRotate and SKIN_FLAG_ROT180)=SKIN_FLAG_ROT180 then
        Label17.Caption:=Label17.Caption+' 180';
      if (Skin.Images.Images[ListBox2.ItemIndex].FlipRotate and (SKIN_FLAG_ROT90 or SKIN_FLAG_ROT180))=0 then
        Label17.Caption:=Label17.Caption+' 0';
      if (Skin.Images.Images[ListBox2.ItemIndex].FlipRotate and SKIN_FLAG_FLIPH)=SKIN_FLAG_FLIPH then
        Label17.Caption:=Label17.Caption+' Flip H';
    end;
end;

function TForm1.EditElement(Index:integer):boolean;
var i:integer;
begin
  Result:=false;
  with Skin.Images.Images[Index]^ do
    begin
      if ID<SKIN_CUSTOM then
          begin
            Form2.ComboBox1.ItemIndex:=ID div 100;
            Form2.ComboBox1.OnChange(nil);
            if ID<=SKIN_MAIN_END then
              Form2.ComboBox2.ItemIndex:=ID
            else
              Form2.ComboBox2.ItemIndex:=ID-100*(ID div 100)-1;
          end
        else
          begin
            Form2.ComboBox1.ItemIndex:=Form2.ComboBox1.Items.Count-1;
            Form2.ComboBox1.OnChange(nil);
            Form2.ComboBox2.ItemIndex:=-1;
          end;
      Form2.ListBox1.Clear;
      for i:=0 to ListBox1.Count-1 do
        Form2.ListBox1.Items.Add('');
      Form2.ListBox1.ItemIndex:=ImageIndex;
      Form2.Edit1.Enabled:=ID>=SKIN_CUSTOM;
      Form2.ComboBox2.Enabled:=ID<SKIN_CUSTOM;
      Form2.Edit2.Text:=ElementName;
      Form2.Edit3.Text:=IntToStr(Pos.X);
      Form2.Edit4.Text:=IntToStr(Pos.Y);
      Form2.Edit5.Text:=IntToStr(Size.X);
      Form2.Edit6.Text:=IntToStr(Size.Y);
      Form2.Edit7.Text:=IntToStr(ZOrder);
      Form2.Panel6.Color:=Cardinal(Color);
      Form2.ComboBox3.ItemIndex:=Tile;
      Form2.ComboBox4.ItemIndex:=FlipRotate;
    end;
  if Form2.ShowModal=mrOk then
    with Skin.Images.Images[Index]^ do
      begin
        if Form2.ComboBox1.ItemIndex=0 then
          ID:=Form2.ComboBox2.ItemIndex
        else
          if Form2.ComboBox1.ItemIndex=Form2.ComboBox1.Items.Count-1 then
            ID:=StrToInt(Form2.Edit1.Text)
          else
            ID:=Form2.ComboBox1.ItemIndex*100+Form2.ComboBox2.ItemIndex+1;
        ImageIndex:=Form2.ListBox1.ItemIndex;
        ElementName:=Form2.Edit2.Text;
        Pos.X:=StrToInt(Form2.Edit3.Text);
        Pos.Y:=StrToInt(Form2.Edit4.Text);
        Size.X:=StrToInt(Form2.Edit5.Text);
        Size.Y:=StrToInt(Form2.Edit6.Text);
        ZOrder:=StrToInt(Form2.Edit7.Text);
        Color:=TRGBQuad(Form2.Panel6.Color);
        Tile:=Form2.ComboBox3.ItemIndex;
        FlipRotate:=Form2.ComboBox4.ItemIndex;

        Result:=true;
        ListBox2.Items.Strings[Index]:=ElementName;
        ListBox2.OnClick(nil);
    end;
end;

procedure TForm1.ListBox2DblClick(Sender: TObject);
begin
  EditElement(ListBox2.ItemIndex);
end;

procedure TForm1.Modify1Click(Sender: TObject);
begin
  EditElement(ListBox2.ItemIndex);
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  ImgList.FreeAndClear;
  ListBox1.Clear;
  ListBox2.Clear;
  Skin.NewSkin;
  ListBox2.Items.Add(Skin.Images.First.ElementName);
  FName:='';
end;

procedure TForm1.Open1Click(Sender: TObject);
var i:integer;
begin
  if OpenDialog1.Execute then
    begin
      ImgList.FreeAndClear;
      ListBox1.Clear;
      ListBox2.Clear;
      if ExtractFileExt(OpenDialog1.FileName)='.gsp' then
      else
        begin
          if Skin.LoadFromFile(OpenDialog1.FileName, ImgList) then
            begin
              for i:=0 to Skin.Images.Count-1 do
                ListBox2.Items.Add(ConstTable.Values[Skin.Images.Images[i].ID]);
              for i:=0 to ImgList.Count-1 do
                ListBox1.Items.Add('Internal');
              FName:=OpenDialog1.FileName;
            end
          else
            MessageBox(0, 'Cannot load file!', 'Error', MB_ICONERROR);
      end;
    end;

end;

procedure TForm1.Replace1Click(Sender: TObject);
var b:TGPBitmap;
    i:integer;
begin
  i:=ListBox1.ItemIndex;
  if (i>-1)and(i<ListBox1.Count)and OpenPictureDialog1.Execute then
    begin
      b:=TGPBitmap.Create(OpenPictureDialog1.FileName);
      ImgList.Images[i].Free;
      ImgList.Images[i]:=b;
      ListBox1.Items.Strings[i]:=(OpenPictureDialog1.FileName);
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if FName<>'' then
    if ExtractFileExt(FName)='.gsp' then
      //Skin.SaveToIni(FName)
    else
      Skin.SaveToFile(FName, ImgList)
  else
    SaveAs1.Click;
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    begin
      if ExtractFileExt(SaveDialog1.FileName)='.gsp' then
        //Skin.SaveToIni(FName)
      else
        Skin.SaveToFile(SaveDialog1.FileName, ImgList);
      FName:=SaveDialog1.FileName;
    end;
end;

procedure TForm1.SkinOptions1Click(Sender: TObject);
var f:TSFont;
begin
  Form3.Edit1.Text:=Skin.Name;
  Form3.Edit2.Text:=Skin.Author;
  Form3.Edit3.Text:=Skin.Description;
  Form3.Edit4.Text:=Skin.Version;
  Form3.F1Name:=Skin.MainFont.Name;
  Form3.F2Name:=Skin.Font2.Name;
  Form3.F3Name:=Skin.Font3.Name;
  Form3.F1Size:=Skin.MainFont.Size;
  Form3.F2Size:=Skin.Font2.Size;
  Form3.F3Size:=Skin.Font3.Size;
  Form3.F1Style:=Skin.MainFont.Style;
  Form3.F2Style:=Skin.Font2.Style;
  Form3.F3Style:=Skin.Font3.Style;
  Form3.Panel6.Color:=ARGBToColorRef(Skin.MainColor);
  Form3.Panel1.Color:=ARGBToColorRef(Skin.Color2);
  Form3.Panel2.Color:=ARGBToColorRef(Skin.Color3);
  if Form3.ShowModal=mrOk then
    begin
      Skin.Name:=Form3.Edit1.Text;
      Skin.Author:=Form3.Edit2.Text;
      Skin.Description:=Form3.Edit3.Text;
      Skin.Version:=Form3.Edit4.Text;

      f.Name:=Form3.F1Name;
      f.Size:=Form3.F1Size;
      f.Style:=Form3.F1Style;
      Skin.MainFont:=f;

      f.Name:=Form3.F2Name;
      f.Size:=Form3.F2Size;
      f.Style:=Form3.F2Style;
      Skin.Font2:=f;

      f.Name:=Form3.F3Name;
      f.Size:=Form3.F3Size;
      f.Style:=Form3.F3Style;
      Skin.Font3:=f;

      Skin.MainColor:=TColorToARGB(Form3.Panel6.Color);
      Skin.Color2:=TColorToARGB(Form3.Panel1.Color);
      Skin.Color3:=TColorToARGB(Form3.Panel2.Color);
    end;
end;

procedure TForm1.ToggleBackground1Click(Sender: TObject);
begin
  ListBox1.Repaint;
end;

end.
