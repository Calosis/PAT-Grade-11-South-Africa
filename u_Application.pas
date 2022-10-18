unit u_Application;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.Buttons;

type
  TfrmApplication = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    stHeading: TStaticText;
    btnLogin: TBitBtn;
    stRegister: TStaticText;
    edtUsername: TLabeledEdit;
    edtPassword: TLabeledEdit;
    tOTP: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure edtUsernameClick(Sender: TObject);
    procedure stRegisterClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    function isEmpty(): Boolean;
    procedure edtPasswordClick(Sender: TObject);
    procedure tOTPTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmApplication: TfrmApplication;
  sUsername, sPassword, sSecret: String;
  bOTPGen: Boolean;
  iOTP: Integer;

implementation

{$R *.dfm}

uses u_Register, u_DatabaseManage, u_Functions, u_DatabaseConnection,
  u_Google2fa, u_2FAScreen;

procedure TfrmApplication.btnLoginClick(Sender: TObject);
var
  bFound, bAuth, b2FASetup, bFirstSet: Boolean;
  sUsernameT, sPasswordT: String;
  iOTPUser: Integer;
begin

  // Set.
  bFound := false;
  bAuth := true;
  b2FASetup := false;
  bFirstSet := false;

  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  edtUsername.Font.Color := clBlack;
  edtPassword.Font.Color := clBlack;

  // Login logic.
  if NOT(isEmpty = true) then
  begin

    // Deny
    Exit;

  end;

  // Follow login logic.
  frmDatabaseConnection.tblAccounts.First;

  // Find user.
  while NOT(frmDatabaseConnection.tblAccounts.Eof) do
  begin

    if (sUsername = frmDatabaseConnection.tblAccounts['U_Username']) then
    begin

      // Found.
      sUsernameT := frmDatabaseConnection.tblAccounts['U_Username'];
      sPasswordT := frmDatabaseConnection.tblAccounts['U_Password'];
      bFound := true;

      // Does the account need 2fa setup?
      if (frmDatabaseConnection.tblAccounts['U_2FA'] = true) AND
        (frmDatabaseConnection.tblAccounts['U_2FAToken'] = Null) then
      begin
        b2FASetup := true;
      end;

      Break;

    end;

    // Not found, carry on.
    frmDatabaseConnection.tblAccounts.Next;

  end;

  // Username is here, lets see if passwords match.
  if (bFound = true) then
  begin

    // Check password.
    if NOT(sPasswordT = sPassword) then
    begin
      ShowMessage('Invalid password, try again.');
      edtPassword.Font.Color := clRed;
      edtPassword.Focused;
      bAuth := false;
    end;

  end
  else
  begin

    // Username not found.
    ShowMessage('Username not found.');
    edtUsername.Font.Color := clRed;
    Exit;

  end;

  // Do 2FA setup if needed.
  if (bAuth = true) then
  begin

    // Check if user has setup 2fa before.
    if (b2FASetup = true) AND (frmDatabaseConnection.tblAccounts['U_2FA'] = true)
    then
    begin

      // Generate secret.
      sSecret := GenerateOTPSecret(16);

      frmDatabaseConnection.tblAccounts.Edit;
      frmDatabaseConnection.tblAccounts['U_2FAToken'] := sSecret;
      frmDatabaseConnection.tblAccounts.Post;

      // First setup.
      bFirstSet := true;

      // Notify user.
      if MessageDlg('OTP Secret created. Do you want the QR code?',
        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      begin

        // Show QR code form.
        frmApplication.Hide;
        frm2FAScreen.Show;

      end
      else
      begin

        // Give token in box.
        ShowMessage('Token: ' + sSecret);

      end;

    end;

  end;

  // Lets get the 2fa token.
  bOTPGen := true;

  // Stop.
  if (bFirstSet = true) then
  begin

    // Make sure re-login.
    Exit;

  end;

  if NOT(frmDatabaseConnection.tblAccounts['U_2FA'] = true) then
  begin

    // No 2FA on account.

    ShowMessage('Auth with no2fa');

    Exit;

  end;

  ShowMessage('Auth with 2fa.');
  // User has 2fa on account.
  frmDatabaseConnection.tblAccounts.First;
  while NOT(frmDatabaseConnection.tblAccounts.Eof) do
  begin

    if sUsername = frmDatabaseConnection.tblAccounts['U_Username'] then
    begin

      // Grab.
      sSecret := frmDatabaseConnection.tblAccounts['U_2FAToken'];
      Break;

    end;

    // Next
    frmDatabaseConnection.tblAccounts.Next;

  end;

  // Grab OTP from user.
  iOTPUser := StrToInt(InputBox('2FA:', 'OTP:', ''));

  // Keep going until the person enters the otp.
  while (iOTPUser <> iOTP) do
  begin

    // Notify user.
    if MessageDlg('OTP Incorrect. Do you want to try again?', mtConfirmation,
      [mbYes, mbNo], 0, mbYes) = mrNo then
    begin
      Exit;
    end
    else
    begin

      ShowMessage('OTP: ' + IntToStr(iOTP));
      // Try get OTP again.
      iOTPUser := StrToInt(InputBox('2FA:', 'OTP:', ''));

    end;
  end;

  // Check again so we don't let past people.
  if iOTP = iOTPUser then
  begin

    // Go into main application.
    ShowMessage('Allowed');

  end;

end;

procedure TfrmApplication.edtPasswordClick(Sender: TObject);
begin

  // Clear text.
  edtPassword.Color := clWhite;

end;

procedure TfrmApplication.edtUsernameClick(Sender: TObject);
begin

  // Clear text.
  edtUsername.Color := clWhite;

end;

procedure TfrmApplication.FormCreate(Sender: TObject);
begin

  // Centre.
  TFunctions.sizeCentre(frmApplication);

  // Disable window resize.
  frmApplication.BorderStyle := bsDialog;
  frmApplication.BorderIcons := BorderIcons;

  // Hide
  edtPassword.PasswordChar := '*';

end;

function TfrmApplication.isEmpty: Boolean;
begin

  // Set.
  Result := true;

  // Check if everything is here.
  if (sUsername = NullAsStringValue) then
  begin

    // Deny + Notify
    Result := false;

    ShowMessage('Please enter a username.');
    edtUsername.Focused;
    edtUsername.Color := clRed;

  end;

  if (sPassword = NullAsStringValue) then
  begin

    // Deny + Notify
    Result := false;

    ShowMessage('Please enter a password.');
    edtPassword.Focused;
    edtPassword.Color := clRed;

  end;

end;

procedure TfrmApplication.stRegisterClick(Sender: TObject);
begin

  // Change form.
  frmApplication.Hide;
  frmRegister.Show;

end;

procedure TfrmApplication.tOTPTimer(Sender: TObject);
begin

  // Only run if allow
  if (bOTPGen = true) then
  begin

    // Generate OTP and store.
    iOTP := CalculateOTP(sSecret);

  end;

end;

end.