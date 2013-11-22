unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  Data.DbxSqlite, Data.FMTBcd, Data.DB, Data.SqlExpr, Data.DBXMSSQL;

type
  TServerMethods1 = class(TDSServerModule)
  private
    { Private declarations }
    FMSGPrinterErro: String;

  public
    { Public declarations }
    iACK, iST1, iST2: Integer;
    // Variáveis com o retorno do Status da Impressora
    { Public declarations }
    property cMSGPrinterErro: String read FMSGPrinterErro write FMSGPrinterErro;

    function AbrirCupom(sCPF_CNPJ: String; NCaixa: Integer): Boolean;
    function VendeItem(pCodigo, pDescricao, pAliquota, pTipoQuantidade
      : AnsiString; pQuantidade, pCasasDecimais: Integer;
      pValorUnitario: Double): Boolean;

    function EfetuaFormaPagamento(pCodFormaPagto: Integer;
      pValorFormaPagamento: Double): Boolean;
    function IniciaFechamentoCupom(pAcrescimoDesconto, pTipoAcrescimoDesconto
      : AnsiString; pValorAcrescimoDesconto, pValorPago: Double): Boolean;
    function TerminaFechamentoCupom(pMensagem: AnsiString): Boolean;
    function CancelaCupom(pNCupom: String): Boolean;
    function CancelaItemGenerico(pNCupom, pItem: String): Boolean;

    function VerificaRetornoFuncaoImpressora(iRetorno: Integer): Boolean;
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

  end;

implementation

{$R *.dfm}

uses System.StrUtils, Bematech, Funcoes, UDataModulo;

function TServerMethods1.AbrirCupom(sCPF_CNPJ: String; NCaixa: Integer)
  : Boolean;
Var
  iRet, iConta: SmallInt;
  Data, Hora, DataHoraFormatada, NCupom, NSerie, CGC_Impressora,
    IE_Impressora: AnsiString;
  StringSQL: String;
begin
  for iConta := 1 to 6 do
    NCupom := NCupom + ' ';
  for iConta := 1 to 6 do
    Data := Data + ' ';
  for iConta := 1 to 6 do
    Hora := Hora + ' ';
  for iConta := 1 to 30 do
    NSerie := NSerie + ' ';
  for iConta := 1 to 15 do
    CGC_Impressora := CGC_Impressora + ' ';
  for iConta := 1 to 15 do
    IE_Impressora := IE_Impressora + ' ';
  iRet := Bematech_FI_DataHoraImpressora(Data, Hora);
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    DataHoraFormatada := '20' + Copy(Data, 5, 2) + // Ano
      '-' + Copy(Data, 3, 2) + // Mes
      '-' + Copy(Data, 1, 2) + // Dia
      ' ' + Copy(Hora, 1, 2) + // Hora
      ':' + Copy(Hora, 3, 2) + ':' + // Mim
      Copy(Hora, 4, 2); // Segundo
    iRet := Bematech_FI_AbreCupom(sCPF_CNPJ);
    if VerificaRetornoFuncaoImpressora(iRet) then
    Begin
      iRet := Bematech_FI_NumeroCupom(NCupom);
      if VerificaRetornoFuncaoImpressora(iRet) then
      Begin
        iRet := Bematech_FI_NumeroSerie(NSerie);
        if VerificaRetornoFuncaoImpressora(iRet) then
        Begin
          iRet := Bematech_FI_CGC_IE(CGC_Impressora, IE_Impressora);
          if VerificaRetornoFuncaoImpressora(iRet) then
          Begin
            try
              {
                id_parte               INTEGER        PRIMARY KEY,
                Data_Hora_Cupom         DATETIME       NOT NULL,
                NCupom                  VARCHAR( 10 ),
                NSerie                  VARCHAR( 30 ),
                CNPJ_Impressora         VARCHAR( 15 ),
                IE_Impressora           VARCHAR( 15 ),
                CNPJ_CPF_Consumidor     VARCHAR( 15 ),
                PDVNumeroCaixaAtendente INTEGER
              }
              StringSQL :=
                'INSERT INTO cupom_fiscal_parte1 (Data_Hora_Cupom,NCupom, NSerie, IE_Impressora, CNPJ_Impressora, CNPJ_CPF_Consumidor, PDVNumeroCaixaAtendente) VALUES (';
              StringSQL := StringSQL + QuotedStr(DataHoraFormatada) + ',' +
                QuotedStr(NCupom) + ',' + QuotedStr(Trim(NSerie)) + ',' +
                QuotedStr(IE_Impressora) + ',' + QuotedStr(CGC_Impressora) + ','
                + QuotedStr(sCPF_CNPJ) + ',' + NCaixa.ToString() + ')';
              Dm.SQLQry1.Close;
              Dm.SQLQry1.SQL.Clear;
              Dm.SQLQry1.SQL.Text := StringSQL;
              Dm.SQLQry1.ExecSQL();
            finally
              Result := True;
            end;
          End;
        End;
      End;
    End;
  End;
