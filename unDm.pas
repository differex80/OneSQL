unit unDm;

interface

uses
  SysUtils, Classes, ImgList, Controls, cxStyles, cxClasses, cxGraphics,
  DB, DBAccess, cxPC, IniFiles, unMain, Forms,
  windows, System.UITypes, System.Types,
  ScBridge, ScSSHClient, ScSSHChannel, ScSSHUtils,
  cxGrid, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGridTableView,
  cxControls, SynEdit, SynEditHighlighter, SynHighlighterSQL, Graphics, DateUtils,
  //AsyncCalls,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

const
  cMaxConnections = 20;

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

  TThreadCallback = procedure(EditorTab: TcxTabSheet; Query: TFDQuery; SQL: TFDCommand; GridView: TcxGridDBTableView);

  TWorkerTask = record
    EditorTab: TcxTabSheet;
    Query: TFDQuery;
    SQL: TFDCommand;
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
    keyStorage: TScFileStorage;
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
    DbDriverList: TStringList;
    Main: TMain;
    function ConnectSSH(Owner: TComponent; ssh_hostname, ssh_port, ssh_user, ssh_pass, ssh_key, ssh_listen_port, dest_host, dest_port : String) : Boolean;
    function getConnectionImage(Index: Integer): Integer;
    function GetSessionIniFile: TIniFile;
    function GetConfigIniFile: TIniFile;
    function NewTabWorker(FTab: TcxTabSheet; FSession: TFDConnection): TWorker;
    function GetTabWorker(Tab: TcxTabSheet): TWorker;
    procedure Style(Sender: TComponent);
    function GetWineAvail: boolean;
    procedure ScSSHClientServerKeyValidate(Sender: TObject; NewServerKey: TScKey; var Accept: Boolean);
  end;

  TWorker = class(TThread)
  private
    Session: TFDConnection;
    Queue: TList;
    lSuspended: boolean;
  public
    constructor Create(FCreateSuspended: Boolean; FSession: TFDConnection);
    destructor Destroy; override;
    procedure Execute; override;
    procedure AddWork(FEditorTab: TcxTabSheet; FQuery: TFDQuery; FSQL: TFDCommand; FGridView: TcxGridDBTableView);
    function GetWorkerTask(FEditorTab: TcxTabSheet): PWorkerTask;
  end;

  TWorkerCancel = class(TThread)
  private
    Q: TFDQuery;
  public
    constructor Create(Query: TFDQuery);
    procedure Execute; override;
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

function Tdm.ConnectSSH(Owner: TComponent; ssh_hostname, ssh_port, ssh_user,
  ssh_pass, ssh_key, ssh_listen_port, dest_host, dest_port: String): boolean;
var
  key: TScKey;
  lSuccess: Boolean;
  sshClient: TScSshClient;
  portForward: TScSshChannel;
begin
  keyStorage.DeleteStorage;
  key := keyStorage.Keys.FindKey(ssh_user);
  if (key = nil) then
  begin
    if ssh_key <> '' then
    begin
      key := TScKey.Create(keyStorage.Keys);
      key.KeyName := ssh_user;
      key.ImportFrom(ssh_key, ssh_pass);
    end;
  end;
  sshClient := TScSshClient.Create(Owner);
  sshClient.KeyStorage := keyStorage;
  sshClient.HostKeyAlgorithms.asString := 'ssh-rsa,ssh-dss';
  if key <> nil then
  begin
    sshClient.Authentication := atPublicKey;
    sshClient.PrivateKeyName := key.KeyName;
  end
  else
  begin
    if ssh_pass <> '' then
    begin
      sshClient.Authentication := atPassword;
      sshClient.Password := ssh_pass;
    end
    else
      sshClient.Authentication := atKeyboardInteractive;
  end;
  sshClient.HostName := ssh_hostname;
  sshClient.Port := StrToIntDef(ssh_port, 22);
  sshClient.User := ssh_user;
  sshClient.OnServerKeyValidate := ScSSHClientServerKeyValidate;
  sshClient.Connect;
  lSuccess := sshClient.Connected;
  // Check if required port forwarding
  if (lSuccess) and (StrToIntDef(ssh_listen_port, 0) <> 0) then
  begin
    portForward := TScSSHChannel.Create(Owner);
    portForward.Client := sshClient;
    portForward.GatewayPorts := True;
    portForward.DestHost := dest_host;
    portForward.DestPort := StrToIntDef(dest_port, 0);
    portForward.SourcePort := StrToIntDef(ssh_listen_port, 0);
    portForward.Connect;
    lSuccess := portForward.Connected;
  end;
  Result := lSuccess;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  connection_name := '';
  application_name := '';
  new_session := '';
  encrypt_key := 1101;
  TabWorkers := TList.Create;
  DbDriverList := TStringList.Create;
  with DbDriverList do
  begin
    Add('MySQL=MySql');
    Add('Ora=Oracle');
    Add('SQLite=SQLite');
    Add('PG=PostgeSql');
  end;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
