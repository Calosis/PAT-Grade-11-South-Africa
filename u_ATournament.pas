unit u_ATournament;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Math,
  System.Generics.Collections;

type
  TDynIntegerArray = array of integer;

type
  TfrmATournament = class(TForm)
    pnlBack: TPanel;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape15: TShape;
    Shape14: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    edtRound11: TEdit;
    edtRound12: TEdit;
    edtRound13: TEdit;
    edtRound14: TEdit;
    edtRound15: TEdit;
    edtRound16: TEdit;
    edtRound17: TEdit;
    edtRound18: TEdit;
    edtRound22: TEdit;
    edtRound21: TEdit;
    edtRound23: TEdit;
    edtRound24: TEdit;
    edtFinal1: TEdit;
    edtFinal2: TEdit;
    btnBack: TButton;
    stRound1: TStaticText;
    stRound2: TStaticText;
    stRound3: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cleanUp();
    procedure Init();
    procedure secondRound();
    procedure lastRound();

    // Fix for multi forums.
    procedure CreateParams(var Params: TCreateParams); override;
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmATournament: TfrmATournament;
  iAmountRoundsNeeded: integer;
  arrAttack, arrDefend, arrWinners: TDynIntegerArray;
  Edits1, Edits2: TArray<TEdit>;
  arrFinals: array [1 .. 2] of integer;
  sTWinner: String;

implementation

{$R *.dfm}

uses u_DatabaseConnection, u_Functions, u_TManage, u_Final, u_Welcome;

procedure TfrmATournament.btnBackClick(Sender: TObject);
begin

  frmATournament.Hide;
  frmWelcome.Show;

end;

procedure TfrmATournament.cleanUp;
var
  I, iTemp: integer;
  bEven: Boolean;

begin

  // Set. - Default true.
  bEven := true;
  I := 1;

  // Should 1 person automatically get a win due to there being an odd amount of ppl?
  if NOT(iCount MOD 2 = 0) then
  begin

    // Allow the last person to get a free win.
    frmDatabaseConnection.tblActiveRound.Last;
    frmDatabaseConnection.tblActiveRound.Edit;
    frmDatabaseConnection.tblActiveRound['A_Won'] := true;
    frmDatabaseConnection.tblActiveRound.Post;

  end;

  // Set.
  I := 1;

  // Lets put 2 people against each other.
  frmDatabaseConnection.tblActiveRound.First;

  while NOT(frmDatabaseConnection.tblActiveRound.Eof) do
  begin

    if (I MOD 2 = 0) then
    begin

      // Grab every 2nd users ID.
      iTemp := frmDatabaseConnection.tblActiveRound['A_PlayerID'];

      frmDatabaseConnection.tblActiveRound.Edit;
      frmDatabaseConnection.tblActiveRound['A_Opponent'] := 0;
      frmDatabaseConnection.tblActiveRound.Post;

      // Move back one to set them against someone.
      frmDatabaseConnection.tblActiveRound.Prior;

      // Add.
      frmDatabaseConnection.tblActiveRound.Edit;
      frmDatabaseConnection.tblActiveRound['A_Opponent'] := iTemp;
      frmDatabaseConnection.tblActiveRound.Post;
      frmDatabaseConnection.tblActiveRound.Next;

    end;

    frmDatabaseConnection.tblActiveRound.Next;

    // Move.
    Inc(I);

  end;

  // Remove every 2nd entry.
  frmDatabaseConnection.tblActiveRound.First;

  while NOT(frmDatabaseConnection.tblActiveRound.Eof) do
  begin

    // Users with the opponent 0 are removable.
    if (frmDatabaseConnection.tblActiveRound['A_Opponent'] = 0) then
    begin
      frmDatabaseConnection.tblActiveRound.Delete;
    end;

    frmDatabaseConnection.tblActiveRound.Next;

  end;

end;

procedure TfrmATournament.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Fix multi form issues.
  Application.Terminate;
end;

procedure TfrmATournament.FormShow(Sender: TObject);
var
  I, Y, iAttackL, iDefendL: integer;
  Names: TArray<String>;
  tFile: TextFile;
  sName: String;
