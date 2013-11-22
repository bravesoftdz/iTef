unit UDataModulo;

interface

uses
  System.SysUtils, System.Classes, Data.DBXMSSQL, Data.FMTBcd, Data.DB,
  Data.SqlExpr, Data.DbxSqlite;

type
  TDm = class(TDataModule)
    Aguia: TSQLConnection;
    SPConsUm: TSQLStoredProc;
    iTEF: TSQLConnection;
    SQLQry1: TSQLQuery;
    Correntistas: TSQLConnection;
    SPCorrUm: TSQLStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
    Path: String;
  end;

var
  Dm: TDm;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

end.
