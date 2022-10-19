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
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcome: TfrmWelcome;

implementation

{$R *.dfm}

uses u_Functions, u_Application;

procedure TfrmWelcome.btnLogoutClick(Sender: TObject);
begin

  // Close form and clean.
  frmLogin.Hide;
  frmApplication.Show;

  sUsername := '';
  sPassword := '';

end;

procedure TfrmWelcome.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // Fix multi form issues.
  Application.Terminate;

end;

procedure TfrmWelcome.FormShow(Sender: TObject);
begin

  // Disable window resize.
  frmLogin.BorderStyle := bsDialog;
  frmLogin.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmLogin);

  // Set form title.
  frmLogin.Caption := 'Welcome ' + sUsername;

end;

end.
