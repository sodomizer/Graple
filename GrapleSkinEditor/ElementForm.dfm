object Form2: TForm2
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Modify Element'
  ClientHeight = 343
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    383
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object Label10: TLabel
    Left = 79
    Top = 169
    Width = 32
    Height = 13
    Caption = 'Color: '
  end
  object Label11: TLabel
    Left = 8
    Top = 216
    Width = 23
    Height = 13
    Caption = 'Tile: '
  end
  object Label12: TLabel
    Left = 8
    Top = 262
    Width = 60
    Height = 13
    Caption = 'Flip/Rotate: '
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 17
    Height = 13
    Caption = 'Id: '
  end
  object Label6: TLabel
    Left = 160
    Top = 35
    Width = 37
    Height = 13
    Caption = 'Image: '
  end
  object Label7: TLabel
    Left = 8
    Top = 81
    Width = 44
    Height = 13
    Caption = 'Position: '
  end
  object Label8: TLabel
    Left = 8
    Top = 124
    Width = 26
    Height = 13
    Caption = 'Size: '
  end
  object Label9: TLabel
    Left = 8
    Top = 170
    Width = 41
    Height = 13
    Caption = 'ZOrder: '
  end
  object Label1: TLabel
    Left = 8
    Top = 35
    Width = 75
    Height = 13
    Caption = 'Element Name: '
  end
  object Panel6: TPanel
    Left = 79
    Top = 189
    Width = 65
    Height = 21
    BevelOuter = bvLowered
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    OnClick = Panel6Click
  end
  object ComboBox1: TComboBox
    Left = 31
    Top = 8
    Width = 114
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBox1Change
    Items.Strings = (
      'Main'
      'Window'
      'System Buttons'
      'System Buttons Hover'
      'System Buttons Pressed'
      'Buttons'
      'Buttons Hover'
      'Buttons Pressed'
      'Toggle Button'
      'Toggle Button Hover'
      'Toggle Button Pressed'
      'Toggle Button Toggled'
      'Toggle Button Toggled Hover'
      'Toggle Button Toggled Pressed'
      'Static'
      'Trackbar'
      'Custom')
  end
  object ComboBox2: TComboBox
    Left = 151
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 302
    Top = 8
    Width = 73
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '10000'
    OnExit = Edit1Exit
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 300
    Top = 310
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object Button2: TButton
    Left = 219
    Top = 310
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Edit2: TEdit
    Left = 8
    Top = 54
    Width = 137
    Height = 21
    TabOrder = 6
  end
  object Edit3: TEdit
    Left = 8
    Top = 97
    Width = 65
    Height = 21
    TabOrder = 7
    OnKeyPress = Edit3KeyPress
  end
  object Edit4: TEdit
    Left = 79
    Top = 97
    Width = 66
    Height = 21
    TabOrder = 8
    OnKeyPress = Edit3KeyPress
  end
  object Edit5: TEdit
    Left = 8
    Top = 143
    Width = 65
    Height = 21
    TabOrder = 9
    OnKeyPress = Edit3KeyPress
  end
  object Edit6: TEdit
    Left = 79
    Top = 143
    Width = 66
    Height = 21
    TabOrder = 10
    OnKeyPress = Edit3KeyPress
  end
  object Edit7: TEdit
    Left = 8
    Top = 189
    Width = 65
    Height = 21
    TabOrder = 11
    OnKeyPress = Edit1KeyPress
  end
  object ComboBox3: TComboBox
    Left = 8
    Top = 235
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
    Items.Strings = (
      'Stretch'
      'Clamp'
      'Tile Flip XY'
      'Tile Flip Y'
      'Tile Flip X'
      'Tile')
  end
  object ComboBox4: TComboBox
    Left = 8
    Top = 281
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 13
    Items.Strings = (
      'Normal'
      'Rotate 90'
      'Rotate 180'
      'Rotate 270'
      'Flip Horizontal'
      'Flip Horizontal Rotate 90'
      'Flip Vertical'
      'Flip Verticall Rotate 90')
  end
  object ListBox1: TListBox
    Left = 160
    Top = 54
    Width = 215
    Height = 250
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 100
    TabOrder = 14
    OnDrawItem = ListBox1DrawItem
  end
  object Button3: TButton
    Left = 321
    Top = 35
    Width = 54
    Height = 17
    Caption = 'Clear'
    TabOrder = 15
    OnClick = Button3Click
  end
  object ColorDialog1: TColorDialog
    Left = 8
    Top = 312
  end
end
