unit WebModuleUnit1;

interface

uses System.SysUtils, System.Classes, Web.HTTPApp, Data.DBXMSSQL, Data.FMTBcd,
  Data.DB, Data.SqlExpr;

type
  TWebModule1 = class(TWebModule)
    // Menu PRI
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    // 1a.
    procedure WebModule1SELECIONA_MENU_PRIAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1SELECIONA_OPCAOAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    { procedure WebModule1SELECIONA_NRO_CARAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    }

    // 2a.

    // 3a.

    procedure WebModule1ADMINISTRATIVOAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1CANCELAR_CUPOMAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1CONFIRMA_PGTO_BICOAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1EFETIVA_PGTO_BICOAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1INFORMA_PGTOAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1MENU_FISCAL_FUNCAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure WebModule1RETORNO_ADM_SITEFAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

  private
    { Private declarations }
    StringSQL: String;

  public
    { Public declarations }
    Acao, Requisicao, Resposta, DataHoraFormatada, Data, Hora, DataHoraCupom,
      NumeroCupom, CGC, IE, NumeroSerie: AnsiString;
    iRetorno: integer;
    ValorAbastec: Double;
    DBPath: String;

    Pagto, VlrPago, VlrAberto, VlrTroco, VlrCompra, VlrTotalPago: Double;
    DescRespProduto: String;

  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}

uses ServerMethodsUnit1, Funcoes, UDataModulo, UMain;

procedure TWebModule1.WebModule1ADMINISTRATIVOAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Resposta := '<HTML>';
  Resposta := Resposta + '<HEAD> <TITLE> LOGIN ADMIN </TITLE>';
  Resposta := Resposta + '<script>';
  Resposta := Resposta + 'function validaForm(form) { ';
  Resposta := Resposta + '   if (form.PWD.value.length > 0) {';
  Resposta := Resposta + '     return true;';
  Resposta := Resposta + '   }';
  Resposta := Resposta + '   alert("A Senha deve ser informado!");';
  Resposta := Resposta + '   return false;';
  Resposta := Resposta + '}';
  Resposta := Resposta + '</script>';
  Resposta := Resposta + '</HEAD>';

  Resposta := Resposta + '<BODY>';
  Resposta := Resposta +
    '<form action="/RETORNO_ADM_SITEF" method="SITEF" onsubmit="return validaForm(this)" >';
  Resposta := Resposta +
    '<input type="hidden" size="9"  name="TIPO_TRN" value="2">';

  Resposta := Resposta + '<br>LOGIN ADMINISTRATIVO';
  Resposta := Resposta + '<br>---------------------';
  Resposta := Resposta + '<br><p>';
  // Resposta := Resposta + '<br>Informe Código:';
  Resposta := Resposta +
    '<input type="text" size="6" name="PWD" value="Continua...." onsubmit="return validaForm(this)" > <br>';
  Resposta := Resposta + '<br>';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<input type="submit" value="    Entrar ">';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '</form>';

  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<table border="0">';
  Resposta := Resposta + '<tr><p>';
  Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
  // Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
  Resposta := Resposta + '</tr>';
  Resposta := Resposta + '</table>';
  Resposta := Resposta + '</BODY></HTML>';
  Response.Content := Resposta;

end;

procedure TWebModule1.WebModule1CANCELAR_CUPOMAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  IP_PDV, SQL: String;
  DBRecords: SmallInt;
  // DB: TSQLite3Database;
  // DBST : TSQLite3Statement;
begin
  { DBRecords := 0;
    IP_PDV := Request.RemoteIP;
    // Cria Conexão do banco de Dados
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST.Step = SQLITE_ROW do
    Begin
    DBRecords := 1;
    iRetorno := FinalizaTransacaoIdentificadaSiTef(0,0,
    PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST)))),
    PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST)))),
    PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST)))),
    PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_DADOS_CONF',DBST)))));
    iRetorno := Bematech_FI_CancelaCupom();
    if (Main.VerificaRetornoFuncaoImpressora( iRetorno, False ) ) then
    begin
    SQL := 'DELETE FROM Pagamentos_TEF WHERE ID_PGTO_TEF = 1';
    DB.Execute(SQL);
    Resposta := '<HTML><HEAD><TITLE> CANCELA CUPOM </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>CANCELAMENTO EFETUADO';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<table border="0">';
    Resposta := Resposta + '<tr>';
    Resposta := Resposta + '<td align="center"> <a href="/">Voltar Inicio</a> </td>';
    Resposta := Resposta + '</tr>';
    Resposta := Resposta + '</table>';
    //        Resposta := Resposta + '<p><a href="/">Voltar Menu</a>';
    end else
    Begin
    Resposta := '<HTML><HEAD><TITLE>ERRO IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<td align="center"> <a href="/">Voltar Inicio</a> </td>';
    end;
    DBST.Reset;
    End;
    if (DBRecords = 0) then
    Begin
    iRetorno := Bematech_FI_CancelaCupom();
    Resposta := '<HTML><HEAD><TITLE>RESULTADO SQL</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>OPERAÇÃO CANCELADA<br><p>';
    Resposta := Resposta + '<td align="center"> <a href="/">Voltar Inicio</a> </td>';
    end;
    DBST.Reset;
    finally
    DB.Free;
    end;
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
  }
end;

procedure TWebModule1.WebModule1CONFIRMA_PGTO_BICOAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  NumeroAbastecAtual: integer;
  IP_PDV, SQL, NRO_ABASTEC, BICO, TRANS_HAB, CODRESP, VALOR: String;
  // DB: TSQLite3Database;
  // DBST, DBST1 : TSQLite3Statement;
  DBRecords: integer;
  CPF, COMP_DATA_FISCAL, COMP_HORA_FISCAL, COMP_DATA_HORA_FISCAL,
    COMP_CUPOM_FISCAL, COMP_CUPOM_FISCAL_NUMEROSERIE,
    COMP_CUPOM_FISCAL_NITEM: String;
  VALOR_PAGO, VALOR_PAGO_DIN, VALOR_PAGO_TEF, VALOR_COMPRA: Double;
  ID_FORMA_PAGTO: SmallInt;
  Integracao: TServerMethods1;
  Ok: Boolean;

