object sessionForm: TsessionForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'Add Database Connection'
  ClientHeight = 619
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    325
    619)
  PixelsPerInch = 96
  TextHeight = 13
  object gbConn: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Caption = ' Database Connection '
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 0
    Height = 113
    Width = 325
    object Label11: TLabel
      Left = 24
      Top = 57
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'Connection Method'
    end
    object Label12: TLabel
      Left = 33
      Top = 30
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = 'Connection Name'
    end
    object laGroup: TLabel
      Left = 31
      Top = 84
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = 'Connection Group'
    end
    object cbSessionType: TComboBox
      Left = 123
      Top = 54
      Width = 175
      Height = 21
      ItemIndex = 0
      TabOrder = 1
      Text = 'Direct Connection'
      OnChange = cbSessionTypeChange
      Items.Strings = (
        'Direct Connection'
        'Connection over SSH Tunnel')
    end
    object edSessionName: TEdit
      Left = 123
      Top = 27
      Width = 175
      Height = 21
      TabOrder = 0
    end
    object cbGroup: TComboBox
      Left = 123
      Top = 81
      Width = 175
      Height = 21
      Sorted = True
      TabOrder = 2
    end
  end
  object gbSSH: TcxGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 118
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = ' SSH Parameters '
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 1
    ExplicitTop = 93
    Height = 214
    Width = 325
    object Label7: TLabel
      Left = 47
      Top = 32
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = 'SSH Hostname'
    end
    object Label8: TLabel
      Left = 75
      Top = 59
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'SSH Port'
    end
    object Label9: TLabel
      Left = 47
      Top = 86
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = 'SSH Username'
    end
    object laSshPassword: TLabel
      Left = 49
      Top = 113
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'SSH Password'
    end
    object Label3: TLabel
      Left = 66
      Top = 183
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = 'Listen Port'
    end
    object edSshHost: TEdit
      Left = 123
      Top = 29
      Width = 175
      Height = 21
      TabOrder = 0
    end
    object edSshPort: TEdit
      Left = 123
      Top = 56
      Width = 175
      Height = 21
      TabOrder = 1
    end
    object edSshUsername: TEdit
      Left = 123
      Top = 83
      Width = 175
      Height = 21
      TabOrder = 2
    end
    object edSshPassword: TEdit
      Left = 123
      Top = 110
      Width = 175
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object edSshListenPort: TEdit
      Left = 123
      Top = 180
      Width = 175
      Height = 21
      TabOrder = 7
    end
    object edSshKey: TEdit
      Left = 123
      Top = 153
      Width = 151
      Height = 21
      Enabled = False
      TabOrder = 5
    end
    object buKey: TcxButton
      Left = 275
      Top = 152
      Width = 23
      Height = 23
      Action = acLoadKey
      Enabled = False
      LookAndFeel.NativeStyle = True
      TabOrder = 6
    end
    object cboxKey: TCheckBox
      Left = 124
      Top = 135
      Width = 120
      Height = 17
      Caption = 'Use private key'
      TabOrder = 4
      OnClick = cboxKeyClick
    end
  end
  object gbDB: TcxGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 337
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Database Parameters '
    Style.LookAndFeel.NativeStyle = True
    StyleDisabled.LookAndFeel.NativeStyle = True
    StyleFocused.LookAndFeel.NativeStyle = True
    StyleHot.LookAndFeel.NativeStyle = True
    TabOrder = 2
    ExplicitTop = 312
    Height = 250
    Width = 325
    object Label1: TLabel
      Left = 77
      Top = 29
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = 'Provider'
    end
    object Label2: TLabel
      Left = 85
      Top = 56
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Server'
    end
    object laPort: TLabel
      Left = 97
      Top = 137
      Width = 20
      Height = 13
      Alignment = taRightJustify
      Caption = 'Port'
    end
    object Label4: TLabel
      Left = 65
      Top = 83
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = 'User Name'
    end
    object Label5: TLabel
      Left = 71
      Top = 110
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Password'
    end
    object laDatabase: TLabel
      Left = 71
      Top = 164
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Database'
    end
    object laEnvironment: TLabel
      Left = 57
      Top = 215
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = 'Environment'
    end
    object cbProvider: TComboBox
      Left = 123
      Top = 26
      Width = 175
      Height = 22
      Style = csOwnerDrawFixed
      TabOrder = 0
      OnChange = cbProviderChange
      OnDrawItem = cbProviderDrawItem
    end
    object edServer: TEdit
      Left = 123
      Top = 53
      Width = 175
      Height = 21
      TabOrder = 1
    end
    object edPort: TEdit
      Left = 123
      Top = 134
      Width = 175
      Height = 21
      TabOrder = 4
    end
    object edUser: TEdit
      Left = 123
      Top = 80
      Width = 175
      Height = 21
      TabOrder = 2
    end
    object edPass: TEdit
      Left = 123
      Top = 107
      Width = 175
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object edDatabase: TEdit
      Left = 123
      Top = 161
      Width = 175
      Height = 21
      TabOrder = 5
    end
    object cbEnvironment: TcxImageComboBox
      Left = 124
      Top = 211
      EditValue = 0
      Properties.Images = dm.imListSmall
      Properties.Items = <
        item
          Description = 'Development'
          ImageIndex = 5
          Value = 0
        end
        item
          Description = 'Testing'
          ImageIndex = 6
          Value = 1
        end
        item
          Description = 'Production'
          ImageIndex = 7
          Value = 2
        end>
      Style.LookAndFeel.NativeStyle = True
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.NativeStyle = True
      TabOrder = 8
      Width = 174
    end
    object cbAutoCommit: TCheckBox
      Left = 124
      Top = 188
      Width = 97
      Height = 17
      Caption = 'Auto Commit'
      TabOrder = 6
    end
    object cbUseUnicode: TCheckBox
      Left = 214
      Top = 188
      Width = 99
      Height = 17
      Caption = 'Use Unicode'
      TabOrder = 7
    end
  end
  object buCancel: TcxButton
    Left = 227
    Top = 593
    Width = 98
    Height = 25
    Action = acCancel
    Anchors = [akLeft, akBottom]
    Cancel = True
    LookAndFeel.NativeStyle = True
    ModalResult = 2
    TabOrder = 5
    ExplicitTop = 565
  end
  object buSave: TcxButton
    Left = 123
    Top = 593
    Width = 98
    Height = 25
    Action = acSave
    Anchors = [akLeft, akBottom]
    LookAndFeel.NativeStyle = True
    TabOrder = 4
    ExplicitTop = 565
  end
  object buTest: TcxButton
    Left = 0
    Top = 593
    Width = 98
    Height = 25
    Action = acTest
    Anchors = [akLeft, akBottom]
    LookAndFeel.NativeStyle = True
    TabOrder = 3
    ExplicitTop = 565
  end
  object ac: TActionList
    Images = dm.imListSmall
    Left = 296
    object acOK: TAction
      Caption = 'Connect'
      ImageIndex = 0
    end
    object acCancel: TAction
      Caption = 'Cancel'
      ImageIndex = 1
      OnExecute = acCancelExecute
    end
    object acSave: TAction
      Caption = 'Save...'
      ImageIndex = 2
      OnExecute = acSaveExecute
    end
    object acTest: TAction
      Caption = 'Test'
      ImageIndex = 3
      OnExecute = acTestExecute
    end
    object acLoadKey: TAction
      ImageIndex = 4
      OnExecute = acLoadKeyExecute
    end
  end
  object odKey: TOpenDialog
    Filter = 'OpenSSH Private key'
    Title = 'Open Private SSH Key'
    Left = 304
    Top = 224
  end
  object Connection: TFDConnection
    LoginPrompt = False
    Left = 24
    Top = 341
  end
end
