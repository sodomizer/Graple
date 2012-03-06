object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Graple Skin Editor'
  ClientHeight = 385
  ClientWidth = 563
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 363
    Height = 385
    Align = alClient
    TabOrder = 0
    object ListBox2: TListBox
      Left = 1
      Top = 1
      Width = 361
      Height = 383
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListBox2Click
      OnDblClick = ListBox2DblClick
    end
  end
  object Panel2: TPanel
    Left = 363
    Top = 0
    Width = 200
    Height = 385
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 0
      Top = 137
      Width = 200
      Height = 248
      Align = alClient
      TabOrder = 0
      object ListBox1: TListBox
        Left = 1
        Top = 1
        Width = 198
        Height = 246
        Style = lbOwnerDrawFixed
        Align = alClient
        BorderStyle = bsNone
        ItemHeight = 100
        TabOrder = 0
        OnDrawItem = ListBox1DrawItem
        OnMouseDown = ListBox1MouseDown
        OnMouseMove = ListBox1MouseMove
        OnMouseUp = ListBox1MouseUp
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 137
      Align = alTop
      TabOrder = 1
      object Label5: TLabel
        Left = 6
        Top = 6
        Width = 17
        Height = 13
        Caption = 'Id: '
      end
      object Label6: TLabel
        Left = 6
        Top = 22
        Width = 68
        Height = 13
        Caption = 'Image Index: '
      end
      object Label7: TLabel
        Left = 6
        Top = 41
        Width = 77
        Height = 13
        Caption = 'X:           Y:        '
      end
      object Label8: TLabel
        Left = 102
        Top = 41
        Width = 79
        Height = 13
        Caption = 'W:           H:       '
      end
      object Label9: TLabel
        Left = 6
        Top = 60
        Width = 41
        Height = 13
        Caption = 'ZOrder: '
      end
      object Label10: TLabel
        Left = 6
        Top = 79
        Width = 32
        Height = 13
        Caption = 'Color: '
      end
      object Label11: TLabel
        Left = 6
        Top = 98
        Width = 23
        Height = 13
        Caption = 'Tile: '
      end
      object Label12: TLabel
        Left = 6
        Top = 117
        Width = 60
        Height = 13
        Caption = 'Flip/Rotate: '
      end
      object Label13: TLabel
        Left = 29
        Top = 6
        Width = 3
        Height = 13
      end
      object Label14: TLabel
        Left = 80
        Top = 22
        Width = 3
        Height = 13
      end
      object Label15: TLabel
        Left = 53
        Top = 60
        Width = 3
        Height = 13
      end
      object Label16: TLabel
        Left = 35
        Top = 98
        Width = 3
        Height = 13
      end
      object Label17: TLabel
        Left = 72
        Top = 117
        Width = 3
        Height = 13
      end
      object Panel6: TPanel
        Left = 44
        Top = 79
        Width = 37
        Height = 13
        BevelOuter = bvLowered
        Color = clBlack
        ParentBackground = False
        TabOrder = 0
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object SkinOptions1: TMenuItem
        Caption = 'Skin Options...'
        OnClick = SkinOptions1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Elements1: TMenuItem
      Caption = 'Elements'
      object Add1: TMenuItem
        Caption = 'Add...'
        OnClick = Add1Click
      end
      object Clone1: TMenuItem
        Caption = 'Clone'
        OnClick = Clone1Click
      end
      object Modify1: TMenuItem
        Caption = 'Modify...'
        OnClick = Modify1Click
      end
      object Delete1: TMenuItem
        Caption = 'Delete'
        OnClick = Delete1Click
      end
    end
    object Images1: TMenuItem
      Caption = 'Images'
      object Add2: TMenuItem
        Caption = 'Add...'
        OnClick = Add2Click
      end
      object Replace1: TMenuItem
        Caption = 'Replace...'
        OnClick = Replace1Click
      end
      object Delete2: TMenuItem
        Caption = 'Delete'
        OnClick = Delete2Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object ToggleBackground1: TMenuItem
        AutoCheck = True
        Caption = 'Toggle Background'
        OnClick = ToggleBackground1Click
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 48
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Graple Skins (*.gsk)|*.gsk|Graple Skin Projects (*.gsp)|*.gsp|Al' +
      'l Files (*.*)|*.*'
    Left = 88
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 128
    Top = 8
  end
end
