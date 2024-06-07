object SplashDlg: TSplashDlg
  Left = 316
  Top = 196
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'SplashDlg'
  ClientHeight = 166
  ClientWidth = 210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SplashImage: TImage
    Left = 0
    Top = 0
    Width = 210
    Height = 166
    Align = alClient
  end
  object StringLabel: TLabel
    Left = 24
    Top = 64
    Width = 26
    Height = 13
    AutoSize = False
    Caption = 'Label'
    Visible = False
  end
  object Timer: TTimer
    Interval = 1
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
end
