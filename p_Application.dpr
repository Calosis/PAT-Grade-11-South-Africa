program p_Application;

uses
  Vcl.Forms,
  u_Application in 'u_Application.pas' {frmApplication},
  u_Functions in 'u_Functions.pas',
  u_Register in 'u_Register.pas' {frmRegister},
  u_DatabaseConnection in 'u_DatabaseConnection.pas' {frmDatabaseConnection};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApplication, frmApplication);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmDatabaseConnection, frmDatabaseConnection);

  Application.Run;

end.
