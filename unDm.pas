unit unDm;

interface

uses
  SysUtils, Classes, ImgList, Controls, cxGraphics, DB,
  DBAccess, Uni, cxPC, IniFiles, AsyncCalls, cxStyles, cxClasses, unMain,
  windows, System.UITypes, System.Types,
  CHILKATSSHLib_TLB,
  cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGridTableView,
  cxControls, SynEdit, SynEditHighlighter, SynHighlighterSQL, Graphics, DateUtils;

const
  cMaxConnections = 20;

  chilkat_key = 'SSH87654321_2A5CA5521C1G';
  secGeneral = 'General';
  secEditor = 'Editor';
  secDataGrid = 'DataGrid';
  secHighlight = 'SyntaxHighlight';

type

  TWorker = class;

  TTabWorker = record
    SessionTab: TcxTabSheet;
    Worker: TWorker;
  end;
  PTabWorker = ^TTabWorker;

  TThreadCallback = procedure(EditorTab: TcxTabSheet; Query: TUniQuery; SQL: TUniSQL; GridView: TcxGridDBTableView);

  TWorkerTask = record
    EditorTab: TcxTabSheet;
    Query: TUniQuery;
    SQL: TUniSQL;
    GridView: TcxGridDBTableView;
  end;
  PWorkerTask = ^TWorkerTask;

  Tdm = class(TDataModule)
    imList: TcxImageList;
    imListSmall: TcxImageList;
    cxStyle: TcxStyleRepository;
    GridAltRow: TcxStyle;
    GridSelectedRow: TcxStyle;
    GridContent: TcxStyle;
    NullString: TcxStyle;
    GridHeader: TcxStyle;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    TabWorkers: TList;
  public
    application_name: String;
    AppDataFolder: String;
    encrypt_key: Word;
    LineEnding: Integer;
    connection_name: String;
    new_session: String;
    Main: TMain;
    function ConnectSSH(Owner: TcxTabSheet; ssh_hostname, ssh_port, ssh_user, ssh_pass, ssh_key, ssh_listen_port, dest_host, dest_port : String) : TChilkatSshTunnel;
    function getConnectionImage(Index: Integer): Integer;
    function GetSessionIniFile: TIniFile;
    function GetConfigIniFile: TIniFile;
    function NewTabWorker(FTab: TcxTabSheet; FSession: TUniConnection): TWorker;
    function GetTabWorker(Tab: TcxTabSheet): TWorker;
    procedure Style(Sender: TComponent);
    function GetWineAvail: boolean;
  end;

  TWorker = class(TThread)
  private
    Session: TUniConnection;
    Queue: TList;
    lSuspended: boolean;
  public
    constructor Create(FCreateSuspended: Boolean; FSession: TUniConnection);
    destructor Destroy; override;
    procedure Execute; override;
    procedure AddWork(FEditorTab: TcxTabSheet; FQuery: TUniQuery; FSQL: TUniSQL; FGridView: TcxGridDBTableView);
    function GetWorkerTask(FEditorTab: TcxTabSheet): PWorkerTask;
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  connection_name := '';
  application_name := '';
  new_session := '';
  encrypt_key := 1101;
  TabWorkers := TList.Create;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
var
  i: integer;
  P: PTabWorker;
begin
  for i := TabWorkers.Count - 1 downto 0 do
  begin
    P := PTabWorker(TabWorkers.Items[i]);
    P^.Worker.Terminate;
    TabWorkers.Delete(i);
  end;
  TabWorkers.Free;
end;

function Tdm.GetWineAvail: boolean;
var
  H: cardinal;
begin
 Result := False;
 H := LoadLibrary('ntdll.dll');
 if H > HINSTANCE_ERROR then
 begin
   Result := Assigned(GetProcAddress(H, 'wine_get_version'));
   FreeLibrary(H);
 end;
end;

function Tdm.ConnectSSH(Owner: TcxTabSheet; ssh_hostname, ssh_port, ssh_user, ssh_pass, ssh_key, ssh_listen_port, dest_host, dest_port : String) : TChilkatSshTunnel;
var
  success: Integer;
  sshTunnel: TChilkatSshTunnel;
  key: TChilkatSshKey;
  privKey: WideString;
