object main: Tmain
  Left = 0
  Top = 0
  Caption = 'OneSQL'
  ClientHeight = 702
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object paTop: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 0
    Width = 1000
    Height = 34
    Margins.Left = 4
    Margins.Top = 0
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object buSessionManager: TcxButton
      Left = 0
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Connection Manager...'
      Action = acSessionManager
      LookAndFeel.NativeStyle = True
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 1
    end
    object buNewSession: TcxButton
      Left = 34
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Create new database connection...'
      Action = acNewSession
      LookAndFeel.NativeStyle = True
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 0
    end
    object buNewEditor: TcxButton
      Left = 68
      Top = 0
      Width = 34
      Height = 34
      Action = acNewEditor
      LookAndFeel.NativeStyle = True
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 2
    end
    object buOpenSQL: TcxButton
      Left = 102
      Top = 0
      Width = 34
      Height = 34
      Action = acOpenSQL
      LookAndFeel.NativeStyle = True
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 3
    end
    object buSaveSQL: TcxButton
      Left = 136
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Save SQL file to disk'
      Action = acSaveSQL
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 4
    end
    object buExportXLS: TcxButton
      Left = 300
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Export to Excel file...'
      OptionsImage.ImageIndex = 11
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 5
      OnClick = buExportXLSClick
    end
    object buExportCSV: TcxButton
      Left = 334
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Export to text file...'
      OptionsImage.ImageIndex = 12
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 6
      OnClick = buExportCSVClick
    end
    object buExportHTML: TcxButton
      Left = 368
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Export to HTML...'
      OptionsImage.ImageIndex = 13
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 7
      OnClick = buExportHTMLClick
    end
    object buCommit: TcxButton
      Left = 200
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Commit'
      OptionsImage.ImageIndex = 14
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 8
      OnClick = buCommitClick
    end
    object buRollback: TcxButton
      Left = 234
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Rollback'
      OptionsImage.ImageIndex = 15
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 9
      OnClick = buRollbackClick
    end
    object buPreferences: TcxButton
      Left = 932
      Top = 0
      Width = 34
      Height = 34
      Align = alRight
      OptionsImage.ImageIndex = 16
      OptionsImage.Images = dm.imList
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 10
      OnClick = buPreferencesClick
    end
    object buExportJSON: TcxButton
      Left = 402
      Top = 0
      Width = 34
      Height = 34
      Hint = 'Export to JSON...'
      OptionsImage.ImageIndex = 17
      OptionsImage.Images = dm.imList
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 11
      OnClick = buExportJSONClick
    end
    object buExit: TcxButton
      Left = 966
      Top = 0
      Width = 34
      Height = 34
      Align = alRight
      OptionsImage.ImageIndex = 5
      OptionsImage.Images = dm.imList
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 12
      OnClick = buExitClick
    end
    object buHistory: TcxButton
      Left = 898
      Top = 0
      Width = 34
      Height = 34
      Align = alRight
      Enabled = False
      OptionsImage.ImageIndex = 18
      OptionsImage.Images = dm.imList
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      TabOrder = 13
      OnClick = buHistoryClick
    end
  end
  object paSessions: TPanel
    Left = 0
    Top = 34
    Width = 1008
    Height = 668
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object pcSessions: TcxPageControl
      Left = 4
      Top = 4
      Width = 1000
      Height = 660
      Align = alClient
      TabOrder = 0
      Properties.AllowTabDragDrop = True
      Properties.CloseButtonMode = cbmActiveAndHoverTabs
      Properties.CloseTabWithMiddleClick = True
      Properties.CustomButtons.Buttons = <>
      Properties.HotTrack = True
      Properties.Images = dm.imListSmall
      Properties.MultiLine = True
      LookAndFeel.NativeStyle = True
      OnCanCloseEx = pcSessionsCanCloseEx
      OnChange = pcSessionsChange
      ExplicitTop = 6
      ClientRectBottom = 656
      ClientRectLeft = 4
      ClientRectRight = 996
      ClientRectTop = 4
    end
  end
  object ac: TActionList
    Images = dm.imList
    Left = 56
    Top = 64
    object acNewSession: TAction
      ImageIndex = 0
      OnExecute = acNewSessionExecute
    end
    object acSessionConnect: TAction
      ImageIndex = 2
    end
    object acSessionDisconnect: TAction
      ImageIndex = 3
    end
    object acSessionManager: TAction
      ImageIndex = 8
      OnExecute = acSessionManagerExecute
    end
    object acNewEditor: TAction
      Hint = 'Create new SQL editor'
      ImageIndex = 9
      OnExecute = acNewEditorExecute
    end
    object acOpenSQL: TAction
      Hint = 'Open SQL file from disk'
      ImageIndex = 10
      OnExecute = acOpenSQLExecute
    end
    object acSaveSQL: TAction
      ImageIndex = 6
      OnExecute = acSaveSQLExecute
    end
  end
  object pmTab: TPopupMenu
    Images = dm.imListSmall
    Left = 88
    Top = 64
    object pmClose: TMenuItem
      Caption = 'Close'
      ImageIndex = 1
      OnClick = pmCloseClick
    end
    object pmSaveAs: TMenuItem
      Caption = 'Save As...'
      ImageIndex = 2
      OnClick = pmSaveAsClick
    end
  end
  object odSQL: TOpenDialog
    DefaultExt = 'sql'
    Filter = 'SQL Files|*.sql|Text Files|*.txt|All Formats|*.*'
    Left = 240
    Top = 64
  end
  object sdSQL: TSaveDialog
    DefaultExt = 'sql'
    Filter = 'SQL files|*.sql'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 200
    Top = 64
  end
  object sdExport: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 160
    Top = 64
  end
  object UniConnection1: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 5432
    Database = 'libreplan'
    SpecificOptions.Strings = (
      'Oracle.Direct=True'
      'MySQL.Compress=True'
      'MySQL.Interactive=True')
    Username = 'libreplan'
    Server = 'localhost'
    LoginPrompt = False
    Left = 448
    Top = 336
    EncryptedPassword = '93FF96FF9DFF8DFF9AFF8FFF93FF9EFF91FF'
  end
  object UniMetaData1: TUniMetaData
    MetaDataKind = 'Columns'
    Restrictions.Strings = (
      'TABLE_SCHEMA=public')
    Connection = UniConnection1
    Left = 448
    Top = 400
  end
  object DataSource1: TDataSource
    DataSet = UniMetaData1
    Left = 520
    Top = 400
  end
  object tiOpen: TTimer
    Interval = 500
    OnTimer = tiOpenTimer
    Left = 120
    Top = 64
  end
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    SQL.Strings = (
      'select '#39'pero'#39' from Cust')
    FetchRows = 50
    CachedUpdates = True
    Options.RequiredFields = False
    Options.CompressBlobMode = cbClient
    AutoCalcFields = False
    Left = 520
    Top = 336
  end
  object tiSearch: TTimer
    Enabled = False
    OnTimer = tiSearchTimer
    Left = 272
    Top = 64
  end
  object FindDialog: TFindDialog
    Options = [frDown, frFindNext, frHideMatchCase, frHideWholeWord, frReplace, frReplaceAll]
    Left = 320
    Top = 65
  end
  object SynSearch: TSynEditSearch
    Left = 392
    Top = 72
  end
  object pmEditor: TPopupMenu
    Images = dm.imListSmall
    OnPopup = pmEditorPopup
    Left = 24
    Top = 64
    object miChangeQuote: TMenuItem
      Caption = 'Replace "qoutes" with '#39'qoutes'#39
      ImageIndex = 23
      OnClick = miChangeQuoteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miSelectForUpdate: TMenuItem
      Caption = 'Select for update?'
      OnClick = miSelectForUpdateClick
    end
  end
  object SQLiteLogCon: TUniConnection
    ProviderName = 'SQLite'
    Database = 'C:\Users\dev7\AppData\Local\OneSQL\LogDB.sqlite3'
    SpecificOptions.Strings = (
      'SQLite.Direct=True')
    Options.KeepDesignConnected = False
    Connected = True
    LoginPrompt = False
    Left = 464
    Top = 73
  end
  object qLog: TUniSQL
    Connection = SQLiteLogCon
    Left = 520
    Top = 72
  end
end
