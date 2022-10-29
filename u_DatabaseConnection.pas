unit u_DatabaseConnection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ADODB, DB;

type
  TfrmDatabaseConnection = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    conApplication: TADOConnection;
    tblAccounts, tblActiveRound, tblTournaments, tblTournamentUsers, tblTournamentUserStats : TADOTable;
    dsrAccounts, dsrActiveRound, dsrTournaments, dsrTournamentUsers
      : TDataSource;

  end;

var
  frmDatabaseConnection: TfrmDatabaseConnection;

implementation

{$R *.dfm}

procedure TfrmDatabaseConnection.FormCreate(Sender: TObject);
begin

  // Dynamically create modules on form.
  conApplication := TADOConnection.Create(frmDatabaseConnection);

  tblAccounts := TADOTable.Create(frmDatabaseConnection);
  tblActiveRound := TADOTable.Create(frmDatabaseConnection);
  tblTournaments := TADOTable.Create(frmDatabaseConnection);
  tblTournamentUsers := TADOTable.Create(frmDatabaseConnection);
  tblTournamentUserStats := TADOTable.Create(frmDatabaseConnection);

  dsrAccounts := TDataSource.Create(frmDatabaseConnection);
  dsrActiveRound := TDataSource.Create(frmDatabaseConnection);
  dsrTournamentUsers := TDataSource.Create(frmDatabaseConnection);

  // Ready connection string.
  conApplication.Close;

  // Looks in debug folder.
  conApplication.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    ExtractFilePath(ParamStr(0)) + 'dbmStorage.mdb' +
    '; Persist Security Info=False';
  // Define prop of connection.
  conApplication.LoginPrompt := False;
  conApplication.Open;

  // Link tables.
  tblAccounts.Connection := conApplication;
  tblAccounts.TableName := 'tblAccounts';

  tblActiveRound.Connection := conApplication;
  tblActiveRound.TableName := 'tblActiveRound';

  tblTournaments.Connection := conApplication;
  tblTournaments.TableName := 'tblTournaments';

  tblTournamentUsers.Connection := conApplication;
  tblTournamentUsers.TableName := 'tblTUsers';

  tblTournamentUserStats.Connection := conApplication;
  tblTournamentUserStats.TableName := 'tblTUserStats';

  // Set dataset.
  dsrAccounts.DataSet := tblAccounts;
  dsrActiveRound.DataSet := tblActiveRound;
  dsrTournamentUsers.DataSet := tblTournamentUsers;

  // Ready for use.
  tblAccounts.Open;
  tblActiveRound.Open;
  tblTournaments.Open;
  tblTournamentUsers.Open;
  tblTournamentUserStats.Open;

end;

end.
