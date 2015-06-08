object history: Thistory
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'SQL History'
  ClientHeight = 554
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 525
    Width = 784
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      784
      29)
    object buClose: TcxButton
      Left = 705
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Close'
      ModalResult = 8
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = dm.imListSmall
      TabOrder = 0
      OnClick = buCloseClick
    end
    object edHistorySearch: TcxTextEdit
      Left = 4
      Top = 4
      Properties.OnChange = edHistorySearchPropertiesChange
      Style.TextColor = clWindowFrame
      Style.TextStyle = [fsItalic]
      TabOrder = 1
      Text = 'Search History...'
      OnEnter = edHistorySearchEnter
      OnExit = edHistorySearchExit
      Width = 400
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 137
    Height = 525
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object cxGrid1: TcxGrid
      Left = 4
      Top = 4
      Width = 129
      Height = 517
      Align = alClient
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsHistory
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsSelection.MultiSelect = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Preview.AutoHeight = False
        Preview.MaxLineCount = 0
        Preview.Visible = True
        object cxGrid1DBTableView1ts: TcxGridDBColumn
          DataBinding.FieldName = 'ts'
          Options.Editing = False
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object Panel3: TPanel
    Left = 137
    Top = 0
    Width = 647
    Height = 525
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel3'
    TabOrder = 2
    object DBSynEdit1: TDBSynEdit
      Left = 4
      Top = 4
      Width = 639
      Height = 517
      DataField = 'statement'
      DataSource = dsHistory
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 0
      Gutter.ShowLineNumbers = True
      Highlighter = syntax
      Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoTabIndent]
      RightEdge = 0
      TabWidth = 2
    end
  end
  object qHistory: TUniQuery
    Connection = main.SQLiteLogCon
    SQL.Strings = (
      'select'
      '  *'
      'from'
      '  sql_history'
      'where'
      '  (:P_SEARCH = '#39#39' or statement like '#39'%'#39' || :P_SEARCH || '#39'%'#39')'
      '  and sess = :P_SESSION'
      'order by'
      '  id desc'
      'limit'
      '  20')
    Left = 552
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'P_SEARCH'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'P_SESSION'
        Value = nil
      end>
    object qHistoryid: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
    end
    object qHistorysess: TMemoField
      FieldName = 'sess'
      BlobType = ftMemo
    end
    object qHistorystatement: TMemoField
      FieldName = 'statement'
      BlobType = ftMemo
    end
    object qHistoryts: TDateTimeField
      DisplayLabel = 'Timestamp'
      FieldName = 'ts'
    end
  end
  object dsHistory: TDataSource
    AutoEdit = False
    DataSet = qHistory
    Left = 512
    Top = 16
  end
  object syntax: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 584
    Top = 16
  end
  object tiExecuteHistory: TTimer
    Enabled = False
    Interval = 750
    OnTimer = tiExecuteHistoryTimer
    Left = 624
    Top = 16
  end
end
