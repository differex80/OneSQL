unit unSessionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, Uni, StdCtrls, UniProvider, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, ActnList, IniFiles,
  System.UITypes, System.Types, CHILKATSSHLib_TLB,
  unEncrypt, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxColorComboBox, cxImageComboBox, OleCtrls,
  cxGroupBox, System.Actions;

type
  TsessionForm = class(TForm)
    Session: TUniConnection;
    buSave: TcxButton;
    buTest: TcxButton;
    gbConn: TcxGroupBox;
    gbSSH: TcxGroupBox;
    gbDB: TcxGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    laPort: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    laDatabase: TLabel;
    cbProvider: TComboBox;
    edServer: TEdit;
    edPort: TEdit;
    edUser: TEdit;
    edPass: TEdit;
    edDatabase: TEdit;
    edSshHost: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    laSshPassword: TLabel;
    edSshPort: TEdit;
    edSshUsername: TEdit;
    edSshPassword: TEdit;
    cbSessionType: TComboBox;
    buCancel: TcxButton;
    ac: TActionList;
    acOK: TAction;
    acCancel: TAction;
    acSave: TAction;
    acTest: TAction;
    Label11: TLabel;
    edSessionName: TEdit;
    Label12: TLabel;
    edSshListenPort: TEdit;
    Label3: TLabel;
    edSshKey: TEdit;
    buKey: TcxButton;
    cboxKey: TCheckBox;
    acLoadKey: TAction;
    odKey: TOpenDialog;
    cbEnvironment: TcxImageComboBox;
    laEnvironment: TLabel;
    cbAutoCommit: TCheckBox;
    cbUseUnicode: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cbProviderChange(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acTestExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure cbSessionTypeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboxKeyClick(Sender: TObject);
    procedure acLoadKeyExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  sessionForm: TsessionForm;

implementation

uses unDm;

{$R *.dfm}

procedure TsessionForm.acCancelExecute(Sender: TObject);
begin
  CloseModal;
end;

procedure TsessionForm.acLoadKeyExecute(Sender: TObject);
begin
  if odKey.Execute then
    edSshKey.Text := odKey.FileName;
end;

procedure TsessionForm.acSaveExecute(Sender: TObject);
var
  IniFile: TIniFile;
  session_name : String;
begin
  session_name := edSessionName.Text;
  if session_name = '' then
  begin
    ShowMessage('Connection Name can not be empty!');
    edSessionName.SetFocus;
    Exit;
  end;
  { Check if exists }
  IniFile := dm.GetSessionIniFile;
  if IniFile.SectionExists(session_name) and (MessageDlg('Database connection with name "'+session_name+'" already exists. Overwrite?', mtConfirmation, mbYesNo, 0, mbYes) = mrNo) then
    Exit;
  {Save to INI}
  try
    with IniFile do
    begin
      WriteInteger(session_name,'session_type', cbSessionType.ItemIndex);
      if cbSessionType.ItemIndex = 1 then
      begin
        WriteString(session_name, 'ssh_hostname', edSshHost.Text);
        WriteString(session_name, 'ssh_port', edSshPort.Text);
        WriteString(session_name, 'ssh_username', edSshUsername.Text);
        WriteString(session_name, 'ssh_password', String(Encrypt(AnsiString(edSshPassword.Text), dm.encrypt_key)));
        WriteString(session_name, 'ssh_key', String(Encrypt(AnsiString(edSshKey.Text), dm.encrypt_key)));
        WriteString(session_name, 'ssh_listen_port', edSshListenPort.Text);
      end;
      WriteString(session_name, 'db_provider', cbProvider.Text);
      WriteString(session_name, 'db_server', edServer.Text);
      WriteString(session_name, 'db_user', edUser.Text);
      WriteString(session_name, 'db_pass', String(Encrypt(AnsiString(edPass.Text), dm.encrypt_key)));
      WriteString(session_name, 'db_port', edPort.Text);
      WriteString(session_name, 'db_database', edDatabase.Text);
      WriteInteger(session_name, 'db_environment', cbEnvironment.ItemIndex);
      WriteBool(session_name, 'db_auto_commit', cbAutoCommit.Checked);
      WriteBool(session_name, 'db_use_unicode', cbUseUnicode.Checked);
    end;
    ShowMessage('Connection "'+edSessionName.Text+'" saved!');
  finally
    IniFile.Free;
  end;
  ModalResult := mrOk;
  CloseModal;
end;

procedure TsessionForm.acTestExecute(Sender: TObject);
var
  sshTunnel: TChilkatSshTunnel;
  ssh_pass, ssh_key: String;
  success: Integer;
  key: TChilkatSshKey;
  privKey: WideString;
begin
  if cboxKey.Checked then
    ssh_key := edSshKey.Text;
  ssh_pass := edSshPassword.Text;
  with Session do
  begin
    ProviderName := cbProvider.Text;
    Server := edServer.Text;
    Username := edUser.Text;
    Password := edPass.Text;
    if edPort.Enabled then
    try
      if cbSessionType.ItemIndex = 1 then
        Port := StrToInt(edSshListenPort.Text)
      else
        Port := StrToInt(edPort.Text)
    except
      if cbSessionType.ItemIndex = 1 then
        ActiveControl := edSshListenPort
      else
        ActiveControl := edPort;
      raise;
    end;
    if edDatabase.Enabled then
      Database := edDatabase.Text;

    sshTunnel := TChilkatSshTunnel.Create(Self);
    success := sshTunnel.UnlockComponent(chilkat_key);
    try
      try
        if cbSessionType.ItemIndex = 1 then
        begin
          //sshTunnel := dm.ConnectSSH(edSshHost.Text, edSshPort.Text, edSshUsername.Text, ssh_pass, ssh_key, edSshListenPort.Text, edServer.Text, edPort.Text);
          { Direct code due to debuging }
          if (success <> 1) then
          begin
            ShowMessage(sshTunnel.LastErrorText);
            Exit;
          end;
          sshTunnel.DestPort := StrToInt(edPort.Text);
          sshTunnel.DestHostname := edServer.Text;
          sshTunnel.SshHostname := edSshHost.Text;
          sshTunnel.SshPort := StrToIntDef(edSshPort.Text, 22);
          sshTunnel.SshLogin := edSshUsername.Text;
          if ssh_key <> '' then
          begin
            key := TChilkatSshKey.Create(Self);
            privKey := key.LoadText(ssh_key);
            key.Password := ssh_pass;
            if (Length(privKey) = 0 ) then
            begin
              ShowMessage(key.LastErrorText);
              Exit;
            end;
            if copy(privKey, 1, 3) = '---' then
              key.FromOpenSshPrivateKey(privKey)
            else
              key.FromPuttyPrivateKey(privKey);
            success := sshTunnel.SetSshAuthenticationKey(key.ControlInterface);
            if (success <> 1) then
            begin
              ShowMessage(sshTunnel.LastErrorText);
              Exit;
            end;
          end
          else
            sshTunnel.SshPassword := ssh_pass;
          success := sshTunnel.BeginAccepting(StrToInt(edSshListenPort.Text));
          if (success <> 1) then
          begin
            ShowMessage(sshTunnel.LastErrorText);
            Exit;
          end;
        end;
        Session.Connected := True;
        ShowMessage('Successfully connected to Database!');
      except
        raise;
      end;
    finally
      Session.Disconnect;
      if sshTunnel <> nil then
      begin
        success := sshTunnel.StopAccepting();
        if (success <> 1) then
        begin
          ShowMessage(sshTunnel.LastErrorText);
        end;
        // If any background tunnels are still in existence (and managed
        // by a single SSH tunnel pool background thread), stop them...
        success := sshTunnel.StopAllTunnels(1000);
        if (success <> 1) then
        begin
          ShowMessage(sshTunnel.LastErrorText);
        end;
      end;
    end;
  end;
end;

procedure TsessionForm.cbProviderChange(Sender: TObject);
var
  Provider: TUniProvider;
begin
  Session.Disconnect;
  Session.ProviderName := TComboBox(Sender).Text;
  Provider := TUniUtils.GetProvider(Session);
  edDatabase.Enabled := Provider.IsDatabaseSupported;
  laDatabase.Enabled := edDatabase.Enabled;
  if not edDatabase.Enabled then
    edDatabase.Clear;
  edPort.Enabled := Provider.IsPortSupported;
  laPort.Enabled := edPort.Enabled;
  if not edPort.Enabled then
    edPort.Clear;
end;

procedure TsessionForm.cbSessionTypeChange(Sender: TObject);
var
  lEnabledSSH: boolean;
  i : INteger;
begin
  lEnabledSSH := TComboBox(Sender).ItemIndex = 1;
  for i := 0 to gbSSH.ControlCount -1 do
  begin
    gbSSH.Controls[i].Enabled := lEnabledSSH;
  end;
  gbSSH.Enabled := lEnabledSSH;
end;

procedure TsessionForm.cboxKeyClick(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    laSshPassword.Caption := 'Key Password'
  else
    laSshPassword.Caption := 'SSH Password';
end;

procedure TsessionForm.cxButton1Click(Sender: TObject);
begin
  ShowMessage(Session.ConnectString);
end;

procedure TsessionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.connection_name := '';
end;

procedure TsessionForm.FormCreate(Sender: TObject);
var
  ProviderList: TStringList;
  IniFile : TIniFile;
  sProvider: String;
begin
  ProviderList := TStringList.Create;
  UniProviders.GetProviderNames(ProviderList);
  cbProvider.Items.Assign(ProviderList);
  cbProvider.ItemIndex := 0;
  if dm.connection_name <> '' then
  begin
    Caption := 'Edit Database Connection';
    edSessionName.Enabled := False;
    IniFile := dm.GetSessionIniFile;
    try
      with IniFile do
      begin
        edSessionName.Text := dm.connection_name;
        cbSessionType.ItemIndex := ReadInteger(dm.connection_name, 'session_type', -1);
        if cbSessionType.ItemIndex = 1 then
        begin
          edSshHost.Text := ReadString(dm.connection_name, 'ssh_hostname', '');
          edSshPort.Text := ReadString(dm.connection_name, 'ssh_port', '');
          edSshUsername.Text := ReadString(dm.connection_name, 'ssh_username', '');
          edSshPassword.Text := String(Decrypt(AnsiString(ReadString(dm.connection_name, 'ssh_password', '')), dm.encrypt_key));
          edSshKey.Text := String(Decrypt(AnsiString(ReadString(dm.connection_name, 'ssh_key', '')), dm.encrypt_key));
          if edSshKey.Text <> '' then
          begin
            cboxKey.Checked := True;
            cboxKey.OnClick(cboxKey);
          end;
          edSshListenPort.Text := ReadString(dm.connection_name, 'ssh_listen_port', '');
        end;
        sProvider := ReadString(dm.connection_name, 'db_provider', '');
        cbProvider.Text := sProvider;
        edServer.Text := ReadString(dm.connection_name, 'db_server', '');
        edUser.Text := ReadString(dm.connection_name, 'db_user', '');
        edPass.Text := String(Decrypt(AnsiString(ReadString(dm.connection_name, 'db_pass', '')), dm.encrypt_key));
        edPort.Text := ReadString(dm.connection_name, 'db_port', '');
        edDatabase.Text := ReadString(dm.connection_name, 'db_database', '');
        cbEnvironment.ItemIndex := ReadInteger(dm.connection_name, 'db_environment', -1);
        cbAutoCommit.Checked := ReadBool(dm.connection_name, 'db_auto_commit', False);
        cbUseUnicode.Checked := ReadBool(dm.connection_name, 'db_use_unicode', False);
      end;
    finally
      IniFile.Free;
    end;
  end;
  cbSessionType.OnChange(cbSessionType);
  cbProvider.OnChange(cbProvider);
  cboxKey.OnClick(cboxKey);
end;

end.
