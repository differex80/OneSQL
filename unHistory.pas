unit unHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, MemDS, DBAccess, Uni,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, SynEdit, SynDBEdit,
  SynEditHighlighter, SynHighlighterSQL, Vcl.Menus, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxContainer, cxTextEdit;

type
  Thistory = class(TForm)
    qHistory: TUniQuery;
    qHistoryid: TIntegerField;
    qHistorysess: TMemoField;
    qHistorystatement: TMemoField;
    qHistoryts: TDateTimeField;
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
  private
    { Private declarations }
  public
    { Public declarations }
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

procedure Thistory.ExecuteHistory(vSearch: Variant);
begin
  with qHistory do
  begin
    Close;
    ParamByName('P_SEARCH').Value := vSearch;
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
end;

procedure Thistory.tiExecuteHistoryTimer(Sender: TObject);
begin
  tiExecuteHistory.Enabled := False;
  ExecuteHistory(edHistorySearch.Text);
end;

end.