begin
  IP_PDV := Request.RemoteIP;
  NRO_ABASTEC := Request.ContentFields.Values['NRO_ABASTEC'];
  BICO := Request.ContentFields.Values['BICO'];
  TRANS_HAB := Request.ContentFields.Values['TRANS_HAB'];
  CODRESP := Request.ContentFields.Values['CODRESP'];
  CPF := Request.ContentFields.Values['CPF'];
  VALOR := BuscaTroca(Request.ContentFields.Values['VALOR'], '.', '');
  VALOR := BuscaTroca(VALOR, ',', '.');

  // VALOR := Copy(VALOR,1,(Length(VALOR)-2))+'.'+Copy(VALOR,(Length(VALOR)-1),2);

  if ((CODRESP <> '00') and (CODRESP <> '000') and (CODRESP <> '') and
    (CODRESP <> '99')) then
  Begin
    Resposta := '<HTML><HEAD><TITLE> CANCELA CUPOM </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br><td align="center"> Transacao Cancelada </td>';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<table border="0">';
    Resposta := Resposta + '<tr>';
    Resposta := Resposta +
      '<td align="center"> <a href="/INFORMA_PGTO">Voltar</a> </td>';
    Resposta := Resposta + '</tr>';
    Resposta := Resposta + '</table>';
    Resposta := Resposta + '</BODY></HTML>';
    // Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Response.Content := Resposta;
    exit;
  End;
  try
    Integracao := TServerMethods1.Create(nil);
    Ok := Integracao.AbrirCupom(CPF, 1);
  finally
    Integracao.Free;
  end;
  if (Ok = True) then
  Begin

  End;
  {
    CREATE TABLE Pagamentos (
    Id_pagto                       INTEGER        PRIMARY KEY AUTOINCREMENT,
    CPF                            VARCHAR( 11 ),
    CNPJ                           VARCHAR( 14 ),
    Comp_Cupom_Fiscal              VARCHAR( 6 ),
    Comp_Cupom_Fiscal_Numero_Serie VARCHAR( 20 ),
    Comp_Data_Hora_Fiscal          DATETIME,
    Comp_Data_Fiscal               VARCHAR( 15 ),
    Comp_Hora_Fiscal               VARCHAR( 15 ),
    Comp_Cupom_Fiscal_NIten        INTEGER,
    Terminal                       VARCHAR( 8 ),
    Valor_Compra                   REAL,
    Valor_Pago                     REAL,
    Valor_Pago_Dinheiro            REAL,
    Valor_Pago_TEF                 REAL,
    Valor_Aberto                   REAL,
    Valor_Troco                    REAL
    );

  }
  {
    StringSQL := 'SELECT * FROM cupom_fiscal_parte1 WHERE Status = 1';
    Dm.SQLQry1.Close;
    Dm.SQLQry1.SQL.Clear;
    Dm.SQLQry1.SQL.Text := StringSQL;
    Dm.SQLQry1.Open;
    if (not Dm.SQLQry1.Eof) then
    Begin
    if Abrir_Cupom_TEFWIFI(Request.ContentFields.Values['CPF']) then
    Begin
    NumeroAbastecAtual := StrToInt( Request.ContentFields.Values['NRO_ABASTEC']);
    with Dm.SPConsUm do
    Begin
    Close;
    StoredProcName := '';
    StoredProcName := 'sp_pdv_busca_abastecimento';
    ParamByName('@numero_abastecimento').AsString := Request.ContentFields.Values['NRO_ABASTEC'];
    Open;
    End;
    if (not Dm.SPConsUm.Eof) then
    Begin
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);

    COMP_CUPOM_FISCAL := Trim(NumeroCupom);
    COMP_CUPOM_FISCAL_NUMEROSERIE :=  Trim(NumeroSerie);
    COMP_DATA_FISCAL := Trim( '20' + Copy(Data, 5, 2) + Copy(Data, 3, 2) + Copy(Data, 1, 2));
    COMP_HORA_FISCAL := Trim(Hora);
    COMP_DATA_HORA_FISCAL := Trim(DataHoraFormatada);
    COMP_CUPOM_FISCAL_NITEM := '1';
    SQL := 'INSERT INTO Pagamentos_TEF  (IP_PDV_TEF, CPF, COMP_CUPOM_FISCAL, COMP_CUPOM_FISCAL_NUMEROSERIE, ';
    SQL := SQL + ' COMP_DATA_FISCAL, COMP_HORA_FISCAL, COMP_DATA_HORA_FISCAL,  ';
    SQL := SQL + ' CODFAMPRODUTO, CODPRODUTO, DESCRESPRODUTO, ';
    SQL := SQL + ' NRO_ABASTEC, BICO, NOMEFUNCIONARIO, ';
    SQL := SQL + ' QTDE_LITROS, PRECO_BOMBA, VALOR_COMPRA, VALOR_PAGO, VALOR_TROCO, VALOR_PAGO_DIN, ';
    SQL := SQL + ' VALOR_PAGO_TEF, VALOR_ABERTO, PGTO_TEF_COUNT ';
    SQL := SQL + ') VALUES (';
    SQL := SQL + QuotedStr(IP_PDV)+',';
    SQL := SQL + QuotedStr(CPF)+',';
    SQL := SQL + QuotedStr(COMP_CUPOM_FISCAL)+',';
    SQL := SQL + QuotedStr(COMP_CUPOM_FISCAL_NUMEROSERIE)+',';
    SQL := SQL + QuotedStr(COMP_DATA_FISCAL)+',';
    SQL := SQL + QuotedStr(COMP_HORA_FISCAL)+',';
    SQL := SQL + QuotedStr(COMP_DATA_HORA_FISCAL)+',';
    SQL := SQL + Dm.SPConsUm.FieldByName('CODFAMPRODUTO').AsString+',';
    SQL := SQL + Dm.SPConsUm.FieldByName('CODPRODUTO').AsString+',';
    SQL := SQL + QuotedStr(Dm.SPConsUm.FieldByName('DESCRESPRODUTO').AsString)+',';
    SQL := SQL + QuotedStr(Dm.SPConsUm.FieldByName('NUMERO_ABASTECIMENTO').AsString)+',';
    SQL := SQL + QuotedStr(Dm.SPConsUm.FieldByName('BICO').AsString)+',';
    SQL := SQL + QuotedStr(Dm.SPConsUm.FieldByName('NOMEFUNCIONARIO').AsString)+',';
    SQL := SQL + QuotedStr(Dm.SPConsUm.FieldByName('QTDE_LITROS').AsString)+',';
    SQL := SQL + QuotedStr(FormataCurrSQL(Dm.SPConsUm.FieldByName('PRECO_BOMBA').AsCurrency))+',';
    SQL := SQL + QuotedStr(FormataCurrSQL(Dm.SPConsUm.FieldByName('VALOR_ABASTECIMENTO').AsCurrency))+',';
    SQL := SQL + QuotedStr('0.00')+',';
    SQL := SQL + QuotedStr('0.00')+',';
    SQL := SQL + QuotedStr('0.00')+',';
    SQL := SQL + QuotedStr('0.00')+',';
    SQL := SQL + QuotedStr(FormataCurrSQL(Dm.SPConsUm.FieldByName('VALOR_ABASTECIMENTO').AsCurrency));
    SQL := SQL + ',0)';
    DB.Execute(SQL);
    finally
    DB.Free;
    end;
    {
    Tipo de Aliquota
    ----------------------------
    FF -> Substuição Tributária
    NN -> Nao incidencia de ICMS
    II - Isenção de ICMS
  }
  // ENVIA VALORES PARA IMPRESSORA FISCAL VENDA ITEM
  { iRetorno := Bematech_FI_VendeItem
    (PAnsiChar(AnsiString(Dm.SPConsUm.FieldByName
    ('Numero_Abastecimento').AsString)),
    Dm.SPConsUm.FieldByName('DESCRESPRODUTO').AsString, 'FF',
    'F', PAnsiChar(AnsiString(Dm.SPConsUm.FieldByName
    ('QTDE_LITROS').AsString)), 2,
    PAnsiChar(AnsiString(FormatFloat(',0.00',
    Dm.SPConsUm.FieldByName('PRECO_BOMBA').AsFloat))), '%',
    PAnsiChar(AnsiString(FormatFloat(',0.00', 0))));
    //----------------------------------------------------------
    if (Main.VerificaRetornoFuncaoImpressora(iRetorno, False)) then
    Begin
    Main.Cupom_Fiscal_Parte2
    (COMP_DATA_HORA_FISCAL,COMP_CUPOM_FISCAL,COMP_CUPOM_FISCAL_NUMEROSERIE,
    COMP_CUPOM_FISCAL_NITEM,
    Dm.SPConsUm.FieldByName('CODFAMPRODUTO').AsInteger,
    Dm.SPConsUm.FieldByName('CODPRODUTO').AsInteger, 1,
    Dm.SPConsUm.FieldByName('QTDE_LITROS').AsFloat,
    Dm.SPConsUm.FieldByName('PRECO_BOMBA').AsFloat, 0,
    Dm.SPConsUm.FieldByName('Valor_Abastecimento').AsFloat);
    cMSGPromocional := Replicate('=',48)
    +chr(10)+chr(13)+'Matricula / Operador:'+Dm.Session_Matricula + ' - '+Dm.Session_Usuario
    +chr(10)+chr(13)+Replicate('=',48);
    End;
    End else
    Begin
    Resposta := '<HTML><HEAD><TITLE> INFOR. IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+BICO+'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    end;
    End
    else
    Begin
    Resposta := '<HTML><HEAD><TITLE> INFOR. IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+Dm.SPConsUm.FieldByName('BICO').AsString+'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End;
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    while DBST.Step = SQLITE_ROW do
    Begin
    Resposta := '<HTML>';
    Resposta := Resposta + '<HEAD>';
    Resposta := Resposta + '<TITLE> CONFIRMA PAGAMENTO</TITLE>';

    Resposta := Resposta + '<script>';
    Resposta := Resposta + 'function validaForm(form) { ';
    Resposta := Resposta + '   if (form.VALOR.value.length > 0) {';
    Resposta := Resposta + '     return true;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '   alert("Campo Pagamento deve ter um valor!");';
    Resposta := Resposta + '   return false;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '</script>';

    Resposta := Resposta + '</HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>FORMA DE PAGAMENTO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<form action="/EFETIVA_PGTO_BICO" method="POST" onsubmit="return validaForm(this)" >';
    Resposta := Resposta + '<input type="hidden" size="2"  name="CODRESP" value="99">';
    Resposta := Resposta + '<input type="hidden" name="CPF" value="' +
    Request.ContentFields.Values['CPF'] + '">';
    Resposta := Resposta + '<input type="hidden" size="9"  name="TIPO_TRN" value="1">';
    Resposta := Resposta + '<br>Produto...:' + Padl(DBST.ColumnText(Dm.SQLiteGetField('DESCRESPRODUTO',DBST)), 5);
    Resposta := Resposta + '<br>VLR Compra:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST))), 10);
    Resposta := Resposta + '<br>VLR Pago..:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))), 10); // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br>VLR Aberto:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))), 10);
    // +Request.ContentFields.Values['TRANS_HAB'];
    //Resposta := Resposta + '<br>Troco.....:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_TROCO',DBST))), 10);
    // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br><p>Forma de Pagto:';
    Resposta := Resposta + '<select name="TRANS_HAB">';
    Resposta := Resposta + '<option value="16">Débito à vista</option>';
    Resposta := Resposta + '<option value="26">Crédito à vista</option>';
    //Resposta := Resposta + '<option value="27">Créd. parc.(estab.)</option>';
    //Resposta := Resposta + '<option value="28">Créd. parc.(admin.)</option>';
    Resposta := Resposta + '<option value="03">Em Dinheiro</option>';
    Resposta := Resposta + '<option value="04">Cartão Correntista</option>';
    Resposta := Resposta + '</select>';
    Resposta := Resposta + '<br>Pagamento.:';
    Resposta := Resposta + '<input type="text" size="12" name="VALOR" value=""><br>';
    Resposta := Resposta + '<br>';

    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_CUPOM_FISCAL" value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST))+'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_DATA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))+'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_HORA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))+'">';

    Resposta := Resposta +'<input type="hidden" size="50" name="BICO" value="' + DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST)) + '">';
    Resposta := Resposta + '<input type="hidden" size="50" name="NRO_ABASTEC" value="' + DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST)) + '">';

    Resposta := Resposta + '<input type="submit" value="   Enviar ">';
    Resposta := Resposta + '<input type="reset"  value="   Resetar ">';
    Resposta := Resposta + '</form>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM&COMP_CUPOM_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST))
    +'&COMP_DATA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))
    +'&COMP_HORA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))
    +'">Cancelar</a>';

    End;
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    DBST.Reset;

    exit;
    finally
    DB.Free;
    end;
    end;
    if ( (Trim(CODRESP) = '00') or (Trim(CODRESP) = '99')) then
    Begin
    // -----------------------------------
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST.Step = SQLITE_ROW do
    Begin
    SQL := 'UPDATE Pagamentos_TEF SET ';
    SQL := SQL + ' VALOR_PAGO = (VALOR_PAGO +'+ FormataCurrSQLTEF(VALOR)+')';
    if (Trim(CODRESP) = '99') then
    SQL := SQL + ' ,VALOR_PAGO_DIN  = (VALOR_PAGO_DIN + '+VALOR+')'
    else
    SQL := SQL + ' ,VALOR_PAGO_TEF  = (VALOR_PAGO_TEF + '+FormataCurrSQLTEF(VALOR)+')';
    end;
    SQL := SQL + ' ,VALOR_ABERTO  = (VALOR_COMPRA - (VALOR_PAGO + '+VALOR+') )';
    SQL := SQL + ',PGTO_TEF_COUNT = (PGTO_TEF_COUNT + 1)';
    SQL := SQL + ' WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DB.Execute(SQL);
    DBST.Reset;
    finally
    DB.Free;
    end;

    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST.Step = SQLITE_ROW do
    Begin
    SQL := 'INSERT INTO TEF (IP_PDV_TEF, CODRESP, EMPRESA, TERMINAL, VALOR_PAGO, ';
    SQL := SQL + ' COD_TRANS, REDE_AUT, COD_BANDEIRA, NUM_PARC, TIPO_TRN, ';
    SQL := SQL + ' COMP_CUPOM_FISCAL, COMP_DATA_FISCAL, COMP_HORA_FISCAL, COMP_DADOS_CONF, ';
    SQL := SQL + ' COMP_1VIA, COMP_2VIA, SAC_01, SAC_02)';
    SQL := SQL + ' VALUES ';
    SQL := SQL + '('+QuotedStr(IP_PDV);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['CODRESP']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['EMPRESA']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['TERMINAL']);
    SQL := SQL + ','+FormataCurrSQLTEF(VALOR);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COD_TRANS']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['REDE_AUT']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COD_BANDEIRA']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['NUM_PARC']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['TIPO_TRN']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_CUPOM_FISCAL']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_DATA_FISCAL']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_HORA_FISCAL']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_DADOS_CONF']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_1VIA']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['COMP_2VIA']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['SAC_01']);
    SQL := SQL + ','+QuotedStr(Request.ContentFields.Values['SAC_02']);
    SQL := SQL + ')';
    DB.Execute(SQL);
    if CODRESP = '00' then ID_FORMA_PAGTO := 2;
    if CODRESP = '99' then ID_FORMA_PAGTO := 1;

    VALOR :=  BuscaTroca(BuscaTroca(VALOR,',',''),'.',',');
    Main.Cupom_Fiscal_Parte3
    (
    DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_HORA_FISCAL',DBST)),
    DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST)),
    DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL_NUMEROSERIE',DBST)),
    ID_FORMA_PAGTO, StrToFloat(VALOR)
    );

    End;
    DBST.Reset;
    finally
    DB.Free;
    end;
    End;
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST.Step = SQLITE_ROW do
    Begin
    VALOR_PAGO := DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST));
    VALOR_COMPRA := DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST));
    if (VALOR_PAGO > 0) then
    Begin
    if (DBST.ColumnInt(Dm.SQLiteGetField('PGTO_TEF_COUNT',DBST)) = 1) then
    Begin
    iRetorno := Bematech_FI_IniciaFechamentoCupom('A', '%', FormatCurr(',0.00', 0.00));
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False) )then
    Begin
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+ DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST)) +'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End;
    End;
    Resposta := '<HTML>';
    Resposta := Resposta + '<TITLE> CONFIRMA PAGAMENTO SELECIONADO</TITLE> ';
    Resposta := Resposta + '<HEAD>';
    Resposta := Resposta + '<script>';
    Resposta := Resposta + 'function validaForm(form) { ';
    Resposta := Resposta + '   if (form.VALOR.value.length > 0) {';
    Resposta := Resposta + '     return true;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '   alert("Campo Pagamento deve ter um valor!");';
    Resposta := Resposta + '   return false;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '</script>';
    Resposta := Resposta + '</HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>--PAGAMENTO EFETUADO- ';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br><p>';
    Resposta := Resposta + '<br>Nº Abastec:' + DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST));
    Resposta := Resposta + '<br>Nº BICO...:' + DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST));
    Resposta := Resposta + '<br>Produto...:' + Padl(DBST.ColumnText(Dm.SQLiteGetField('DESCRESPRODUTO',DBST)), 3);
    Resposta := Resposta + '<br>Vendedor..:' + Padl(Maiuscula(trim(DBST.ColumnText(Dm.SQLiteGetField('NOMEFUNCIONARIO',DBST)))), 11);
    Resposta := Resposta + '<br>VLR Compra:' + Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST))), 10);
    Resposta := Resposta + '<br>VLR Pago..:' + Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))), 10);
    if (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST)) > 0) then
    Begin
    Resposta := Resposta + '<br>VLR Aberto:'    + Padr(FormatFloat(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))  ), 10);
    Resposta := Resposta + '<br>VLR Troco:'    + Padr(FormatFloat(',0.00', 0), 10);
    end else
    Begin
    Resposta := Resposta + '<br>VLR Aberto:'    + Padr(FormatFloat(',0.00', 0), 10);
    Resposta := Resposta + '<br>VLR Troco.:'    + Padr(FormatFloat(',0.00', Abs(DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST)))), 10);
    End;

    if (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO_TEF',DBST)) > 0) then
    Begin
    Beep;
    SQL := 'SELECT * FROM TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST1 := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST1.Step = SQLITE_ROW do
    Begin
    if (DBST1.ColumnText(Dm.SQLiteGetField('COMP_DADOS_CONF',DBST1)) <> '') then
    Begin
    iRetorno := FinalizaTransacaoIdentificadaSiTef(1,1,
    PAnsiChar(AnsiString( DBST1.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST1)))),
    PAnsiChar(AnsiString( DBST1.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL' ,DBST1)))),
    PAnsiChar(AnsiString( DBST1.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL' ,DBST1)))),
    PAnsiChar(AnsiString( DBST1.ColumnText(Dm.SQLiteGetField('COMP_DADOS_CONF'  ,DBST1)))));
    End;
    End;
    DBST1.Reset;
    End;

    if (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))) >= (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST)) ) then
    Begin
    // Fechamento Efetuado na formas de pagamentos
    //------------------------------------------------------------------------
    VALOR_PAGO_TEF := DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO_TEF',DBST));
    if (VALOR_PAGO_TEF > 0) then
    Begin
    iRetorno := Bematech_FI_EfetuaFormaPagamento('CARTAO',
    FormatCurr(',0.00', VALOR_PAGO_TEF ));
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False)) then
    Begin
    Resposta := '<HTML><HEAD><TITLE> INFOR. IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro +'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+ DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST)) +'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    End;
    End;
    VALOR_PAGO_DIN := DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO_DIN',DBST));
    if (VALOR_PAGO_DIN > 0 ) then
    Begin
    iRetorno := Bematech_FI_EfetuaFormaPagamento('DINHEIRO',
    FormatCurr(',0.00', VALOR_PAGO_DIN ));
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False)) then
    Begin
    Resposta := '<HTML><HEAD><TITLE> INFOR. IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro +'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+ DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST)) +'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    End;
    End;
    End;
    //----------------------------------->
    if (( DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST)) ) > 0) and (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST)) < (  DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST)) )) then
    Begin
    Resposta := '<HTML><HEAD><TITLE>CONTINUA PAGAMENTO</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>CONTINUA PAGAMENTO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br><p>Produto...:' + Padl(DBST.ColumnText(Dm.SQLiteGetField('DESCRESPRODUTO',DBST)), 3);
    Resposta := Resposta + '<br>VLR Compra:'    + Padr(FormatFloat(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST))  ), 10);
    Resposta := Resposta + '<br>VLR Pago..:'    + Padr(FormatFloat(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))    ), 10); // +Request.ContentFields.Values['VALOR'];
    if (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST)) > 0) then
    Begin
    Resposta := Resposta + '<br>VLR Aberto:'    + Padr(FormatFloat(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))  ), 10);
    Resposta := Resposta + '<br>VLR Troco.:'    + Padr(FormatFloat(',0.00', 0), 10);
    end else
    Begin
    Resposta := Resposta + '<br>VLR Aberto:'    + Padr(FormatFloat(',0.00', 0), 10);
    Resposta := Resposta + '<br>VLR Troco.:'    + Padr(FormatFloat(',0.00', Abs(DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST)))), 10);
    End;
    Resposta := Resposta + '<br>VLR Aberto:'    + Padr(FormatFloat(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))  ), 10);
    Resposta := Resposta + '<br><p>---------------------';
    Resposta := Resposta + '<table border="0">';
    Resposta := Resposta + '<tr>';
    Resposta := Resposta + '<td align="center"> <a href="/INFORMA_PGTO">Continua</a> </td>';
    Resposta := Resposta + '</tr>';
    Resposta := Resposta + '</table>';
    Resposta := Resposta + '</BODY></HTML>';
    //Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Response.Content := Resposta;
    exit;
    End;
    Main.Cupom_Fiscal_Parte4
    ( DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_HORA_FISCAL',DBST)) ,
    DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST)),
    DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL_NUMEROSERIE',DBST)),
    ( DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO_DIN',DBST)) +
    DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO_TEF',DBST))  ));
    Resposta := Resposta + '<br><p>';
    Resposta := Resposta + '<br><p>';
    iRetorno := Bematech_FI_TerminaFechamentoCupom(cMSGPromocional);
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False)) then
    Begin
    Resposta := '<HTML><HEAD><TITLE> INFOR. IMPRESSORA </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/EFETIVA_PGTO_BICO?BICO='+DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST))+'">Voltar</a>';
    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM">Cancelar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    end else
    Begin
    Resposta := Resposta + '<p><a href="/">Voltar Menu</a>';
    End;

    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;

    SQL := 'DELETE FROM TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DB.Execute(SQL);
    exit;
    End;
    End;
    finally
    DB.Free;
    end;
  }
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Resposta := '<HTML>';
  Resposta := Resposta + '<HEAD> <TITLE> MENU TEF WIFI </TITLE>';

  Resposta := Resposta + '<BODY>';
  Resposta := Resposta + '<form action="/SELECIONA_MENU_PRI" method="POST"';

  Resposta := Resposta + '<br>PAGAMENTO-PosTEF 1.0';
  Resposta := Resposta + '<br>---------------------';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<br><p>MENU PosTEF WIFI:';
  Resposta := Resposta + '<br>---------------------';
  Resposta := Resposta + '<br><p>';

  // Resposta := Resposta + '<INPUT TYPE="CARD" NAME="NRO_CARD" [MAXLENGTH="16"] ';
  // Resposta := Resposta + '[MINLENGTH="10"][MAGTYPE="1"]>';

  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<select name="ID_MENU">';
  Resposta := Resposta + '<option value="1">Abastecimento</option>';

  // Resposta := Resposta + '<option value="0">Carrinho de Compra</option>';
  Resposta := Resposta + '<option value="2">Administrativo</option>';

  Resposta := Resposta + '<option value="3">Menu Fiscal</option>';

  Resposta := Resposta + '<option value="4">Correntista</option>';

  Resposta := Resposta + '</select>';
  Resposta := Resposta + '<br>';

  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<input type="submit" value="    Enviar ">';
  Resposta := Resposta + '<br><p>';

  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '</form>';
  Resposta := Resposta + '<br><p>';
  Resposta := Resposta + '<table border="0">';
  Resposta := Resposta + '<tr>';
  Resposta := Resposta + '<td align="left"> Copyright - Cascol</td>';
  Resposta := Resposta + '</tr>';
  Resposta := Resposta + '</table>';

  Resposta := Resposta + '</BODY></HTML>';
  Response.Content := Resposta;

