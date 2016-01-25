object Preferences: TPreferences
  Left = 0
  Top = 0
  Caption = 'Preferences'
  ClientHeight = 554
  ClientWidth = 334
  Color = clBtnFace
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 526
    Width = 334
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      334
      28)
    object buCancel: TcxButton
      Left = 254
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 11
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = dm.imListSmall
      TabOrder = 0
    end
    object buSave: TcxButton
      Left = 173
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save'
      OptionsImage.ImageIndex = 2
      OptionsImage.Images = dm.imListSmall
      TabOrder = 1
      OnClick = buSaveClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 334
    Height = 526
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object cxPageControl1: TcxPageControl
      Left = 4
      Top = 4
      Width = 326
      Height = 518
      Align = alClient
      TabOrder = 0
      Properties.ActivePage = tsGeneral
      Properties.CustomButtons.Buttons = <>
      ClientRectBottom = 514
      ClientRectLeft = 4
      ClientRectRight = 322
      ClientRectTop = 24
      object tsGeneral: TcxTabSheet
        BorderWidth = 4
        Caption = 'General'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object GroupBox5: TGroupBox
          Left = 0
          Top = 0
          Width = 310
          Height = 97
          Align = alTop
          Caption = ' File Open/Save '
          TabOrder = 0
          object Label18: TLabel
            Left = 21
            Top = 28
            Width = 61
            Height = 13
            Alignment = taRightJustify
            Caption = 'Sql Directory'
          end
          object Label23: TLabel
            Left = 28
            Top = 55
            Width = 54
            Height = 13
            Alignment = taRightJustify
            Caption = 'Line Ending'
          end
          object edSqlDirectory: TEdit
            Left = 88
            Top = 25
            Width = 174
            Height = 21
            TabOrder = 0
          end
          object cbLineEnding: TComboBox
            Left = 88
            Top = 52
            Width = 200
            Height = 21
            TabOrder = 2
            Text = 'Windows'
            Items.Strings = (
              'Windows'
              'Unix'
              'Mac OS')
          end
          object buSqlDirectory: TcxButton
            Left = 265
            Top = 24
            Width = 23
            Height = 23
            OptionsImage.ImageIndex = 4
            OptionsImage.Images = dm.imListSmall
            SpeedButtonOptions.GroupIndex = 2
            TabOrder = 1
            OnClick = buSqlDirectoryClick
          end
        end
        object GroupBox6: TGroupBox
          Left = 0
          Top = 97
          Width = 310
          Height = 56
          Align = alTop
          Caption = ' Layout '
          TabOrder = 1
          object cboxShowObjectInspector: TCheckBox
            Left = 16
            Top = 24
            Width = 272
            Height = 17
            Caption = 'Show Object Inspector'
            TabOrder = 0
          end
        end
      end
      object tsEditor: TcxTabSheet
        BorderWidth = 4
        Caption = 'SQL Editor'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 310
          Height = 120
          Align = alTop
          Caption = ' Font '
          TabOrder = 0
          object Label7: TLabel
            Left = 32
            Top = 58
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font Color'
          end
          object Label8: TLabel
            Left = 26
            Top = 85
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Background'
          end
          object Label5: TLabel
            Left = 33
            Top = 28
            Width = 49
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font Type'
          end
          object ceEditorColor: TdxColorEdit
            Left = 88
            Top = 54
            ColorValue = clBlack
            Properties.ColorSet = csCustom
            Properties.OnInitPopup = ColorEditInitPopup
            TabOrder = 0
            Width = 89
          end
          object buFontEditor: TcxButton
            Left = 88
            Top = 23
            Width = 89
            Height = 25
            Caption = 'Font...'
            OptionsImage.ImageIndex = 19
            OptionsImage.Images = dm.imListSmall
            TabOrder = 1
            OnClick = buFontEditorClick
          end
          object ceEditorBackground: TdxColorEdit
            Left = 88
            Top = 81
            ColorValue = clWhite
            Properties.ColorSet = csCustom
            Properties.OnInitPopup = ColorEditInitPopup
            TabOrder = 2
            Width = 89
          end
        end
        object GroupBox2: TGroupBox
          Left = 0
          Top = 120
          Width = 310
          Height = 362
          Align = alClient
          Caption = ' Syntax Highlight  '
          TabOrder = 1
          object sePreview: TSynEdit
            AlignWithMargins = True
            Left = 6
            Top = 167
            Width = 298
            Height = 189
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 0
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Courier New'
            Gutter.Font.Style = []
            Gutter.LeftOffset = 0
            Gutter.ShowLineNumbers = True
            Highlighter = syntax
            Lines.Strings = (
              'select'
              '  count(*) no, # Testing'
              '  coalesce(name, desc) name'
              'from'
              '  MyTable'
              'where'
              '  name like '#39'sql'#39
              'order by'
              '  id desc')
            Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
            ReadOnly = True
            RightEdge = 0
            FontSmoothing = fsmNone
          end
          object Panel3: TPanel
            Left = 2
            Top = 15
            Width = 306
            Height = 148
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label15: TLabel
              Left = 8
              Top = 133
              Width = 38
              Height = 13
              Caption = 'Preview'
            end
            object laComments: TLabel
              Left = 13
              Top = 75
              Width = 50
              Height = 13
              Alignment = taRightJustify
              Caption = 'Comments'
            end
            object laDataTypes: TLabel
              Left = 8
              Top = 103
              Width = 55
              Height = 13
              Alignment = taRightJustify
              Caption = 'Data Types'
            end
            object laFunctions: TLabel
              Left = 17
              Top = 47
              Width = 46
              Height = 13
              Alignment = taRightJustify
              Caption = 'Functions'
            end
            object laKeywords: TLabel
              Left = 16
              Top = 19
              Width = 47
              Height = 13
              Alignment = taRightJustify
              Caption = 'Keywords'
            end
            object laNumbers: TLabel
              Left = 166
              Top = 47
              Width = 42
              Height = 13
              Alignment = taRightJustify
              Caption = 'Numbers'
            end
            object laStrings: TLabel
              Left = 175
              Top = 75
              Width = 33
              Height = 13
              Alignment = taRightJustify
              Caption = 'Strings'
            end
            object laTables: TLabel
              Left = 177
              Top = 19
              Width = 31
              Height = 13
              Alignment = taRightJustify
              Caption = 'Tables'
            end
            object buCommentsBold: TcxButton
              Left = 113
              Top = 70
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 5
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 0
              OnClick = buKeywordsBoldClick
            end
            object buCommentsItalic: TcxButton
              Left = 135
              Top = 70
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 6
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 1
              OnClick = buKeywordsBoldClick
            end
            object buDataTypesBold: TcxButton
              Left = 113
              Top = 98
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 7
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 2
              OnClick = buKeywordsBoldClick
            end
            object buDataTypesItalic: TcxButton
              Left = 135
              Top = 98
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 8
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 3
              OnClick = buKeywordsBoldClick
            end
            object buFunctionsBold: TcxButton
              Left = 113
              Top = 42
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 3
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 4
              OnClick = buKeywordsBoldClick
            end
            object buFunctionsItalic: TcxButton
              Left = 135
              Top = 42
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 4
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 5
              OnClick = buKeywordsBoldClick
            end
            object buKeywordsBold: TcxButton
              Left = 113
              Top = 14
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 1
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 6
              OnClick = buKeywordsBoldClick
            end
            object buKeywordsItalic: TcxButton
              Left = 135
              Top = 14
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 2
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 7
              OnClick = buKeywordsBoldClick
            end
            object buNumbersBold: TcxButton
              Left = 258
              Top = 42
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 11
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 8
              OnClick = buKeywordsBoldClick
            end
            object buNumbersItalic: TcxButton
              Left = 280
              Top = 42
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 12
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 9
              OnClick = buKeywordsBoldClick
            end
            object buStringsBold: TcxButton
              Left = 258
              Top = 70
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 13
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 10
              OnClick = buKeywordsBoldClick
            end
            object buStringsItalic: TcxButton
              Left = 280
              Top = 70
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 14
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 11
              OnClick = buKeywordsBoldClick
            end
            object buTablesBold: TcxButton
              Left = 258
              Top = 14
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 20
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 9
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 12
              OnClick = buKeywordsBoldClick
            end
            object buTablesItalic: TcxButton
              Left = 280
              Top = 14
              Width = 23
              Height = 23
              OptionsImage.ImageIndex = 21
              OptionsImage.Images = dm.imListSmall
              SpeedButtonOptions.GroupIndex = 10
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.AllowAllUp = True
              TabOrder = 13
              OnClick = buKeywordsBoldClick
            end
            object ceComments: TdxColorEdit
              Left = 69
              Top = 71
              ColorValue = clGreen
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 14
              Width = 44
            end
            object ceDataTypes: TdxColorEdit
              Left = 69
              Top = 99
              ColorValue = clMaroon
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 15
              Width = 44
            end
            object ceFunctions: TdxColorEdit
              Left = 69
              Top = 43
              ColorValue = clFuchsia
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 16
              Width = 44
            end
            object ceKeywords: TdxColorEdit
              Left = 69
              Top = 15
              ColorValue = 15168792
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 17
              Width = 44
            end
            object ceNumbers: TdxColorEdit
              Left = 214
              Top = 43
              ColorValue = clBlue
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 18
              Width = 44
            end
            object ceStrings: TdxColorEdit
              Left = 214
              Top = 71
              ColorValue = clRed
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 19
              Width = 44
            end
            object ceTables: TdxColorEdit
              Left = 214
              Top = 15
              ColorValue = clOlive
              Properties.OnInitPopup = ColorEditInitPopup
              TabOrder = 20
              Width = 44
            end
          end
        end
      end
      object tsGrid: TcxTabSheet
        BorderWidth = 4
        Caption = 'Data Grid'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 310
          Height = 120
          Align = alTop
          Caption = ' Font '
          TabOrder = 0
          object Label6: TLabel
            Left = 33
            Top = 28
            Width = 49
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font Type'
          end
          object Label9: TLabel
            Left = 32
            Top = 58
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Font Color'
          end
          object Label10: TLabel
            Left = 26
            Top = 85
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Background'
          end
          object buFontGrid: TcxButton
            Left = 88
            Top = 23
            Width = 89
            Height = 25
            Caption = 'Font...'
            OptionsImage.ImageIndex = 19
            OptionsImage.Images = dm.imListSmall
            TabOrder = 0
            OnClick = buFontEditorClick
          end
          object ceGridColor: TdxColorEdit
            Left = 88
            Top = 54
            ColorValue = clBlack
            Properties.ColorSet = csCustom
            Properties.OnInitPopup = ColorEditInitPopup
            TabOrder = 1
            Width = 89
          end
          object ceGridBackground: TdxColorEdit
            Left = 88
            Top = 81
            ColorValue = clWhite
            Properties.ColorSet = csCustom
            Properties.OnInitPopup = ColorEditInitPopup
            TabOrder = 2
            Width = 89
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 120
          Width = 310
          Height = 161
          Align = alTop
          Caption = ' Style '
          TabOrder = 1
          object Label1: TLabel
            Left = 34
            Top = 27
            Width = 48
            Height = 13
            Alignment = taRightJustify
            Caption = 'Null String'
          end
          object edNullString: TEdit
            Left = 88
            Top = 24
            Width = 89
            Height = 21
            TabOrder = 0
            Text = '{null}'
          end
          object ceNullStringBackground: TdxColorEdit
            Left = 179
            Top = 24
            ColorValue = clWhite
            Properties.OnInitPopup = ceNullStringBackgroundPropertiesInitPopup
            TabOrder = 1
            Width = 44
          end
          object buNullStringBold: TcxButton
            Left = 223
            Top = 23
            Width = 23
            Height = 23
            OptionsImage.ImageIndex = 20
            OptionsImage.Images = dm.imListSmall
            SpeedButtonOptions.GroupIndex = 1
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.AllowAllUp = True
            TabOrder = 2
            OnClick = buNullStringBoldClick
          end
          object buNullStringItalic: TcxButton
            Left = 245
            Top = 23
            Width = 23
            Height = 23
            OptionsImage.ImageIndex = 21
            OptionsImage.Images = dm.imListSmall
            SpeedButtonOptions.GroupIndex = 2
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.AllowAllUp = True
            TabOrder = 3
            OnClick = buNullStringItalicClick
          end
        end
      end
      object tsAbout: TcxTabSheet
        Caption = 'About'
        ImageIndex = 2
        OnResize = tsAboutResize
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object paInfoLeft: TPanel
          Left = 0
          Top = 0
          Width = 153
          Height = 490
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            153
            490)
          object Label2: TLabel
            Left = 33
            Top = 6
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Name:'
            ExplicitLeft = 57
          end
          object Label3: TLabel
            Left = 33
            Top = 23
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Description:'
            ExplicitLeft = 57
          end
          object Label4: TLabel
            Left = 33
            Top = 91
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Web:'
            ExplicitLeft = 57
          end
          object Label11: TLabel
            Left = 33
            Top = 40
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Version:'
            ExplicitLeft = 57
          end
          object Label12: TLabel
            Left = 33
            Top = 57
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Company Name:'
            ExplicitLeft = 57
          end
          object Label13: TLabel
            Left = 33
            Top = 74
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Email:'
            ExplicitLeft = 57
          end
          object Label14: TLabel
            Left = 33
            Top = 108
            Width = 120
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'GitHub:'
            ExplicitLeft = 57
          end
        end
        object paInfoRight: TPanel
          Left = 153
          Top = 0
          Width = 165
          Height = 490
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Label16: TLabel
            Left = 2
            Top = 6
            Width = 160
            Height = 13
            AutoSize = False
            Caption = 'OneSQL'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label17: TLabel
            Left = 2
            Top = 23
            Width = 160
            Height = 13
            AutoSize = False
            Caption = 'Universal SQL Editor'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object laVersion: TLabel
            Left = 2
            Top = 40
            Width = 160
            Height = 13
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label19: TLabel
            Left = 2
            Top = 57
            Width = 160
            Height = 13
            AutoSize = False
            Caption = 'CrashIT'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label20: TLabel
            Left = 2
            Top = 74
            Width = 160
            Height = 13
            Cursor = crHandPoint
            AutoSize = False
            Caption = 'igrubisic@gmail.com'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = Label20Click
          end
          object Label21: TLabel
            Left = 2
            Top = 91
            Width = 160
            Height = 13
            AutoSize = False
            Caption = 'N/A'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label22: TLabel
            Left = 2
            Top = 108
            Width = 160
            Height = 13
            AutoSize = False
            Caption = 'N/A'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
  object colorDialog: TColorDialog
    Left = 264
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [fdWysiwyg]
    Left = 296
  end
  object syntax: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    DataTypeAttri.Foreground = clMaroon
    FunctionAttri.Foreground = clFuchsia
    KeyAttri.Foreground = 15168792
    NumberAttri.Foreground = clBlue
    StringAttri.Foreground = clRed
    TableNameAttri.Foreground = clOlive
    TableNameAttri.Style = [fsBold]
    TableNames.Strings = (
      'MyTable')
    SQLDialect = sqlMySQL
    Left = 288
    Top = 280
  end
end
