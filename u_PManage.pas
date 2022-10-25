unit u_PManage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.WinXCtrls;

type
  TfrmPManage = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    btnBack: TBitBtn;
    stHeading: TStaticText;
    btnAdd: TBitBtn;
    cmbList: TComboBox;
    edtName: TLabeledEdit;
    edtSurname: TLabeledEdit;
    edtAge: TLabeledEdit;
    edtWeight: TLabeledEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure resetAll();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPManage: TfrmPManage;

implementation

{$R *.dfm}

uses u_Functions, u_Welcome, u_DatabaseConnection;

procedure TfrmPManage.btnAddClick(Sender: TObject);
var
  sFirstname, sLastname: String;
  iAge: Integer;
  rWeight: Real;

begin

  // Reset.
  resetAll;

  // Grab.
  sFirstname := edtName.Text;
  sLastname := edtSurname.Text;

  // Check empty.
  if (sFirstname = NullAsStringValue) then
  begin

    edtName.Font.Color := clRed;
    edtName.Focused;

    ShowMessage('Please enter a firstname.');
    Exit;

  end;

  if (sLastname = NullAsStringValue) then
  begin

    edtSurname.Font.Color := clRed;
    edtSurname.Focused;

    ShowMessage('Please enter a surname.');
    Exit;

  end;

  if (edtAge.Text = NullAsStringValue) then
  begin

    edtAge.Font.Color := clRed;
    edtAge.Focused;

    ShowMessage('Please enter a age.');
    Exit;

  end;

  if (edtWeight.Text = NullAsStringValue) then
  begin

    edtWeight.Font.Color := clRed;
    edtWeight.Focused;

    ShowMessage('Please enter a weight.');
    Exit;

  end;

  if (TFunctions.isNumber(edtAge.Text) = false) then
  begin

    edtAge.Font.Color := clRed;
    edtAge.Focused;

    ShowMessage('Please enter a number.');
    Exit;

  end;

  // Yes, we can store this.
  iAge := StrToInt(edtAge.Text);

  if (TFunctions.isNumber(edtWeight.Text) = false) then
  begin

    edtWeight.Font.Color := clRed;
    edtWeight.Focused;

    ShowMessage('Please enter a number.');
    Exit;

  end;

  // Yessir
  rWeight := StrToFloat(edtWeight.Text);

end;

procedure TfrmPManage.btnBackClick(Sender: TObject);
begin

  // Go back.
  frmPManage.Hide;
  frmWelcome.Show;

  // Reset.
  resetAll;

  cmbList.Items.Clear;

end;

procedure TfrmPManage.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  // Fix multi form issues.
  Application.Terminate;

end;

procedure TfrmPManage.FormShow(Sender: TObject);
var
  sTemp: String;

begin

  // Disable window resize.
  frmPManage.BorderStyle := bsDialog;
  frmPManage.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmPManage);

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

end;

procedure TfrmPManage.resetAll;
begin

  // Reset all.

  edtName.Font.Color := clBlack;
  edtSurname.Font.Color := clBlack;
  edtAge.Font.Color := clBlack;
  edtWeight.Font.Color := clBlack;

  edtName.Clear;
  edtSurname.Clear;
  edtAge.Clear;
  edtWeight.Clear;

end;

end.
