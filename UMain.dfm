object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderWidth = 10
  Caption = 'iTEF - Integrador de Dispositivos'
  ClientHeight = 267
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 248
    Width = 603
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 603
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 10
    Caption = 'Panel1'
    TabOrder = 1
    object Button1: TButton
      Left = 10
      Top = 10
      Width = 161
      Height = 36
      Align = alLeft
      Caption = 'Simular Venda'
      TabOrder = 0
      OnClick = Button1Click
    end
    object BitBtn1: TBitBtn
      Left = 171
      Top = 10
      Width = 161
      Height = 36
      Align = alLeft
      Caption = 'Cancela Cupom'
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object Button2: TButton
      Left = 332
      Top = 10
      Width = 67
      Height = 36
      Align = alLeft
      Caption = 'RZ'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 96
    Width = 587
    Height = 113
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 544
    Top = 32
  end
end