begin
  Result := nil;
  sshTunnel := TChilkatSshTunnel.Create(Owner);
  success := sshTunnel.UnlockComponent(chilkat_key);
  if (success <> 1) then Exit;
  // The destination host/port is the database server.
  // The DestHostname may be the domain name or
  // IP address (in dotted decimal notation) of the database
  // server.
  sshTunnel.DestPort := StrToInt(dest_port);
  sshTunnel.DestHostname := dest_host;

  // Provide information about the location of the SSH server,
  // and the authentication to be used with it. This is the
  // login information for the SSH server (not the database server).
  sshTunnel.SshHostname := ssh_hostname;
  sshTunnel.SshPort := StrToIntDef(ssh_port, 22);
  sshTunnel.SshLogin := ssh_user;
  if ssh_key <> '' then
  begin
    key := TChilkatSshKey.Create(Self);
    //  Load a private key from a PEM file:
    //  (Private keys may be loaded from OpenSSH and Putty formats.
    //  Both encrypted and unencrypted private key file formats
    //  are supported.  This example loads an unencrypted private
    //  key in OpenSSH format.  PuTTY keys typically use the .ppk
    //  file extension, while OpenSSH keys use the PEM format.
    privKey := key.LoadText(ssh_key);
    key.Password := ssh_pass;
    if (Length(privKey) = 0 ) then
    begin
      //Memo1.Lines.Add(key.LastErrorText);
      Exit;
    end;
    if copy(privKey, 1, 3) = '---' then
      key.FromOpenSshPrivateKey(privKey)
    else
      key.FromPuttyPrivateKey(privKey);
    //  Tell the SSH tunnel to use the key for authentication:
    success := sshTunnel.SetSshAuthenticationKey(key.ControlInterface);
    if (success <> 1) then
    begin
      //ShowMessage(sshTunnel.LastErrorText);
      Exit;
    end;
  end
  else
    sshTunnel.SshPassword := ssh_pass;

  // Start accepting connections in a background thread.
  // The SSH tunnels are autonomously run in a background
  // thread.  There is one background thread for accepting
  // connections, and another for managing the tunnel pool.
  success := sshTunnel.BeginAccepting(StrToInt(ssh_listen_port));
  if (success <> 1) then
  begin
  //  ShowMessage(sshTunnel.LastErrorText);
    result := nil;
    Exit;
  end;
  result := sshTunnel;
end;

function Tdm.GetSessionIniFile: TIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(AppDataFolder+'ConnectionManager.ini');
  Result := IniFile;
end;

function Tdm.GetConfigIniFile: TIniFile;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(AppDataFolder+'Config.ini');
  Result := IniFile;
end;

function Tdm.getConnectionImage(Index: Integer): Integer;
begin
  case Index of
    0 : Result := 5;
    1 : Result := 6;
    2 : Result := 7
  else
    Result := -1;
  end;
end;

function Tdm.NewTabWorker(FTab: TcxTabSheet; FSession: TUniConnection): TWorker;
var
  P: PTabWorker;
begin
  New(P);
  P^.SessionTab := FTab;
  P^.Worker := TWorker.Create(True, FSession);
  TabWorkers.Add(P);
  Result :=  P^.Worker;
end;

procedure Tdm.Style(Sender: TComponent);
var
  Config: TIniFile;
begin
  Config := GetConfigIniFile;
  try
    if Sender is TSynEdit then
    with TSynEdit(Sender) do
    begin
      Font.Name := Config.ReadString(secEditor, 'FontName', 'Courier New');
      Font.Size := Config.ReadInteger(secEditor, 'FontSize', 10);
      Font.Style := [];
      if Config.ReadBool(secEditor, 'FontBold', False) then
        Font.Style := Font.Style + [fsBold];
      if Config.ReadBool(secEditor, 'FontItalic', False) then
        Font.Style := Font.Style + [fsItalic];
      Font.Color := Config.ReadInteger(secEditor, 'Color', clBlack);
      Color := Config.ReadInteger(secEditor, 'Background', clWhite);
    end
    else if Sender is TSynSQLSyn then
    with TSynSQLSyn(Sender) do
    begin
      CommentAttri.Foreground := Config.ReadInteger(secHighlight, 'Comments', clGreen);
      CommentAttri.Style := [];
      if Config.ReadBool(secHighlight, 'CommentsBold', False) then
        CommentAttri.Style := CommentAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'CommentsItalic', False) then
        CommentAttri.Style := CommentAttri.Style + [fsItalic];
      FunctionAttri.Foreground := Config.ReadInteger(secHighlight, 'Functions', clFuchsia);
      FunctionAttri.Style := [];
      if Config.ReadBool(secHighlight, 'FunctionsBold', False) then
        FunctionAttri.Style := FunctionAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'FunctionsItalic', False) then
        FunctionAttri.Style := FunctionAttri.Style + [fsItalic];
      KeyAttri.Foreground := Config.ReadInteger(secHighlight, 'Keywords', 0);
      KeyAttri.Style := [];
      if Config.ReadBool(secHighlight, 'KeywordsBold', False) then
        KeyAttri.Style := KeyAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'KeywordsItalic', False) then
        KeyAttri.Style := KeyAttri.Style + [fsItalic];
      NumberAttri.Foreground := Config.ReadInteger(secHighlight, 'Numbers', clBlue);
      NumberAttri.Style := [];
      if Config.ReadBool(secHighlight, 'NumbersBold', False) then
        NumberAttri.Style := NumberAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'NumbersItalic', False) then
        NumberAttri.Style := NumberAttri.Style + [fsItalic];
      StringAttri.Foreground := Config.ReadInteger(secHighlight, 'Strings', clRed);
      StringAttri.Style := [];
      if Config.ReadBool(secHighlight, 'StringsBold', False) then
        StringAttri.Style := StringAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'StringsItalic', False) then
        StringAttri.Style := StringAttri.Style + [fsItalic];
      DataTypeAttri.Foreground := Config.ReadInteger(secHighlight, 'DataTypes', clMaroon);
      DataTypeAttri.Style := [];
      if Config.ReadBool(secHighlight, 'DataTypesBold', False) then
        DataTypeAttri.Style := DataTypeAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'DataTypesItalic', False) then
        DataTypeAttri.Style := DataTypeAttri.Style + [fsItalic];
      TableNameAttri.Foreground := Config.ReadInteger(secHighlight, 'Tables', clOlive);
      TableNameAttri.Style := [];
      if Config.ReadBool(secHighlight, 'TablesBold', False) then
        TableNameAttri.Style := TableNameAttri.Style + [fsBold];
      if Config.ReadBool(secHighlight, 'TablesItalic', False) then
        TableNameAttri.Style := TableNameAttri.Style + [fsItalic];
    end;
  finally
    Config.Free;
  end;