begin

  // Set title.
  frmATournament.Caption := frmATournament.Caption + ' ' + sSelected;

  I := 1;

  // Disable window resize.
  frmATournament.BorderStyle := bsDialog;
  frmATournament.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frmATournament);

  // Fix stupid delphi stuff
  frmDatabaseConnection.tblActiveRound.Close;
  frmDatabaseConnection.tblActiveRound.Open;

  // Ready tbl for tournament.
  cleanUp;

  // Setup.
  Init;

  // Second Round
  secondRound;

  // Final.
  lastRound;

  // Save all in next file for later reading.
  sName := sSelected + '.txt';

  AssignFile(tFile, sName);

  Rewrite(tFile);

  Writeln(tFile, 'Round 1:');
  Writeln(tFile, ' ');
  // Round 1.

  Writeln(tFile, Edits1[0].Text + ' VS ' + Edits2[1].Text);
  Writeln(tFile, Edits1[2].Text + ' VS ' + Edits1[3].Text);
  Writeln(tFile, Edits1[4].Text + ' VS ' + Edits1[5].Text);
  Writeln(tFile, Edits1[6].Text + ' VS ' + Edits1[7].Text);
  Writeln(tFile, ' ');

  // Round 2:
  Writeln(tFile, 'Round 2:');
  Writeln(tFile, ' ');

  Writeln(tFile, Edits2[0].Text + ' VS ' + Edits2[1].Text);
  Writeln(tFile, Edits2[2].Text + ' VS ' + Edits2[3].Text);
  Writeln(tFile, ' ');

  // Finals.
  Writeln(tFile, 'Finals:');
  Writeln(tFile, ' ');

  Writeln(tFile, edtFinal1.Text + ' VS ' + edtFinal2.Text);
  Writeln(tFile, ' ');

  Writeln(tFile, 'Tournament Winner:');
  Writeln(tFile, ' ');

  iAttackL := RandomRange(1, 1000) + 1;
  iDefendL := RandomRange(1, 1000) + 1;

  if iAttackL > iDefendL then
  begin

    Writeln(tFile, edtFinal1.Text);

    ShowMessage('Tournament Winner: ' + edtFinal1.Text);

  end
  else
  begin
    Writeln(tFile, edtFinal2.Text);

    ShowMessage('Tournament Winner: ' + edtFinal2.Text);

  end;

  // Done, lets close it.
  CloseFile(tFile);

  // Set finished.
  frmDatabaseConnection.tblTournaments.First;
  while NOT(frmDatabaseConnection.tblTournaments.Eof) do
  begin

    if frmDatabaseConnection.tblTournaments['T_Name'] = sSelected then
    begin
      // Set tournament to finished. - Dev uncommented.
      frmDatabaseConnection.tblTournaments.Edit;
      frmDatabaseConnection.tblTournaments['T_Finished'] := true;
      frmDatabaseConnection.tblTournaments.Post;

      Exit;

    end;

    frmDatabaseConnection.tblTournaments.Next;

  end;

end;

procedure TfrmATournament.Init;
begin

  Edits1 := TArray<TEdit>.Create(edtRound11, edtRound12, edtRound13, edtRound14,
    edtRound15, edtRound16, edtRound17, edtRound18);

  frmDatabaseConnection.tblActiveRound.First;

  // Take everyone out of the database and lets store it locally.
  frmDatabaseConnection.tblActiveRound.First;

  while NOT(frmDatabaseConnection.tblActiveRound.Eof) do
  begin

    // Store attacker.
    SetLength(arrAttack, Length(arrAttack) + 1);
    arrAttack[High(arrAttack)] := frmDatabaseConnection.tblActiveRound
      ['A_PlayerID'];

    // Store defender.
    SetLength(arrDefend, Length(arrDefend) + 1);
    arrDefend[High(arrDefend)] := frmDatabaseConnection.tblActiveRound
      ['A_Opponent'];

    // Keep a internal counter for real size.
    // Inc(I);

    // Move.
    frmDatabaseConnection.tblActiveRound.Next;

  end;

  Edits1[0].Text := IntToStr(arrAttack[0]) + ': ' +
    TFunctions.whoIs(arrAttack[0]);
  Edits1[1].Text := IntToStr(arrDefend[0]) + ': ' +
    TFunctions.whoIs(arrDefend[0]);

  Edits1[2].Text := IntToStr(arrAttack[1]) + ': ' +
    TFunctions.whoIs(arrAttack[1]);
  Edits1[3].Text := IntToStr(arrDefend[1]) + ': ' +
    TFunctions.whoIs(arrDefend[1]);

  Edits1[4].Text := IntToStr(arrAttack[2]) + ': ' +
    TFunctions.whoIs(arrAttack[2]);
  Edits1[5].Text := IntToStr(arrDefend[2]) + ': ' +
    TFunctions.whoIs(arrDefend[2]);

  Edits1[6].Text := IntToStr(arrAttack[3]) + ': ' +
    TFunctions.whoIs(arrAttack[3]);
  Edits1[7].Text := IntToStr(arrDefend[3]) + ': ' +
    TFunctions.whoIs(arrDefend[3]);

