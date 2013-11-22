unit UMain;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.AppEvnts, IdHTTPWebBrokerBridge, Web.HTTPApp, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    Button1: TButton;
    BitBtn1: TBitBtn;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses ServerMethodsUnit1, Bematech, Funcoes, Winapi.ShellApi;

procedure TForm1.BitBtn1Click(Sender: TObject);
Var
  Integracao: TServerMethods1;
  iRet: Integer;
begin
  // Bematech_FI_ReducaoZ('','');

  try
    Integracao := TServerMethods1.Create(nil);
    iRet := Bematech_FI_CancelaCupom;
    // CheckBox1.Checked := Integracao.VerificaRetornoFuncaoImpressora(iRet);
    // Edit1.Text := Integracao.StatusImpressora;
    StatusBar1.Panels[0].Text := Integracao.cMSGPrinterErro;

  finally
    Integracao.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Integracao: TServerMethods1;
begin
  try
    Integracao := TServerMethods1.Create(nil);

    Integracao.AbrirCupom('55972020149', 1);
    { Integracao.VendeItem( '123',  'Caneta',  '1700', 'I',  10, 2, 1.25);
      Integracao.IniciaFechamentoCupom('A', '%', 0,0);
      Integracao.EfetuaFormaPagamento(1, 50.5);
      Integracao.TerminaFechamentoCupom('Obrigado pela Preferencia!');
    }
    StatusBar1.Panels[0].Text := Integracao.cMSGPrinterErro;
  finally
    Integracao.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Bematech_FI_ReducaoZ('', '');
end;

{ procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
  var
  LURL: string;
  begin
  StartServer;
  LURL := Format('http://localhost:%s', ['81']);
  ShellExecute(0,
  nil,
  PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
  end;
}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  StartServer;
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := 81;
    FServer.Active := True;
  end;
end;

end.
