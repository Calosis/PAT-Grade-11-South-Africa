unit u_2FAScreen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.WinXCtrls, ShellAPI;

type
  Tfrm2FAScreen = class(TForm)
    RelativePanel1: TRelativePanel;
    imgBackground: TImage;
    pnlNext: TPanel;
    btnBack: TBitBtn;
    stHeading: TStaticText;
    pnlMiddle: TPanel;
    Label6: TLabel;
    imgApple: TImage;
    imgPlay: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    pbQR: TPaintBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure imgPlayClick(Sender: TObject);
    procedure imgAppleClick(Sender: TObject);
    procedure pbQRPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm2FAScreen: Tfrm2FAScreen;
  QRCodeBitmap: TBitmap;

implementation

{$R *.dfm}

uses u_Functions, u_Application, u_QRCode;

procedure Tfrm2FAScreen.btnBackClick(Sender: TObject);
begin

  // Back.
  frm2FAScreen.Hide;
  frmApplication.Show;

end;

procedure Tfrm2FAScreen.FormActivate(Sender: TObject);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
begin
  // Disable window resize.
  frm2FAScreen.BorderStyle := bsDialog;
  frm2FAScreen.BorderIcons := BorderIcons;

  // Centre
  TFunctions.sizeCentre(frm2FAScreen);

  // Provide token.
  Label11.Caption := '5.) Enter your key: ' + sSecret;

  // Create bitmap.
  QRCodeBitmap := TBitmap.Create;

  // Create.
  QRCode := TDelphiZXingQRCode.Create;

  try
    // Generate auth string.
    QRCode.Data := 'otpauth://totp/PAT ' + sUsername + '?secret=' + sSecret +
      '&issuer=' + 'Delphi';

    QRCode.Encoding := TQRCodeEncoding(0);
    QRCode.QuietZone := StrToIntDef('Auto', 4);
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);

    // Create QR code.
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end
        else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
  pbQR.Repaint;

end;

procedure Tfrm2FAScreen.imgAppleClick(Sender: TObject);
var
  sURL: String;
begin

  // Exec browser open.
  sURL := 'https://apps.apple.com/us/app/google-authenticator/id388497605';
  ShellExecute(self.WindowHandle, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);

end;

procedure Tfrm2FAScreen.imgPlayClick(Sender: TObject);
var
  sURL: String;
begin

  // Exec browser open.
  sURL := 'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_ZA&gl=US';
  ShellExecute(self.WindowHandle, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);

end;

procedure Tfrm2FAScreen.pbQRPaint(Sender: TObject);
var
  Scale: Double;
begin

  // Draw QR code.

  pbQR.Canvas.Brush.Color := clWhite;
  pbQR.Canvas.FillRect(Rect(0, 0, pbQR.Width, pbQR.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
  begin
    if (pbQR.Width < pbQR.Height) then
    begin
      Scale := pbQR.Width / QRCodeBitmap.Width;
    end
    else
    begin
      Scale := pbQR.Height / QRCodeBitmap.Height;
    end;
    pbQR.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width),
      Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);

  end;
end;

end.