end;

procedure TWebModule1.WebModule1EFETIVA_PGTO_BICOAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
Var
  // DB: TSQLite3Database;
  // DBST: TSQLite3Statement;
  DBRecords: integer;
  SQL: String;
  Pagto, VlrCompra: Double;

begin
  { DBPath :=  Dm.Path+'posTEFDB.db';
    if (FileExists(DBPath)) then
    Begin
    // Criar banco de dados e preenche-o com dados de exemplo
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    finally
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE ID_PGTO_TEF = 1';
    DBST := DB.Prepare(SQL);
    DBRecords := 0;
    while DBST.Step = SQLITE_ROW do
    Begin
    Pagto := (DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST)) +
    ConvertMoedaString(Request.ContentFields.Values['VALOR']));

    Resposta :=
    '<HTML><HEAD><TITLE> CONFIRMA PAGAMENTO NOVO-> SELECIONADO </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';

    if (DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST)) <> '') then
    Begin

    if ((Request.ContentFields.Values['TRANS_HAB'] = '00') or
    (Request.ContentFields.Values['TRANS_HAB'] = '03')) then
    Begin
    Resposta := Resposta +
    '<form action="/CONFIRMA_PGTO_BICO" method="POST" >';
    // onsubmit="return validaForm(this)"
    Resposta := Resposta + '<input type="hidden" name="CODRESP" value="99">';
    end
    else
    Resposta := Resposta +
    '<form action="/CONFIRMA_PGTO_BICO" method="SITEF" >';
    // onsubmit="return validaForm(this)"
    Resposta := Resposta + '<input type="hidden" name="ACAO" value="SITEF">';
    end;

    VlrCompra := ConvertMoedaString(DBST.ColumnText(Dm.SQLiteGetField('VALOR_COMPRA',DBST)));

    if (Pagto <= VlrCompra) or
    ((Request.ContentFields.Values['TRANS_HAB'] = '03')) then
    Begin

    Resposta := Resposta + '<input type="hidden" name="CPF" value="' +
    DBST.ColumnText(Dm.SQLiteGetField('CPF',DBST)) + '">';
    Resposta := Resposta + '<input type="hidden" name="VALOR" value="' +
    Request.ContentFields.Values['VALOR'] + '">';

    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_CUPOM_FISCAL" value="'+ DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST)) +'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_DATA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))+'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_HORA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))+'">';


    Resposta := Resposta + '<input type="hidden" size="50" name="BICO" value="'
    + DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST))+ '">';
    Resposta := Resposta +
    '<input type="hidden" size="50" name="NRO_ABASTEC" value="' +
    DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST)) + '">';
    Resposta := Resposta +
    '<input type="hidden" size="9"  name="TIPO_TRN" value="1">';
    Resposta := Resposta + '<input type="hidden" name="TRANS_HAB" value="' + Request.ContentFields.Values['TRANS_HAB'] + '"><br>';

    Pagto := ConvertMoedaString(Request.ContentFields.Values['VALOR']);
    // Resposta := Resposta + '<br>PAGAMENTO:';
    Resposta := Resposta + '<br>' + FormaDePagamento
    (Request.ContentFields.Values['TRANS_HAB']);
    // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>Nº Abastec:' +
    DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST));
    Resposta := Resposta + '<br>Nº BICO...:' +
    DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST));
    Resposta := Resposta + '<br>Produto...:' +
    Padl(DBST.ColumnText(Dm.SQLiteGetField('DESCRESPRODUTO',DBST)), 3);
    Resposta := Resposta + '<br>Vendedor..:' +
    Padl(Maiuscula(trim(DBST.ColumnText(Dm.SQLiteGetField('NOMEFUNCIONARIO',DBST)))), 11);
    Resposta := Resposta + '<br>VLR Compra:' +
    Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST))), 10);
    Resposta := Resposta + '<br>VLR Pago..:' +
    Padr(FormatCurr(',0.00',  DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))), 10); // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br>VLR Aberto:' +
    Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))), 10); // +Request.ContentFields.Values['TRANS_HAB'];
    //Resposta := Resposta + '<br>Troco.....:' +
    //  Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_TROCO',DBST))), 10); // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br>Pagamento.:' + Padr(FormatFloat(',0.00', Pagto),
    10); // +Request.ContentFields.Values['VALOR'];

    Resposta := Resposta + '<p><input type="submit" value="   Enviar ">';
    Resposta := Resposta + '<input type="reset"  value="   Resetar ">';

    //Resposta := Resposta + '<a href="/CONFIRMA_PGTO_BICO?NRO_ABASTEC=' +NRO_ABASTEC + '&BICO=' + BICO + '">Cancelar</a>';

    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM&COMP_CUPOM_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST))
    +'&COMP_DATA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))
    +'&COMP_HORA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))
    +'">Cancelar</a>';
    End
    else
    Begin // .....................
    Resposta := Resposta + '<br>-----ATENÇÃO:-------';
    Resposta := Resposta + '<br>VLR. do Pagamento';
    Resposta := Resposta + '<br>em cartão deve ser';
    Resposta := Resposta + '<br>MENOR ou IGUAL ao ';
    Resposta := Resposta + '<br>VLR. da Compra!';

    Resposta := Resposta + '<p><a href="/INFORMA_PGTO'
    +'">Voltar</a>';
    End;
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    End;
    DBST.Reset;
    DB.Free;
    end;
    End;
  }

