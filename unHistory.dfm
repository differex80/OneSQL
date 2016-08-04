object history: Thistory
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'SQL History'
  ClientHeight = 554
  ClientWidth = 776
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
    Width = 776
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      776
      29)
    object Label1: TLabel
      Left = 409
      Top = 7
      Width = 60
      Height = 13
      Caption = 'Limit results:'
    end
    object Label2: TLabel
      Left = 508
      Top = 7
      Width = 26
      Height = 13
      Caption = 'Rows'
    end
    object buClose: TcxButton
      Left = 697
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
    object edLimit: TEdit
      Left = 472
      Top = 4
      Width = 32
      Height = 21
      Alignment = taRightJustify
      TabOrder = 2
      Text = '20'
      OnChange = edLimitChange
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
    object grHistory: TcxGrid
      Left = 4
      Top = 4
      Width = 129
      Height = 517
      Align = alClient
      TabOrder = 0
      object tvHistory: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnCellDblClick = tvHistoryCellDblClick
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
        object tvHistoryts: TcxGridDBColumn
          DataBinding.FieldName = 'ts'
          Options.Editing = False
        end
      end
      object lvHistory: TcxGridLevel
        GridView = tvHistory
      end
    end
  end
  object Panel3: TPanel
    Left = 137
    Top = 0
    Width = 639
    Height = 525
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    Caption = 'Panel3'
    TabOrder = 2
    object dbseStatement: TDBSynEdit
      Left = 4
      Top = 4
      Width = 631
      Height = 517
      DataField = 'statement'
      DataSource = dsHistory
      Align = alClient
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentCtl3D = False
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
  object qHistory: TFDQuery
    AfterDelete = qHistoryAfterDelete
    Connection = main.SQLiteLogCon
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
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
      '  :P_LIMIT')
    Left = 544
    Top = 16
    ParamData = <
      item
        Name = 'P_SEARCH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'P_SESSION'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'P_LIMIT'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qHistoryid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qHistorysess: TMemoField
      FieldName = 'sess'
      Origin = 'sess'
      BlobType = ftMemo
    end
    object qHistorystatement: TMemoField
      FieldName = 'statement'
      Origin = 'statement'
      BlobType = ftMemo
    end
    object qHistoryts: TDateTimeField
      DisplayLabel = 'Timestamp'
      FieldName = 'ts'
      Origin = 'ts'
    end
  end
end