end;

function TServerMethods1.VendeItem(pCodigo, pDescricao, pAliquota,
  pTipoQuantidade: AnsiString; pQuantidade, pCasasDecimais: Integer;
  pValorUnitario: Double): Boolean;
var
  iRet, iConta: SmallInt;
  DataHoraFormatada, NCupom, NSerie, Item: AnsiString;
  StringSQL: String;
begin
  { iRet :=  Bematech_FI_VendeItem(PAnsiChar(AnsiString('001')),
    'Caneta 2',
    '1700', 'I',
    PAnsiChar(AnsiString(IntToStr(1))), 2,
    PAnsiChar(AnsiString(FormatFloat(',0.00',2.5))), '%' ,
    PAnsiChar(AnsiString(FormatFloat(',0.00',0))));
  }
  iRet := Bematech_FI_VendeItem(PAnsiChar(AnsiString(pCodigo)), pDescricao,
    pAliquota, 'I', PAnsiChar(AnsiString(IntToStr(pQuantidade))),
    pCasasDecimais, PAnsiChar(AnsiString(FormatFloat(',0.00', pValorUnitario))),
    '%', PAnsiChar(AnsiString(FormatFloat(',0.00', 0))));
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    for iConta := 1 to 6 do
      Item := Item + ' ';
    Bematech_FI_UltimoItemVendido(Item);
    Try
      StringSQL :=
        'SELECT * FROM cupom_fiscal_parte1 WHERE id_parte = (SELECT MAX(id_parte) FROM  cupom_fiscal_parte1) and Status = 0';
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        {
          id_parte2         INTEGER        PRIMARY KEY ASC AUTOINCREMENT,
          Data_Hora_Cupom   DATETIME       NOT NULL,
          NCupom            VARCHAR( 10 )  NOT NULL,
          NSerie            VARCHAR( 30 )  NOT NULL,
          NItem             INTEGER,
          CodFamProduto     INTEGER,
          CodProduto        INTEGER,
          CodCaracteristica INTEGER,
          Quantidade        INTEGER,
          Valor_Unit        FLOAT,
          Valor_Desconto    FLOAT,
          Valor_Total       REAL( 15, 4 )
        }
        try
          StringSQL :=
            '            INSERT INTO cupom_fiscal_parte2 (id_parte, Data_Hora_Cupom, NCupom, ';
          StringSQL := StringSQL + ' NSerie, NItem, CodProduto, ';
          StringSQL := StringSQL +
            ' Quantidade,Valor_Unit,Valor_Desconto, Valor_Total) VALUES (';
          StringSQL := StringSQL + Dm.SQLQry1.FieldByName('id_parte')
            .AsString + ',';
          StringSQL := StringSQL +
            QuotedStr(Dm.SQLQry1.FieldByName('Data_Hora_Cupom').AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NCupom')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NSerie')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Trim(Item)) + ',';
          StringSQL := StringSQL + QuotedStr(Trim(pCodigo)) + ',';
          StringSQL := StringSQL + QuotedStr(pQuantidade.ToString()) + ',';
          StringSQL := StringSQL + FormataCurrSQL(pValorUnitario) + ',';
          StringSQL := StringSQL + QuotedStr('0') + ',';
          StringSQL := StringSQL + FormataCurrSQL
            ((pQuantidade * pValorUnitario)) + ')';

          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();
        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Cupom não aberto ou não encontrado!!!';
      End;
    finally
      Result := True;
    end;
  End;