end;

procedure TWebModule1.WebModule1INFORMA_PGTOAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  // DB: TSQLite3Database;
  // DBST: TSQLite3Statement;
  DBRecords: integer;
  SQL, IP_PDV: String;
begin
  { IP_PDV := Request.RemoteIP;
    DBPath :=  Dm.Path+'posTEFDB.db';
    DB := TSQLite3Database.Create;
    try
    DB.Open(DBPath);
    SQL := 'SELECT * FROM Pagamentos_TEF WHERE IP_PDV_TEF = '+QuotedStr(IP_PDV);
    DBST := DB.Prepare(SQL);
    while DBST.Step = SQLITE_ROW do
    Begin
    Resposta := '<HTML>';
    Resposta := Resposta + '<TITLE> CONFIRMA PAGAMENTO SELECIONADO</TITLE> ';
    Resposta := Resposta + '<HEAD>';
    Resposta := Resposta + '<script>';
    Resposta := Resposta + 'function validaForm(form) { ';
    Resposta := Resposta + '   if (form.VALOR.value.length > 0) {';
    Resposta := Resposta + '     return true;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '   alert("Campo Pagamento deve ter um valor!");';
    Resposta := Resposta + '   return false;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '</script>';
    Resposta := Resposta + '</HEAD>';
    Resposta := Resposta + '<BODY>';

    Resposta := Resposta + '<br>FORMA DE PAGAMENTO*:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<form action="/EFETIVA_PGTO_BICO" method="POST" onsubmit="return validaForm(this)" >';
    // onsubmit="return validaForm(this)"
    Resposta := Resposta + '<input type="hidden" size="2"  name="CODRESP" value="99">';
    Resposta := Resposta + '<input type="hidden" name="CPF" value="' +
    Request.ContentFields.Values['CPF'] + '">';
    Resposta := Resposta + '<input type="hidden" size="9"  name="TIPO_TRN" value="1">';


    Resposta := Resposta + '<br>Produto...:' + Padl(DBST.ColumnText(Dm.SQLiteGetField('DESCRESPRODUTO',DBST)), 3);
    Resposta := Resposta + '<br>VLR Compra:' + Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_COMPRA',DBST))), 10);
    Resposta := Resposta + '<br>VLR Pago..:' + Padr(FormatCurr(',0.00', DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_PAGO',DBST))), 10); // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br>VLR Aberto:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))), 10);

    // +Request.ContentFields.Values['TRANS_HAB'];
    //Resposta := Resposta + '<br>Troco.....:' + Padr(FormatCurr(',0.00',DBST.ColumnDouble(Dm.SQLiteGetField('VALOR_ABERTO',DBST))), 10);
    // +Request.ContentFields.Values['VALOR'];
    Resposta := Resposta + '<br><p>Forma de Pagto:';
    Resposta := Resposta + '<select name="TRANS_HAB">';
    Resposta := Resposta + '<option value="16">Débito à vista</option>';
    Resposta := Resposta + '<option value="26">Crédito à vista</option>';
    //Resposta := Resposta + '<option value="27">Créd. parc.(estab.)</option>';
    //Resposta := Resposta + '<option value="28">Créd. parc.(admin.)</option>';
    Resposta := Resposta + '<option value="03">Em Dinheiro</option>';
    Resposta := Resposta + '<option value="04">Cartão Correntista</option>';
    Resposta := Resposta + '</select>';
    Resposta := Resposta + '<br>Pagamento.:';
    Resposta := Resposta + '<input type="text" size="12" name="VALOR" value=""><br>';
    Resposta := Resposta + '<br>';

    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_CUPOM_FISCAL" value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST))+'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_DATA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))+'">';
    Resposta := Resposta + '<input type="hidden" size="50" name="COMP_HORA_FISCAL"  value="'+DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))+'">';

    Resposta := Resposta +'<input type="hidden" size="50" name="BICO" value="' + DBST.ColumnText(Dm.SQLiteGetField('BICO',DBST))+ '">';
    Resposta := Resposta + '<input type="hidden" size="50" name="NRO_ABASTEC" value="' + DBST.ColumnText(Dm.SQLiteGetField('NRO_ABASTEC',DBST)) + '">';

    Resposta := Resposta + '<input type="submit" value="   Enviar ">';
    Resposta := Resposta + '<input type="reset"  value="   Resetar ">';

    Resposta := Resposta + '<p><a href="/CANCELAR_CUPOM?ACAO=CANCELAR_CUPOM&COMP_CUPOM_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST))
    +'&COMP_DATA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST))
    +'&COMP_HORA_FISCAL='
    +DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST))
    +'">Cancelar</a>';

    End;
    finally

    end;
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
  }
