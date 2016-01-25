unit unSessionManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, Menus, StdCtrls,
  cxButtons, cxInplaceContainer, ExtCtrls, IniFiles, ComCtrls,
  cxContainer, cxTreeView, ActnList, ImgList, cxEdit, System.UITypes, System.Types,
  System.Actions;

type
  TsessionManager = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    buCancel: TcxButton;
    buConnect: TcxButton;
    tvSessions: TcxTreeView;
    ac: TActionList;
    acConnect: TAction;
    acCancel: TAction;
    imEnv: TcxImageList;
    pmSession: TPopupMenu;
    Connect1: TMenuItem;
    Delete1: TMenuItem;
    acDeleteSession: TAction;
    acEditSession: TAction;
    Edit1: TMenuItem;
    N1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acConnectExecute(Sender: TObject);
    procedure tvSessionsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmSessionPopup(Sender: TObject);
    procedure acDeleteSessionExecute(Sender: TObject);
    procedure acEditSessionExecute(Sender: TObject);
    procedure tvSessionsDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure Init;
    procedure Connect;
    function GetNodeByText(ATree: TcxTreeView; AValue: String; AVisible: Boolean): TTreeNode;
  public
    { Public declarations }
  end;

var
  sessionManager: TsessionManager;

implementation

uses unDm;

{$R *.dfm}

{ TsessionManager }

procedure TsessionManager.acCancelExecute(Sender: TObject);
begin
  CloseModal;
end;

procedure TsessionManager.acConnectExecute(Sender: TObject);
begin
  Connect;
end;

procedure TsessionManager.acDeleteSessionExecute(Sender: TObject);
var
  Node: TTreeNode;
  IniFile: TIniFile;
begin
  Node := tvSessions.Selected;
  if MessageDlg('Are you sure you want to delete database connection "'+Node.Text+'"?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    IniFile := dm.GetSessionIniFile;
    try
      IniFile.EraseSection(Node.Text);
    finally
      IniFile.Free;
    end;
    tvSessions.Items.Delete(Node);
  end;
end;

procedure TsessionManager.acEditSessionExecute(Sender: TObject);
begin
  dm.connection_name := tvSessions.Selected.Text;
  ModalResult := mrOk;
  CloseModal;
end;

procedure TsessionManager.Connect;
var
  Node: TTreeNode;
begin
  Node := tvSessions.Selected;
  if Node <> nil then
  begin
    if Node.Level = 0 then Exit;
    dm.new_session := Node.Text;
    ModalResult := mrOk;
    CloseModal;
  end;
end;

procedure TsessionManager.FormShow(Sender: TObject);
begin
  Init;
end;

procedure TsessionManager.Init;
var
  IniFile: TIniFile;
  Sections: TStringList;
  i: Integer;
  ParentNode, Node: TTreeNode;
  sDatabase: String;
begin
  IniFile := dm.GetSessionIniFile;
  Sections := TStringList.Create;
  try
    IniFile.ReadSections(Sections);
    tvSessions.Items.Clear;
    for i := 0 to Sections.Count -1 do
    begin
      sDatabase := IniFile.ReadString(Sections.Strings[i], 'db_provider', '');
      ParentNode := GetNodeByText(tvSessions, dm.DbDriverList.Values[sDatabase], True);
      if not Assigned(ParentNode) then
      begin
        ParentNode := tvSessions.Items.Add(nil, dm.DbDriverList.Values[sDatabase]);
        ParentNode.ImageIndex := 3;
        ParentNode.SelectedIndex := ParentNode.ImageIndex;
      end;
      Node := tvSessions.Items.AddChild(ParentNode, Sections.Strings[i]);
      Node.ImageIndex := IniFile.ReadInteger(Sections.Strings[i], 'db_environment', -1);
      Node.SelectedIndex := Node.ImageIndex;
      Node.MakeVisible;
    end;
    tvSessions.Items.GetFirstNode.Selected := True;
  finally
    IniFile.Free;
    Sections.Free;
  end;
end;

procedure TsessionManager.pmSessionPopup(Sender: TObject);
begin
  if (tvSessions.Selected = nil) or (tvSessions.Selected.Level = 0) then
    Abort;
end;

procedure TsessionManager.tvSessionsDblClick(Sender: TObject);
begin
  Connect;
end;

procedure TsessionManager.tvSessionsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node: TTreeNode;
begin
  if (Button = mbRight) then
  begin
    Node := tvSessions.GetNodeAt(X, Y);
    if Assigned(Node) then
      Node.Selected := True;
  end;
end;

function TsessionManager.GetNodeByText(ATree : TcxTreeView; AValue:String; AVisible: Boolean): TTreeNode;
var
    Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then Exit;
  Node := ATree.Items[0];
  while Node <> nil do
  begin
    if UpperCase(Node.Text) = UpperCase(AValue) then
    begin
      Result := Node;
      if AVisible then
        Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;

end.