end;

function TServerMethods1.EfetuaFormaPagamento(pCodFormaPagto: Integer;
  pValorFormaPagamento: Double): Boolean;
var
  iRet: SmallInt;
  StringSQL: String;
  Formapagto: Array [1 .. 2] of string;
begin
  Formapagto[1] := 'Dinheiro';
  Formapagto[2] := 'Cartao';

  iRet := Bematech_FI_EfetuaFormaPagamento(Formapagto[pCodFormaPagto],
    PAnsiChar(AnsiString(FormatFloat(',0.00', pValorFormaPagamento))));
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    try
      StringSQL :=
        'SELECT * FROM cupom_fiscal_parte1 WHERE id_parte = (SELECT MAX(id_parte) FROM  cupom_fiscal_parte1) and Status = 0';
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        {
          id_parte3          INTEGER        PRIMARY KEY AUTOINCREMENT,
          [Data_Hora_Cupom ] DATETIME       NOT NULL,
          NCupom             VARCHAR( 10 ),
          NSerie             VARCHAR( 30 )  NOT NULL,
          CodFormaPagto      INTEGER,
          Valor_Pago         FLOAT
        }
        try
          StringSQL :=
            '            INSERT INTO cupom_fiscal_parte3 (id_parte, Data_Hora_Cupom, NCupom, NSerie, ';
          StringSQL := StringSQL + ' CodFormaPagto,Valor_Pago) VALUES (';
          StringSQL := StringSQL + Dm.SQLQry1.FieldByName('id_parte')
            .AsString + ',';
          StringSQL := StringSQL +
            QuotedStr(Dm.SQLQry1.FieldByName('Data_Hora_Cupom').AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NCupom')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NSerie')
            .AsString) + ',';
          StringSQL := StringSQL + pCodFormaPagto.ToString() + ',';
          StringSQL := StringSQL + FormataCurrSQL(pValorFormaPagamento);
          StringSQL := StringSQL + ')';
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();
        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Forma de pagamento não Efetuada!!!';
      End;
    finally
      Result := True;
    end;
  End;
end;

function TServerMethods1.IniciaFechamentoCupom(pAcrescimoDesconto,
  pTipoAcrescimoDesconto: AnsiString; pValorAcrescimoDesconto,
  pValorPago: Double): Boolean;
var
  iRet: SmallInt;
  StringSQL: String;
begin
  iRet := Bematech_FI_IniciaFechamentoCupom(pAcrescimoDesconto,
    pTipoAcrescimoDesconto, PAnsiChar(AnsiString(FormatFloat(',0.00',
    pValorAcrescimoDesconto))));
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    try
      StringSQL :=
        'SELECT * FROM cupom_fiscal_parte1 WHERE id_parte = (SELECT MAX(id_parte) FROM  cupom_fiscal_parte1) and Status = 0';
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        {
          id_parte4       INTEGER        PRIMARY KEY ASC AUTOINCREMENT,
          Data_Hora_Cupom DATETIME       NOT NULL,
          NCupom          VARCHAR( 10 )  NOT NULL,
          NSerie          VARCHAR( 30 )  NOT NULL,
          Total_Pago      FLOAT
        }
        try
          StringSQL :=
            '            INSERT INTO cupom_fiscal_parte4 (id_parte, Data_Hora_Cupom,NCupom, ';
          StringSQL := StringSQL + ' NSerie,Total_Pago) VALUES (';
          StringSQL := StringSQL + Dm.SQLQry1.FieldByName('id_parte')
            .AsString + ',';
          StringSQL := StringSQL +
            QuotedStr(Dm.SQLQry1.FieldByName('Data_Hora_Cupom').AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NCupom')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NSerie')
            .AsString) + ',';
          StringSQL := StringSQL + FormataCurrSQL(pValorPago);;
          StringSQL := StringSQL + ')';
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();
        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Fechamendo de cupom fiscal não iniciado!!!';
      End;
    finally
      Result := True;
    end;
  End;