end;

procedure TWebModule1.WebModule1MENU_FISCAL_FUNCAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  TIPO_FUNC_MENU, DataMovimento: AnsiString;
  iConta: integer;

begin
  {
    TIPO_FUNC_MENU := Request.ContentFields.Values['TIPO_FUNC_MENU'];
    Resposta := '';
    if (TIPO_FUNC_MENU = '2') then
    Begin
    for iConta := 1 to 7 do DataMovimento := DataMovimento + ' ';
    iRetorno := Bematech_FI_DataMovimento(DataMovimento);
    if (Main.VerificaRetornoFuncaoImpressora(iRetorno, False) )then
    Begin
    if (Trim(DataMovimento) <> '000000') then
    Begin
    if (Trim(DataMovimento) <> FormatDateTime('DDMMYY',Now)) then
    begin
    iRetorno := Bematech_FI_ReducaoZ('', '') ;
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False) )then
    Begin
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=3">Voltar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End else
    Begin
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br> Operação realizada <br> com sucesso!<br><p>';
    Resposta := Resposta + '<a href="/">Voltar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End;
    end;
    End;
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>Operação não <br>permitida,<br> Redução Z já <br> realizada hoje!<br><p>';
    Resposta := Resposta + '<a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=3">Voltar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End;
    End else if (TIPO_FUNC_MENU = '1') then
    Begin
    iRetorno := Bematech_FI_LeituraX;
    if (not Main.VerificaRetornoFuncaoImpressora(iRetorno, False) )then
    Begin
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
    Resposta := Resposta + '<a href="/SELECIONA_TIPO?TIPO_PAGAMENTO=3">Voltar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End else
    Begin
    Resposta := '<HTML><HEAD><TITLE>INFOR. IMPRESSORA</TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '<br>INFORMAÇÃO:';
    Resposta := Resposta + '<br>---------------------';
    Resposta := Resposta + '<br> Operação realizada <br>com sucesso!<br><p>';
    Resposta := Resposta + '<a href="/">Voltar</a>';
    Resposta := Resposta + '</BODY></HTML>';
    Response.Content := Resposta;
    exit;
    End;
    End;
  }
