unit unMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, MemDS, ActnList, ImgList, OleCtrls, ComCtrls,
  Uni, UniDacVcl, UniProvider, MySQLUniProvider, OracleUniProvider,
  SQLiteUniProvider, ODBCUniProvider, AccessUniProvider, PostgreSQLUniProvider,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxClasses, IniFiles, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxMemo, Menus, StdCtrls, cxButtons,
  ExtCtrls, cxPC, cxSplitter, cxGridCustomPopupMenu, cxGridPopupMenu,
  cxPCdxBarPopupMenu, cxTreeView, cxVGrid, cxDBVGrid, cxInplaceContainer,
  cxGridExportLink, cxExport, cxNavigator, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxImageComboBox,
  ioutils, unEncrypt, CHILKATSSHLib_TLB, AsyncCalls, System.UITypes, System.Types,
  SynEdit, SynEditHighlighter, SynHighlighterSQL, StrUtils, ShellApi, SHFolder,
  SynEditMiscClasses, SynEditSearch, SQLMemMain, cxBlobEdit, dxBarBuiltInMenu,
  System.Actions, System.Character, Vcl.Grids, Vcl.DBGrids, SynDBEdit;

  const
  maxParams = 20;
  maxEditors = 30;


type
  TParam = record
    Active: String;
    ParamName: String;
    ParamType: String;
    ParamValue: Variant;
  end;

  TParams = array [1 .. maxParams] of TParam;

  TEditorParam = record
    Editor: TSynEdit;
    FileName: TFileName;
    Params: TParams;
  end;

  TEditorParams = array [1 .. maxEditors] of TEditorParam;

  Tmain = class(TForm)
    paTop: TPanel;
    ac: TActionList;
    acNewSession: TAction;
    acSessionConnect: TAction;
    acSessionDisconnect: TAction;
    buNewSession: TcxButton;
    paSessions: TPanel;
    pcSessions: TcxPageControl;
    buSessionManager: TcxButton;
    acSessionManager: TAction;
    buNewEditor: TcxButton;
    acNewEditor: TAction;
    pmTab: TPopupMenu;
    pmClose: TMenuItem;
    pmSaveAs: TMenuItem;
    buOpenSQL: TcxButton;
    acOpenSQL: TAction;
    odSQL: TOpenDialog;
    sdSQL: TSaveDialog;
    acSaveSQL: TAction;
    buSaveSQL: TcxButton;
    buExportXLS: TcxButton;
    buExportCSV: TcxButton;
    sdExport: TSaveDialog;
    buExportHTML: TcxButton;
    buCommit: TcxButton;
    buRollback: TcxButton;
    UniConnection1: TUniConnection;
    UniMetaData1: TUniMetaData;
    DataSource1: TDataSource;
    tiOpen: TTimer;
    UniQuery1: TUniQuery;
    buPreferences: TcxButton;
    tiSearch: TTimer;
    FindDialog: TFindDialog;
    SynSearch: TSynEditSearch;
    pmEditor: TPopupMenu;
    miChangeQuote: TMenuItem;
    buExportJSON: TcxButton;
    buExit: TcxButton;
    N1: TMenuItem;
    miSelectForUpdate: TMenuItem;
    SQLiteLogCon: TUniConnection;
    qLog: TUniSQL;
    buHistory: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure acNewSessionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton3Click(Sender: TObject);
    procedure acSessionManagerExecute(Sender: TObject);
    procedure acNewEditorExecute(Sender: TObject);
    procedure pmCloseClick(Sender: TObject);
    procedure pmSaveAsClick(Sender: TObject);
    procedure acOpenSQLExecute(Sender: TObject);
    procedure pcSessionsCanCloseEx(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
    procedure acSaveSQLExecute(Sender: TObject);
    procedure pcSessionsChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure buExportXLSClick(Sender: TObject);
    procedure buExportCSVClick(Sender: TObject);
    procedure buExportHTMLClick(Sender: TObject);
    procedure buCommitClick(Sender: TObject);
    procedure buRollbackClick(Sender: TObject);
    procedure tiOpenTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buPreferencesClick(Sender: TObject);
    procedure tiSearchTimer(Sender: TObject);
    procedure miChangeQuoteClick(Sender: TObject);
    procedure buExportJSONClick(Sender: TObject);
    procedure buExitClick(Sender: TObject);
    procedure miSelectForUpdateClick(Sender: TObject);
    procedure pmEditorPopup(Sender: TObject);
    procedure buHistoryClick(Sender: TObject);
  private
    EditorParams: TEditorParams;
    cNullString: String;
    procedure InitParams(var P: TParams);
    procedure InitEditorParams(var EP: TEditorParams);
    procedure SaveParams(Editor: TSynEdit; FileName: TFileName; Params: TParams);
    procedure FreeParams(Editor: TSynEdit);
    function LoadParams(Editor: TSynEdit): TParams;
    function ParamValue(Param: TParam): Variant;
    function IsTextFile(const sFile: TFileName): Boolean;

    procedure GetSessionObjects(Conn: TUniConnection);
    function GetActiveEditorParamCount: Integer;
    function GetDataType(ParamType: String): TFieldType;
    function GetActiveEditorPC: TcxPageControl;
    function GetObjectMemTable(Tab: TcxTabSheet): TSQLMemTable;
    function GetSQLEditor(Control: TWinControl): TSynEdit;
    function GetSQLGridView(Control: TWinControl): TcxGridDBTableView;
    function GetSessionTab(SessionName: String): TcxTabSheet;
    function GetSession(SessionName: String): TUniConnection;
    function GetObjectInspector(Conn: TUniConnection): TcxTreeView;
    function GetMetaData: TUniMetaData;
    function GetObjectInfoGrid(Control: TWinControl): TcxDBVerticalGrid;
    function GetSyntaxType(Database: String): TSQLDialect;
    function GetSyntaxSQL(Tab: TcxTabSheet): TSynSQLSyn;
    function GetUniSQL(Control: TWinControl): TUniSQL;
    function GetCursorSQL(Text: String; CursorPos: Integer): String;
    function GetSearchEdit(Conn: TUniConnection): TEdit;
    function GetSpecialFolderPath(folder: Integer): String;
    function GetCancelButton(Control: TWinControl): TcxButton;

    function CreateSessionTab(SessionName: String): TcxTabSheet;
    function CreateSession(SessionName: String): TUniConnection;
    function AddSqlEditor(pcEditors: TcxPageControl; sCaption: String = ''): TcxTabSheet;

    procedure ExecuteSQL(Tab: TcxTabSheet);
    procedure DisconnectSSH(Tab: TcxTabSheet = nil);
    procedure SaveSQL(Tab: TcxTabSheet);
    procedure EditorButtonState;
    procedure LoadEditorOptions;
    procedure LoadGenericOptions;
    procedure InitLogDB;
    procedure ExportToFile(Format: String; DisableStyle: Boolean = False);
    procedure ExportToJson(FileName: TFileName; GridView: TcxGridDBTableView);
    procedure StyleComponents(Component: TComponent);
    procedure DisplaySessionObjects;
    procedure Log(Sess: String; Statement: String);

    procedure ObjectInspectorExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure ObjectInspectorChange(Sender: TObject; Node: TTreeNode);
    procedure OnEditorClose(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
    procedure PageControlMouseClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControlContexPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure pcEditorOnChange(Sender: TObject);
    procedure EditorOnChange(Sender: TObject);
    procedure EditorOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnAutoCommitChange(Sender: TObject);
    procedure CancelExecute(Sender: TObject);
//    function GetNewSession(SessionName: String): TUniConnection;
    procedure onGetContentStyle(Sender: TcxCustomGridTableView;
      ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem;
      var AStyle: TcxStyle);
    procedure onGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure onDataGridDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    function GetResultLabel(Control: TWinControl): TLabel;
    function GetEditorFileName(Editor: TSynEdit): TFileName;
    procedure OnBeforeQueryPost(DataSet: TDataSet);
  public
    procedure ShowError(sMessage: String);
    procedure ExecuteSQLCallback(EditorTab: TcxTabSheet; Query: TUniQuery;
      SQL: TUniSQL; GridView: TcxGridDBTableView; Error: String);
  end;

var
  main: Tmain;

implementation

uses unParamForm, unSessionForm, unDm, unSessionManager, unPreferences, unHistory;

{$R *.dfm}

type
  TcxPageControlPropertiesAccess = class(TcxPageControlProperties);

procedure Tmain.pmCloseClick(Sender: TObject);
var
  PC: TcxPageControl;
begin
  PC := GetActiveEditorPC;
  if PC = nil then
    Exit;
  FreeParams(GetSQLEditor(PC.ActivePage));
  PC.ActivePage.Free;
  EditorButtonState;
end;

procedure Tmain.pmEditorPopup(Sender: TObject);
begin
  miSelectForUpdate.Checked := GetSQLGridView(TWinControl(TPopupMenu(Sender).PopupComponent.GetParentComponent.GetParentComponent)).DataController.DataSource.AutoEdit;
  if miSelectForUpdate.Checked then
    miSelectForUpdate.ImageIndex := 0
  else
    miSelectForUpdate.ImageIndex := -1;
end;

procedure Tmain.buRollbackClick(Sender: TObject);
var
  PC: TcxPageControl;
  conn: TUniConnection;
begin
  PC := GetActiveEditorPC;
  if PC = nil then
    Exit;
  conn := GetSession(pcSessions.ActivePage.Caption);
  if not conn.InTransaction then
  begin
    GetResultLabel(PC.ActivePage).Caption := 'Nothing to rollback';
    Exit;
  end;
  conn.Rollback;
  GetResultLabel(PC.ActivePage).Caption := 'Rollback executed at ' + DateTimeToStr(now);
end;

procedure Tmain.buCommitClick(Sender: TObject);
var
  PC: TcxPageControl;
  conn: TUniConnection;
begin
  PC := GetActiveEditorPC;
  if PC = nil then
    Exit;
  conn := GetSession(pcSessions.ActivePage.Caption);
  if not conn.InTransaction then
  begin
    GetResultLabel(PC.ActivePage).Caption := 'Nothing to commit';
    Exit;
  end;
  conn.Commit;
  GetResultLabel(PC.ActivePage).Caption := 'Commit executed at ' + DateTimeToStr(now);
end;

procedure Tmain.buExportXLSClick(Sender: TObject);
begin
  ExportToFile('xls', True);
end;

procedure Tmain.buHistoryClick(Sender: TObject);
var
  i: Integer;
begin
  StyleComponents(history);
  with history.qHistory do
  begin
    Close;
    for i := 0 to ParamCount -1 do
      Params[i].Value := null;
    ParamByName('P_SESSION').Value := pcSessions.ActivePage.Caption;
  end;
  history.ShowModal;
end;

procedure Tmain.buPreferencesClick(Sender: TObject);
var
  Pref: TPreferences;
begin
  Pref := TPreferences.Create(Self);
  try
    if Pref.ShowModal = mrOk then
    begin
      StyleComponents(main);
      LoadGenericOptions;
    end;
  finally
    Pref.Free;
  end;
end;

procedure Tmain.StyleComponents(Component: TComponent);
var
  i: Integer;
begin
  for i := 0 to Component.ComponentCount -1 do
  begin
    if (Component.Components[i] is TSynSQLSyn) or (Component.Components[i] is TDBSynEdit) or
       (Component.Components[i] is TSynEdit) or (Component.Components[i] is TcxGrid) then
      dm.Style(Component.Components[i]);
    StyleComponents(Component.Components[i]);
  end;
end;

procedure Tmain.buExitClick(Sender: TObject);
begin
  Close;
end;

procedure Tmain.buExportCSVClick(Sender: TObject);
begin
  ExportToFile('csv');
end;

procedure Tmain.buExportHTMLClick(Sender: TObject);
begin
  ExportToFile('html');
end;

procedure Tmain.buExportJSONClick(Sender: TObject);
begin
  ExportToFile('json');
end;

procedure Tmain.CancelExecute(Sender: TObject);
var
  Grid: TcxGridDBTableView;
  DataSet: TUniQuery;
begin
  Grid := GetSQLGridView(TcxButton(Sender).Parent.Parent.Parent);
  if Grid = nil then Exit;
  TcxButton(Sender).Enabled := False;
  DataSet := TUniQuery(Grid.DataController.DataSource.DataSet);
  DataSet.Tag := 1;
  DataSet.BreakExec;
end;

procedure Tmain.cxButton3Click(Sender: TObject);
var
  SessionF: TsessionForm;
begin
  dm.connection_name := TcxButton(Sender).Caption;
  SessionF := TsessionForm.Create(Self);
  SessionF.ShowModal;
  SessionF.Destroy;
end;

procedure Tmain.onDataGridDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
(*  if TcxGridDBColumn(ACellViewInfo.Item).DataBinding.Field is TBlobField then
  begin
    s := TMemoryStream.Create;
    TBlobField(TcxGridDBColumn(ACellViewInfo.Item).DataBinding.Field).SaveToStream(s);
    s.Position := 0;
    ShowMessage(s.ToString);
    s.Free;

  end;   *)
//    ShowMessage(TBlobField(TcxGridDBColumn(ACellViewInfo.Item).DataBinding.Field).AsString);
end;

procedure Tmain.onGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  if Arecord.Values[Sender.Index] = null then
    AText := cNullString;
end;

procedure Tmain.onGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  try
    if (ARecord.IsData) and (ARecord.Values[AItem.Index] = null) then
      AStyle := dm.NullString;
  except
  end;
end;

procedure Tmain.OnAutoCommitChange(Sender: TObject);
var
  Conn: TUniConnection;
begin
  Conn := GetSession(pcSessions.ActivePage.Caption);
  if Conn = nil then
    Exit;
  Conn.AutoCommit := TcxImageComboBox(Sender).ItemIndex = 0;
  EditorButtonState;
end;

procedure Tmain.ObjectInspectorChange(Sender: TObject; Node: TTreeNode);
var
  Meta: TUniMetaData;
  VGrid: TcxDBVerticalGrid;
  TableName: String;
begin
  if (Node.Text = 'Columns') or (Node.Text = 'Constraints') or (Node.Text = 'Indexes') or (pos('Tables', Node.Text) > 0) or (pos('Procedures', Node.Text) > 0) or (pos('Functions', Node.Text) > 0) then
    Exit;
  Meta := GetMetaData;
  VGrid := GetObjectInfoGrid(pcSessions.ActivePage);
  VGrid.ClearRows;
  with Meta do
  begin
    Active := False;
    if (pos('Procedures', Node.Parent.Text) > 0) or (pos('Functions', Node.Parent.Text) > 0) then
    begin
      MetaDataKind := 'Procedures';
      Restrictions.Values['PROCEDURE_SCHEMA'] := Connection.Database;
      Restrictions.Values['PROCEDURE_NAME'] := Node.Text;
    end
    else
    begin
      MetaDataKind := Node.Parent.Text;
      if pos('Tables', Node.Parent.Text) > 0 then
      begin
        TableName := Node.Text;
        MetaDataKind := 'Tables';
      end
      else
        TableName := Node.Parent.Parent.Text;
      if (pos('/', Connection.Database) > 0) or (pos('\', Connection.Database) > 0) then
        Meta.Restrictions.Values['TABLE_CATALOG'] := Connection.Database
      else
        if Connection.SpecificOptions.Values['SCHEMA'] <> '' then
        begin
          Restrictions.Values['TABLE_CATALOG'] := Connection.Database;
          Restrictions.Values['TABLE_SCHEMA'] := Connection.SpecificOptions.Values['SCHEMA'];
        end
        else
          Restrictions.Values['TABLE_SCHEMA'] := Connection.Database;
      Restrictions.Values['TABLE_NAME'] := TableName;
      if Node.Parent.Text = 'Columns' then
        Restrictions.Values['COLUMN_NAME'] := Node.Text
      else if Node.Parent.Text = 'Constraints' then
        Restrictions.Values['CONSTRAINT_NAME'] := Node.Text
      else if Node.Parent.Text = 'Indexes' then
        Restrictions.Values['INDEX_NAME'] := Node.Text;
    end;
    Meta.Active := True;
    { Refresh Vertical grid }
    VGrid.DataController.CreateAllItems;
  end;
end;

procedure Tmain.ObjectInspectorExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
var
  Conn: TUniConnection;
  Meta: TUniMetaData;
  TypeNode, Item: TTreeNode;
begin
  if Node.Level <> 1 then
    Exit;
  if Node.Count > 0 then
    Exit;
  Conn := GetSession(pcSessions.ActivePage.Caption);
  if Conn = nil then
    Exit;
  Meta := TUniMetaData.Create(nil);
  try
    Meta.Connection := Conn;
    { Colums }
    TypeNode := TcxTreeView(Node.TreeView.Parent).Items.AddChild(Node, 'Columns');
    TypeNode.ImageIndex := 11;
    TypeNode.SelectedIndex := TypeNode.ImageIndex;
    Meta.MetaDataKind := 'Columns';
    if (pos('/', Conn.Database) > 0) or (pos('\', Conn.Database) > 0) then
      Meta.Restrictions.Values['TABLE_CATALOG'] := Conn.Database
    else
      if Meta.Connection.SpecificOptions.Values['SCHEMA'] <> '' then
      begin
        Meta.Restrictions.Values['TABLE_CATALOG'] := Conn.Database;
        Meta.Restrictions.Values['TABLE_SCHEMA'] := Meta.Connection.SpecificOptions.Values['SCHEMA'];
      end
      else
        Meta.Restrictions.Values['TABLE_SCHEMA'] := Conn.Database;
    Meta.Restrictions.Values['TABLE_NAME'] := Node.Text;
    Meta.Active := True;
    while not Meta.Eof do
    begin
      Item := TcxTreeView(Node.TreeView.Parent).Items.AddChild(TypeNode, Meta.FieldByName('COLUMN_NAME').AsString);
      Item.ImageIndex := 11;
      Item.SelectedIndex := Item.ImageIndex;
      Meta.Next;
    end;
    Meta.Active := False;
    { Constraints }
    TypeNode := TcxTreeView(Node.TreeView.Parent).Items.AddChild(Node, 'Constraints');
    TypeNode.ImageIndex := 13;
    TypeNode.SelectedIndex := TypeNode.ImageIndex;
    Meta.MetaDataKind := 'Constraints';
    Meta.Active := True;
    while not Meta.Eof do
    begin
      Item := TcxTreeView(Node.TreeView.Parent).Items.AddChild(TypeNode, Meta.FieldByName('CONSTRAINT_NAME').AsString);
      if Meta.FieldByName('CONSTRAINT_TYPE').AsString = 'PRIMARY KEY' then
        Item.ImageIndex := 12
      else if Meta.FieldByName('CONSTRAINT_TYPE').AsString = 'FOREIGN KEY' then
        Item.ImageIndex := 13
      else if Meta.FieldByName('CONSTRAINT_TYPE').AsString = 'CHECK' then
        Item.ImageIndex := 0
      else
        Item.ImageIndex := 14;
      Item.SelectedIndex := Item.ImageIndex;
      Meta.Next;
    end;
    Meta.Active := False;
    { Indexes }
    TypeNode := TcxTreeView(Node.TreeView.Parent).Items.AddChild(Node, 'Indexes');
    TypeNode.ImageIndex := 15;
    TypeNode.SelectedIndex := TypeNode.ImageIndex;
    Meta.MetaDataKind := 'Indexes';
    Meta.Active := True;
    while not Meta.Eof do
    begin
      Item := TcxTreeView(Node.TreeView.Parent).Items.AddChild(TypeNode, Meta.FieldByName('INDEX_NAME').AsString);
      if Meta.FieldByName('UNIQUE').AsInteger = 1 then
        Item.ImageIndex := 15
      else
        Item.ImageIndex := 15;
      Item.SelectedIndex := Item.ImageIndex;
      Meta.Next;
    end;
  finally
    Meta.Free;
  end;
end;

procedure Tmain.PageControlContexPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  i: Integer;
begin
  with Sender as TcxPageControl do
  begin
    PopupMenu := nil;
    i := IndexOfTabAt(MousePos.X, MousePos.Y);
    if i > -1 then
    begin
      PopupMenu := pmTab;
    end;
  end;
end;

procedure Tmain.PageControlMouseClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  if Button = mbRight then
  begin
    i := TcxPageControl(Sender).IndexOfTabAt(X, Y);
    if i > -1 then
      TcxPageControl(Sender).ActivePageIndex := i;
  end;
end;

procedure Tmain.acNewSessionExecute(Sender: TObject);
var
  SessionF: TsessionForm;
  mr: Integer;
begin
  SessionF := TsessionForm.Create(Self);
  dm.connection_name := '';
  mr := SessionF.ShowModal;
  SessionF.Destroy;
  if mr = mrOk then
    buSessionManager.Click;
end;

procedure Tmain.acOpenSQLExecute(Sender: TObject);
var
  Tab: TcxTabSheet;
  Memo: TSynEdit;
begin
  if pcSessions.PageCount = 0 then
    Exit;
  if odSQL.Execute then
  begin
    if not IsTextFile(odSQL.FileName) then
    begin
      ShowMessage('Not a text file!');
      Exit;
    end;
    Tab := AddSqlEditor(GetActiveEditorPC, ExtractFileName(odSQL.FileName));
    if Tab = nil then
      Exit;
    Tab.Tag := 1;
    Memo := GetSQLEditor(Tab);
    SaveParams(Memo, odSQL.FileName, LoadParams(Memo));
    Memo.Lines.LoadFromFile(odSQL.FileName);
  end;
end;

procedure Tmain.acSaveSQLExecute(Sender: TObject);
var
  PC: TcxPageControl;
begin
  if pcSessions.PageCount = 0 then
    Exit;
  PC := GetActiveEditorPC;
  if PC = nil then
    Exit;
  SaveSQL(PC.ActivePage);
end;

procedure Tmain.SaveSQL(Tab: TcxTabSheet);
var
  Memo: TSynEdit;
  sSQL: String;
begin
  Memo := GetSQLEditor(Tab);
  sdSQL.FileName := GetEditorFileName(Memo);
  if sdSQL.FileName = '' then
    if pos('*', Tab.Caption) > 0 then
      sdSQL.FileName := copy(Tab.Caption, 1, Length(Tab.Caption) -2)
    else
      sdSQL.FileName := Tab.Caption;
  if Tab.Tag = 1 then
  begin
    Memo.Lines.SaveToFile(sdSQL.FileName);
    Tab.Caption := ExtractFileName(sdSQL.FileName);
    Tab.Tag := 1;
  end
  else
  begin
    if sdSQL.Execute then
    begin
      if TFile.Exists(sdSQL.FileName) then
        TFile.Delete(sdSQL.FileName);
      sSQL := Memo.Lines.Text;
      if dm.LineEnding = 1 then
        sSQL := StringReplace(sSQL, #13#10, #10, [rfReplaceAll])
      else if dm.LineEnding = 2 then
        sSQL := StringReplace(sSQL, #13#10, #13, [rfReplaceAll]);
      TFile.AppendAllText(sdSQL.FileName, sSQL, TEncoding.ANSI);
      Tab.Caption := ExtractFileName(sdSQL.FileName);
      SaveParams(Memo, sdSQL.FileName, LoadParams(Memo));
      Tab.Tag := 1;
    end;
  end;
  EditorButtonState;
end;

procedure Tmain.ShowError(sMessage: String);
begin
  ShowMessage(sMessage);
end;

procedure Tmain.tiOpenTimer(Sender: TObject);
var
  IniFile: TIniFile;
  Sections: TStringList;
begin
  tiOpen.Enabled := False;
  IniFile := dm.GetSessionIniFile;
  Sections := TStringList.Create;
  try
    IniFile.ReadSections(Sections);
    if Sections.Count = 0 then
      buNewSession.Click
    else
      buSessionManager.Click;
  finally
    IniFile.Free;
    Sections.Free;
  end;
end;

procedure Tmain.tiSearchTimer(Sender: TObject);
begin
  DisplaySessionObjects;
  tiSearch.Enabled := False;

end;

procedure Tmain.OnBeforeQueryPost(DataSet: TDataSet);
begin
  if (not TUniQuery(DataSet).Connection.AutoCommit) and (not TUniQuery(DataSet).Connection.InTransaction) then
    TUniQuery(DataSet).Connection.StartTransaction;
end;

procedure Tmain.acSessionManagerExecute(Sender: TObject);
var
  SessionF: TsessionForm;
  mr: Integer;
  Tab: TcxTabSheet;
  sess: String;
begin
  sessionManager.ShowModal;
  if dm.connection_name <> '' then
  begin
    SessionF := TsessionForm.Create(Self);
    mr := SessionF.ShowModal;
    SessionF.Destroy;
    if mr = mrOk then
      buSessionManager.Click;
  end
  else if dm.new_session <> '' then
  begin
    try
      Tab := CreateSessionTab(dm.new_session);
      if Tab = nil then
      begin
        Tab := GetSessionTab(dm.new_session);
        if Tab <> nil then
        begin
          DisconnectSSH(Tab);
          Tab.Free;
        end;
      end;
      sess := dm.new_session;
    finally
      dm.new_session := '';
    end;
  end;
end;

function Tmain.GetActiveEditorParamCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to maxEditors do
    if EditorParams[i].Editor <> nil then
      Inc(Result);
end;

function Tmain.AddSqlEditor(pcEditors: TcxPageControl; sCaption: String): TcxTabSheet;
var
  Tab: TcxTabSheet;
  Conn: TUniConnection;
  paEditor, paGrid, StatusPanel: TPanel;
  cxGrid: TcxGrid;
  cxGridLevel: TcxGridLevel;
  cxGridView: TcxGridDBTableView;
  Query: TUniQuery;
  SQL: TUniSQL;
  DataSource: TDataSource;
  Memo: TSynEdit;
  Cap: String;
  i: Integer;
  Splitter: TSplitter;
begin
  Result := nil;
  if pcEditors = nil then
    Exit;
  if GetActiveEditorParamCount >= maxEditors then
  begin
    ShowMessage('Max number of SQL editors reached! Please close some of unused SQL editors before creating a new one!');
    Exit;
  end;
  Conn := GetSession(TcxTabSheet(pcEditors.Parent).Caption);
  { Create Editor Tab }
  Tab := TcxTabSheet.Create(pcEditors);
  with Tab do
  begin
    PageControl := pcEditors;
    pcEditors.Tag := pcEditors.Tag + 1;
    Name := pcEditors.Name + 'Editor' + IntToStr(pcEditors.Tag);
    if sCaption <> '' then
      Cap := sCaption
    else
      Cap := 'Editor ' + IntToStr(pcEditors.Tag);
    Caption := Cap;
    BorderWidth := 4;
  end;
  pcEditors.ActivePage := Tab;
  { Create SQL editor panel - for TSynEdit }
  paEditor := TPanel.Create(Tab);
  with paEditor do
  begin
    Name := 'paMemo' + pcEditors.Name + IntToStr(pcEditors.Tag);
    BevelOuter := bvNone;
    Align := alClient;
    AlignWithMargins := True;
    Margins.Top := 0;
    Margins.Right := 0;
    Margins.Bottom := 4;
    Margins.Left := 0;
    Caption := '';
    Parent := Tab;
  end;
  { Create SQL editor - TSynEdit }
  Memo := TSynEdit.Create(paEditor);
  with Memo do
  begin
    Name := 'seSQL' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Align := alClient;
    Lines.Clear;
    WantTabs := True;
    TabWidth := 2;
    RightEdge := 0;
    Options := Options - [eoSmartTabs, eoTabsToSpaces, eoScrollPastEol] + [eoAltSetsColumnMode, eoTabIndent];
    Gutter.ShowLineNumbers := True;
    Gutter.LeftOffset := 0;
    Highlighter := GetSyntaxSQL(TcxTabSheet(pcEditors.Parent));
    SearchEngine := SynSearch;
    PopupMenu := pmEditor;
    OnKeyDown := EditorOnKeyDown;
    OnChange := EditorOnChange;
    Parent := paEditor;
    DoubleBuffered := True;
  end;
  dm.Style(Memo);
  { Assign Memo to EditorParams for SQL params cache }
  for i := 1 to maxEditors do
  begin
    if EditorParams[i].Editor = nil then
    begin
      EditorParams[i].Editor := Memo;
      break
    end;
  end;
  { Create Data Grid panel - for TcxGrid }
  paGrid := TPanel.Create(Tab);
  with paGrid do
  begin
    Name := 'paGrid' + pcEditors.Name + IntToStr(pcEditors.Tag);
    BevelOuter := bvNone;
    Align := alBottom;
    Height := Round(Tab.Height * 0.3);
    AlignWithMargins := True;
    Margins.Top := 4;
    Margins.Right := 0;
    Margins.Bottom := 0;
    Margins.Left := 0;
    Caption := '';
    Parent := Tab;
  end;
  { Create Ststus panel }
  StatusPanel := TPanel.Create(paGrid);
  with StatusPanel do
  begin
    Parent := paGrid;
    Name := 'paBottom' + pcEditors.Name + IntToStr(pcEditors.Tag);
    BevelOuter := bvNone;
    Align := alBottom;
    Height := 25;
    AlignWithMargins := True;
    Margins.Top := 4;
    Margins.Left := 4;
    Margins.Right := 0;
    Margins.Bottom := 0;
    Caption := '';
  end;
  with TLabel.Create(Tab) do
  begin
    Parent := StatusPanel;
    Align := alLeft;
    Name := 'laResult' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Caption := '';
    Tag := 1;
  end;
  { Create Cancel execution button }
  with TcxButton.Create(Tab) do
  begin
    Parent := StatusPanel;
    Name := 'buCancelExec' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Caption := 'Cancel Execition';
    Align := alRight;
    Width := 110;
    OptionsImage.Images := dm.imListSmall;
    OptionsImage.ImageIndex := 1;
    Enabled := False;
    OnClick := CancelExecute;
  end;
  { Create UniQuerry - For select statements }
  Query := TUniQuery.Create(Tab);
  with Query do
  begin
    Name := 'qSQL' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Connection := Conn;
    if not Conn.AutoCommit then
      Transaction := Conn.DefaultTransaction;
    { Start transaction if editing thru grid}
    BeforePost := OnBeforeQueryPost;
    BeforeDelete:= OnBeforeQueryPost;
  end;
  { Create UniSQl - For DML and DDL actions }
  SQL := TUniSQL.Create(Tab);
  with SQL do
  begin
    Name := 'sSQL' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Connection := Conn;
    if not Conn.AutoCommit then
      Transaction := Conn.DefaultTransaction;
  end;
  { Create Data Source }
  DataSource := TDataSource.Create(Tab);
  with DataSource do
  begin
    Name := 'ds' + pcEditors.Name + IntToStr(pcEditors.Tag);
    DataSet := Query;
    AutoEdit := False;
  end;
  { Create Data Grid }
  cxGrid := TcxGrid.Create(paGrid);
  with cxGrid do
  begin
    Parent := paGrid;
    Name := 'cxGrid' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Align := alClient;
    LookAndFeel.NativeStyle := True;
    LockedStateImageOptions.Enabled := True;
    LockedStateImageOptions.ShowText := True;
    LockedStateImageOptions.Effect := lsieLight;
  end;
  { Create Grid Popup menu }
  with TcxGridPopupMenu.Create(paGrid) do
  begin
    Name := 'pmGrid' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Grid := cxGrid;
  end;
  { Create Grid Level }
  cxGridLevel := cxGrid.Levels.Add;
  cxGridLevel.Name := 'cxLevel' + pcEditors.Name + IntToStr(pcEditors.Tag);
  { Create Grid View }
  cxGridView := TcxGridDBTableView.Create(cxGridLevel);
  with cxGridView do
  begin
    Name := 'cxView' + pcEditors.Name + IntToStr(pcEditors.Tag);
    OptionsView.GroupByBox := False;
    OptionsView.Footer := True;
    OptionsCustomize.ColumnsQuickCustomization := True;
    DataController.DataSource := DataSource;
    OptionsBehavior.ImmediateEditor := False;
    OptionsBehavior.IncSearch := True;
    OptionsBehavior.BestFitMaxRecordCount := 5;
    OptionsData.Inserting := False;
    //OptionsData.Editing := False;
    OptionsData.Deleting := False;
    Styles.Content := dm.GridContent;
    Styles.ContentOdd := dm.GridAltRow;
    Styles.Header := dm.GridHeader;
    Styles.OnGetContentStyle := onGetContentStyle;
    OnCellDblClick := onDataGridDblClick;
  end;
  { Assign Grid View to Grid Level }
  cxGridLevel.GridView := cxGridView;
  { Create editor splitter }
  Splitter := TSplitter.Create(Tab);
  with Splitter do
  begin
    Name := 'spEditor' + pcEditors.Name + IntToStr(pcEditors.Tag);
    Align := alBottom;
    Beveled := True;
    Parent := Tab;
    Top := 0;
  end;
  try
    ActiveControl := GetSQLEditor(Tab);
  except
  end;
  EditorButtonState;
  Result := Tab;
end;

function Tmain.CreateSessionTab(SessionName: String): TcxTabSheet;
var
  i: Integer;
  Tab: TcxTabSheet;
  SynSQL: TSynSQLSyn;
  IniFile, Config: TIniFile;
  PC: TcxPageControl;
  Meta: TUniMetaData;
  dsInfo: TDataSource;
  browserPanel, infoPanel, commitPanel, searchPanel: TPanel;
  AutoCommitItem: TcxImageComboBoxItem;
  memTable: TSQLMemTable;
begin
  { Try to find existing connectoin }
  Tab := nil;
  for i := 0 to pcSessions.PageCount - 1 do
  begin
    if pcSessions.Pages[i].Caption = SessionName then
    begin
      { Found it! Set it to current }
      Tab := pcSessions.Pages[i];
      // DONE : Check if session is active
      CreateSession(SessionName);
      break;
    end;
  end;
  { Session not found - create it }
  if Tab = nil then
  begin
    Tab := TcxTabSheet.Create(pcSessions);
    with Tab do
    begin
      PageControl := pcSessions;
      pcSessions.Tag := pcSessions.Tag + 1;
      Name := 'tsSession' + IntToStr(pcSessions.Tag);
      Caption := SessionName;
      AlignWithMargins := True;
      Margins.Top := 4;
      Margins.Right := 4;
      Margins.Bottom := 4;
      Margins.Left := 0;     
    end;
    pcSessions.ActivePage := Tab;
    { Find environment icon from INI file }
    IniFile := dm.GetSessionIniFile;
    { Find Editor and DataGrid styles }
    Config := dm.GetConfigIniFile;
    try
      Tab.ImageIndex := dm.getConnectionImage(IniFile.ReadInteger(SessionName, 'db_environment', -1));
      { Create schema browser }
      browserPanel := TPanel.Create(Tab);
      with browserPanel do
      begin
        Parent := Tab;
        Name := 'paBrowser' + Tab.Name;
        BevelOuter := bvNone;
        BorderWidth := 4;
        Caption := '';
        Align := alLeft;
        Width := 250;
      end;
      { Create database browser search panel }
      searchPanel := TPanel.Create(Tab);
      with searchPanel do
      begin
        Parent := browserPanel;
        Name := 'paSearch' + Tab.Name;
        BevelOuter := bvNone;
        Align := alTop;
        Height := 30;
        Caption := '';
      end;
      { Create input search }
      with TEdit.Create(Self) do
      begin
        Parent := searchPanel;
        Name := 'edSearch' + Tab.Name;
        Top := 0;
        Left := 0;
        Width := searchPanel.Width;
        Text := '';
        OnKeyDown := SearchKeyDown;
      end;
      { Create Memory DataSet for Object inspector }
      memTable := TSQLMemTable.Create(Tab);
      with memTable do
      begin
        Name := 'mdsObject' + Tab.Name;
        ReadOnly := False;
        with FieldDefs do
        begin
          Clear;
          Add('ID',ftAutoInc,0,False);
          Add('ICON',ftInteger,0,False);
          Add('PARENT',ftInteger,0,False);
          Add('VALUE',ftString,100,False);
        end;
        for i := 0 to FieldDefs.Count - 1 do
          FieldDefs[i].CreateField(memTable);


(*        iField := TIntegerField.Create(memTable);
        iField.FieldName := 'ID';
        iField.DataSet := memTable;
        iField.AutoGenerateValue := arAutoInc;
        iField.FieldKind := fkInternalCalc;
        iField := TIntegerField.Create(memTable);
        iField.FieldName := 'ICON';
        iField.DataSet := memTable;
        iField.FieldKind := fkInternalCalc;
        iField := TIntegerField.Create(memTable);
        iField.FieldName := 'PARENT';
        iField.DataSet := memTable;
        iField.FieldKind := fkInternalCalc;
        sField := TStringField.Create(memTable);
        sField.FieldName := 'VALUE';
        sField.DataSet := memTable;
        sField.Size := 100;
        sField.FieldKind := fkInternalCalc;  *)
        if not Exists then
          CreateTable;
      end;
      memTable.FieldByName('ID').AutoGenerateValue := arAutoInc;
      memTable.Open;

      { Create database object info panel }
      infoPanel := TPanel.Create(Tab);
      with infoPanel do
      begin
        Parent := browserPanel;
        Name := 'paObjectInfo' + Tab.Name;
        BevelOuter := bvNone;
        Align := alBottom;
        AlignWithMargins := True;
        Margins.Top := 4;
        Margins.Right := 0;
        Margins.Bottom := 0;
        Margins.Left := 0;
        Height := 150;
        Caption := '';
      end;
      commitPanel := TPanel.Create(infoPanel);
      with commitPanel do
      begin
        Parent := infoPanel;
        Name := 'paCommit' + Tab.Name;
        Align := alBottom;
        Height := 21;
        BevelOuter := bvNone;
        Caption := '';
      end;
      { Create Meta dataset }
      Meta := TUniMetaData.Create(Tab);
      Meta.Name := 'mtInfo' + Tab.Name;
      { Create Data source for vertical grid - object informations }
      dsInfo := TDataSource.Create(Tab);
      with dsInfo do
      begin
        AutoEdit := False;
        DataSet := Meta;
      end;
      { Create Vertical Grid for object info display }
      with TcxDBVerticalGrid.Create(Tab) do
      begin
        Parent := infoPanel;
        Name := 'vgInfo' + Tab.Name;
        Align := alClient;
        LookAndFeel.NativeStyle := True;
        DataController.DataSource := dsInfo;
        OptionsBehavior.ImmediateEditor := False;
        OptionsView.RowHeaderWidth := 120;
      end;
      { Create browser objects splitter }
      with TSplitter.Create(Tab) do
      begin
        Parent := browserPanel;
        Name := 'spObject' + Tab.Name;
        Align := alBottom;
        Beveled := True;
        Width := 2;
      end;
      { Create database object Tree View }
      with TcxTreeView.Create(Tab) do
      begin
        Parent := browserPanel;
        Name := 'tvObject' + Tab.Name;
        Align := alClient;
        AlignWithMargins := True;
        Margins.Top := 0;
        Margins.Right := 0;
        Margins.Bottom := 4;
        Margins.Left := 0;
        Images := dm.imListSmall;
        ReadOnly := True;
        Style.LookAndFeel.NativeStyle := True;
        OnExpanding := ObjectInspectorExpanding;
        OnChange := ObjectInspectorChange;
      end;
      { Create vertical splitter with hotzone }
      with TcxSplitter.Create(Tab) do
      begin
        Parent := Tab;
        name := 'spBrowser' + Tab.Name;
        AlignSplitter := salLeft;
        HotZoneStyleClass := TcxSimpleStyle;
        Control := browserPanel;
        CloseSplitter;
      end;
      PC := TcxPageControl.Create(Tab);
      with PC do
      begin
        Parent := Tab;
        Name := 'pcEditors' + Tab.Name;
        LookAndFeel.NativeStyle := True;
        Align := alClient;
        Tag := 0;
        Properties.AllowTabDragDrop := True;
        Properties.CloseButtonMode := cbmActiveAndHoverTabs;
        Properties.CloseTabWithMiddleClick := True;
        OnMouseDown := PageControlMouseClick;
        OnContextPopup := PageControlContexPopup;
        OnCanCloseEx := OnEditorClose;
        OnChange := pcEditorOnChange;
      end;
      { Create Highlighter for Editor }
      SynSQL := TSynSQLSyn.Create(Tab);
      with SynSQL do
      begin
        Name := 'sySQL' + Tab.Name;
      end;
      dm.Style(SynSQL);
      Meta.Connection := CreateSession(SessionName);
      if Meta.Connection = nil then
      begin
        Result := nil;
        Exit;
      end;
      dm.NewTabWorker(Tab, Meta.Connection);
      { Create auto-commit combo box }
      with TcxImageComboBox.Create(commitPanel) do
      begin
        Parent := commitPanel;
        Left := -1;
        Top := 0;
        Properties.Images := dm.imListSmall;
        Properties.OnChange := OnAutoCommitChange;
        AutoCommitItem := Properties.Items.Add;
        AutoCommitItem.Value := 1;
        AutoCommitItem.Description := 'Auto Commit';
        AutoCommitItem.ImageIndex := 17;
        AutoCommitItem := Properties.Items.Add;
        AutoCommitItem.Value := 0;
        AutoCommitItem.Description := 'No Auto Commit';
        AutoCommitItem.ImageIndex := 18;
        if Meta.Connection.AutoCommit then
          ItemIndex := 0
        else
          ItemIndex := 1;
      end;
      SynSQL.SQLDialect := GetSyntaxType(Meta.Connection.ProviderName);
      AddSqlEditor(PC);      
    finally
      IniFile.Free;
      Config.Free;
    end;
  end;
  Result := Tab;
end;

function Tmain.CreateSession(SessionName: String): TUniConnection;
var
  Tab: TcxTabSheet;
  IniFile: TIniFile;
  Method: Integer;
  Provider: TUniProvider;
  Session: TUniConnection;
  fSQLite: TextFile;
begin
  Result := nil;
  { Find session tab }
  Tab := GetSessionTab(SessionName);
  if Tab = nil then
    Exit;
  { Find current session if exists }
  Result := GetSession(SessionName);
  if Result <> nil then
  begin
    if Result.Connected then
      Exit;
    Result.Free;
    DisconnectSSH(Tab);
  end;
  { Create new session }
  Session := TUniConnection.Create(Tab);
//  Session2 := TUniConnection.Create(Tab);
  IniFile := dm.GetSessionIniFile;
  try
    with Session do
    begin
      Name := 'con' + Tab.Name;
      LoginPrompt := False;
      Method := IniFile.ReadInteger(SessionName, 'session_type', -1);
      ProviderName := IniFile.ReadString(SessionName, 'db_provider', '');
      Server := IniFile.ReadString(SessionName, 'db_server', '');
      Username := IniFile.ReadString(SessionName, 'db_user', '');
      Password := String(Decrypt(AnsiString(IniFile.ReadString(SessionName, 'db_pass', '')), dm.encrypt_key));
      Provider := TUniUtils.GetProvider(Session);
      AutoCommit := IniFile.ReadBool(SessionName, 'db_auto_commit', False);
      if IniFile.ReadBool(SessionName, 'db_use_unicode', False) then
        SpecificOptions.Values['UseUnicode'] := 'True';
      if Provider.IsPortSupported then
      begin
        if Method = 1 then
          Port := StrToIntDef(IniFile.ReadString(SessionName, 'ssh_listen_port', ''), 0)
        else
          Port := StrToIntDef(IniFile.ReadString(SessionName, 'db_port', ''), 0);
      end;
      if Provider.IsDatabaseSupported then
        Database := IniFile.ReadString(SessionName, 'db_database', '')
      else
        Database := IniFile.ReadString(SessionName, 'db_user', '');
      {Set default schema for Postgres}
      if (Provider is TPostgreSQLUniProvider) and (SpecificOptions.Values['SCHEMA'] = '') then
        SpecificOptions.Values['SCHEMA'] := 'public';
      {Check if SQLLite file exists}
      if (Provider is TSQLiteUniProvider) then
      begin
        SpecificOptions.Values['Direct'] := 'True';
        if not FileExists(Database) then
        begin
          if MessageDlg('SQLite database not found! Create new database?', mtConfirmation, mbYesNo, 0, mbYes) = mrYes then
          begin
            try
              AssignFile(fSQLite, Database);
              Rewrite(fSQLite);
            finally
              CloseFile(fSQLite);
            end;
          end;
        end;
      end;
      { Create SSH tunnef if needed }
      if Method = 1 then
      begin
        dm.ConnectSSH(Tab, IniFile.ReadString(SessionName, 'ssh_hostname', ''), IniFile.ReadString(SessionName, 'ssh_port', '22'), IniFile.ReadString(SessionName, 'ssh_username', ''), String(Decrypt(AnsiString(IniFile.ReadString(SessionName, 'ssh_password', '')), dm.encrypt_key)),
          String(Decrypt(AnsiString(IniFile.ReadString(SessionName, 'ssh_key', '')), dm.encrypt_key)), IniFile.ReadString(SessionName, 'ssh_listen_port', ''), IniFile.ReadString(SessionName, 'db_server', ''), IniFile.ReadString(SessionName, 'db_port', ''));
      end;
      { Assign params to Session2 }
      (*Session2.Name := 'new' + Name;
      Session2.LoginPrompt := LoginPrompt;
      Session2.ProviderName := ProviderName;
      Session2.Server := Server;
      Session2.Username := Username;
      Session2.Password := Password;
      Session2.AutoCommit := AutoCommit;
      Session2.SpecificOptions := SpecificOptions;
      Session2.Port := Port;
      Session2.Database := Database; *)
      try
        Connected := True;
        //Session2.Connected := True;
      except
        on E: Exception do
        begin
          ShowMessage(E.ClassName + ' error raised, with message : ' + E.Message);
          Exit;
        end;
      end;
      GetSessionObjects(Session);
    end;
  finally
    IniFile.Free;
  end;
  Result := Session;
end;

procedure Tmain.DisplaySessionObjects;
var
  RootNode, Node: TTreeNode;
  tableID: Integer;
  memTable: TSQLMemTable;
  TreeView: TcxTreeView;
  SearchEdit: TEdit;
  Conn: TUniConnection;
  Search: String;
begin
  RootNode := nil;
  tableID := 0;
  Conn := GetSession(pcSessions.ActivePage.Caption);
  if Conn = nil then Exit;
  TreeView := GetObjectInspector(Conn);
  if TreeView = nil then Exit;
  SearchEdit := GetSearchEdit(Conn);
  if SearchEdit = nil then
    Search := ''
  else
    Search := SearchEdit.Text;
  TreeView.Items.Clear;
  memTable := GetObjectMemTable(TcxTabSheet(TreeView.Parent.Parent));
  memTable.First;
  while not memTable.Eof do
  begin
    if memTable.FieldByName('PARENT').AsInteger = 0 then
    begin
      if RootNode <> nil then
      begin
        RootNode.Text := RootNode.Text + ' ('+ IntToStr(RootNode.Count) + ')';
        if Search <> '' then
          RootNode.Expand(False);
      end;
      RootNode := TreeView.Items.Add(nil, memTable.FieldByName('VALUE').Value);
      RootNode.ImageIndex := memTable.FieldByName('ICON').Value;
      RootNode.SelectedIndex := RootNode.ImageIndex;
      if (memTable.FieldByName('VALUE').AsString = 'Tables') and (memTable.FieldByName('PARENT').IsNull) then
        tableID := memTable.FieldByName('ID').AsInteger;
    end
    else
    begin
      if (Search = '') or (pos(LowerCase(Search), LowerCase(memTable.FieldByName('VALUE').AsString)) > 0) then
      begin
        Node := TreeView.Items.AddChild(RootNode, memTable.FieldByName('VALUE').Value);
        Node.ImageIndex := memTable.FieldByName('ICON').Value;
        Node.SelectedIndex := RootNode.ImageIndex;
        if (memTable.FieldByName('PARENT').AsInteger <> 0) and (memTable.FieldByName('PARENT').Value = tableID) then
          Node.HasChildren := True;
      end;
    end;
    memTable.Next;
  end;
  if RootNode <> nil then
  begin
    RootNode.Text := RootNode.Text + ' ('+ IntToStr(RootNode.Count) + ')';
    if Search <> '' then
      RootNode.Expand(False);
  end;
end;

procedure Tmain.GetSessionObjects(Conn: TUniConnection);
var
  Meta: TUniMetaData;
  TV: TcxTreeView;
  SynSQL: TSynSQLSyn;
  List: TStringList;
  ParentID: Integer;
  memTable: TSQLMemTable;
  Provider: TUniProvider;
begin
  if Conn = nil then Exit;
  TV := GetObjectInspector(Conn);
  TV.Items.Clear;
  Meta := TUniMetaData.Create(nil);
  List := TStringList.Create;
  SynSQL := GetSyntaxSQL(TcxTabSheet(TV.Parent.Parent));
  memTable := GetObjectMemTable(TcxTabSheet(TV.Parent.Parent));
  memTable.Open;
  try
    Meta.Connection := Conn;
    { Tables }
    memTable.Append;
    memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
    memTable.FieldByName('VALUE').AsString := 'Tables';
    memTable.FieldByName('ICON').Value := 10;
    ParentID := memTable.FieldByName('ID').AsInteger;
    Meta.Active := False;
    Meta.MetaDataKind := 'Tables';
    if (pos('/', Conn.Database) > 0) or (pos('\', Conn.Database) > 0) then
      Meta.Restrictions.Values['TABLE_CATALOG'] := Conn.Database
    else
      if Conn.SpecificOptions.Values['SCHEMA'] <> '' then
      begin
        Meta.Restrictions.Values['TABLE_CATALOG'] := Conn.Database;
        Meta.Restrictions.Values['TABLE_SCHEMA'] := Conn.SpecificOptions.Values['SCHEMA'];
      end
      else
        Meta.Restrictions.Values['TABLE_SCHEMA'] := Conn.Database;
    Provider := TUniUtils.GetProvider(Conn);
    if Provider is TPostgreSQLUniProvider then
      Meta.Restrictions.Values['TABLE_TYPE'] := 'TABLE'
    else
      Meta.Restrictions.Values['TABLE_TYPE'] := 'TABLE,BASE TABLE,VIEW';
    Meta.Active := True;
    while not Meta.Eof do
    begin
      memTable.Append;
      memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
      memTable.FieldByName('VALUE').AsString := Meta.FieldByName('TABLE_NAME').AsString;
      memTable.FieldByName('ICON').Value := 10;
      memTable.FieldByName('PARENT').Value := ParentID;
      List.Add(Meta.FieldByName('TABLE_NAME').AsString);
      Meta.Next;
    end;
    SynSQL.TableNames := List;
    List.Clear;
    { Procedures }
    memTable.Append;
    memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
    memTable.FieldByName('VALUE').AsString := 'Procedures';
    memTable.FieldByName('ICON').Value := 16;
    ParentID := memTable.FieldByName('ID').AsInteger;
    Meta.Active := False;
    Meta.MetaDataKind := 'Procedures';
    Meta.Restrictions.Clear;
    Meta.Restrictions.Values['PROCEDURE_SCHEMA'] := Conn.Database;
    Meta.Restrictions.Values['PROCEDURE_TYPE'] := 'PROCEDURE';
    Meta.Active := True;
    while not Meta.Eof do
    begin
      memTable.Append;
      memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
      memTable.FieldByName('VALUE').AsString := Meta.FieldByName('PROCEDURE_NAME').AsString;
      memTable.FieldByName('ICON').Value := 16;
      memTable.FieldByName('PARENT').Value := ParentID;
      Meta.Next;
    end;
    { Functions }
    memTable.Append;
    memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
    memTable.FieldByName('VALUE').AsString := 'Functions';
    memTable.FieldByName('ICON').Value := 16;
    ParentID := memTable.FieldByName('ID').AsInteger;
    Meta.Active := False;
    Meta.Restrictions.Values['PROCEDURE_TYPE'] := 'FUNCTION';
    Meta.Active := True;
    while not Meta.Eof do
    begin
      memTable.Append;
      memTable.FieldByName('ID').Value := memTable.RecordCount + 1;
      memTable.FieldByName('VALUE').AsString := Meta.FieldByName('PROCEDURE_NAME').AsString;
      memTable.FieldByName('ICON').Value := 16;
      memTable.FieldByName('PARENT').Value := ParentID;
      List.Add(Meta.FieldByName('PROCEDURE_NAME').AsString);
      Meta.Next;
    end;
    { BUG in TSynSQLSyn component. AV is raised when FunctionNames list is used
      Highlighting of functions not working
      AV is raised when trying to free objects }
    // SynSQL.FunctionNames := List;
    DisplaySessionObjects;
  finally
    Meta.Free;
    List.Free;
  end;
end;

function Tmain.GetDataType(ParamType: String): TFieldType;
begin
  if ParamType = 'String' then
    Result := ftString
  else if ParamType = 'Integer' then
    Result := ftInteger
  else if ParamType = 'Decimal' then
    Result := ftFloat
  else
    Result := ftString;
end;

procedure Tmain.miChangeQuoteClick(Sender: TObject);
var
  Editor: TSynEdit;
begin
  Editor := TSynEdit(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent);
  Editor.Text := StringReplace(Editor.Text, '"', '''', [rfReplaceAll, rfIgnoreCase]);
end;

procedure Tmain.miSelectForUpdateClick(Sender: TObject);
var
  Tab: TcxTabSheet;
  GridView: TcxGridDBTableView;
begin
  Tab := TcxTabSheet(TPopupMenu(TMenuItem(Sender).GetParentMenu).PopupComponent.GetParentComponent.GetParentComponent);
  GridView := GetSQLGridView(Tab);
  GridView.DataController.DataSource.AutoEdit := not TMenuItem(Sender).Checked;
  GridView.Navigator.Visible := not TMenuItem(Sender).Checked;
  GridView.OptionsData.Inserting := not TMenuItem(Sender).Checked;
  GridView.OptionsData.Deleting := not TMenuItem(Sender).Checked;
end;

procedure Tmain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iCount: Integer;
begin
  while pcSessions.PageCount > 0 do
  begin
    pcSessions.ActivePageIndex := 0;
    iCount := pcSessions.PageCount;
    TcxPageControlPropertiesAccess(pcSessions.Properties).CloseActiveTab;
    if iCount = pcSessions.PageCount then
      Abort;
  end;
end;

procedure Tmain.DisconnectSSH(Tab: TcxTabSheet);
var
  i, j, success, maxWaitMs: Integer;
  sshTunnel: TChilkatSshTunnel;
begin
  for j := 0 to pcSessions.PageCount - 1 do
  begin
    for i := 0 to pcSessions.Pages[j].ComponentCount - 1 do
    begin
      { If specific tab provided, skip all other tabs }
      if (Tab <> nil) and (pcSessions.Pages[j] <> Tab) then
        continue;
      if pcSessions.Pages[j].Components[i] is TChilkatSshTunnel then
      begin
        sshTunnel := TChilkatSshTunnel(pcSessions.Pages[j].Components[i]);
        // When you're finished with the database connection, you may
        // stop the background tunnel threads:
        // Stop the background thread that accepts new connections:
        success := sshTunnel.StopAccepting();
        if (success <> 1) then
        begin
          ShowMessage(sshTunnel.LastErrorText);
          continue;
        end;
        // If any background tunnels are still in existence (and managed
        // by a single SSH tunnel pool background thread), stop them...
        maxWaitMs := 1000;
        success := sshTunnel.StopAllTunnels(maxWaitMs);
        if (success <> 1) then
        begin
          ShowMessage(sshTunnel.LastErrorText);
          continue;
        end;
      end;
    end;
  end;
end;

procedure Tmain.FormCreate(Sender: TObject);
begin
  dm.Main := TMain(Sender);
  if not DirectoryExists(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '\OneSQL\') then
  begin
    SetCurrentDir(GetSpecialFolderPath(CSIDL_LOCAL_APPDATA));
    CreateDir('OneSQL');
  end;
  dm.AppDataFolder := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '\OneSQL\';
  dm.application_name := Application.ExeName;
  InitLogDB;
  LoadGenericOptions;
  LoadEditorOptions;
  InitEditorParams(EditorParams);
end;

procedure Tmain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  PC: TcxPageControl;
begin
  PC := GetActiveEditorPC;
  { Add new editor }
  if (ssCtrl in Shift) and (Key = Ord('T')) then
    buNewEditor.Click;
  if (ssCtrl in Shift) and (Key = VK_TAB) then
  begin
    if ssShift in Shift then
      PC.SelectNextPage(False)
    else
      PC.SelectNextPage(True);
  end;
  { Close Tab }
  if (ssCtrl in Shift) and (Key = VK_F4) and (PC <> nil) and (PC.PageCount > 0) then
    TcxPageControlPropertiesAccess(PC.Properties).CloseActiveTab;
  { Show Session Manager }
  if (Key = VK_F6) then
    buSessionManager.Click;
  { Show History }
  if (Key = VK_F12) then
    buHistory.Click;
end;

procedure Tmain.FormShow(Sender: TObject);
begin
  tiOpen.Enabled := True;
end;

procedure Tmain.FreeParams(Editor: TSynEdit);
var
  i: Integer;
  P: TParams;
begin
  if Editor = nil then Exit;
  for i := 1 to maxEditors do
  begin
    if EditorParams[i].Editor = Editor then
    begin
      InitParams(P);
      EditorParams[i].Editor := nil;
      EditorParams[i].Params := P;
      EditorParams[i].FileName := '';
      break;
    end;
  end;
end;

function Tmain.GetActiveEditorPC: TcxPageControl;
var
  i: Integer;
begin
  Result := nil;
  if pcSessions.PageCount = 0 then
    Exit;
  for i := 0 to pcSessions.ActivePage.ControlCount - 1 do
  begin
    if pcSessions.ActivePage.Controls[i] is TcxPageControl then
    begin
      Result := TcxPageControl(pcSessions.ActivePage.Controls[i]);
      break;
    end;
  end;
end;

function Tmain.GetCancelButton(Control: TWinControl): TcxButton;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ControlCount - 1 do
  begin
    if (Control.Controls[i] is TcxButton) and (copy(Control.Controls[i].Name, 1, 12) = 'buCancelExec') then
    begin
      Result := TcxButton(Control.Controls[i]);
      Break;
    end;
    if Control.Controls[i] is TWinControl then
      Result := GetCancelButton(TWinControl(Control.Controls[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetResultLabel(Control: TWinControl): TLabel;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ControlCount - 1 do
  begin
    if (Control.Controls[i] is TLabel) and (copy(Control.Controls[i].Name, 1, 8) = 'laResult') then
    begin
      Result := TLabel(Control.Controls[i]);
      Break;
    end;
    if Control.Controls[i] is TWinControl then
      Result := GetResultLabel(TWinControl(Control.Controls[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetCursorSQL(Text: String; CursorPos: Integer): String;
var
  LastPos, iPos: Integer;
  IniPos, FinPos: Integer;
  offset: Integer;
begin
  offset := length(Text) - length(TrimLeft(Text));
  CursorPos := CursorPos - offset;
  Text := Trim(Text);
  iPos := 1;
  Repeat
    LastPos := iPos;
    iPos := PosEx(#13#10#13#10, Text, iPos);
    if (iPos <> 0) then
      Inc(iPos, 2);
  until (iPos = 0) or (CursorPos < iPos - 1);
  if (iPos = 0) then
    iPos := length(Text)
  else
    Dec(iPos, 2);
  FinPos := iPos;
  IniPos := LastPos;
  Result := Trim(copy(Text, IniPos, FinPos - IniPos + 1));
  if copy(Result, length(Result)) = ';' then
    Result := copy(Result, 1, length(Result) - 1);
end;

function Tmain.GetMetaData: TUniMetaData;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to pcSessions.ActivePage.ComponentCount - 1 do
  begin
    if pcSessions.ActivePage.Components[i] is TUniMetaData then
    begin
      Result := TUniMetaData(pcSessions.ActivePage.Components[i]);
      break;
    end;
  end;
end;

function Tmain.GetObjectInfoGrid(Control: TWinControl): TcxDBVerticalGrid;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TcxDBVerticalGrid then
    begin
      Result := TcxDBVerticalGrid(Control.Controls[i]);
      Exit;
    end;
    Result := GetObjectInfoGrid(TWinControl(Control.Controls[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetSearchEdit(Conn: TUniConnection): TEdit;
var
  Tab: TcxTabSheet;
begin
  Result := nil;
  if Conn = nil then Exit;
  Tab := TcxTabSheet(Conn.Owner);
  if Tab = nil then Exit;
  Result := FindComponent('edSearch'+Tab.Name) as TEdit;
end;

function Tmain.GetObjectInspector(Conn: TUniConnection): TcxTreeView;
var
  Tab: TcxTabSheet;
  i, j: Integer;
begin
  Result := nil;
  if Conn = nil then Exit;
  Tab := TcxTabSheet(Conn.Owner);
  if Tab = nil then
    Exit;
  for i := 0 to Tab.ControlCount - 1 do
  begin
    if (Tab.Controls[i] is TPanel) and (Tab.Controls[i].Align = alLeft) then
    begin
      for j := 0 to TPanel(Tab.Controls[i]).ControlCount - 1 do
        if TPanel(Tab.Controls[i]).Controls[j] is TcxTreeView then
        begin
          Result := TcxTreeView(TPanel(Tab.Controls[i]).Controls[j]);
          Break;
        end;
    end;
  end;
end;

function Tmain.GetObjectMemTable(Tab: TcxTabSheet): TSQLMemTable;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Tab.ComponentCount -1 do
    if Tab.Components[i] is TSQLMemTable then
    begin
      Result := TSQLMemTable(Tab.Components[i]);
      break;
    end;
end;

function Tmain.GetSession(SessionName: String): TUniConnection;
var
  Tab: TcxTabSheet;
  i: Integer;
begin
  Result := nil;
  Tab := GetSessionTab(SessionName);
  if Tab = nil then
    Exit;
  for i := 0 to Tab.ComponentCount - 1 do
  begin
    if (Tab.Components[i] is TUniConnection) and (copy(Tab.Components[i].Name, 1, 3) = 'con') and (Tab.Components[i].Tag = 0) then
    begin
      Result := TUniConnection(Tab.Components[i]);
      break;
    end;
  end;
end;

(*function Tmain.GetNewSession(SessionName: String): TUniConnection;
var
  Tab: TcxTabSheet;
  i: Integer;
begin
  Result := nil;
  Tab := GetSessionTab(SessionName);
  if Tab = nil then
    Exit;
  for i := 0 to Tab.ComponentCount - 1 do
  begin
    if (Tab.Components[i] is TUniConnection) and (copy(Tab.Components[i].Name, 1, 3) = 'new') then
    begin
      Result := TUniConnection(Tab.Components[i]);
      break;
    end;
  end;
end; *)

function Tmain.GetSessionTab(SessionName: String): TcxTabSheet;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to pcSessions.PageCount - 1 do
  begin
    if pcSessions.Pages[i].Caption = SessionName then
    begin
      Result := pcSessions.Pages[i];
      break;
    end;
  end;
end;

function Tmain.GetSQLEditor(Control: TWinControl): TSynEdit;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TSynEdit then
    begin
      Result := TSynEdit(Control.Controls[i]);
      Break;
    end;
    Result := GetSQLEditor(TWinControl(Control.Controls[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetUniSQL(Control: TWinControl): TUniSQL;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ComponentCount - 1 do
  begin
    if Control.Components[i] is TUniSQL then
    begin
      Result := TUniSQL(Control.Components[i]);
      Exit;
    end;
    if Control.Components[i] is TWinControl then
      Result := GetUniSQL(TWinControl(Control.Components[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetSQLGridView(Control: TWinControl): TcxGridDBTableView;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Control.ControlCount - 1 do
  begin
    if Control.Controls[i] is TcxGrid then
    begin
      Result := TcxGridDBTableView(TcxGrid(Control.Controls[i]).ActiveView);
      break;
    end;
    if Control.Controls[i] is TWinControl then
      Result := GetSQLGridView(TWinControl(Control.Controls[i]));
    if Assigned(Result) then
      break;
  end;
end;

function Tmain.GetSyntaxSQL(Tab: TcxTabSheet): TSynSQLSyn;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Tab.ComponentCount - 1 do
    if Tab.Components[i] is TSynSQLSyn then
    begin
      Result := TSynSQLSyn(Tab.Components[i]);
      break;
    end;
end;

function Tmain.GetSyntaxType(Database: String): TSQLDialect;
begin
  if Database = 'Oracle' then
    Result := sqlOracle
  else if Database = 'MySQL' then
    Result := sqlMySQL
  else if Database = 'InterBase' then
    Result := sqlInterbase6
  else if Database = 'SQL Server' then
    Result := sqlMSSQL2K
  else if Database = 'PostgreSQL' then
    Result := sqlPostgres
  else
    Result := sqlStandard;
end;

procedure Tmain.acNewEditorExecute(Sender: TObject);
begin
  AddSqlEditor(GetActiveEditorPC);
end;

procedure Tmain.InitEditorParams(var EP: TEditorParams);
var
  i: Integer;
  P: TParams;
begin
  for i := 1 to maxEditors do
  begin
    InitParams(P);
    EP[i].Editor := nil;
    EP[i].FileName := '';
    EP[i].Params := P;
  end;
end;

procedure Tmain.InitLogDB;
var
  sLogDB: String;
  fSQLite: TextFile;
begin
  sLogDB := dm.AppDataFolder + 'LogDB.sqlite3';
  try
    if not FileExists(sLogDB) then
    begin
      AssignFile(fSQLite, sLogDB);
      Rewrite(fSQLite);
      CloseFile(fSQLite);
    end;
    SQLiteLogCon.Database := sLogDB;
    SQLiteLogCon.Connect;
    qLog.SQL.Text := 'create table if not exists sql_history (id INTEGER PRIMARY KEY AUTOINCREMENT, sess TEXT, statement  TEXT, ts DATETIME DEFAULT CURRENT_TIMESTAMP);';
    qLog.Execute;
  except
    on E: EDatabaseError do
      ShowMessage('Exception raised with message' + E.Message);
  end;
end;

procedure Tmain.InitParams(var P: TParams);
var
  i: Integer;
begin
  for i := 1 to maxParams do
  begin
    P[i].Active := '0';
    P[i].ParamName := '';
    P[i].ParamType := 'String';
    P[i].ParamValue := null;
  end;
end;

function Tmain.IsTextFile(const sFile: TFileName): Boolean;
var
  oIn: TFileStream;
  iRead: Integer;
  iMaxRead: Integer;
  iData: Byte;
  dummy: string;
begin
  Result := True;
  dummy := '';
  oIn := TFileStream.Create(sFile, fmOpenRead or fmShareDenyNone);
  try
    iMaxRead := 1000; // only text the first 1000 bytes
    if iMaxRead > oIn.Size then
      iMaxRead := oIn.Size;
    for iRead := 1 to iMaxRead do
    begin
      oIn.Read(iData, 1);
      if iData = 0 then
      begin
        Result := False;
        break;
      end;
    end;
  finally
    FreeAndNil(oIn);
  end;
end;

procedure Tmain.LoadEditorOptions;
begin
  Screen.Cursors[crSQLWait] := Screen.Cursors[crHourGlass];
  pcSessions.OnMouseDown := PageControlMouseClick;
  EditorButtonState;
end;

procedure Tmain.LoadGenericOptions;
var
  IniFile: TIniFile;
begin
  IniFile := dm.GetConfigIniFile;
  try
    with IniFile do
    begin
      dm.GridContent.Font.Name := ReadString(secDataGrid, 'FontName', 'Tahoma');
      dm.GridContent.Font.Size := ReadInteger(secDataGrid, 'FontSize', 10);
      dm.GridContent.TextColor := ReadInteger(secDataGrid, 'Color', clBlack);
      dm.GridContent.Color := ReadInteger(secDataGrid, 'Background', clWhite);
      dm.GridAltRow.Font := dm.GridContent.Font;
      dm.GridAltRow.TextColor := dm.GridContent.TextColor;
      dm.GridAltRow.Color := $00F0F0F0;
      dm.GridHeader.Font := dm.GridContent.Font;
      cNullString := ReadString(secDataGrid, 'NullString', '{null}');
      dm.NullString.Color := ReadInteger(secDataGrid, 'NullStringBackground', clWhite);
      dm.NullString.Font := dm.GridContent.Font;

      dm.LineEnding := ReadInteger(secGeneral, 'LineEnding', 0);
      sdSQL.InitialDir := ReadString(secGeneral, 'SqlDirectory', '');
      if ReadBool(secDataGrid, 'NullStringBold', false) then
        dm.NullString.Font.Style := dm.NullString.Font.Style + [fsBold];
      if ReadBool(secDataGrid, 'NullStringItalic', false) then
        dm.NullString.Font.Style := dm.NullString.Font.Style + [fsItalic];
    end;
  finally
    IniFile.Free;
  end;
end;

function Tmain.LoadParams(Editor: TSynEdit): TParams;
var
  i: Integer;
  P: TParams;
begin
  InitParams(P);
  Result := P;
  for i := 1 to maxEditors do
  begin
    if EditorParams[i].Editor = Editor then
    begin
      Result := EditorParams[i].Params;
      break;
    end;
  end;
end;

procedure Tmain.Log(Sess: String; Statement: String);
var
  sInsert: String;
begin
  Statement := Trim(Statement);
  sInsert := 'insert into sql_history (sess, statement) values ('''+ Sess + ''','+ QuotedStr(Statement) +');';
  try
    qLog.SQL.Text := sInsert;
    qLog.Execute;
  except
  end;
end;

function Tmain.GetEditorFileName(Editor: TSynEdit): TFileName;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to maxEditors do
  begin
    if EditorParams[i].Editor = Editor then
    begin
      Result := EditorParams[i].FileName;
      break;
    end;
  end;
end;

procedure Tmain.EditorOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Tab: TcxTabSheet;
  Ini: TIniFile;
begin
  { Execute SQL statement }
  if (Key = VK_F9) or ((ssCtrl in Shift) and (Key = VK_RETURN)) then
  begin
    if TSynEdit(Sender).Parent.Parent is TcxTabSheet then
      Tab := TcxTabSheet(TSynEdit(Sender).Parent.Parent)
    else
    begin
      ShowMessage('ERROR! Table grid not found!!!');
      Exit;
    end;
    ExecuteSQL(Tab);
  end;
  { Save SQL statement to file }
  if (ssCtrl in Shift) and (Key = Ord('S')) then
    buSaveSQL.Click;
  { Open SQL statement from file }
  if (ssCtrl in Shift) and (Key = Ord('O')) then
    buOpenSQL.Click;
  { Find }
  if (ssCtrl in Shift) and (Key = Ord('F')) then
    FindDialog.Execute;
  { Zoom in }
  if (ssCtrl in Shift) and (Key = VK_ADD) then
    if TSynEdit(Sender).Font.Size < 48 then
      TSynEdit(Sender).Font.Size := Round(TSynEdit(Sender).Font.Size * 1.1);
  { Zoom out }
  if (ssCtrl in Shift) and (Key = VK_SUBTRACT) then
    if TSynEdit(Sender).Font.Size > 5 then
      TSynEdit(Sender).Font.Size := Round(TSynEdit(Sender).Font.Size * 0.9);
  { Toom reset }
  if (ssCtrl in Shift) and (Key = VK_NUMPAD0) then
  begin
    Ini := dm.GetConfigIniFile;
    try
      TSynEdit(Sender).Font.Size := Ini.ReadInteger('Editor', 'FontSize', 10);
    finally
      Ini.Free;
    end;
  end;
end;

function Tmain.ParamValue(Param: TParam): Variant;
begin
  case GetDataType(Param.ParamType) of
    ftString:
      Result := VarToStr(Param.ParamValue);
    ftInteger:
      Result := StrToInt(VarToStr(Param.ParamValue));
    ftFloat:
      Result := StrToFloat(VarToStr(Param.ParamValue));
  end;
end;

procedure Tmain.ExecuteSQL(Tab: TcxTabSheet);
var
  i, j, recNo: Integer;
  varName, varType, sParamName, sParamType, lParamActive: String;
  vParamValue: Variant;
  Vars: TStringList;
  GridView: TcxGridDBTableView;
  DataSet: TUniQuery;
  SQL: TUniSQL;
  sql_text: String;
  MemoSQL: TSynEdit;
  Params: TParams;
  lSelect: Boolean;
  Conn: TUniConnection;
  Worker: TWorker;
  CancelBtn: TcxButton;
begin
  lSelect := False;
  GridView := GetSQLGridView(Tab);
  if not Assigned(GridView) then
  begin
    ShowMessage('ERROR! Data Grid not found!!!');
    Exit;
  end;
  MemoSQL := GetSQLEditor(Tab);
  if not Assigned(MemoSQL) then
  begin
    ShowMessage('ERROR! SQL Editor not found!!!');
    Exit;
  end;
  Conn := GetSession(pcSessions.ActivePage.Caption);
  { Remove all empty lines }
  for i := 0 to MemoSQL.Lines.Count - 1 do
    MemoSQL.Lines[i] := TrimRight(MemoSQL.Lines[i]);

  SQL := GetUniSQL(Tab);
  if SQL.Connection = nil then
    SQL.Connection := Conn;
  if SQL.Executing then Exit;
  DataSet := TUniQuery(GridView.DataController.DataSource.DataSet);
  if DataSet.Tag = 1 then
  begin
//    DataSet.Connection.Tag := 1;
//    temp_conn_name := DataSet.Connection.Name;
//    DataSet.Connection.Name := DataSet.Connection.Name + '_old';
//    Conn := CreateSession(pcSessions.ActivePage.Caption);
//    Conn := GetNewSession(pcSessions.ActivePage.Caption);
//    newDataSet.SQL := DataSet.SQL;
//    DataSet := TUniQuery.Create(Tab);
//    if not Conn.AutoCommit then
//      DataSet.Transaction := Conn.DefaultTransaction;
//    DataSet.Connection := Conn;
//    GridView.DataController.DataSource.DataSet := DataSet;
    Conn.Disconnect;
    Conn.Connect;
    DataSet.Tag := 0;
  end;
  if DataSet.Connection = nil then
    DataSet.Connection := Conn;
  DataSet.UnPrepare;
  if (DataSet.Executing) or (DataSet.Fetching) then Exit;
  { Get Cancel button and enable it}
  CancelBtn := GetCancelButton(Tab);
  if CancelBtn <> nil then
    CancelBtn.Enabled := True;

  { Start Execute }
  GridView.ClearItems;
  Params := LoadParams(MemoSQL);
  while paramForm.tvParams.DataController.RecordCount > 0 do
    paramForm.tvParams.DataController.DeleteRecord(0);
  sql_text := GetCursorSQL(MemoSQL.Lines.Text, MemoSQL.SelStart);
  if Trim(sql_text) = '' then
    Exit;
  if (LowerCase(copy(sql_text, 1, 4)) = 'sele') or (LowerCase(copy(sql_text, 1, 4)) = 'show') or (LowerCase(copy(sql_text, 1, 4)) = 'desc') then
    lSelect := True;
  DataSet.SQL.Text := sql_text;
  SQL.SQL.Text := sql_text;
  Vars := TStringList.Create;
  if lSelect then
  begin
    for i := 0 to DataSet.ParamCount - 1 do
      Vars.Values[DataSet.Params[i].Name] := 'PARAM';
    for i := 0 to DataSet.MacroCount - 1 do
      Vars.Values[DataSet.Macros[i].Name] := 'MACRO';
  end
  else
  begin
    if (not Conn.AutoCommit) and (not SQL.Connection.InTransaction) then
      SQL.Transaction.StartTransaction;
    for i := 0 to SQL.ParamCount - 1 do
      Vars.Values[SQL.Params[i].Name] := 'PARAM';
    for i := 0 to SQL.MacroCount - 1 do
      Vars.Values[SQL.Macros[i].Name] := 'MACRO';
  end;

  for i := 0 to Vars.Count - 1 do
  begin
    varName := copy(Vars.Strings[i], 1, pos('=', Vars.Strings[i]) - 1);
    varType := copy(Vars.Strings[i], pos('=', Vars.Strings[i]) + 1);
    sParamName := varName;
    if varType = 'MACRO' then
      sParamType := 'Substitution'
    else
      sParamType := 'String';
    vParamValue := null;
    lParamActive := '1';
    for j := 1 to maxParams do
    begin
      if Params[j].ParamName = sParamName then
      begin
        sParamName := Params[j].ParamName;
        sParamType := Params[j].ParamType;
        vParamValue := Params[j].ParamValue;
        lParamActive := Params[j].Active;
        break;
      end;
    end;
    if sParamName <> '' then
    begin
      with paramForm do
      begin
        if varType = 'MACRO' then
          sParamType := 'Substitution';
        recNo := tvParams.DataController.AppendRecord;
        tvParams.DataController.SetValue(recNo, 0, lParamActive);
        tvParams.DataController.SetValue(recNo, 1, sParamName);
        tvParams.DataController.SetValue(recNo, 2, sParamType);
        tvParams.DataController.SetValue(recNo, 3, vParamValue);
      end;
    end;
  end;
  if Vars.Count > 0 then
  begin
    if paramForm.ShowModal = mrOk then
    begin
      InitParams(Params);
      with paramForm do
      begin
        for i := 0 to tvParams.DataController.RecordCount - 1 do
        begin
          Params[i + 1].ParamName := tvParams.DataController.GetValue(i, 1);
          Params[i + 1].ParamType := tvParams.DataController.GetValue(i, 2);
          Params[i + 1].ParamValue := tvParams.DataController.GetValue(i, 3);
          Params[i + 1].Active := tvParams.DataController.GetValue(i, 0);
          { Save params for next execution }
          SaveParams(MemoSQL, '', Params);
          if Params[i + 1].ParamType = 'Substitution' then
          begin
            if Params[i + 1].Active = '1' then
              DataSet.MacroByName(Params[i + 1].ParamName).Value := VarToStr(Params[i + 1].ParamValue)
            else
              DataSet.MacroByName(Params[i + 1].ParamName).Value := '';
          end
          else
          begin
            if lSelect then
            begin
              DataSet.ParamByName(Params[i + 1].ParamName).DataType := GetDataType(Params[i + 1].ParamType);
              if Params[i + 1].Active = '1' then
                DataSet.ParamByName(Params[i + 1].ParamName).Value := ParamValue(Params[i + 1])
              else
                DataSet.ParamByName(Params[i + 1].ParamName).Value := null;
            end
            else
            begin
              SQL.ParamByName(Params[i + 1].ParamName).DataType := GetDataType(Params[i + 1].ParamType);
              if Params[i + 1].Active = '1' then
                SQL.ParamByName(Params[i + 1].ParamName).Value := ParamValue(Params[i + 1])
              else
                SQL.ParamByName(Params[i + 1].ParamName).Value := null;
            end;
          end;
        end;
      end;
    end
    else
      Exit;
  end;
  Worker := dm.GetTabWorker(pcSessions.ActivePage);
  if lSelect then
    Worker.AddWork(Tab, DataSet, nil, GridView)
  else
    Worker.AddWork(Tab, nil, SQL, GridView);
end;

procedure Tmain.ExecuteSQLCallback(EditorTab: TcxTabSheet; Query: TUniQuery; SQL: TUniSQL;
  GridView: TcxGridDBTableView; Error: String);
var
  i: Integer;
  CancelBtn: TcxButton;
  ResultLabel: TLabel;
  sCommand: String;
  sSqlText: String;
  sSession: String;
begin
  try
    ResultLabel := GetResultLabel(EditorTab);
    ResultLabel.Caption := '';
    if (SQL <> nil) then
    begin
      sSqlText := SQL.SQL.Text;
      sSession := TcxTabSheet(SQL.Connection.Owner).Caption;
      for i := 1 to Length(SQL.SQL.Text) do
        if SQL.SQL.Text[i].IsWhiteSpace then
          break;
      sCommand := copy(SQL.SQL.Text, 1, i-1);
      if sCommand  = 'create' then
        ResultLabel.Caption := 'Object successfully created'
      else if sCommand = 'alter' then
        ResultLabel.Caption := 'Object successfully altered'
      else if sCommand = 'drop' then
        ResultLabel.Caption := 'Object successfully droped'
      else if sCommand = 'insert' then
        ResultLabel.Caption := IntToStr(SQL.RowsAffected) + ' rows inserted'
      else if sCommand = 'update' then
        ResultLabel.Caption := IntToStr(SQL.RowsAffected) + ' rows updated'
      else if sCommand = 'delete' then
        ResultLabel.Caption := IntToStr(SQL.RowsAffected) + ' rows deleted';
    end;
    if (Query <> nil) and (Query.Active) then
    begin
      sSqlText := Query.SQL.Text;
      sSession := TcxTabSheet(query.Connection.Owner).Caption;
      GridView.DataController.CreateAllItems;
      for i := 0 to GridView.ColumnCount - 1 do
      begin
        if i = 0 then
        begin
          GridView.Columns[i].Summary.FooterKind := skCount;
          GridView.Columns[i].Summary.FooterFormat := '#,##0';
        end;
        if (GridView.Columns[i].DataBinding.Field is TBlobField) and (TBlobField(GridView.Columns[i].DataBinding.Field).BlobType = ftBlob) then
        begin
          GridView.Columns[i].PropertiesClass := TcxBlobEditProperties;
          TcxBlobEditProperties(GridView.Columns[i].Properties).BlobEditKind := bekMemo;
          TcxBlobEditProperties(GridView.Columns[i].Properties).MemoScrollBars := ssVertical;
        end;

        GridView.Columns[i].OnGetDisplayText := onGetDisplayText;
        GridView.Columns[i].MinWidth := 35;
        if GridView.Columns[i].Width > 150 then
          GridView.Columns[i].Width := 150;
      end;
    end;
    if ResultLabel.Caption = '' then
      ResultLabel.Caption := EditorTab.Hint
    else
      ResultLabel.Caption := ResultLabel.Caption + ', ' + EditorTab.Hint;
    Log(sSession, sSqlText);
  finally
    GridView.EndUpdate;
    { Get Cancel button and enable it}
    CancelBtn := GetCancelButton(EditorTab);
    if CancelBtn <> nil then
      CancelBtn.Enabled := False;
  end;
  if Error <> '' then
    ShowMessage(Error);
end;

procedure Tmain.ExportToFile(Format: string; DisableStyle: Boolean = False);
var
  Grid: TcxGridDBTableView;
  FileName: string;
begin
  sdExport.DefaultExt := LowerCase(Format) ;
  if sdExport.DefaultExt = 'xls' then
    sdExport.Filter := 'Excel Files|*.xls'
  else if sdExport.DefaultExt = 'csv' then
    sdExport.Filter := 'CSV Files|*.csv'
  else if sdExport.DefaultExt = 'html' then
    sdExport.Filter := 'Html Files|*.html'
  else if sdExport.DefaultExt = 'json' then
    sdExport.Filter := 'JSON Files|*.json'
  else
    Exit;
  Grid := GetSQLGridView(GetActiveEditorPC.ActivePage);
  if Grid = nil then
  begin
    ShowMessage('Error! Can''t find data grid!');
    Exit;
  end;
  try
//    Grid.BeginUpdate(lsimImmediate);
    if DisableStyle then
      Grid.Styles.ContentOdd := nil;
    if sdExport.Execute then
    begin
      if sdExport.DefaultExt = 'xls' then
        ExportGridToExcel(sdExport.FileName, TcxGrid(Grid.Control))
      else if sdExport.DefaultExt = 'csv' then
        ExportGridToText(sdExport.FileName, TcxGrid(Grid.Control), True, True, ',', '', '', 'csv')
      else if sdExport.DefaultExt = 'html' then
        ExportGridToHTML(sdExport.FileName, TcxGrid(Grid.Control))
      else if sdExport.DefaultExt = 'json' then
        ExportToJson(sdExport.FileName, Grid);
      if MessageDlg('Open ' + ExtractFileName(sdExport.FileName) + '?', mtConfirmation, mbYesNo, 0, mbYes) = mrYes then
      begin
        FileName := sdExport.FileName;
        if dm.GetWineAvail() then
          FileName := 'winebrowser ' + FileName;
        ShellExecute(Handle, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
      end;
    end;
  finally
    if DisableStyle then
      Grid.Styles.ContentOdd := dm.GridAltRow;
    //Grid.EndUpdate;
  end;
end;

procedure Tmain.ExportToJson(FileName: TFileName; GridView: TcxGridDBTableView);
var
  json: TStringList;
  i, j: Integer;
  cell_value: Variant;
  json_row: String;
begin
  json := TStringList.Create;
  try
    json.Add('{');
    json.Add(#9 + '"data": [');
    for i := 0 to GridView.DataController.RecordCount -1 do
    begin
      json_row := #9 + #9 + '{';
      for j := 0 to GridView.VisibleItemCount -1 do
      begin
        cell_value := GridView.DataController.Values[i, j];
        json_row := json_row + '"' + GridView.VisibleItems[j].DataBinding.Item.Caption + '": ';
        if VarIsNumeric(cell_value) then
          json_row := json_row + VarToStr(cell_value)
        else if VarIsNull(cell_value) then
          json_row := json_row + 'null'
        else
          json_row := json_row + '"' + VarToStr(cell_value) + '"';
        if j <> GridView.VisibleItemCount -1 then
          json_row := json_row + ',';
      end;
      json_row := json_row + '}';
      if i <> GridView.DataController.RecordCount -1 then
        json_row := json_row +',';
      json.Add(json_row);
    end;
    json.Add(#9 + ']');
    json.Add('}');
    json.SaveToFile(FileName);
  finally
    json.Free;
  end;
end;

procedure Tmain.OnEditorClose(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
var
  mr: Integer;
begin
  if pos('*', TcxPageControl(Sender).Pages[ATabIndex].Caption) > 0 then
  begin
    mr := MessageDlg('Save changes for "' + TcxPageControl(Sender).Pages[ATabIndex].Caption + '"?', mtConfirmation, mbYesNoCancel, 0, mbYes);
    case mr of
      mrCancel:
        begin
          ACanClose := False;
          ActiveControl := GetSQLEditor(TcxPageControl(Sender).Pages[ATabIndex]);
        end;
      mrYes:
        begin
          SaveSQL(TcxPageControl(Sender).Pages[ATabIndex]);
        end;
    end;
  end;
  if ACanClose then
  begin
    FreeParams(GetSQLEditor(TcxPageControl(Sender).Pages[ATabIndex]));
    EditorButtonState;
  end;
end;

procedure Tmain.pcSessionsCanCloseEx(Sender: TObject; ATabIndex: Integer; var ACanClose: Boolean);
var
  i, Count: Integer;
  PC: TcxPageControl;
begin
  PC := nil;
  for i := 0 to TcxPageControl(Sender).Pages[ATabIndex].ControlCount - 1 do
    if TcxPageControl(Sender).Pages[ATabIndex].Controls[i] is TcxPageControl then
    begin
      PC := TcxPageControl(TcxPageControl(Sender).Pages[ATabIndex].Controls[i]);
      break;
    end;
  if Assigned(PC) then
    while PC.PageCount > 0 do
    begin
      Count := PC.PageCount;
      PC.ActivePageIndex := 0;
      TcxPageControlPropertiesAccess(PC.Properties).CloseActiveTab;
      if Count = PC.PageCount then
      begin
        ACanClose := False;
        break;
      end;
    end;
  if ACanClose then
  begin
    DisconnectSSH(TcxPageControl(Sender).Pages[ATabIndex]);
    EditorButtonState;
  end;
end;

procedure Tmain.pcSessionsChange(Sender: TObject);
begin
  EditorButtonState;
end;

procedure Tmain.pcEditorOnChange(Sender: TObject);
begin
  EditorButtonState;
end;

procedure Tmain.SearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  tiSearch.Enabled := False;
  tiSearch.Enabled := True;
end;

procedure Tmain.EditorButtonState;
var
  lNew, lOpen, lSave, lExport, lTransaction, lHistory: Boolean;
  PC: TcxPageControl;
  Conn: TUniConnection;
begin
  lNew := False;
  lOpen := False;
  lSave := False;
  lExport := False;
  lTransaction := False;
  lHistory := False;
  if pcSessions.PageCount > 0 then
  begin
    Conn := GetSession(pcSessions.ActivePage.Caption);
    if Conn <> nil then
      lTransaction := not Conn.AutoCommit;
  end;
  if pcSessions.PageCount > 0 then
  begin
    lNew := True;
    lOpen := True;
    lHistory := True;
    PC := GetActiveEditorPC;
    if PC = nil then
      Exit;
    if PC.PageCount > 0 then
      lExport := True;
    if pos('*', PC.ActivePage.Caption) > 0 then
    begin
      lSave := True;
    end;
  end;
  buNewEditor.Enabled := lNew;
  buOpenSQL.Enabled := lOpen;
  buSaveSQL.Enabled := lSave;
  buExportXLS.Enabled := lExport;
  buExportCSV.Enabled := lExport;
  buExportHTML.Enabled := lExport;
  buExportJSON.Enabled := lExport;
  buCommit.Enabled := lTransaction;
  buRollback.Enabled := lTransaction;
  buHistory.Enabled := lHistory;
end;

procedure Tmain.EditorOnChange(Sender: TObject);
var
  PC: TcxPageControl;
  Tab: TcxTabSheet;
begin
  PC := GetActiveEditorPC;
  if PC = nil then
    Exit;
  Tab := PC.ActivePage;
  if Tab = nil then
    Exit;
  if pos('*', Tab.Caption) > 0 then
    Exit;
  Tab.Caption := Tab.Caption + ' *';
  EditorButtonState;
end;

procedure Tmain.pmSaveAsClick(Sender: TObject);
begin
  buSaveSQL.Click;
end;

procedure Tmain.SaveParams(Editor: TSynEdit; FileName: TFileName; Params: TParams);
var
  iFirstFree: Integer;
  i: Integer;
begin
  iFirstFree := 0;
  for i := 1 to maxEditors do
  begin
    if (EditorParams[i].Editor = nil) and (iFirstFree = 0) then
      iFirstFree := i;
    if EditorParams[i].Editor = Editor then
    begin
      EditorParams[i].Params := Params;
      if (FileName <> '') then
        EditorParams[i].FileName := FileName;
      Exit;
    end;
  end;
  { Save to first free if not found }
  EditorParams[iFirstFree].Editor := Editor;
  EditorParams[iFirstFree].Params := Params;
  if (FileName <> '') then
    EditorParams[iFirstFree].FileName := FileName;
end;

function Tmain.GetSpecialFolderPath(folder: Integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0 .. MAX_PATH] of char;
begin
  if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
    Result := path
  else
    Result := '';
end;

end.