end;

function TServerMethods1.TerminaFechamentoCupom(pMensagem: AnsiString): Boolean;
var
  iRet: SmallInt;
  StringSQL, id_parte: String;
begin
  iRet := Bematech_FI_TerminaFechamentoCupom(pMensagem);
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    try
      StringSQL :=
        'SELECT * FROM cupom_fiscal_parte1 WHERE id_parte = (SELECT MAX(id_parte) FROM  cupom_fiscal_parte1) and Status = 0';
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        id_parte := Dm.SQLQry1.FieldByName('id_parte').AsString;
        {
          id_parte4       INTEGER         PRIMARY KEY ASC AUTOINCREMENT,
          Data_Hora_Cupom DATETIME( 20 )  NOT NULL,
          NCupom          VARCHAR( 10 )   NOT NULL,
          NSerie          VARCHAR( 30 )   NOT NULL,
          Status          INT
        }
        try
          StringSQL :=
            '            INSERT INTO cupom_fiscal_status (id_parte, Data_Hora_Cupom,NCupom,NSerie, Status) ';
          StringSQL := StringSQL + ' VALUES (';
          StringSQL := StringSQL + Dm.SQLQry1.FieldByName('id_parte')
            .AsString + ',';
          StringSQL := StringSQL +
            QuotedStr(Dm.SQLQry1.FieldByName('Data_Hora_Cupom').AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NCupom')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NSerie')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr('1');
          StringSQL := StringSQL + ')';
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();

          StringSQL := '            UPDATE cupom_fiscal_parte1 SET Status = 1 ';
          StringSQL := StringSQL + ' WHERE id_parte = ' + id_parte;
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();

        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Cupom não Encontrado!!!';
      End;
    finally
      Result := True;
    end;
  End;
end;

function TServerMethods1.CancelaCupom(pNCupom: String): Boolean;
var
  iRet: SmallInt;
  StringSQL: String;
begin
  iRet := Bematech_FI_CancelaCupom();
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    try
      StringSQL := 'SELECT * FROM cupom_fiscal_parte1 WHERE NCupom =' +
        QuotedStr(pNCupom) +
        ' and id_parte = (SELECT MAX(id_parte1) FROM  cupom_fiscal_parte1) and Status = 0';
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        {
          id_parte       INTEGER         PRIMARY KEY ASC AUTOINCREMENT,
          Data_Hora_Cupom DATETIME( 20 )  NOT NULL,
          NCupom          VARCHAR( 10 )   NOT NULL,
          NSerie          VARCHAR( 30 )   NOT NULL,
          Status          INT
        }
        try
          StringSQL :=
            '            INSERT INTO cupom_fiscal_status (Data_Hora_Cupom,NCupom, ';
          StringSQL := StringSQL + ' Status) VALUES (';
          StringSQL := StringSQL +
            QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS',
            Dm.SQLQry1.FieldByName('Data_Hora_Cupom').AsDateTime)) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NCupom')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr(Dm.SQLQry1.FieldByName('NSerie')
            .AsString) + ',';
          StringSQL := StringSQL + QuotedStr('2') + ','; // 2=Cupom cancelado.
          StringSQL := StringSQL + ')';
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();

          StringSQL := '            UPDATE cupom_fiscal_parte1 SET Status = 2 ';
          StringSQL := StringSQL + ' WHERE id_parte = ' + Dm.SQLQry1.FieldByName
            ('id_parte').AsString;
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();

        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Cupom não Terminado!!!';
      End;
    finally
      Result := True;
    end;
  End;

