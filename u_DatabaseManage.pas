unit u_DatabaseManage;

interface

uses
  System.SysUtils, System.Classes, ADODB, DB;

type
  TDatabaseConnection = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    conApplication: TADOConnection;
    tblAccounts: TADOTable;
    tblActiveRound: TADOTable;
    dsrAccounts: TDataSource;
    dsrActiveRound: TDataSource;
  end;

var
  dmDatabaseConnection: TDatabaseConnection;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDatabaseConnection.DataModuleCreate(Sender: TObject);
begin

  // Dynamically create modules on form.
  conApplication := TADOConnection.Create(dmDatabaseConnection);

  tblAccounts := TADOTable.Create(dmDatabaseConnection);
  tblActiveRound := TADOTable.Create(dmDatabaseConnection);
  dsrAccounts := TDataSource.Create(dmDatabaseConnection);
  dsrActiveRound := TDataSource.Create(dmDatabaseConnection);

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
  tblAccounts.TableName := 'tblApplication';
  tblActiveRound.Connection := conApplication;
  tblActiveRound.TableName := 'tblActiveRound';

  // Set dataset.
  dsrAccounts.DataSet := tblAccounts;
  dsrActiveRound.DataSet := tblActiveRound;

  // Ready for use.
  tblAccounts.Open;
  tblActiveRound.Open;


end;

end.
