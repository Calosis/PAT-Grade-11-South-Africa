unit u_LTournament;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.WinXCtrls;

type
  TfrmPastLoad = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    btnBack: TBitBtn;
    stHeading: TStaticText;
    stTournaments: TStaticText;
    cmbList: TComboBox;
    btnLoad: TBitBtn;
    rtOut: TRichEdit;
    procedure FormShow(Sender: TObject);

    // Fix for multi forums.
    procedure CreateParams(var Params: TCreateParams); override;
    procedure btnBackClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPastLoad: TfrmPastLoad;

implementation

{$R *.dfm}

uses u_Functions, u_TManage, u_Welcome, u_DatabaseConnection;

procedure TfrmPastLoad.btnBackClick(Sender: TObject);
begin

  // Go back.
  frmPastLoad.Hide;
  frmWelcome.Show;

end;

procedure TfrmPastLoad.btnLoadClick(Sender: TObject);
var
  tFile: TextFile;
  sName, sSelected, sTemp: String;

begin

  // Clear.
  rtOut.Clear;

  // Grab name.
  sSelected := cmbList.Text;

  sName := sSelected + '.txt';

  // Ready text file.
  AssignFile(tFile, sName);

  Reset(tFile);

  while NOT(EOF(tFile)) do
  begin

    Readln(tFile, sTemp);

    // Output.
    rtOut.Lines.Add(sTemp);

  end;

end;

procedure TfrmPastLoad.CreateParams(var Params: TCreateParams);
begin
  inherited;

  // Set style sheet so windows knows its another "window".
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;

  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmPastLoad.FormShow(Sender: TObject);
var
  sTemp: String;

begin

  // Clear old stuff.
  cmbList.Clear;

  // Disable window resize.
  frmPastLoad.BorderStyle := bsDialog;
  frmPastLoad.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmPastLoad);

  // Clear.
  rtOut.Clear;

  // Ready.
  frmDatabaseConnection.tblTournaments.First;

  while NOT(frmDatabaseConnection.tblTournaments.EOF) do
  begin

    // Grab only non finished tourni.
    sTemp := frmDatabaseConnection.tblTournaments['T_Name'];

    if frmDatabaseConnection.tblTournaments['T_Finished'] = true then
    begin

      cmbList.Items.Add(sTemp);

    end;

    frmDatabaseConnection.tblTournaments.Next;

  end;

end;

end.
