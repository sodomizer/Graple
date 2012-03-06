object Form3: TForm3
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'SkinSettings'
  ClientHeight = 221
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    192
    221)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 49
    Height = 13
    Caption = 'Skin Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object Label2: TLabel
    Left = 9
    Top = 38
    Width = 33
    Height = 13
    Caption = 'Author'
  end
  object Label4: TLabel
    Left = 8
    Top = 92
    Width = 35
    Height = 13
    Caption = 'Version'
  end
  object Label5: TLabel
    Left = 8
    Top = 123
    Width = 50
    Height = 13
    Caption = 'Main Color'
  end
  object Label6: TLabel
    Left = 8
    Top = 142
    Width = 34
    Height = 13
    Caption = 'Color 2'
  end
  object Label7: TLabel
    Left = 8
    Top = 161
    Width = 34
    Height = 13
    Caption = 'Color 3'
  end
  object Edit1: TEdit
    Left = 64
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Edit3: TEdit
    Left = 64
    Top = 62
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 64
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 64
    Top = 89
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object Panel6: TPanel
    Left = 64
    Top = 123
    Width = 37
    Height = 13
    BevelOuter = bvLowered
    Color = clBlack
    ParentBackground = False
    TabOrder = 4
    OnClick = Panel6Click
  end
  object Panel1: TPanel
    Left = 64
    Top = 142
    Width = 37
    Height = 13
    BevelOuter = bvLowered
    Color = clBlack
    ParentBackground = False
    TabOrder = 5
    OnClick = Panel1Click
  end
  object Panel2: TPanel
    Left = 64
    Top = 161
    Width = 37
    Height = 13
    BevelOuter = bvLowered
    Color = clBlack
    ParentBackground = False
    TabOrder = 6
    OnClick = Panel2Click
  end
  object Button1: TButton
    Left = 120
    Top = 123
    Width = 65
    Height = 15
    Caption = 'Main Font'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 142
    Width = 65
    Height = 15
    Caption = 'Font 2'
    TabOrder = 8
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 120
    Top = 161
    Width = 65
    Height = 15
    Caption = 'Font 3'
    TabOrder = 9
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 109
    Top = 188
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 10
  end
  object Button5: TButton
    Left = 28
    Top = 188
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 8
    Top = 16
  end
  object ColorDialog1: TColorDialog
    Left = 8
    Top = 48
  end
end