end;

function TServerMethods1.CancelaItemGenerico(pNCupom, pItem: String): Boolean;
var
  iRet: SmallInt;
  StringSQL: String;
Begin
  iRet := Bematech_FI_CancelaItemGenerico(pItem);
  if VerificaRetornoFuncaoImpressora(iRet) then
  Begin
    try
      StringSQL := 'SELECT * FROM cupom_fiscal_parte2 WHERE pNCupom = ' +
        QuotedStr(pNCupom) + ' and NItem = ' + QuotedStr(pItem) +
        ' and Status = 1'; // Status=1 => Processado
      Dm.SQLQry1.Close;
      Dm.SQLQry1.SQL.Clear;
      Dm.SQLQry1.SQL.Text := StringSQL;
      Dm.SQLQry1.Open;
      if (not Dm.SQLQry1.Eof) then
      Begin
        {
          id_parte       INTEGER         PRIMARY KEY ASC AUTOINCREMENT,
          Data_Hora_Cupom DATETIME( 20 )  NOT NULL,
          NCupom          VARCHAR( 10 )   NOT NULL,
          NSerie          VARCHAR( 30 )   NOT NULL,
          Status          INT
        }
        try
          StringSQL :=
            '             UPDATE cupom_fiscal_parte2 SET Status = 2 ';
          StringSQL := StringSQL + '  WHERE pNCupom =' + QuotedStr(pNCupom) +
            ' and NItem =' + QuotedStr(pItem) + ' and Status = 0';
          Dm.SQLQry1.Close;
          Dm.SQLQry1.SQL.Clear;
          Dm.SQLQry1.SQL.Text := StringSQL;
          Dm.SQLQry1.ExecSQL();

        finally
          Result := True;
        end;
      End
      else
      Begin
        FMSGPrinterErro := 'Item cupom não encontrado!!!';
      End;
    finally
      Result := True;
    end;
  End;

end;

function TServerMethods1.VerificaRetornoFuncaoImpressora
  (iRetorno: Integer): Boolean;
Var
  IRetLigada: Integer;