var
  i: integer;
  P: PTabWorker;
begin
  keyStorage.DeleteStorage;
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

function Tdm.NewTabWorker(FTab: TcxTabSheet; FSession: TFDConnection): TWorker;
var
  P: PTabWorker;
begin
  New(P);
  P^.SessionTab := FTab;
  P^.Worker := TWorker.Create(True, FSession);
  TabWorkers.Add(P);
  Result :=  P^.Worker;
end;

procedure Tdm.ScSSHClientServerKeyValidate(Sender: TObject; NewServerKey: TScKey; var Accept: Boolean);
begin
  Accept := True;
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

constructor TWorker.Create(FCreateSuspended: Boolean; FSession: TFDConnection);
begin
  inherited Create(false);
  Session := FSession;
  Queue :=  TList.Create;
  FreeOnTerminate := True;
  lSuspended := FCreateSuspended;
end;

destructor TWorker.Destroy;
begin
  Queue.Free;
  inherited;
end;

procedure TWorker.AddWork(FEditorTab: TcxTabSheet; FQuery: TFDQuery; FSQL: TFDCommand; FGridView: TcxGridDBTableView);
var
  W: PWorkerTask;
begin
  // thread safety (jer MOZDA nismo u glavnom threadu)
  //EnterMainThread;
  try
    New(W);
    W^.EditorTab := FEditorTab;
    W^.Query := FQuery;
    W^.SQL := FSQL;
    W^.GridView := FGridView;
    Queue.Add(W);
    lSuspended := False;
  finally
    //LeaveMainThread;
  end;
end;

function TWorker.GetWorkerTask(FEditorTab: TcxTabSheet): PWorkerTask;
var
  i: Integer;
  W: PWorkerTask;
begin
  Result := nil;
  //EnterMainThread;
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
    //LeaveMainThread;
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
      //EnterMainThread;
      try
        W := Queue.Items[0];
        Queue.Delete(0);
        W^.GridView.BeginUpdate(lsimImmediate);
      finally
        //LeaveMainThread;
      end;
      // run it
      try
        Error := '';
        if W^.Query <> nil then
        begin
//          W^.Query.Close;
          W^.EditorTab.Hint := '';
          iTime := now;
          W^.Query.Open;
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
      //EnterMainThread;
      try
        dm.Main.ExecuteSQLCallback(W^.EditorTab, W^.Query, W^.SQL, W^.GridView, Error);
      finally
        //LeaveMainThread;
      end;
    end
    else
    begin
      // nothing to do, simulate suspend
      //EnterMainThread;
      try
        lSuspended := True;
      finally
        //LeaveMainThread;
      end;
    end;
  except
    on E: Exception do
    begin
      //EnterMainThread;
      try
        dm.Main.ShowError(E.Message);
      finally
        //LeaveMainThread;
      end;
    end;
  end;
end;

{ TWorkerCancel }

constructor TWorkerCancel.Create(Query: TFDQuery);
begin
  Q := Query;
  FreeOnTerminate := True;
  inherited Create(False);
end;

procedure TWorkerCancel.Execute;
begin
  Q.AbortJob;
end;

end.