end;

procedure TfrmATournament.lastRound;
var
  I: integer;
  rAttack1, rAttack2, rDefend1, rDefend2: Real;

begin

  rAttack1 := (RandomRange(10, 90 + 1) * 0.01) * 3;
  rDefend1 := (RandomRange(10, 90 + 1) * 0.01) * 3;

  rAttack2 := (RandomRange(10, 90 + 1) * 0.01) / 5;
  rDefend2 := (RandomRange(10, 90 + 1) * 0.01) / 5;

  // Final 1.
  if rAttack1 > rDefend1 then
  begin

    edtFinal1.Text := IntToStr(arrWinners[1]) + ': ' +
      TFunctions.whoIs(arrWinners[1]);
    arrFinals[1] := arrWinners[1];
  end
  else
  begin
    edtFinal1.Text := IntToStr(arrWinners[2]) + ': ' +
      TFunctions.whoIs(arrWinners[2]);
    arrFinals[1] := arrWinners[2];
  end;

  // Final 1.
  if Trunc(rAttack2) > Trunc(rDefend2) then
  begin

    edtFinal2.Text := IntToStr(arrWinners[3]) + ': ' +
      TFunctions.whoIs(arrWinners[3]);
    arrFinals[2] := arrWinners[3];
  end
  else
  begin
    edtFinal2.Text := IntToStr(arrWinners[4]) + ': ' +
      TFunctions.whoIs(arrWinners[4]);
    arrFinals[2] := arrWinners[4];
  end;

end;

procedure TfrmATournament.CreateParams(var Params: TCreateParams);
begin
  inherited;

  // Set style sheet so windows knows its another "window".
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;

  Params.WndParent := GetDesktopWindow;
end;

procedure TfrmATournament.secondRound;
var
  I: integer;
  rAttackP, rDefendP: Real;
begin

  // Take everyone out of the database and lets store it locally.
  frmDatabaseConnection.tblActiveRound.First;

  while NOT(frmDatabaseConnection.tblActiveRound.Eof) do
  begin

    // Store attacker.
    SetLength(arrAttack, Length(arrAttack) + 1);
    arrAttack[High(arrAttack)] := frmDatabaseConnection.tblActiveRound
      ['A_PlayerID'];

    // Store defender.
    SetLength(arrDefend, Length(arrDefend) + 1);
    arrDefend[High(arrDefend)] := frmDatabaseConnection.tblActiveRound
      ['A_Opponent'];

    // Move.
    frmDatabaseConnection.tblActiveRound.Next;

  end;

  // 1v1.
  for I := 1 to 6 do
  begin

    rAttackP := RandomRange(10, 90 + 1) * 0.01;
    rDefendP := RandomRange(10, 90 + 1) * 0.01;

    // Its fine that we only do this once, the odds it happens twice is so low.
    if (rAttackP = rDefendP) then
    begin

      rAttackP := RandomRange(10, 90 + 1) * 0.01;
      rDefendP := RandomRange(10, 90 + 1) * 0.01;

    end;

    // Attacker got more points.
    if rAttackP > rDefendP then
    begin

      SetLength(arrWinners, Length(arrWinners) + 1);
      arrWinners[High(arrWinners)] := arrAttack[I];

    end
    else
    begin
      // Defender got more points.
      SetLength(arrWinners, Length(arrWinners) + 1);
      arrWinners[High(arrWinners)] := arrDefend[I];

    end;
  end;

  Edits2 := TArray<TEdit>.Create(edtRound21, edtRound22, edtRound23,
    edtRound24);

  Edits2[0].Text := IntToStr(arrWinners[1]) + ': ' +
    TFunctions.whoIs(arrWinners[1]);
  Edits2[1].Text := IntToStr(arrWinners[2]) + ': ' +
    TFunctions.whoIs(arrWinners[2]);

  Edits2[2].Text := IntToStr(arrWinners[3]) + ': ' +
    TFunctions.whoIs(arrWinners[3]);
  Edits2[3].Text := IntToStr(arrWinners[4]) + ': ' +
    TFunctions.whoIs(arrWinners[4]);

end;

end.
