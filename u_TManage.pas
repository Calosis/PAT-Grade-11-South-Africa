unit u_TManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TfrmTManage = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    btnBack: TBitBtn;
    stHeading: TStaticText;
    stTournaments: TStaticText;
    cmbList: TComboBox;
    btnStart: TBitBtn;
    dbUsers: TDBGrid;
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cmbListChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTManage: TfrmTManage;

implementation

{$R *.dfm}

uses u_Welcome, u_Functions, u_DatabaseConnection;

procedure TfrmTManage.btnBackClick(Sender: TObject);
begin

  // Go back.
  frmTManage.Hide;
  frmWelcome.Show;

end;

procedure TfrmTManage.cmbListChange(Sender: TObject);
begin

  // Show all items.
  btnStart.Show;

end;

procedure TfrmTManage.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // Fix multi form issues.
  Application.Terminate;

end;

procedure TfrmTManage.FormShow(Sender: TObject);
var
  sTemp: String;

begin

  // Disable window resize.
  frmWelcome.BorderStyle := bsDialog;
  frmWelcome.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmTManage);

  // Grab all tournaments.

  // Ready.
  frmDatabaseConnection.tblTournaments.First;

  while NOT(frmDatabaseConnection.tblTournaments.Eof) do
  begin

    // Grab only non finished tourni.
    sTemp := frmDatabaseConnection.tblTournaments['T_Name'];

    if frmDatabaseConnection.tblTournaments['T_Finished'] = false then
    begin

      cmbList.Items.Add(sTemp);
      frmDatabaseConnection.tblTournaments.Next;

    end;

    frmDatabaseConnection.tblTournaments.Next;

  end;

  // DB grid.
  dbUsers.DataSource := frmDatabaseConnection.dsrTournamentUsers;

  // Hide.
  btnStart.Hide;

end;

end.