begin
  cMSGPrinterErro := '';
  Result := False;
  // iRetorno := Bematech_FI_VerificaImpressoraLigada();
  case iRetorno of
    0:
      cMSGPrinterErro := 'Erro de Comunicação!' + #10 + #13 +
        'A impressora pode esta desligada ';
    -1:
      cMSGPrinterErro := 'Erro de execução na Função ! ';
    -2:
      cMSGPrinterErro := 'Parâmetro inválido na Função ! ';
    -3:
      cMSGPrinterErro := 'Alíquota não Programada ! ';
    -4:
      cMSGPrinterErro := 'Arquivo BEMAFI32.INI não Encontrado ! ';
    -5:
      cMSGPrinterErro := 'Erro ao abrir a Porta de Comunicação ! ';
    -6:
      cMSGPrinterErro :=
        'Impressora Desligada ou Cabo de Comunicação Desconectado! ';
    -7:
      cMSGPrinterErro :=
        'Código do Banco não encontrado no arquivo BEMAFI32.INI ! ';
    -8:
      cMSGPrinterErro := 'Erro ao criar arquivo STATUS.TXT ou RETORNO.TXT! ';
    -24:
      cMSGPrinterErro := 'Forma de pagamento não programada. ';
    -25:
      cMSGPrinterErro := 'Totalizador não fiscal não programado. ';
    -26:
      cMSGPrinterErro := 'Transação já Efetuada. ';
    -27:
      cMSGPrinterErro := 'Status diferente de 6, 0, 0 ! ';
    -28:
      cMSGPrinterErro := 'Não há Informações para serem Impressas! ';
    -30:
      cMSGPrinterErro := 'Função incompatível com a impressora fiscal YANCO ! ';
  end;
  if (cMSGPrinterErro <> '') then
  begin
    Result := False;
    exit;
  end;
  cMSGPrinterErro := '';
  if (iRetorno = 1) then
  begin
    Bematech_FI_RetornoImpressora(iACK, iST1, iST2);
    if ((iACK = 21)) then
    begin
      cMSGPrinterErro := 'A Impressora retornou NAK ! ' + #13 +
        'Erro de Protocolo de Comunicação ! ';
      // MainServerPos.MemoLogStatus.Lines.Add(cMSGPrinterErro);
      Result := False;
    end
    {
      else  if ( (iACK = 6)) then
      begin
      //Application.MessageBox( 'A Impressora retornou NAK !' + #13 +
      //   'Problemas ao Enviar Comando !', 'Atenção', MB_IconError +
      //   MB_OK );
      result := True;
      end
    }
    else

      if (iST1 <> 0) or (iST2 <> 0) then
    begin
      // Analisa ST1
      if (iST1 >= 128) then
      begin
        iST1 := iST1 - 128;
        cMSGPrinterErro := cMSGPrinterErro + ' Fim de Papel ' + #13;
      end;
      if (iST1 >= 64) then
      begin
        iST1 := iST1 - 64;
        cMSGPrinterErro := cMSGPrinterErro + ' Pouco Papel ' + #13;
        Result := True;
        exit;
      end;
      if (iST1 >= 32) then
      begin
        iST1 := iST1 - 32;
        cMSGPrinterErro := cMSGPrinterErro + ' Erro no Relógio ' + #13;
      end;
      if (iST1 >= 16) then
      begin
        iST1 := iST1 - 16;
        cMSGPrinterErro := cMSGPrinterErro + ' Impressora em Erro ' + #13;
      end;
      if (iST1 >= 8) then
      begin
        iST1 := iST1 - 8;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Primeiro Dado do Comando não foi ESC' + #13;
      end;
      if iST1 >= 4 then
      begin
        iST1 := iST1 - 4;
        cMSGPrinterErro := cMSGPrinterErro + ' Comando Inexistente ' + #13;
      end;
      if iST1 >= 2 then
      begin
        iST1 := iST1 - 2;
        cMSGPrinterErro := cMSGPrinterErro + ' Cupom Fiscal Aberto ' + #13;
      end;
      if iST1 >= 1 then
      begin
        iST1 := iST1 - 1;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Número de Parâmetros Inválidos ' + #13;
      end;

      // Analisa ST2
      if iST2 >= 128 then
      begin
        iST2 := iST2 - 128;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Tipo de Parâmetro de Comando Inválido ' + #13;
      end;
      if iST2 >= 64 then
      begin
        iST2 := iST2 - 64;
        cMSGPrinterErro := cMSGPrinterErro + ' Memória Fiscal Lotada ' + #13;
      end;
      if iST2 >= 32 then
      begin
        iST2 := iST2 - 32;
        cMSGPrinterErro := cMSGPrinterErro + ' Erro na CMOS ' + #13;
      end;
      if iST2 >= 16 then
      begin
        iST2 := iST2 - 16;
        cMSGPrinterErro := cMSGPrinterErro + ' Alíquota não Programada ' + #13;
      end;
      if iST2 >= 8 then
      begin
        iST2 := iST2 - 8;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Capacidade de Alíquota Programáveis Lotada ' + #13;
      end;
      if iST2 >= 4 then
      begin
        iST2 := iST2 - 4;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Cancelamento não permitido ' + #13;
      end;
      if iST2 >= 2 then
      begin
        iST2 := iST2 - 2;
        cMSGPrinterErro := cMSGPrinterErro +
          ' CGC/IE do Proprietário não Programados ' + #13;
      end;
      if iST2 >= 1 then
      begin
        iST2 := iST2 - 1;
        cMSGPrinterErro := cMSGPrinterErro +
          ' Comando não executado, Verifique por favor!!! ' + #13;
      end;
      if (cMSGPrinterErro <> '') then
        Result := False;
    end
    else
      Result := True;
  end;
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

end.
