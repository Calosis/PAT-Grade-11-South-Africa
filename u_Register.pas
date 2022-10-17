unit u_Register;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.WinXCtrls, Vcl.ComCtrls;

type
  TfrmRegister = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    stHeading: TStaticText;
    btnRegister: TBitBtn;
    cb2FA: TCheckBox;
    redOutput: TRichEdit;
    edtUsername: TLabeledEdit;
    edtPassword: TLabeledEdit;
    edtPasswordConfirm: TLabeledEdit;
    btnBack: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRegisterClick(Sender: TObject);
    procedure isAllValid();
    function isPasswordValid(): Boolean;
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRegister: TfrmRegister;
  // isAllValid
  sUsername, sPassword, sPasswordConfirm: String;
  bUsernameE, bPasswordE, bPasswordCE, bRun: Boolean;

implementation

{$R *.dfm}

uses u_Functions, u_DatabaseManage, u_DatabaseConnection, u_Application;

procedure TfrmRegister.btnBackClick(Sender: TObject);
begin

  // Go back.
  frmRegister.Hide;
  frmApplication.Show;

end;

procedure TfrmRegister.btnRegisterClick(Sender: TObject);
var
  sTemp: String;
  b2FA, bPassCheck, bTaken: Boolean;
  I, iPass: Integer;

begin

  // Set.
  bPassCheck := false;
  b2FA := false;
  edtPassword.Font.Color := clBlack;
  edtPasswordConfirm.Font.Color := clBlack;
  edtUsername.Font.Color := clBlack;

  // Clear all past data.
  redOutput.Clear;


  // Grab data.

  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;
  sPasswordConfirm := edtPasswordConfirm.Text;

  case cb2FA.Checked of
    True:
      b2FA := True;
  end;

  // Run checks.
  isAllValid;
  if bUsernameE OR bPasswordE OR bPasswordCE = True then
  begin

    // Dont run anymore code.
    bRun := false;

  end
  else
  begin
    bPassCheck := isPasswordValid;
  end;

  if (bPassCheck = True) AND (bRun = True) then
  begin

    // Run our register code.

    // Check if username is already taken.
    frmDatabaseConnection.tblAccounts.First;

    while NOT(frmDatabaseConnection.tblAccounts.Eof) do
    begin

      // Grab value.
      sTemp := frmDatabaseConnection.tblAccounts['U_Username'];

      // Check if its there.
      if (sTemp = sUsername) then
      begin

        bTaken := True;

        // Notify User.
        redOutput.Lines.Add('Username is already taken.');
        edtUsername.Focused;
        edtUsername.Font.Color := clRed;

        Break;

      end;

      // Not found, lets keep going.
      frmDatabaseConnection.tblAccounts.Next;

    end;

    // Username not found, so we can register.
    if NOT(bTaken = True) then
    begin

      // Ready database.
      frmDatabaseConnection.tblAccounts.First;
      frmDatabaseConnection.tblAccounts.Insert;

      // Add to database.
      frmDatabaseConnection.tblAccounts['U_Username'] := sUsername;
      frmDatabaseConnection.tblAccounts['U_Password'] := sPassword;
      frmDatabaseConnection.tblAccounts['U_2FA'] := b2FA;
      frmDatabaseConnection.tblAccounts['U_LastLogin'] := Date;

      // Send to database.
      frmDatabaseConnection.tblAccounts.Post;

      // Notify user.
      ShowMessage('Account has been created.');

      // Go to login page.
      frmRegister.Hide;
      frmApplication.Show;

    end;

  end;

end;

procedure TfrmRegister.FormActivate(Sender: TObject);
begin
  // Disable window resize.
  frmRegister.BorderStyle := bsDialog;
  frmRegister.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmRegister);

  // Ready forms.
  redOutput.Clear;
  redOutput.Font.Color := clRed;
  redOutput.Enabled := false;

  // Hide Passwords.
  edtPassword.PasswordChar := '*';
  edtPasswordConfirm.PasswordChar := '*';

end;

procedure TfrmRegister.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // Fix multi form issues.
  Application.Terminate;

end;

procedure TfrmRegister.FormShow(Sender: TObject);
begin

  // Clear old data.
  edtUsername.Clear;
  edtPassword.Clear;
  edtPasswordConfirm.Clear;
  redOutput.Clear;
  cb2FA.Checked := false;

end;

procedure TfrmRegister.isAllValid;
begin

  // Set all.
  bUsernameE := false;
  bPasswordE := false;
  bPasswordCE := false;

  // Check edtBox is valid.
  if sUsername = NullAsStringValue then
  begin

    // Output.
    redOutput.Lines.Add('Please enter a username.');

    // Notify.
    edtUsername.Focused;
    edtUsername.Font.Color := clRed;

    // Set.
    bUsernameE := True;

  end;

  if sPassword = NullAsStringValue then
  begin

    // Output.

    redOutput.Lines.Add('Please enter a password.');

    // Notify.
    edtPassword.Focused;
    edtPassword.Font.Color := clRed;

    // Set.
    bPasswordE := True;

  end;

  if sPasswordConfirm = NullAsStringValue then
  begin

    // Output.
    redOutput.Lines.Add('Please enter your password again.');

    // Notify.
    edtPasswordConfirm.Focused;
    edtPasswordConfirm.Font.Color := clRed;

    // Set.
    bPasswordCE := True;

  end;

end;

function TfrmRegister.isPasswordValid: Boolean;
var
  I: Integer;
  bCapital, bNumber, bSpecial: Boolean;

begin

  // Set.
  bCapital := false;
  bNumber := false;
  bSpecial := false;

  // Set run.
  bRun := True;

  if NOT(sPassword = sPasswordConfirm) then
  begin

    ShowMessage('Passwords do not match.');
    edtPassword.Font.Color := clRed;
    edtPasswordConfirm.Font.Color := clRed;

    // Dont run any other code, exit function.
    bRun := false;
    Exit;

  end;

  // Check if password is valid.
  for I := 1 to Length(sPassword) do
    case sPassword[I] of
      'A' .. 'Z':
        bCapital := True;
      '0' .. '9':
        bNumber := True;
      '!', '#', '%', '&', '*', '@':
        bSpecial := True;
    end;

  // Result.
  if (bCapital AND bNumber AND bSpecial = True) then
  begin
    Result := True;
  end;

  // Notify User.
  if (bCapital = false) then
  begin
    redOutput.Lines.Add('Password does not contain atleast 1 uppercase.');
  end;

  if (bNumber = false) then
  begin
    redOutput.Lines.Add('Password does not contain atleast 1 number.');
  end;

  if (bSpecial = false) then
  begin
    redOutput.Lines.Add('Password does not contain atleast 1 special.');
  end;

end;

procedure TfrmRegister.CreateParams(var Params: TCreateParams);
begin

  inherited;

  // Set style sheet so windows knows its another "window".
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;

  Params.WndParent := GetDesktopWindow;
end;

end.
