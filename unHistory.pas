unit unHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, MemDS, DBAccess,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, SynEdit, SynDBEdit,
  SynEditHighlighter, SynHighlighterSQL, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxContainer, cxTextEdit, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Thistory = class(TForm)
    dsHistory: TDataSource;
    syntax: TSynSQLSyn;
    Panel1: TPanel;
    Panel2: TPanel;
    grHistory: TcxGrid;
    tvHistory: TcxGridDBTableView;
    tvHistoryts: TcxGridDBColumn;
    lvHistory: TcxGridLevel;
    Panel3: TPanel;
    dbseStatement: TDBSynEdit;
    buClose: TcxButton;
    edHistorySearch: TcxTextEdit;
    tiExecuteHistory: TTimer;
    qHistory: TFDQuery;
    qHistoryid: TFDAutoIncField;
    qHistorysess: TMemoField;
    qHistorystatement: TMemoField;
    qHistoryts: TDateTimeField;
    Label1: TLabel;
    edLimit: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure buCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edHistorySearchExit(Sender: TObject);
    procedure edHistorySearchEnter(Sender: TObject);
    procedure edHistorySearchPropertiesChange(Sender: TObject);
    procedure tiExecuteHistoryTimer(Sender: TObject);
    procedure tvHistoryCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure qHistoryAfterDelete(DataSet: TDataSet);
    procedure edLimitChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iLookupId: Int64;
    procedure ExecuteHistory(vSearch: Variant);
  end;

var
  history: Thistory;

implementation

{$R *.dfm}

uses unMain, unDm;

procedure Thistory.buCloseClick(Sender: TObject);
begin

  CloseModal;
end;

procedure Thistory.tvHistoryCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  history.ModalResult := mrOK;
  CloseModal;
end;

procedure Thistory.edHistorySearchEnter(Sender: TObject);
begin
  if TcxTextEdit(Sender).Tag = 0 then
  begin
    TcxTextEdit(Sender).Text := '';
    TcxTextEdit(Sender).Style.TextColor := clBlack;
    TcxTextEdit(Sender).Style.TextStyle := TcxTextEdit(Sender).Style.TextStyle - [ fsItalic ];
    TcxTextEdit(Sender).Tag := 1;
  end;
end;

procedure Thistory.edHistorySearchExit(Sender: TObject);
begin
  if TcxTextEdit(Sender).Text = '' then
  begin
    TcxTextEdit(Sender).Tag := 0;
    TcxTextEdit(Sender).Text := 'Search History...';
    TcxTextEdit(Sender).Style.TextColor := clGrayText;
    TcxTextEdit(Sender).Style.TextStyle := TcxTextEdit(Sender).Style.TextStyle + [ fsItalic ];
  end;
end;

procedure Thistory.edHistorySearchPropertiesChange(Sender: TObject);
begin
  if TcxTextEdit(Sender).Tag = 1 then
  begin
    tiExecuteHistory.Enabled := False;
    tiExecuteHistory.Enabled := True;
  end;
end;

procedure Thistory.edLimitChange(Sender: TObject);
begin
  try
    if (TEdit(Sender).Text <> '') then
      StrToInt(TEdit(Sender).Text);
  except
    On E : Exception do
    begin
      TEdit(Sender).Text := '';
      ShowMessage(E.Message);
    end;
  end;
  if StrToIntDef(TEdit(Sender).Text, 1000) <> qHistory.ParamByName('P_LIMIT').AsInteger then
    with qHistory do
    begin
      Close;
      ParamByName('P_LIMIT').Value := StrToIntDef(TEdit(Sender).Text, 1000);
      Open;
    end;
end;

procedure Thistory.ExecuteHistory(vSearch: Variant);
begin
  with qHistory do
  begin
    Close;
    ParamByName('P_SEARCH').Value := vSearch;
    ParamByName('P_LIMIT').Value := StrToIntDef(edLimit.Text, 1000);
    Open;
  end;
end;

procedure Thistory.FormCreate(Sender: TObject);
begin
  dm.Style(syntax);
end;

procedure Thistory.FormShow(Sender: TObject);
begin
  ExecuteHistory('');
  if iLookupId <> 0 then
    if not qHistory.Locate('id', iLookupId, []) then
      MessageDlg('Query statement not found in history log! All logs will be displayed.', mtWarning, [mbOK], 0);
  iLookupId := 0;
end;

procedure Thistory.qHistoryAfterDelete(DataSet: TDataSet);
begin
  Dataset.Refresh;
end;

procedure Thistory.tiExecuteHistoryTimer(Sender: TObject);
begin
  tiExecuteHistory.Enabled := False;
  ExecuteHistory(edHistorySearch.Text);
end;

end.
