program iTef;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UMain in 'UMain.pas' {Form1} ,
  ServerMethodsUnit1
    in 'ServerMethodsUnit1.pas' {ServerMethods1: TDSServerModule} ,
  ServerContainerUnit1
    in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule} ,
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule} ,
  UDataModulo in 'UDataModulo.pas' {Dm: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TServerContainer1, ServerContainer1);
  Application.Run;

end.