end;

procedure TWebModule1.WebModule1RETORNO_ADM_SITEFAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
Var
  CODRESP, Resposta_old: String;
begin
  CODRESP := Request.ContentFields.Values['CODRESP'];
  Resposta := '';
  if (CODRESP = '00') then
  Begin

    Resposta := Resposta + '<pre>';
    Resposta := Resposta + BuscaTroca(Request.ContentFields.Values['COMP_1VIA'],
      '@', #13 + #10);
    // Resposta := Resposta + '\pause IMPRESSAO DA PRIMEIRA VIA...';
    Resposta := Resposta + '</pre>';
    Resposta := Resposta + Replicate('<br>', 5) + ':) Sucesso!!!';

  End
  else
  Begin
    Resposta := Resposta + Replicate('<br>', 5) + ':( Nenhum Resultado!!!';
  end;
  Resposta := Resposta + '<a href="/">Voltar</a> <br>';

  {
    Resposta := '<HTML><HEAD><TITLE> COMPROVANTE </TITLE></HEAD>';
    Resposta := Resposta + '<BODY>';
    Resposta := Resposta + '-->TRANSACAO OK!<br>';
    Resposta := Resposta + 'Codigo Resposta:'+ CODRESP +'<br>';
    Resposta := Resposta + '---------------------<br>';
    Resposta := Resposta + '/pause 10';
    // Resposta := Resposta + '<a href="/form">Inicial</a> <br>';
    Resposta := Resposta + '</BODY></HTML>';
  }
  Response.Content := Resposta;

end;

procedure TWebModule1.WebModule1SELECIONA_OPCAOAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ID_OPCAO, BICO, TIPO_CARTAO, NUMERO_CARTAO, NUMERO_CARTAO_T1,
    NUMERO_CARTAO_T2, SITUACAO_DIGITACAO, PLACA, IP_HOST, LOGIN: String;
Var
  DadosCartao: TStringList;
begin
  BICO := Request.ContentFields.Values['BICO'];
  ID_OPCAO := Request.ContentFields.Values['ID_OPCAO'];

  // Parametros para [sp_consulta_cartao]
  TIPO_CARTAO := Request.ContentFields.Values['TIPO_CARTAO'];
  NUMERO_CARTAO_T1 := Request.ContentFields.Values['NUMERO_CARTAO'];
  SITUACAO_DIGITACAO := '1';
  PLACA := Request.ContentFields.Values['PLACA'];
  LOGIN := Request.ContentFields.Values['LOGIN'];
  IP_HOST := Request.RemoteIP;

  try
    DadosCartao := TStringList.Create;
    DadosCartao := BreakApart(Request.ContentFields.Values
      ['NUMERO_CARTAO'], ';');
    TIPO_CARTAO := Copy(DadosCartao[0], 4, DadosCartao[0].Length - 3);
    NUMERO_CARTAO_T1 := Copy(DadosCartao[1], 4, DadosCartao[1].Length - 3);
    NUMERO_CARTAO_T2 := Copy(DadosCartao[2], 4, DadosCartao[2].Length - 3);
    if TIPO_CARTAO = '1' then
      NUMERO_CARTAO := NUMERO_CARTAO_T1
    else
      NUMERO_CARTAO := NUMERO_CARTAO_T2;
  finally
    DadosCartao.Free;
  end;

  Form1.Memo1.Lines.Clear;
  Form1.Memo1.Lines.Add(NUMERO_CARTAO);

  // if ((BICO <> '0') and (BICO <> '')) then
  if ID_OPCAO = '1' then
  Begin
    Resposta := '           <HTML><HEAD>';
    Resposta := Resposta + '<TITLE>PROCESSA BICHO ABASTECIMENTO </TITLE>';
    Resposta := Resposta + '<script>';
    Resposta := Resposta + '  function validaForm(form) {';
    Resposta := Resposta + '    if (form.VALOR.value.length == 0) {';
    Resposta := Resposta + '      alert("Campo [VALOR] deve ter um valor!");';
    Resposta := Resposta + '      return true;';
    Resposta := Resposta + '    }';
    Resposta := Resposta + '    return false;';
    Resposta := Resposta + '  }';
    Resposta := Resposta + '</script>';

    Resposta := Resposta + '</HEAD>';
    Resposta := Resposta + '<BODY>';

    Resposta := Resposta + '<form action="/CONFIRMA_PGTO_BICO" method="POST" >';
    // onsubmit="return validaForm(this)"
    // if not Dm.Aguia.Connected then
    // Dm.Aguia.Connected := True;

    with Dm.SPConsUm do
    Begin
      Close;
      StoredProcName := '';
      StoredProcName := 'sp_pdv_lista_abastecimentos_bico';
      ParamByName('@codbico').AsString := BICO;
      Open;
      if (Fields[0].AsInteger = 1) then
      Begin
        beep;
      End
      else
      Begin
        beep;
      end;
    End;
    if (Not Dm.SPConsUm.Eof) then
    Begin

      Resposta := Resposta + '<br>PROCESSA PAGAMENTO:';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br>Abastecimento:';
      Resposta := Resposta + '<select name="NRO_ABASTEC">';
      // Resposta := Resposta + '<option value="0">Sel. Abastecimento</option>';
      while (not Dm.SPConsUm.Eof) do
      Begin
        Resposta := Resposta + '<option value="' +
          trim(Dm.SPConsUm.FieldByName('Numero_Abastecimento').AsString) + '">'
          + Padl(Maiuscula(trim(Dm.SPConsUm.FieldByName('NomeFuncionario')
          .AsString)), 6) +
          Padr(FormatFloat(',0.00',
          Dm.SPConsUm.FieldByName('Valor_abastecimento').AsFloat), 8) + ' ' +
          Padl(Dm.SPConsUm.FieldByName('DescResProduto').AsString, 3) +
          '</option>';
        Dm.SPConsUm.Next;
      End;

      Resposta := Resposta + '</select>';

      Resposta := Resposta +
        '<input type="hidden" size="50" name="BICO" value="' + BICO + '">';

      Resposta := Resposta + '<p><br>CPF no Cupom Fiscal?:';
      Resposta := Resposta +
        '<input type="text" size="15" name="CPF" value=""> <br>';
      Resposta := Resposta + '<p><br>';
      Resposta := Resposta + '<input type="submit" value="   Enviar ">';
      Resposta := Resposta + '<input type="reset"  value="   Resetar ">';

      Resposta := Resposta +
        '<p><p><p><p><p><a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=1">Voltar</a>';

    End
    else
    Begin
      Resposta := Resposta + '<br>Nenhuma venda p/ este';
      Resposta := Resposta + '<br>bico agora!';
      Resposta := Resposta + '<br>';
      Resposta := Resposta + '<br>';
      Resposta := Resposta +
        '<a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=1">Voltar</a>';
    End;

    Resposta := Resposta + '</form>';
    Resposta := Resposta + '</BODY></HTML>';
  End
  else if (ID_OPCAO = '2') then
  Begin

  End
  else if (ID_OPCAO = '3') then
  Begin
    with Dm.SPCorrUm do
    Begin
      Close;
      StoredProcName := '';
      StoredProcName := 'sp_consulta_cartao';
      ParamByName('@tipocartao').AsString := TIPO_CARTAO;
      ParamByName('@numerocartao').AsString := NUMERO_CARTAO;
      ParamByName('@situacaodigitacao').AsString := SITUACAO_DIGITACAO;
      ParamByName('@placa').AsString := UpperCase(PLACA);
      ParamByName('@senha').AsString := LOGIN;
      ParamByName('@IP').AsString := IP_HOST;
      Open;
      if (Fields[0].AsInteger = 1) then
      Begin
        beep;
      End
      else
      Begin
        beep;
      end;
    End;
    if (Not Dm.SPCorrUm.Eof) then
    Begin
      if (Dm.SPCorrUm.FieldByName('coderro').AsInteger = 0) then
      Begin
        Resposta := '           <HTML><HEAD>';
        Resposta := Resposta + '<TITLE>RESPOSTA </TITLE>';
        Resposta := Resposta + '</HEAD>';
        Resposta := Resposta + '<BODY>';
        Resposta := Resposta + Dm.SPCorrUm.FieldByName('msg_erro').AsString;

        Resposta := Resposta + '<pre>' + BuscaTroca(Dm.SPCorrUm.FieldByName('retorno').AsString, '@', #13 + #10);
        Resposta := Resposta + '</pre>';

        Resposta := Resposta +
          '<p><p><a href="/SELECIONA_MENU_PRI?ID_MENU=4">Voltar</a>';
        Resposta := Resposta + '</BODY></HTML>';
      end
      else if (Dm.SPCorrUm.FieldByName('coderro').AsInteger = 1) then
      Begin
        Resposta := '           <HTML><HEAD>';
        Resposta := Resposta + '<TITLE>RESPOSTA </TITLE>';
        Resposta := Resposta + '</HEAD>';
        Resposta := Resposta + '<BODY>';
        Resposta := Resposta + '<br><p><p>' + Dm.SPCorrUm.FieldByName('msg_erro').AsString;
        Resposta := Resposta +
          '<p><a href="/SELECIONA_MENU_PRI?ID_MENU=4">Voltar</a>';
        Resposta := Resposta + '</BODY></HTML>';
      End
      else
      Begin
        Resposta := '           <HTML><HEAD>';
        Resposta := Resposta + '<TITLE>RESPOSTA </TITLE>';
        Resposta := Resposta + '</HEAD>';
        Resposta := Resposta + '<BODY>';
        Resposta := Resposta + '<br><p><p>Não Cadastradado!';
        Resposta := Resposta +
          '<p><a href="/SELECIONA_MENU_PRI?ID_MENU=4">Voltar</a>';
        Resposta := Resposta + '</BODY></HTML>';
      End;
    End
    else
    Begin
      Resposta := '           <HTML><HEAD>';
      Resposta := Resposta + '<TITLE>RESPOSTA </TITLE>';
      Resposta := Resposta + '</HEAD>';
      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<br><p><p>Não Cadastradado!';
      Resposta := Resposta +
        '<p><a href="/SELECIONA_MENU_PRI?ID_MENU=4">Voltar</a>';
      Resposta := Resposta + '</BODY></HTML>';
    End;
    Response.Content := Resposta;
  end;
end;

procedure TWebModule1.WebModule1SELECIONA_MENU_PRIAction(Sender: TObject;
    Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  var
    ID_MENU: String;
    // DB: TSQLite3Database;
    // DBST: TSQLite3Statement;
    // DBRecords : Integer;
    SQL, IP_PDV: String;

  begin
    // DBRecords := 0;
    IP_PDV := Request.RemoteIP;
    ID_MENU := Request.ContentFields.Values['ID_MENU'];

    if (ID_MENU = '1') then
    Begin
      Resposta := '<HTML>';
      Resposta := Resposta + '<HEAD> <TITLE> PAGAMENTO </TITLE>';
      Resposta := Resposta + '<script>';
      Resposta := Resposta + 'function validaForm(form) { ';
      Resposta := Resposta + '   if (form.BICO.value.length > 0) {';
      Resposta := Resposta + '     return true;';
      Resposta := Resposta + '   }';
      Resposta := Resposta +
        '   alert("Campo BICO deve ter  um valor válido!");';
      Resposta := Resposta + '   return false;';
      Resposta := Resposta + '}';
      Resposta := Resposta + '</script>';
      Resposta := Resposta + '</HEAD>';

      Resposta := Resposta + '<BODY>';
      Resposta := Resposta +
        '<form action="/SELECIONA_OPCAO" method="POST" onsubmit="return validaForm(this)" >';
      Resposta := Resposta + '<INPUT TYPE="hidden" name="ID_OPCAO" value="1">';

      Resposta := Resposta + '<br>PAGAMENTO-PosTEF 1.0';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br><p>Digite Nro. do Bico:';
      Resposta := Resposta +
        '<input type="text" size="2" name="BICO" value="" onsubmit="return validaForm(this)" > <br>';
      Resposta := Resposta + '<br>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<input type="submit" value="    Enviar ">';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '</form>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<tr><p>';
      Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
      // Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';
      Resposta := Resposta + '</BODY></HTML>';
    end;
    if (ID_MENU = '4') then
    Begin
      Resposta := '<HTML>';
      Resposta := Resposta + '<HEAD><TITLE>CORRENTISTA</TITLE>';
      Resposta := Resposta + '</HEAD>';

      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<form action="/SELECIONA_OPCAO" method="POST">';
      Resposta := Resposta + '<INPUT TYPE="hidden" name="ID_OPCAO" value="3">';
      Resposta := Resposta + '<br>PESQUISA AUTORIZACAO:';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br>Placa Veículo:';
      Resposta := Resposta +
        '<INPUT TYPE="TEXT" NAME="PLACA" SIZI="7" value="JHI7044">';
      Resposta := Resposta + '<p><br>Entrar com Cartão:';
      Resposta := Resposta +
      // '<INPUT TYPE="REPOM-SMART" NAME="dadoscard" [SMARTTYPE="dados"]>';
        '<INPUT TYPE="CARD" NAME="NUMERO_CARTAO" [MAGTYPE="2"] [MAXLENGTH="16"] [MINLENGTH="4" [MAGTYPE="dados"] >';
      // '<INPUT TYPE="SERIAL" NAME="NROSMARTCARD" [MAXLENGTH="16"] [MINLENGTH="4"] [SERIALTYPE="1" [PORT="1"] [RATE="2400"] [DATABITS="dados"] [PARITY="paridade"] [STOP="parada"]> <br>';

      Resposta := Resposta + '<p><br>PWD:';
      Resposta := Resposta +
        '<input type="password" name="LOGIN" VALUE="">';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<input type="submit" value="    Enviar ">';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '</form>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<tr><p>';
      Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
      // Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';
      Resposta := Resposta + '</BODY></HTML>';

    End;
    Response.Content := Resposta;

    { DBPath :=  Dm.Path+'posTEFDB.db';
      DB := TSQLite3Database.Create;
      try
      DB.Open(DBPath);
      SQL := '     SELECT * FROM TEF WHERE EXISTS(SELECT IP_PDV_TEF  FROM  PAGAMENTOS_TEF ';
      SQL := SQL+' WHERE PAGAMENTOS_TEF.IP_PDV_TEF = TEF.IP_PDV_TEF) AND ';
      SQL := SQL+' TEF.IP_PDV_TEF = '+QuotedStr(IP_PDV);
      DBST := DB.Prepare(SQL);
      while DBST.Step = SQLITE_ROW do
      Begin
      DBRecords := 1;
      iRetorno := FinalizaTransacaoIdentificadaSiTef(0,0,
      PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_CUPOM_FISCAL',DBST)))),
      PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_DATA_FISCAL',DBST)))),
      PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_HORA_FISCAL',DBST)))),
      PAnsiChar(AnsiString(DBST.ColumnText(Dm.SQLiteGetField('COMP_DADOS_CONF',DBST)))));
      end;
      if (DBRecords > 0) then
      Begin
      iRetorno := Bematech_FI_CancelaCupom();
      if (Main.VerificaRetornoFuncaoImpressora( iRetorno, False ) ) then
      begin
      SQL := 'DELETE FROM TEF WHERE ID_PGTO_TEF = 1';
      DB.Execute(SQL);
      Resposta := '<HTML><HEAD><TITLE> CANCELA CUPOM </TITLE></HEAD>';
      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<br>CANCELAMENTO EFETUADO';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<tr>';
      Resposta := Resposta + '<td align="center"> <a href="/">Voltar Inicio</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';
      Resposta := Resposta + '</BODY></HTML>';
      Response.Content := Resposta;
      exit;
      end else
      Begin
      Resposta := '<HTML><HEAD><TITLE>ERRO IMPRESSORA </TITLE></HEAD>';
      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<br>INFORMAÇÃO:';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br>'+Main.cMSGPrinterErro+'<br><p>';
      Resposta := Resposta + '<td align="center"> <a href="/">Voltar Inicio</a> </td>';
      End;
      end;
      DBST.Reset;
      finally
      DB.Free;
      end;

      if (DBRecords = 0) then
      Dm.CreateDB;

      TIPO_PAGAMENTO := Request.ContentFields.Values['TIPO_PAGAMENTO'];

      if (TIPO_PAGAMENTO = '0') then
      Begin

      Resposta := '<HTML>';
      Resposta := Resposta + '<HEAD> <TITLE> PAGAMENTO CARRINHO </TITLE>';
      Resposta := Resposta + '<script>';
      Resposta := Resposta + 'function validaForm(form) { ';
      Resposta := Resposta + '   if (form.NRO_CAR.value.length > 0) {';
      Resposta := Resposta + '     return true;';
      //   Resposta := Resposta + ' }// ';
    { Resposta := Resposta + '   alert("Campo CARRINHO deve ter  um valor válido!");';
      Resposta := Resposta + '   return false;';
      //    Resposta := Resposta + ' }// ';
    { Resposta := Resposta + '</script>';
      Resposta := Resposta + '</HEAD>';

      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<form action="/SELECIONA_NRO_CAR" method="POST" onsubmit="return validaForm(this)" >';

      Resposta := Resposta + '<br>PAGAMENTO-PosTEF 1.0';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br><p>Digite Nro. Carrinho:';
      Resposta := Resposta + '<input type="text" size="4" name="NRO_CAR" value="" onsubmit="return validaForm(this)" > <br>';
      Resposta := Resposta + '<br>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<input type="submit" value="    Enviar ">';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '</form>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
      //Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';

      Resposta := Resposta + '</BODY></HTML>';


      End else if (TIPO_PAGAMENTO = '1') then
      Begin


      End else if (TIPO_PAGAMENTO = '2') then
      Begin

      Resposta := '<HTML>';
      Resposta := Resposta + '<HEAD> <TITLE> LOGIN ADMIN </TITLE>';
      Resposta := Resposta + '<script>';
      Resposta := Resposta + 'function validaForm(form) { ';
      Resposta := Resposta + '   if (form.PWD.value.length > 0) {';
      Resposta := Resposta + '     return true;';
      //    Resposta := Resposta + ' }// ';
    // Resposta := Resposta + '   alert("A Senha deve ser informado!");';
    // Resposta := Resposta + '   return false;';
    // Resposta := Resposta + '}';
    { Resposta := Resposta + '</script>';
      Resposta := Resposta + '</HEAD>';

      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<form action="/RETORNO_ADM_SITEF" method="SITEF" onsubmit="return validaForm(this)" >';
      Resposta := Resposta +
      '<input type="hidden" size="9"  name="TIPO_TRN" value="2">';


      Resposta := Resposta + '<br>LOGIN ADMINISTRATIVO';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br><p>';
      //Resposta := Resposta + '<br>Informe Código:';
      Resposta := Resposta +
      '<input type="text" size="6" name="PWD" value="Continua...." onsubmit="return validaForm(this)" > <br>';
      Resposta := Resposta + '<br>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<input type="submit" value="    Entrar ">';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '</form>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<tr><p>';
      Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
      //Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';
      Resposta := Resposta + '</BODY></HTML>';


      End else if (TIPO_PAGAMENTO = '3') then
      Begin

      Resposta := '<HTML>';
      Resposta := Resposta + '<HEAD> <TITLE> MENU FISCAL </TITLE>';
      Resposta := Resposta + '</HEAD>';

      Resposta := Resposta + '<BODY>';
      Resposta := Resposta + '<form action="/MENU_FISCAL_FUNC" method="POST">';
      Resposta := Resposta + '<br>MENU FISCAL';
      Resposta := Resposta + '<br>---------------------';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<select name="TIPO_FUNC_MENU">';
      Resposta := Resposta + '<option value="1">Leitura X</option>';
      Resposta := Resposta + '<option value="2">Redução Z</option>';
      Resposta := Resposta + '</select>';
      Resposta := Resposta + '<br>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<input type="submit" value="    Enviar ">';
      Resposta := Resposta + '<br><p>';


      Resposta := Resposta + '</form>';

      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<br><p>';
      Resposta := Resposta + '<table border="0">';
      Resposta := Resposta + '<tr><p>';
      Resposta := Resposta + '<td align="left"> <a href="/">Voltar</a> </td>';
      //Resposta := Resposta + '<td align="left"> <a href="/">Ajuda</a> </td>';
      Resposta := Resposta + '</tr>';
      Resposta := Resposta + '</table>';
      Resposta := Resposta + '</BODY></HTML>';


      End;
    }

  end;

  {
    var
    NRO_CAR : String;
    begin
    NRO_CAR := Request.ContentFields.Values['NRO_CAR'];
    if (NRO_CAR <> '') then
    Begin
    Resposta := '           <HTML><HEAD>';
    Resposta := Resposta + '<TITLE>PROCESSA CARRINHO</TITLE>';
    Resposta := Resposta + '<script>';
    Resposta := Resposta + '  function validaForm(form) {';
    Resposta := Resposta + '    if (form.VALOR.value.length == 0) {';
    Resposta := Resposta + '      alert("Campo [VALOR] deve ter um valor!");';
    Resposta := Resposta + '      return true;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '    return false;';
    Resposta := Resposta + ' }// ';
  { Resposta := Resposta + '</script>';

    Resposta := Resposta + '</HEAD>';
    Resposta := Resposta + '<BODY>';

    Resposta := Resposta + '<form action="/CONFIRMA_PGTO_CAR" method="POST" >';
    // onsubmit="return validaForm(this)"
    with Dm.SPConsUm do
    Begin
    Close;
    StoredProcName := '';
    StoredProcName := 'sp_pdv_carrinho_busca';
    ParamByName('@numero_carrinho').AsString := NRO_CAR;
    Open;
    if (Fields[0].AsInteger = 1) then
    Begin
    beep;
    End
    else
    Begin
    beep;
    end;
    End;
    if (not Dm.SPConsUm.Eof) then
    Begin

    Resposta := Resposta + '<br>PROCESSA PAGAMENTO:';
    Resposta := Resposta + '<br>-------------------';
    Resposta := Resposta + '<br>Carrinho.:'+Dm.SPConsUm.FieldByName('Numero_Carrinho').AsString;
    Resposta := Resposta + '<br>Valor....:'+Padr(FormatFloat(',0.00',Dm.SPConsUm.FieldByName('valor').AsFloat), 11);
    Resposta := Resposta + '<br>Vendedor.:'+Dm.SPConsUm.FieldByName('NomeFuncionario').AsString;
    Resposta := Resposta + '<br>Matrícula:'+Dm.SPConsUm.FieldByName('matriculafuncionario').AsString;

    Resposta := Resposta +
    '<input type="hidden" size="50" name="NRO_CAR" value="' + Dm.SPConsUm.FieldByName('Numero_Carrinho').AsString + '">';

    Resposta := Resposta + '<p><br>CPF no Cupom Fiscal?:';
    Resposta := Resposta +
    '<input type="text" size="15" name="CPF" value=""> <br>';
    Resposta := Resposta + '<p><br>';
    Resposta := Resposta + '<input type="submit" value="   Enviar ">';
    Resposta := Resposta + '<input type="reset"  value="   Resetar ">';

    Resposta := Resposta + '<p><a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=0">Voltar</a>';

    End
    else
    Begin
    Resposta := Resposta + '<br>Nenhuma venda p/ este';
    Resposta := Resposta + '<br>carrinho agora!';
    Resposta := Resposta + '<br>';
    Resposta := Resposta + '<br>';
    Resposta := Resposta + '<p><a href="/SELECIONA_MENU_PRI?TIPO_PAGAMENTO=0">Voltar</a>';
    End;

    Resposta := Resposta + '</form>';
    Resposta := Resposta + '</BODY></HTML>';
    End;
    Response.Content := Resposta;

  }

end.