end;

function Tdm.GetTabWorker(Tab: TcxTabSheet): TWorker;
var
  i: Integer;
  P: PTabWorker;
begin
  Result := nil;
  for i := 0 to TabWorkers.Count -1 do
  begin
    P := TabWorkers[i];
    if P^.SessionTab = Tab then
    begin
      Result := P^.Worker;
      break;
    end;
  end;
end;

{ TWorker }

constructor TWorker.Create(FCreateSuspended: Boolean; FSession: TUniConnection);
begin
  Session := FSession;
  Queue :=  TList.Create;
  FreeOnTerminate := True;
  lSuspended := FCreateSuspended;
  inherited Create(false);
end;

destructor TWorker.Destroy;
begin
  Queue.Free;
  inherited;
end;

procedure TWorker.AddWork(FEditorTab: TcxTabSheet; FQuery: TUniQuery; FSQL: TUniSQL; FGridView: TcxGridDBTableView);
var
  W: PWorkerTask;
begin
  // thread safety (jer MOZDA nismo u glavnom threadu)
  EnterMainThread;
  try
    New(W);
    W^.EditorTab := FEditorTab;
    W^.Query := FQuery;
    W^.SQL := FSQL;
    W^.GridView := FGridView;
    Queue.Add(W);
    lSuspended := False;
  finally
    LeaveMainThread;
  end;
end;

function TWorker.GetWorkerTask(FEditorTab: TcxTabSheet): PWorkerTask;
var
  i: Integer;
  W: PWorkerTask;
begin
  Result := nil;
  EnterMainThread;
  try
    for i := 0 to Queue.Count -1 do
    begin
      W := PWorkerTask(Queue.Items[i]);
      if W^.EditorTab = FEditorTab then
      begin
        Result := W;
        break;
      end;
    end;
    lSuspended := False;
  finally
    LeaveMainThread;
  end;
end;

procedure TWorker.Execute;
var
  W: PWorkerTask;
  Error: String;
  iTime: TDateTime;
begin
  while not Terminated do
  try
    // Since suspend is deprecated, simulate suspend
    if lSuspended then
    begin
      Sleep(100);
      Continue;
    end;
    Sleep(20);
    if not Session.Connected then
      Session.Connected := True;
    if Queue.Count > 0 then
    begin
      // thread safety (jer nismo u glavnom threadu)
      EnterMainThread;
      try
        W := Queue.Items[0];
        Queue.Delete(0);
        W^.GridView.BeginUpdate(lsimImmediate);
      finally
        LeaveMainThread;
      end;
      // run it
      try
        Error := '';
        if W^.Query <> nil then
        begin
//          W^.Query.Close;
          W^.EditorTab.Hint := '';
          iTime := now;
          W^.Query.Execute;
          W^.EditorTab.Hint := FormatFloat('0.000', MilliSecondsBetween(now, iTime) /1000) + ' sec';
//          W^.Query.First;
        end;

        if W^.SQL <> nil then
        begin
          W^.EditorTab.Hint := '';
          iTime := now;
          W^.SQL.Execute;
          W^.EditorTab.Hint := FormatFloat('0.000', MilliSecondsBetween(now, iTime) /1000) + ' sec';
        end;
      except on E: Exception do
        begin
          Error := E.Message;
        end;
      end;
      {Callback}
      EnterMainThread;
      try
        dm.Main.ExecuteSQLCallback(W^.EditorTab, W^.Query, W^.SQL, W^.GridView, Error);
      finally
        LeaveMainThread;
      end;
    end
    else
    begin
      // nothing to do, simulate suspend
      EnterMainThread;
      try
        lSuspended := True;
      finally
        LeaveMainThread;
      end;
    end;
  except
    on E: Exception do
    begin
      EnterMainThread;
      try
        dm.Main.ShowError(E.Message);
      finally
        LeaveMainThread;
      end;
    end;
  end;
end;

end.
