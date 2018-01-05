unit unSessionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBAccess, StdCtrls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxButtons, ActnList, IniFiles,
  System.UITypes, System.Types, ScSshClient, ScSSHChannel,
  unEncrypt, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxColorComboBox, cxImageComboBox, OleCtrls,
  cxGroupBox, System.Actions, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef;

type
  TsessionForm = class(TForm)
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
    Connection: TFDConnection;
    cbGroup: TComboBox;
    laGroup: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbProviderChange(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acTestExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure cbSessionTypeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboxKeyClick(Sender: TObject);
    procedure acLoadKeyExecute(Sender: TObject);
    procedure cbProviderDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    procedure PopulateGroups(IniFile: TIniFile);
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
      WriteString(session_name, 'session_group', cbGroup.Text);
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
      WriteString(session_name, 'db_provider', cbProvider.Items.Names[cbProvider.ItemIndex]);
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
  i: Integer;
  sshClient: TScSshClient;
  sshChannel: TScSshChannel;
  lPort, lDatabase: Boolean;
begin
  with Connection do
  begin
    lPort := (DriverName = 'MySQL') or (DriverName = 'PG');
    lDatabase := (DriverName = 'MySQL') or (DriverName = 'SQLite') or (DriverName = 'MSSQL') or (DriverName = 'PG');
    DriverName := cbProvider.Items.Names[cbProvider.ItemIndex];
    if Params.DriverID = 'Ora' then
      Params.Database := edServer.Text
    else
      Params.Values['Server'] := edServer.Text;
    Params.UserName := edUser.Text;
    Params.Password := edPass.Text;
    if lPort then
      try
        if cbSessionType.ItemIndex = 1 then
          Params.Values['Port'] := IntToStr(StrToInt(edSshListenPort.Text))
        else
          Params.Values['Port'] := IntToStr(StrToInt(edPort.Text))
      except
        if cbSessionType.ItemIndex = 1 then
          ActiveControl := edSshListenPort
        else
          ActiveControl := edPort;
        raise;
      end;
    if (lDatabase) then
      Params.Database := edDatabase.Text;

    try
      try
        if cbSessionType.ItemIndex = 1 then
        begin
          dm.ConnectSSH(Self, edSshHost.Text, edSshPort.Text, edSshUsername.Text, edSshPassword.Text, edSshKey.Text, edSshListenPort.Text, edServer.Text, edPort.Text);
        end;
        Connection.Connected := True;
        ShowMessage('Connection successful');
      except
        raise;
      end;
    finally
      Connection.Connected := False;
      sshClient := nil;
      sshChannel := nil;
      for i := 0 to self.ComponentCount - 1 do
      begin
        if self.Components[i] is TScSSHChannel then
          sshChannel := TScSSHChannel(self.Components[i]);
        if self.Components[i] is TScSshClient then
          sshClient := TScSSHClient(self.Components[i]);
      end;
      if sshChannel <> nil then
      begin
        sshChannel.Disconnect;
        sshChannel.Destroy;
      end;
      if sshClient <> nil then
      begin
        sshClient.Disconnect;
        sshClient.Destroy;
      end;
    end;
  end;
end;

procedure TsessionForm.cbProviderChange(Sender: TObject);
begin
  Connection.DriverName := TComboBox(Sender).Items.Names[TComboBox(Sender).ItemIndex];
end;

procedure TsessionForm.cbProviderDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  TComboBox(Control).Canvas.TextRect(Rect, Rect.Left, Rect.Top, TComboBox(Control).Items.Values[TComboBox(Control).Items.Names[Index]]);
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

procedure TsessionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.connection_name := '';
end;

procedure TsessionForm.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;
  sProvider: String;
  lClone: Boolean;
begin
  lClone := False;
  if (pos('clone#', dm.connection_name) > 0) then
  begin
    lClone := True;
    dm.connection_name := Copy(dm.connection_name, 7);
  end;

  cbProvider.Items.Text := dm.DbDriverList.Text;
  cbProvider.ItemIndex := 0;
  IniFile := dm.GetSessionIniFile;
  PopulateGroups(IniFile);
  if dm.connection_name <> '' then
  begin
    Caption := 'Edit Database Connection';
    edSessionName.Enabled := lClone;
    try
      with IniFile do
      begin
        if (lClone) then
          edSessionName.Text := ''
        else
          edSessionName.Text := dm.connection_name;
        cbGroup.ItemIndex := cbGroup.Items.IndexOf(ReadString(dm.connection_name, 'session_group', ''));
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
        cbProvider.ItemIndex := dm.DbDriverList.IndexOfName(sProvider);
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

procedure TsessionForm.PopulateGroups(IniFile: TIniFile);
var
  Sections: TStringList;
  i: Integer;
  sGroup: String;
begin
  Sections := TStringList.Create;
  cbGroup.Items.Clear;
  try
    IniFile.ReadSections(Sections);
    for i := 0 to Sections.Count -1 do
    begin
      sGroup := IniFile.ReadString(Sections.Strings[i], 'session_group', '');
      if (cbGroup.Items.IndexOf(sGroup) = -1) then
        cbGroup.Items.Add(sGroup);
    end;
  finally
    Sections.Free;
  end;
end;

end.
