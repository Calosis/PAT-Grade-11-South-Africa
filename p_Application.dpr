program p_Application;

uses
  Vcl.Forms,
  u_Application in 'u_Application.pas' {frmApplication},
  u_Functions in 'u_Functions.pas',
  u_Register in 'u_Register.pas' {frmRegister},
  u_DatabaseConnection in 'u_DatabaseConnection.pas' {frmDatabaseConnection},
  u_Google2fa in 'u_Google2fa.pas',
  u_Base32 in 'u_Base32.pas',
  u_QRCode in 'u_QRCode.pas',
  u_2FAScreen in 'u_2FAScreen.pas' {frm2FAScreen},
  u_Welcome in 'u_Welcome.pas' {frmWelcome};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmApplication, frmApplication);
  Application.CreateForm(TfrmRegister, frmRegister);
  Application.CreateForm(TfrmDatabaseConnection, frmDatabaseConnection);
  Application.CreateForm(Tfrm2FAScreen, frm2FAScreen);
  Application.CreateForm(TfrmWelcome, frmWelcome);
  Application.Run;

end.
