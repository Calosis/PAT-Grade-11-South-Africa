unit u_Welcome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.jpeg, Vcl.WinXCtrls;

type
  TfrmWelcome = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    stHeading: TStaticText;
    btnCreateT: TBitBtn;
    btnPastT: TBitBtn;
    btnLogout: TBitBtn;
    btnManageT: TBitBtn;
    btnTournamentUsers: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnCreateTClick(Sender: TObject);
    procedure btnManageTClick(Sender: TObject);
    procedure btnTournamentUsersClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcome: TfrmWelcome;

implementation

{$R *.dfm}

uses u_Functions, u_Application, u_DatabaseConnection, u_TManage, u_PManage;

procedure TfrmWelcome.btnCreateTClick(Sender: TObject);
var
  sInput: String;

begin

  // Grab Tournament name from user.
  sInput := InputBox('Create tournament:', 'Name:', '');

  // Check input.
  if (sInput = NullAsStringValue) then
  begin

    ShowMessage('Please enter a name.');
    Exit;

  end;

  // Ready database.
  frmDatabaseConnection.tblTournaments.First;

  // Lets see if the tournament exists.
  while NOT(frmDatabaseConnection.tblTournaments.Eof) do
  begin

    if (frmDatabaseConnection.tblTournaments['T_Name'] = sInput) then
    begin

      ShowMessage('Tourament with this name already exists.');
      Exit;

    end;

    // Next.
    frmDatabaseConnection.tblTournaments.Next;

  end;

  // Tournament doesnt exist, let us create it.
  frmDatabaseConnection.tblTournaments.Insert;
  frmDatabaseConnection.tblTournaments['T_Name'] := sInput;
  frmDatabaseConnection.tblTournaments.Post;

  ShowMessage('Tournament Created!');

  // Update data.
  frmDatabaseConnection.tblTournaments.Refresh;

end;

procedure TfrmWelcome.btnLogoutClick(Sender: TObject);
begin

  // Close form and clean.
  frmWelcome.Hide;
  frmApplication.Show;

  sUsername := '';
  sPassword := '';

end;

procedure TfrmWelcome.btnManageTClick(Sender: TObject);
begin

  // Move.
  frmWelcome.Hide;
  frmTManage.Show;

end;

procedure TfrmWelcome.btnTournamentUsersClick(Sender: TObject);
begin

  // Move.
  frmWelcome.Hide;
  frmPManage.Show;

end;

procedure TfrmWelcome.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // Fix multi form issues.
  Application.Terminate;

end;

procedure TfrmWelcome.FormShow(Sender: TObject);
begin

  // Disable window resize.
  frmWelcome.BorderStyle := bsDialog;
  frmWelcome.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmWelcome);

  // Set form title.
  frmWelcome.Caption := 'Welcome ' + sUsername;

end;

end.
