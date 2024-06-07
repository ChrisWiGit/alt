object Form1: TForm1
  Left = 333
  Top = 253
  Width = 663
  Height = 376
  Caption = 'speed tester'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object FilenameEdit1: TFilenameEdit
    Left = 8
    Top = 16
    Width = 497
    Height = 21
    NumGlyphs = 1
    TabOrder = 0
    Text = '"F:\Projekte D7\PascalParser\speed\testfile2.txt"'
  end
  object Memo1: TMemo
    Left = 8
    Top = 120
    Width = 625
    Height = 209
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 48
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 2
  end
  object Button1: TButton
    Left = 512
    Top = 16
    Width = 75
    Height = 25
    Caption = 'analyze'
    TabOrder = 3
    OnClick = Button1Click
  end
end
