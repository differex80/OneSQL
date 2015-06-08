program OneSQL;

uses
  Forms,
  unMain in 'unMain.pas' {main},
  unParamForm in 'unParamForm.pas' {paramForm},
  unSessionForm in 'unSessionForm.pas' {sessionForm},
  unDm in 'unDm.pas' {dm: TDataModule},
  unSessionManager in 'unSessionManager.pas' {sessionManager},
  unPreferences in 'unPreferences.pas' {Preferences},
  unHistory in 'unHistory.pas' {history};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'OneSQL';
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tmain, main);
  Application.CreateForm(TparamForm, paramForm);
  Application.CreateForm(THistory, history);
  Application.CreateForm(TsessionManager, sessionManager);
  //  Application.CreateForm(TsessionForm, sessionForm);
  Application.Run;
end.
