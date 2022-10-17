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
    procedure FormCreate(Sender: TObject);
    procedure edtUsernameClick(Sender: TObject);
    procedure stRegisterClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    function isEmpty(): Boolean;
    procedure edtPasswordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmApplication: TfrmApplication;
  sUsername, sPassword: String;

implementation

{$R *.dfm}

uses u_Register, u_DatabaseManage, u_Functions, u_DatabaseConnection;

procedure TfrmApplication.btnLoginClick(Sender: TObject);
var
  bFound, bAuth: Boolean;
  sUsernameT, sPasswordT: String;
begin

  // Set.
  bFound := false;
  bAuth := true;

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

    ShowMessage('Would login.');

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

end.
