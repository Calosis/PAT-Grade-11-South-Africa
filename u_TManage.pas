unit u_TManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Math;

type
  TDynIntegerArray = array of integer;

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
    dbgInfo: TDBGrid;
    btnDelete: TButton;
    st1: TStaticText;
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cmbListChange(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure randomArray(A: TDynIntegerArray);

    // Fix for multi forums.
    procedure CreateParams(var Params: TCreateParams); override;
    procedure btnDeleteClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTManage: TfrmTManage;
  arrPlayers: TDynIntegerArray;
  iCount: integer;
  sSelected: String;

implementation

{$R *.dfm}

uses u_Welcome, u_Functions, u_DatabaseConnection, u_ATournament;

procedure TfrmTManage.btnBackClick(Sender: TObject);
begin

  // Go back.
  frmTManage.Hide;
  frmWelcome.Show;

  cmbList.Clear;

end;

procedure TfrmTManage.btnDeleteClick(Sender: TObject);
begin

  // Delete selected entry.
  frmDatabaseConnection.tblTournamentUsers.Delete;

end;

procedure TfrmTManage.btnStartClick(Sender: TObject);
var
  I: integer;

begin

  // Set.
  iCount := 0;

  // Get selected tournament.
  sSelected := cmbList.Text;


  // Grab all players in the selected tournament.

  // Ready database.
  frmDatabaseConnection.tblTournamentUsers.First;

  while NOT(frmDatabaseConnection.tblTournamentUsers.Eof) do
  begin

    if frmDatabaseConnection.tblTournamentUsers['T_Tournament'] = sSelected then
    begin
      SetLength(arrPlayers, Length(arrPlayers) + 1);

      arrPlayers[High(arrPlayers)] :=
        frmDatabaseConnection.tblTournamentUsers['T_ID'];

      Inc(iCount);

    end;

    frmDatabaseConnection.tblTournamentUsers.Next;

  end;

  // Check if we have enough players.
  if NOT(iCount = 8) then
  begin

    ShowMessage('Unable to start. Tournament must have 8 players.');
    ShowMessage('Current size: ' + IntToStr(iCount));
    Exit;

  end;


  // We have all the players, lets add them all to the active round.

  // Clear table first.
  if (frmDatabaseConnection.tblActiveRound.RecordCount >= 1) then
  begin
    try
      frmDatabaseConnection.qrQuery.SQL.Add('DELETE FROM tblActiveRound;');
      frmDatabaseConnection.qrQuery.ExecSQl;
    finally
      FreeAndNil(frmDatabaseConnection.qrQuery);
    end;

    ShowMessage('Ready');

  end;

  // Shuffle Array so people so we get random picks.
  randomArray(arrPlayers);

  // Ready.
  frmDatabaseConnection.tblActiveRound.First;

  // Add.
  for I := 0 to iCount - 1 do
  begin

    // Add.
    frmDatabaseConnection.tblActiveRound.Insert;

    frmDatabaseConnection.tblActiveRound['A_PlayerID'] := arrPlayers[I];
    frmDatabaseConnection.tblActiveRound['A_Round'] := 1;
    frmDatabaseConnection.tblActiveRound['A_Won'] := false;

    frmDatabaseConnection.tblActiveRound.Post;

  end;

  // Move to next form.

  frmTManage.Hide;
  frmATournament.Show;


end;

procedure TfrmTManage.cmbListChange(Sender: TObject);
begin

  // Show all items.
  btnStart.Show;

end;

procedure TfrmTManage.CreateParams(var Params: TCreateParams);
begin
  inherited;

  // Set style sheet so windows knows its another "window".
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;

  Params.WndParent := GetDesktopWindow;

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
  frmTManage.BorderStyle := bsDialog;
  frmTManage.BorderIcons := BorderIcons;

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

    end;

    frmDatabaseConnection.tblTournaments.Next;

  end;

  // Hide.
  btnStart.Hide;

  // Connect DB grid.
  dbgInfo.DataSource := frmDatabaseConnection.dsrTournamentUsers;

end;

procedure TfrmTManage.randomArray(A: TDynIntegerArray);
  procedure Swap(n, m: integer);
  var
    tmp: integer;
  begin
    tmp := A[n];
    A[n] := A[m];
    A[m] := tmp;
  end;

var
  I: integer;
begin
  for I := High(A) downto 1 do
    Swap(I, RandomRange(0, I));
end;

end.
