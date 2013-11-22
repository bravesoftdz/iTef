{ ******************************************************* }
{ }
{ Delphi Runtime Library }
{ Windows Messages and Types }
{ }
{ ******************************************************* }

unit Funcoes;

interface

uses
  Printers, Graphics, Windows, Dialogs, Messages, SysUtils, Classes, Controls,
  StdCtrls, Mask,
  WinSock, wininet, Urlmon, Registry, Forms;

function ArredontaFloat(x: Real): Real;
function RoundNum(Valor: Extended; Decimais: Integer): Extended;
function Gerapercentual(Valor: Real; Percent: Real): Real;
function IntToBin(Value: LongInt; Size: Integer): string;
function BinToInt(Value: string): LongInt;
function DecToBase(Decimal: LongInt; const Base: Byte): string;
function Base10(Base2: Integer): Integer; assembler;
function DecToBinStr(n: Integer): string;
function DecToRoman(Decimal: LongInt): string;
function NumToHex(Num: Word): string;
function Min(A, B: Integer): Integer;
function Max(A, B: Integer): Integer;
function IntPrime(Value: Integer): Boolean;
function strByteSize(Value: LongInt): string;
function StrToReal(inString: string): Real;
function BuscaDireita(Busca, Text: string): Integer;
function BuscaTroca(Text, Busca, Troca: string): string;
function RemoveMaskEdit(Str, Masks: string): string;
function ContaCaracs(Edit: string): Integer;
function Empty(inString: string): Boolean;
function LTrim(Texto: string): string;
function Maiuscula(Texto: string): string;
function Padr(s: string; n: Integer): string;
function RemoveAcentos(Str: string): string;
function Replicate(Caracter: string; Quant: Integer): string;
function RTrim(Texto: string): string;

function Strs(I: LongInt): string;
function StrToPChar(const Str: string): PChar;
function Alltrim(const Search: string): string;
function StrZero(Zeros: string; Quant: Integer): string;
function StrZerodec(Numero: Double; Total, Decimal: Integer): string;
function Padl(s: string; n: Integer): string;
function wordcount(Str: string): Integer;
function LineIsEmpty(Text: string): Boolean;
function PadC(s: string; Len: Byte): string;
function FullFill(Str: string; FLen: Byte; symb: char): string;
function Before(const Search, Find: string): string;
function after(const Search, Find: string): string;
function MaskString(Valor: string): string;
function Encrypt(Senha: string): string;
function ExisteInt(Texto: string): Boolean;
function Crypt(Action, Src, Key: string): string;
function CalculaModulo10(Numero: string): string;
function CalculaCnpjCpf(Numero: string): String;
// Valores Extensos
function DataExtenso(pCidade: string; Data: TDateTime): string;
function Extenso(literal: Double): string;

procedure AngleTextOut(CV: TCanvas; const sText: string;
  x, y, angle, Size: Integer);
function FormataDataRef(DataRef: string): string;
function FormataCPF(CPF: string): string;
function FormataCNPJ(CNPJ: string): string;
function IsPrinter: Boolean;
function BuscaStr(Text, Busca: string): Boolean;
function BuscaTrocaStr(Text, Busca, Troca: string): string;
function ConnectionNet: Boolean;
function IncrementaSerial(numInicial: string; qtd: Integer): string;
function IncrementaSerialUm(numInicial: string): string;
// Exemplo e configurações
// Para usar esta function é preciso declarar Urlmon na seção uses da unit.Depois basta fazer uma chamada padrão:
// if DownloadFile('http://www.onde.com/arq.htm', 'c:\arq.htm')
// then ...
function DownloadFile(Source, Dest: string): Boolean;
function GetRegistryValue(KeyName, Valor: string): string;
function Criptografia(mStr, mChave: string): string;
function DiskInDrive(const Drive: char): Boolean;

// procedure Delay(iMSecs: Integer);
function DiaUtilAnterior(dData: TDateTime): TDateTime;
function ProximoDiaUtil(dData: TDateTime): TDateTime;
function PrinterOnLine: Boolean;
function ConvertStrToCurr(Valor: string): Currency;
function VersaoDoSistema: string;
function AbreviaNome(Nome: string): string;
function FormataCurr(Vlr: Double): string;
function TruncValor(StrVlr: string): Currency;
function StrBranco(Zeros: string; Quant: Integer): string;
function Get_File_Size(sFileToExamine: string; bInKBytes: Boolean): string;
function Get_File_Size2(sFileToExamine: string; bInKBytes: Boolean): string;
function DigitoVerificadorPreviSaude(Str: string): string;
function FormataCurrSQL(Valor: Currency): string;
function FormataCurrSQLTEF(Valor: String): string;
function ExDizima(ValorString: string): string;
function ValidaCPF(const s: string): Boolean;
function ValidaCnpj(xCNPJ: String): Boolean;

function FloatToStrValid(aValue: Extended): string;

function SegundosToTime(Segundos: Cardinal): String;

function JustificaTexto(const texto: TStringList; Colunas: integer): TStringList;

function FormatStringToSQLiteDouble(Text : String) : String;
function IsNumeric(s: String) : Boolean;


function BreakApart(BaseString, BreakString: string): TStringList;




implementation

uses StrUtils;


function BreakApart(BaseString, BreakString: string): TStringList;
var
  EndOfCurrentString: integer;
begin
  Result := TStringList.Create;
  Result.Clear;
  repeat
    EndOfCurrentString := Pos(BreakString, BaseString);
    if EndOfCurrentString = 0 then
      Result.Add(BaseString)
    else
      Result.Add(Copy(BaseString, 1, EndOfCurrentString - 1));
    if EndOfCurrentString > 0 then
      BaseString := Copy(BaseString,EndOfCurrentString +length(BreakString), length(BaseString) - EndOfCurrentString);
  until EndOfCurrentString = 0;
end;

function IsNumeric(s: String) : Boolean;
VAR
  Code: Integer;
  Value: Double;
BEGIN
  val(s, Value, Code);
  Result := (Code = 0)
END;



function FormatStringToSQLiteDouble(Text : String) : String;
Begin
  Result := BuscaTroca(BuscaTroca(Text,'.',''),',','.');
End;

function JustificaTexto(const texto: TStringList; Colunas: integer): TStringList;
var
  Tamanho, x, y, z: Integer;
  Lista: TStringList;
  LinhaCompleta, Inicio, Resto: String;
begin
  Lista := TStringList.Create;
  for x := 0 to Texto.Count - 1 do
  begin
    // Substitui tab por tres espaços
    while Pos(''#9'', Texto.Strings[x]) > 0 do
    Texto.Strings[x] := Copy(Texto.Strings[x], 1,
    Pos(''#9'', Texto.Strings[x]) - 1) +' ' + Copy(Texto.Strings[x], Pos(''#9'', Texto.Strings[x]) + 1,
    Length(Texto.Strings[x]));
    // a última coluna é um espaço
    if Length(TrimRight(Texto.Strings[x])) <= Colunas then
    Lista.Add(TrimRight(Texto.Strings[x]))
  else
  begin
    if Copy(Texto.Strings[x], 1, Colunas + 1) = ' ' then
    Lista.Add(Copy(Texto.Strings[x], 1, Colunas))
  else
  begin
    LinhaCompleta := Texto.Strings[x];
    y := Colunas;
  while (LinhaCompleta <> '') do
  begin
    for y := Colunas downto 1 do
    begin
      Inicio := Copy(LinhaCompleta, 1, y);
      Resto := Copy(LinhaCompleta, y + 1, Length(LinhaCompleta));
      if (Inicio= '') then
        break
      else if Length(TrimRight(LinhaCompleta)) <= Colunas then
      begin
        Lista.Add(TrimRight(Inicio));
        LinhaCompleta := '';
        break;
      end
      else if (Inicio[y] = ' ') then
      begin
      if Inicio <> '' then
      begin
        Inicio := TrimRight(Inicio);
        // justifica o texto
        while Length(Inicio) < Colunas do
        begin
          if Inicio = '' then break;
          Tamanho := Length(Inicio);
          for z := Tamanho downto 1 do
          begin
            if inicio[z] = ' ' then
            begin
              Inicio := (Copy(Inicio, 1, z) + ' ' +
              Copy(Inicio, z + 1, Length(Inicio)));
              if (Length(Inicio) = Colunas) then break;
            end
            else if (Pos(' ', Inicio) = 0)then
            begin
              Lista.Add(TrimRight(Inicio));
              Inicio := '';
              break;
            end;
          end;
      end;
      Lista.Add(TrimRight(Inicio));
      LinhaCompleta := Resto;
      break;
    end
    else
      Break;
    end;
  end;
  if LinhaCompleta <> Resto then
    LinhaCompleta := Resto;
end;
end;
end;
end;
Result := Lista;
end;


function SegundosToTime(Segundos: Cardinal): String;
var
  Seg, Min, Hora: Cardinal;
begin
  Hora := Segundos div 3600;
  Seg := Segundos mod 3600;
  Min := Seg div 60;
  Seg := Seg mod 60;

  Result := FormatFloat(',00', Hora) + ':' + FormatFloat('00', Min) + ':' +
    FormatFloat('00', Seg);
end;

function FloatToStrValid(aValue: Extended): string;
var
  fs: TFormatSettings;
begin
  GetLocaleFormatSettings(LCID_INSTALLED, fs);
  fs.ThousandSeparator := ',';
  fs.DecimalSeparator := '.';
  Result := FloatToStr(aValue, fs);
end;

function ValidaCPF(const s: string): Boolean;
var
  I, Numero, Resto: Byte;
  DV1, DV2: Byte;
  Total, Soma: Integer;
Begin
  Result := false;
  if length(Trim(s)) = 11 then
  begin
    Total := 0;
    Soma := 0;
    for I := 1 to 9 do
    Begin
      Try
        Numero := StrToInt(s[I]);
      Except
        Numero := 0;
      end;
      Total := Total + (Numero * (11 - I));
      Soma := Soma + Numero;
    end;
    Resto := Total mod 11;
    if Resto > 1 then
      DV1 := 11 - Resto
    else
      DV1 := 0;
    Total := Total + Soma + 2 * DV1;
    Resto := Total mod 11;
    if Resto > 1 then
      DV2 := 11 - Resto
    else
      DV2 := 0;
    if (IntToStr(DV1) = s[10]) and (IntToStr(DV2) = s[11]) then
      Result := true;
  end;
end;

function ValidaCnpj(xCNPJ: String): Boolean;
Var
  d1, d4, xx, nCount, fator, Resto, digito1, digito2: Integer;
  Check: String;
begin
  xCNPJ := Trim(xCNPJ);
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to length(xCNPJ) - 2 do
  begin
    if Pos(Copy(xCNPJ, nCount, 1), '/-.') = 0 then
    begin
      if xx < 5 then
      begin
        fator := 6 - xx;
      end
      else
      begin
        fator := 14 - xx;
      end;
      d1 := d1 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      if xx < 6 then
      begin
        fator := 7 - xx;
      end
      else
      begin
        fator := 15 - xx;
      end;
      d4 := d4 + StrToInt(Copy(xCNPJ, nCount, 1)) * fator;
      xx := xx + 1;
    end;
  end;
  Resto := (d1 mod 11);
  if Resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - Resto;
  end;
  d4 := d4 + 2 * digito1;
  Resto := (d4 mod 11);
  if Resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - Resto;
  end;
  Check := IntToStr(digito1) + IntToStr(digito2);
  if Check <> Copy(xCNPJ, succ(length(xCNPJ) - 2), 2) then
  begin
    Result := false;
  end
  else
  begin
    Result := true;
  end;
end;

function FormataCurrSQL(Valor: Currency): string;
begin
  Result := BuscaTroca(BuscaTroca(FormatFloat(',0.00', Valor), '.', ''),',', '.');
end;

function FormataCurrSQLTEF(Valor: String): string;
Var ValorString : String;
begin
  if (length(Valor) <= 2) then
    ValorString := '0.'+Valor
  else
    ValorString := Copy(Valor,1,length(Valor)-2) +'.'+ Copy(Valor,length(Valor)-1,2);
  Result := ValorString;
end;

function DigitoVerificadorPreviSaude(Str: string): string;
var
  I, calc: Integer;
  DV: Double;

begin
  calc := 0;
  for I := 1 to length(Str) do
  begin
    calc := calc + StrToInt(Copy(Str, I, 1));
  end;
  DV := (calc / 11);
  Result := Copy(FloatToStr(DV), 1, 1);
end;

function Get_File_Size2(sFileToExamine: string; bInKBytes: Boolean): string;
var
  SearchRec: TSearchRec;
  sgPath: string;
  inRetval, I1: Integer;
begin
  sgPath := ExpandFileName(sFileToExamine);
  try
    inRetval := FindFirst(ExpandFileName(sFileToExamine), faAnyFile, SearchRec);
    if inRetval = 0 then
      I1 := SearchRec.Size
    else
      I1 := -1;
  finally
    SysUtils.FindClose(SearchRec);
  end;
  Result := IntToStr(I1);
end;

function Get_File_Size(sFileToExamine: string; bInKBytes: Boolean): string;
var
  FileHandle: THandle;
  FileSize: LongWord;
  d1: Double;
  I1: Int64;
begin
  // a- Get file size
  FileHandle := CreateFile(PChar(sFileToExamine), GENERIC_READ, 0, { exclusive }
    nil, { security }
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  FileSize := GetFileSize(FileHandle, nil);
  Result := IntToStr(FileSize);
  CloseHandle(FileHandle);
  // a- optionally report back in Kbytes
  if bInKBytes = true then
  begin
    if length(Result) > 3 then
    begin
      Insert(',', Result, length(Result) - 2);
      d1 := StrToFloat(Result);
      Result := IntToStr(round(d1));
    end
    else
      Result := '1';
  end;
end;

function TruncValor(StrVlr: string): Currency;
begin
  StrVlr := Trim(StrVlr);
  StrVlr := Copy(StrVlr, 1, (length(StrVlr) - 2)) + ',' + RightStr(StrVlr, 2);
  Result := StrToFloat(StrVlr);
end;

function FormataCurr(Vlr: Double): string;
begin
  Result := BuscaTroca(FormatFloat(',0.00', Vlr), '.', '');
  Result := Result + BuscaTroca(Result, ',', '.');
end;


// A função Criptografia pode ser usada para criptografar a senha acesso ao sistema.
// Ela é usada nos dois sentidos, para criptografar e descriptografar, desde que seja usada
// a mesma chave nas duas operações. "mStr" é a String que vai ser criptografada e "mChave"
// é a String que sera usada como base para fazer a criptografia.


// função que abrevia o nome

function AbreviaNome(Nome: string): string;
var
  Nomes: array [1 .. 20] of string;
  I, TotalNomes: Integer;
begin
  Nome := Trim(Nome);
  Result := Nome;
  Nome := Nome + #32;
  I := Pos(#32, Nome);
  if I > 0 then
  begin
    TotalNomes := 0;
    { Separa todos os nomes }
    while I > 0 do
    begin
      Inc(TotalNomes);
      Nomes[TotalNomes] := Copy(Nome, 1, I - 1);
      Delete(Nome, 1, I);
      I := Pos(#32, Nome);
    end;
    if TotalNomes > 2 then
    begin
      { Abreviar a partir do segundo nome, exceto o último. }
      for I := 2 to TotalNomes - 1 do
      begin
        { Contém mais de 3 letras? (ignorar de, da, das, do, dos, etc.) }
        if length(Nomes[I]) > 3 then
          { Pega apenas a primeira letra do nome e coloca um ponto após. }
          Nomes[I] := Nomes[I][1] + '.';
      end;
      Result := '';
      for I := 1 to TotalNomes do
        Result := Result + Trim(Nomes[I]) + #32;
      Result := Trim(Result);
    end;
  end;
end;

function Criptografia(mStr, mChave: string): string;
var
  I, TamanhoString, Pos, PosLetra, TamanhoChave: Integer;
begin
  Result := mStr;
  TamanhoString := length(mStr);
  TamanhoChave := length(mChave);
  for I := 1 to TamanhoString do
  begin
    Pos := (I mod TamanhoChave);
    if Pos = 0 then
      Pos := TamanhoChave;
    PosLetra := ord(Result[I]) xor ord(mChave[Pos]);
    if PosLetra = 0 then
      PosLetra := ord(Result[I]);
    Result[I] := chr(PosLetra);
  end;
end;

// A função DiskInDrive retorna True se existe um disquete no drive "a".
// É ideal para ser usada antes de executar um comando de backup para um disquete.

function DiskInDrive(const Drive: char): Boolean;
var
  DrvNum: Byte;
  EMode: Word;
begin
  Result := false;
  DrvNum := ord(Drive);
  if DrvNum >= ord('a') then
    dec(DrvNum, $20);
  EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    if DiskSize(DrvNum - $40) <> -1 then
      Result := true
    else
      MessageBeep(0);
  finally
    SetErrorMode(EMode);
  end;
end;

function ConvertStrToCurr(Valor: string): Currency;
begin
  Result := StrToFloat(BuscaTroca(BuscaTroca(Valor, '.', ''), ',', '.'));
end;

function DataExtenso(pCidade: string; Data: TDateTime): string;
var
  Ano, Mes, Dia: Word;
  Mes1: string;
begin
  // Retorna a data por extenso
  DecodeDate(Data, Ano, Mes, Dia);
  case Mes of
    1:
      Mes1 := 'Janeiro';
    2:
      Mes1 := 'Fevereiro';
    3:
      Mes1 := 'Março';
    4:
      Mes1 := 'Abril';
    5:
      Mes1 := 'Maio';
    6:
      Mes1 := 'Junho';
    7:
      Mes1 := 'Julho';
    8:
      Mes1 := 'Agosto';
    9:
      Mes1 := 'Setembro';
    10:
      Mes1 := 'Outubro';
    11:
      Mes1 := 'Novembro';
    12:
      Mes1 := 'Dezembro';
  end;
  if (Dia = 1) then
    Result := IntToStr(Dia) + 'º de ' + Mes1 + ' de ' + IntToStr(Ano)
  else
  begin
    Result := IntToStr(Dia) + ' de ' + Mes1 + ' de ' + IntToStr(Ano);
  end;
  if Trim(pCidade) <> '' then
  begin
    Result := pCidade + ', ' + Result;
  end;
end;

function GetRegistryValue(KeyName, Valor: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    // False because we do not want to create it if it doesn't exist
    Registry.OpenKey(KeyName, false);
    Result := Registry.ReadString(Valor);
  finally
    Registry.Free;
  end;
end;

function DownloadFile(Source, Dest: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(Source), PChar(Dest), 0, nil) = 0;
  except
    Result := false;
  end;
end;

function PrinterOnLine: Boolean;
const
  PrnStInt: Byte = $17;
  StRq: Byte = $02;
  PrnNum: Word = 0; { 0 para LPT1, 1 para LPT2, etc. }
var
  nResult: Byte;
begin (* PrinterOnLine *)
  asm
    mov ah,StRq;
    mov dx,PrnNum;
    Int $17;
    mov nResult,ah;
  end;

  PrinterOnLine := (nResult and $80) = $80;
end;

function DiaUtilAnterior(dData: TDateTime): TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData - 1
  else if DayOfWeek(dData) = 1 then
    dData := dData - 2;
  DiaUtilAnterior := dData;
end;

function ProximoDiaUtil(dData: TDateTime): TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData + 2
  else if DayOfWeek(dData) = 1 then
    dData := dData + 1;
  ProximoDiaUtil := dData;
end;

{ procedure Delay(iMSecs: Integer);
  var
  lnTickCount: LongInt;
  begin
  lnTickCount := GetTickCount;
  repeat
  Application.ProcessMessages;
  until ((GetTickCount - lnTickCount) >= LongInt(iMSecs));
  end; }

function ConnectionNet: Boolean;
//
// Retorna o tipo de conexão com a Internet
//
// Requer a wininet na clausula Uses da Unit
var
  flags: dword;
begin
  Result := InternetGetConnectedState(@flags, 0);
  if Result then
  begin
    if (flags and INTERNET_CONNECTION_MODEM) = INTERNET_CONNECTION_MODEM then
      // ShowMessage('Você esta conectador Modem')
    else if (flags and INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN then
      // ShowMessage('LAN')
    else if (flags and INTERNET_CONNECTION_PROXY)
      = INTERNET_CONNECTION_PROXY then
      // ShowMessage('Proxy')
    else if (flags and INTERNET_CONNECTION_MODEM_BUSY)
      = INTERNET_CONNECTION_MODEM_BUSY then
      ShowMessage('Modem ocupado')
    else
    begin
      ShowMessage
        ('Conexão com [ INTERNET ] não estabelecida. Verifique por favor!!!');
      Result := false;
    end;
  end
  else
  begin
    ShowMessage
      ('Conexão com [ INTERNET ] não estabelecida. Verifique por favor!!!');
    Result := false;
  end;
end;

function IsPrinter: Boolean;
const
  PrnStInt: Byte = $17;
  StRq: Byte = $02;
  PrnNum: Word = 0; { 0 para LPT1, 1 para LPT2, etc. }
var
  nResult: Byte;
begin (* IsPrinter *)
  asm
    mov ah,StRq;
    mov dx,PrnNum;
    Int $17;
    mov nResult,ah;
  end;
  IsPrinter := (nResult and $80) = $80;
end;

function FormataDataRef(DataRef: string): string;
begin
  Result := Copy(DataRef, 1, 2) + '/' + Copy(DataRef, 3, 4)
end;

function FormataCPF(CPF: string): string;
begin
  CPF := BuscaTroca(BuscaTroca(BuscaTroca(BuscaTroca(BuscaTroca(CPF, '.', ''),
    '-', ''), ',', ''), '/', ''), '\', '');
  Result := Copy(CPF, 1, 3) + '.' + Copy(CPF, 4, 3) + '.' + Copy(CPF, 7, 3) +
    '-' + Copy(CPF, 10, 2);
end;
// 002.634.353/0001-79

function FormataCNPJ(CNPJ: string): string;
begin
  CNPJ := BuscaTroca(BuscaTroca(BuscaTroca(BuscaTroca(BuscaTroca(CNPJ, '.', ''),
    '-', ''), ',', ''), '/', ''), '\', '');
  Result := Copy(CNPJ, 1, 2) + '.' + Copy(CNPJ, 3, 3) + '.' + Copy(CNPJ, 6, 3) +
    '/' + Copy(CNPJ, 9, 4) + '-' + Copy(CNPJ, 10, 2);
end;

procedure AngleTextOut(CV: TCanvas; const sText: string;
  x, y, angle, Size: Integer);
// Requer a Printers declarada na clausula uses da unit
//
// Ex:
// Printer.BeginDoc;
// AngleTextOut(Printer.Canvas,'Teste',180,100,0,11);
// Printer.EndDoc;
var
  LogFont: TLogFont;
  SaveFont: TFont;
begin
  SaveFont := TFont.Create;
  SaveFont.Assign(CV.Font);
  GetObject(SaveFont.Handle, sizeof(TLogFont), @LogFont);
  with LogFont do
  begin
    lfHeight := Size * 5;
    lfEscapement := angle * 10;
    lfQuality := PROOF_QUALITY;
    lfPitchAndFamily := DEFAULT_PITCH or FF_DONTCARE;
  end;
  CV.Font.Handle := CreateFontIndirect(LogFont);
  SetBkMode(CV.Handle, TRANSPARENT);
  CV.TextOut(x, y, sText);
  CV.Font.Assign(SaveFont);
  SaveFont.Free;
end;


function Extenso(literal: Double): string;
var
  I, centena, dezena, unidade: Integer;
  Valor, monta, Extenso: string;
begin
  Extenso := '';
  if literal = 0.00 then
    Result := 'zero'
  else
  begin
    Valor := FormatFloat('000000000000.00', literal);
    I := 1;
    while I <= 13 do
    begin
      if (Pos(Valor[I], '0123456789') = 0) then
        Valor[I] := '0';
      if (Pos(Valor[I + 1], '0123456789') = 0) then
        Valor[I + 1] := '0';
      if (Pos(Valor[I + 2], '0123456789') = 0) then
        Valor[I + 2] := '0';
      if (I = 13) then
        centena := 0
      else
        centena := StrToInt(Valor[I]);
      dezena := StrToInt(Valor[I + 1]);
      if dezena > 1 then
        unidade := StrToInt(Valor[I + 2])
      else
        unidade := StrToInt(Copy(Valor, (I + 1), 2));
      if (((I = 13) and (StrToFloat(Copy(Valor, 14, 2)) > 0.01)) and
        ((StrToFloat(Copy(Valor, 1, 12))) <> 0.00)) then
        Extenso := Trim(Extenso) + ' e';
      monta := 'duzentos trezentos quatrocentosquinhentos seiscentos setecentos oitocentos novecentos';
      if ((dezena + unidade) = 0) then
        monta := ' cem ' + monta
      else
        monta := ' cento ' + monta;
      Extenso := Trim(Extenso) + ' ' +
        Trim(Copy(monta, ((centena * 12) + 1), 12));
      if ((centena <> 0) and ((dezena + unidade) > 0)) then
        Extenso := Trim(Extenso) + ' e';
      monta := ' vinte trinta quarenta cincoentasessenta setenta oitenta noventa';
      Extenso := Trim(Extenso) + ' ' + Trim(Copy(monta, ((dezena * 9) + 1), 9));
      if ((dezena > 1) and (unidade > 0)) then
        Extenso := Trim(Extenso) + ' e';
      monta := ' um dois tres quatro cinco seis sete oito nove dez onze doze treze quatorze quinze dezeseis dezesete dezoito dezenove';
      Extenso := Trim(Extenso) + ' ' +
        Trim(Copy(monta, ((unidade * 9) + 1), 9));
      if ((centena + dezena + unidade) > 0) then
      begin
        if I = 1 then
          if (((centena + dezena) = 0) and (unidade <= 1)) then
            Extenso := Trim(Extenso) + ' bilhão'
          else
            Extenso := Trim(Extenso) + ' bilhões';
        if (I = 4) then
          if ((centena + dezena = 0) and (unidade <= 1)) then
            Extenso := Trim(Extenso) + ' milhão'
          else
            Extenso := Trim(Extenso) + ' milhões';
        if I = 7 then
          Extenso := Trim(Extenso) + ' mil';
        if ((I < 10) and (StrToFloat(Copy(Valor, (I + 3), (13 - I))) >
          1.00)) then
          Extenso := Extenso + ' e';
      end;
      if ((I = 1) and (StrToFloat(Copy(Valor, 4, 9)) = 0.00) and
        ((centena + unidade + dezena) <> 0)) then
        Extenso := Trim(Extenso) + ' de';
      if ((I = 4) and (StrToFloat(Copy(Valor, 7, 6)) = 0.00) and
        ((centena + unidade + dezena) <> 0)) then
        Extenso := Trim(Extenso) + ' de';
      if ((I = 10) and (StrToFloat(Copy(Valor, 1, 12)) <> 0.00)) then
        if (StrToFloat(Copy(Valor, 1, 12)) = 1.00) then
          Extenso := Trim(Extenso) + ' real'
        else
          Extenso := Trim(Extenso) + ' reais';
      if ((I = 13) and ((dezena + unidade) <> 0)) then
        if ((dezena + unidade) = 1) then
          Extenso := Trim(Extenso) + ' centavo'
        else
          Extenso := Trim(Extenso) + ' centavos';
      I := I + 3;
    end;
    if literal < 0.00 then
      Extenso := Trim(Extenso) + ' negativo';
    if (literal < 1.0) then
      if (StrToInt(Copy(Valor, 14, 2)) = 1) then
        Extenso := Trim(Extenso) + ' de real'
        // "de real/de reais" podem ser substituidos por campos de arquivos de parametros
      else // o que dá mais flexibilidade, caso aconteçam mais planos econômicos.
        Extenso := Trim(Extenso) + ' de reais';
    Result := Extenso;
  end;
end;


// rotina de cálculo do CNPJ e CPF
// entrada - número em formato String
// saída - número com dígito de verificação
// a rotina testa se é CNPJ ou CPF pelo número de dígitos - se for 9 e CPF, se 12, CNPJ

function CalculaCnpjCpf(Numero: string): String;
var
  I, j, k: Integer;
  Soma: Integer;
  Digito: Integer;
  CNPJ: Boolean;
begin
  case length(Numero) of
    9:
      CNPJ := false;
    14:
      CNPJ := true;
  else
    begin
      ShowMessage('          Número inválido!            ');
      Abort;
      Exit;
    end
  end;
  Result := Numero;
  for j := 1 to 2 do
  begin
    k := 2;
    Soma := 0;
    for I := length(Result) downto 1 do
    begin
      Soma := Soma + (ord(Result[I]) - ord('0')) * k;
      Inc(k);
      if (k > 9) and CNPJ then
        k := 2;
    end;
    Digito := 11 - Soma mod 11;
    if Digito >= 10 then
      Digito := 0;
    Result := Result + chr(Digito + ord('0'));
  end;
  Result := Result;
end;

// rotina de cálculo do módulo 10
// entrada - número em formato String
// saída - número com dígito de verificação

function CalculaModulo10(Numero: string): string;
var
  Digito: Integer;
  I, j, cod, n: Integer;
begin
  Numero := Trim(Numero);
  Digito := 0;
  j := 2;
  for I := length(Numero) downto 1 do
  begin
    n := ord(Numero[I]) - ord('0');
    cod := (n mod 10) * j;
    Digito := Digito + (cod mod 10) + (cod div 10);
    if j = 2 then
      j := 1
    else
      j := 2;
  end;
  Digito := Digito mod 10;
  if Digito <> 0 then
    Result := Numero + ' ' + IntToStr(10 - Digito)
  else
    Result := Numero + ' 0';
end;

function Crypt(Action, Src, Key: string): string;
// E para Encriptar e D para Desencripitar
// Crypt('D', TxtResult.Caption, EdtKey.Text)
var
  KeyLen: Integer;
  KeyPos: Integer;
  offset: Integer;
  Dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;
begin
  Dest := '';
  KeyLen := length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if Action = UpperCase('E') then
  begin
    Randomize;
    offset := Random(Range);
    Dest := format('%1.2x', [offset]);
    for SrcPos := 1 to length(Src) do
    begin
      SrcAsc := (ord(Src[SrcPos]) + offset) mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      SrcAsc := SrcAsc xor ord(Key[KeyPos]);
      Dest := Dest + format('%1.2x', [SrcAsc]);
      offset := SrcAsc;
    end;
  end;
  if Action = UpperCase('D') then
  begin
    offset := StrToInt('$' + Copy(Src, 1, 2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc xor ord(Key[KeyPos]);
      if TmpSrcAsc <= offset then
        TmpSrcAsc := 255 + TmpSrcAsc - offset
      else
        TmpSrcAsc := TmpSrcAsc - offset;
      Dest := Dest + chr(TmpSrcAsc);
      offset := SrcAsc;
      SrcPos := SrcPos + 2;
    until SrcPos >= length(Src);
  end;
  Crypt := Dest;
end;

function ArredontaFloat(x: Real): Real;
{ Arredonda um número float para convertê-lo em String }
begin
  if x > 0 then
  begin
    if Frac(x) > 0.5 then
    begin
      x := x + 1 - Frac(x);
    end
    else
    begin
      x := x - Frac(x);
    end;
  end
  else
  begin
    x := x - Frac(x);
  end;
  Result := x
end;

function RoundNum(Valor: Extended; Decimais: Integer): Extended;
{ Quando houver,Arredonda uma possivel terceira casa decimal em uma variável }
var
  I: Integer;
  Multiplicador: Integer;
begin
  if Decimais > 15 then
  begin
    Decimais := 15;
  end
  else if Decimais < 0 then
  begin
    Decimais := 0;
  end;
  Multiplicador := 1;
  for I := 1 to Decimais do
  begin
    Multiplicador := Multiplicador * 10;
  end;
  Result := round(Valor * Multiplicador) / Multiplicador;
end;

function Gerapercentual(Valor: Real; Percent: Real): Real;
// Retorna a porcentagem de um valor
begin
  Percent := Percent / 100;
  try
    Valor := Valor * Percent;
  finally
    Result := Valor;
  end;
end;



// Integer

function IntToBin(Value: LongInt; Size: Integer): string;
{ Converte uma string em binário }
var
  I: Integer;
begin
  Result := '';
  for I := Size downto 0 do
  begin
    if Value and (1 shl I) <> 0 then
    begin
      Result := Result + '1';
    end
    else
    begin
      Result := Result + '0';
    end;
  end;
end;

function BinToInt(Value: string): LongInt;
{ Converte um numero binário em Inteiro }
var
  I, Size: Integer;
begin
  Result := 0;
  Size := length(Value);
  for I := Size downto 0 do
  begin
    if Copy(Value, I, 1) = '1' then
    begin
      Result := Result + (1 shl I);
    end;
  end;
end;

function DecToBase(Decimal: LongInt; const Base: Byte): string;
{ converte um número decimal na base especificada }
const
  Symbols: string[16] = '0123456789ABCDEF';
var
  scratch: string;
  remainder: Byte;
begin
  scratch := '';
  repeat
    remainder := Decimal mod Base;
    scratch := Symbols[remainder + 1] + scratch;
    Decimal := Decimal div Base;
  until (Decimal = 0);
  Result := scratch;
end;

function Base10(Base2: Integer): Integer; assembler;
{ Converte uma string em Base 10 }
asm
  cmp    eax,100000000            // check upper limit
  jb     @1                       // ok
  mov    eax,-1                   // error flag
  jmp    @exit                    // exit with -1
@1:
  push   ebx                      // save registers
  push   esi
  xor    esi,esi                  // result = 0
  mov    ebx,10                   // diveder base 10
  mov    ecx,8                    // 8 nibbles (10^8-1)
@2:
  mov    edx,0                    // clear remainder
  div    ebx                      // eax DIV 10, edx mod 10
  add    esi,edx                  // result = result + remainder[I]
  ror    esi,4                    // shift nibble
  loop  @2                       // loop for all 8 nibbles
  mov    eax,esi                  // Function result
  pop    esi                      // restore registers
  pop    ebx
@exit:
end;

function DecToBinStr(n: Integer): string;
{ Converte um numero decimal em binário }
var
  s: string;
  I: Integer;
  Negative: Boolean;
begin
  Negative := false;
  if n < 0 then
  begin
    Negative := true;
  end;
  n := Abs(n);
  for I := 1 to sizeof(n) * 8 do
  begin
    if n < 0 then
    begin
      s := s + '1';
    end
    else
    begin
      s := s + '0';
    end;
    n := n shl 1;
  end;
  Delete(s, 1, Pos('1', s) - 1); // remove leading zeros
  if Negative then
  begin
    s := '-' + s;
  end;
  Result := s;
end;

function DecToRoman(Decimal: LongInt): string;
{ Converte um numero decimal em algarismos romanos }
const
  Romans: array [1 .. 13] of string = ('I', 'IV', 'V', 'IX', 'X', 'XL', 'L',
    'XC', 'C', 'CD', 'D', 'CM', 'M');
  Arabics: array [1 .. 13] of Integer = (1, 4, 5, 9, 10, 40, 50, 90, 100, 400,
    500, 900, 1000);
var
  I: Integer;
  scratch: string;
begin
  scratch := '';
  for I := 13 downto 1 do
    while (Decimal >= Arabics[I]) do
    begin
      Decimal := Decimal - Arabics[I];
      scratch := scratch + Romans[I];
    end;
  Result := scratch;
end;

function NumToHex(Num: Word): string;
// Converte um numero em Hexadecimal
var
  L: string[16];
  BHi, BLo: Byte;
begin
  L := '0123456789ABCDEF';
  BHi := Hi(Num);
  BLo := Lo(Num);
  Result := Copy(L, succ(BHi shr 4), 1) + Copy(L, succ(BHi and 15), 1) +
    Copy(L, succ(BLo shr 4), 1) + Copy(L, succ(BLo and 15), 1);
end;

function Min(A, B: Integer): Integer;
{ Compara dois valores Retornando o maior deles }
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: Integer): Integer;
{ Compara dois valores Retornando o maior deles }
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function IntPrime(Value: Integer): Boolean;
{ Testa se um numero é primo ou não }
var
  I: Integer;
begin
  Result := false;
  Value := Abs(Value);
  if Value mod 2 <> 0 then
  begin
    I := 1;
    repeat
      I := I + 2;
      Result := Value mod I = 0
    until Result or (I > Trunc(sqrt(Value)));
    Result := not Result;
  end;
end;

function strByteSize(Value: LongInt): string;
{ Retorna uma conversão de Bytes para integer }
const
  KBYTE = sizeof(Byte) shl 10;
  MBYTE = KBYTE shl 10;
  GBYTE = MBYTE shl 10;
begin
  if Value > GBYTE then
  begin
    Result := FloatToStrF(round(Value / GBYTE), ffNumber, 6, 0) + ' GB';
  end
  else if Value > MBYTE then
  begin
    Result := FloatToStrF(round(Value / MBYTE), ffNumber, 6, 0) + ' MB';
  end
  else if Value > KBYTE then
  begin
    Result := FloatToStrF(round(Value / KBYTE), ffNumber, 6, 0) + ' KB';
  end
  else
  begin
    Result := FloatToStrF(round(Value), ffNumber, 6, 0) + ' Byte';
  end;
end;


// Strings

function StrToReal(inString: string): Real;
{ converte um número em Float }
var
  I: Real;
  k: Integer;
begin
  Val(inString, I, k);
  StrToReal := I;
end;

function BuscaDireita(Busca, Text: string): Integer;
{ Pesquisa um caractere à direita da string,
  retornando sua posição }
var
  n, retorno: Integer;
begin
  retorno := 0;
  for n := length(Text) downto 1 do
  begin
    if Copy(Text, n, 1) = Busca then
    begin
      retorno := n;
      break;
    end;
  end;
  Result := retorno;
end;

function ExDizima(ValorString: string): string;
var
  n: Integer;
  encontrou: Boolean;

begin
  encontrou := false;
  for n := length(ValorString) downto 1 do
  begin
    if Copy(ValorString, n, 1) = ',' then
    begin
      Result := Copy(ValorString, 1, n + 2);
      encontrou := true;
      break;
    end;
  end;
  if encontrou = false then
    Result := ValorString + ',00';
end;

function BuscaTroca(Text, Busca, Troca: string): string;
{ Substitui um caractere dentro da string }
var
  n: Integer;
begin
  for n := 1 to length(Text) do
  begin
    if Copy(Text, n, 1) = Busca then
    begin
      Delete(Text, n, 1);
      Insert(Troca, Text, n);
    end;
  end;
  Result := Text;
end;

function BuscaTrocaStr(Text, Busca, Troca: string): string;
{ Busca dentro da string }
var
  n: Integer;
begin
  for n := 1 to length(Text) do
  begin
    if Copy(Text, n, length(Busca)) = Busca then
    begin
      Delete(Text, n, length(Busca));
      Insert(Troca, Text, length(Busca));
    end;
  end;
  Result := Text;
end;

function BuscaStr(Text, Busca: string): Boolean;
{ Busca dentro da string }
var
  n: Integer;
begin
  Result := false;
  for n := 1 to length(Text) do
  begin
    if Copy(Text, n, length(Busca)) = Busca then
    begin
      Result := true;
    end;
  end;
end;

function ContaCaracs(Edit: string): Integer;
{ Retorna quantos caracteres tem um Edit especificado }
begin
  Result := length(Edit);
end;

function Empty(inString: string): Boolean;
{ Testa se a variavel está vazia ou não }
var
  index: Byte;
begin
  index := 1;
  Empty := true;
  while (index <= length(inString)) and (index <> 0) do
  begin
    if inString[index] = ' ' then
    begin
      Inc(index)
    end
    else
    begin
      Empty := false;
      index := 0
    end;
  end;
end;

function LTrim(Texto: string): string;
{ Remove os Espaços em branco à direita da string }
var
  I: Integer;
begin
  I := 0;
  while true do
  begin
    Inc(I);
    if I > length(Texto) then
      break;
    if Texto[I] <> #32 then
      break;
  end;
  Result := Copy(Texto, I, length(Texto));
end;

function Maiuscula(Texto: string): string;
{ Converte a primeira letra do texto especificado para
  maiuscula e as restantes para minuscula }
var
  OldStart: Integer;
begin
  if Texto <> '' then
  begin
    Texto := UpperCase(Copy(Texto, 1, 1)) +
      LowerCase(Copy(Texto, 2, length(Texto)));
    Result := Texto;
  end;
end;

function Padr(s: string; n: Integer): string;
{ alinha uma string à direita }
begin
  Result := format('%' + IntToStr(n) + '.' + IntToStr(n) + 's', [s]);
end;

function RemoveAcentos(Str: string): string;
{ Remove caracteres acentuados de uma string }
const
  ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
  x: Integer;
begin
  for x := 1 to length(Str) do
  begin
    if Pos(Str[x], ComAcento) <> 0 then
    begin
      Str[x] := SemAcento[Pos(Str[x], ComAcento)];
    end;
  end;
  Result := Str;
end;

function RemoveMaskEdit(Str, Masks: string): string;
{ Remove Mascara Edit de string }
var
  StrResult: String;
  x: Integer;
begin
  StrResult := Str;
  for x := 1 to length(Masks) do
  Begin
    StrResult := BuscaTroca(StrResult, Copy(Masks, x, 1), '');
  End;
  Result := Trim(StrResult);
end;

function Replicate(Caracter: string; Quant: Integer): string;
{ Repete o mesmo caractere várias vezes }
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Quant do
    Result := Result + Caracter;
end;

function RTrim(Texto: string): string;
{ Remove os Espaços em branco à esquerda da string }
var
  I: Integer;
begin
  I := length(Texto) + 1;
  while true do
  begin
    dec(I);
    if I <= 0 then
      break;
    if Texto[I] <> #32 then
      break;
  end;
  Result := Copy(Texto, 1, I);
end;

function Strs(I: LongInt): string;
{ Converte uma variavel numérica em string }
var
  x: string[16];
begin
  Str(I, x);
  Strs := x;
end;

function StrToPChar(const Str: string): PChar;
{ Converte String em Pchar }
type
  TRingIndex = 0 .. 7;
var
  Ring: array [TRingIndex] of PChar;
  RingIndex: TRingIndex;
  Ptr: PChar;
begin
  Ptr := @Str[length(Str)];
  Inc(Ptr);
  if Ptr^ = #0 then
  begin
    Result := @Str[1];
  end
  else
  begin
    Result := StrAlloc(length(Str) + 1);
    RingIndex := (RingIndex + 1) mod ( High(TRingIndex) + 1);
    StrPCopy(Result, Str);
    StrDispose(Ring[RingIndex]);
    Ring[RingIndex] := Result;
  end;
end;

function Alltrim(const Search: string): string;
{ Remove os espaços em branco de ambos os lados da string }
const
  BlackSpace = [#33 .. #126];
var
  Index: Byte;
begin
  Index := 1;
  while (Index <= length(Search)) and not(Search[Index] in BlackSpace) do
  begin
    Index := Index + 1;
  end;
  Result := Copy(Search, Index, 255);
  Index := length(Result);

  while (Index > 0) and not(Result[Index] in BlackSpace) do
  begin
    Index := Index - 1;
  end;

  Result := Copy(Result, 1, Index);
end;

function StrZero(Zeros: string; Quant: Integer): string;
{ Insere Zeros à frente de uma string }
var
  I, Tamanho: Integer;
  aux: string;
begin
  aux := Zeros;
  Tamanho := length(Zeros);
  Zeros := '';
  for I := 1 to Quant - Tamanho do
    Zeros := Zeros + '0';
  aux := Zeros + aux;
  StrZero := aux;
end;

function StrBranco(Zeros: string; Quant: Integer): string;
{ Insere Zeros à frente de uma string }
var
  I, Tamanho: Integer;
  aux: string;
begin
  aux := Zeros;
  Tamanho := length(Zeros);
  Zeros := '';
  for I := 1 to Quant - Tamanho do
    Zeros := Zeros + ' ';
  aux := Zeros + aux;
  StrBranco := aux;
end;

function StrZerodec(Numero: Double; Total, Decimal: Integer): string;
{ Insere Zeros e decimais à frente de uma string }
var
  TempStr: string;
begin
  Str(Numero: 0: Decimal, TempStr);
  while length(TempStr) < Total do
  begin
    Insert('0', TempStr, 1);
  end;
  Result := TempStr;
end;

function Padl(s: string; n: Integer): string; // Alinhamento pela esquerda
{ alinha uma string à esquerda }
begin
  Result := format('%-' + IntToStr(n) + '.' + IntToStr(n) + 's', [s]);
end;

function wordcount(Str: string): Integer;
// Retorna o número de palavras que contem em uma string
var
  count: Integer;
  I: Integer;
  Len: Integer;
begin
  Len := length(Str);
  count := 0;
  I := 1;
  while I <= Len do
  begin
    while ((I <= Len) and ((Str[I] = #32) or (Str[I] = #9) or
      (Str[I] = ';'))) do
      Inc(I);
    if I <= Len then
      Inc(count);
    while ((I <= Len) and ((Str[I] <> #32) and (Str[I] <> #9) and
      (Str[I] <> ';'))) do
      Inc(I);
  end;
  wordcount := count;
end;

function LineIsEmpty(Text: string): Boolean;
// Testa se uma linha de texto está vazia ou não
var
  I: Byte;
begin
  for I := 1 to length(Text) do
  begin
    if Text[I] <> ' ' then
    begin
      Result := false;
      Exit;
    end;
  end;
  Result := true;
end;

function PadC(s: string; Len: Byte): string;
// Centraliza uma string em um espaço determinado
var
  Str: string;
  L: Byte;
begin
  Str := '';
  if Len < length(s) then
  begin
    Result := '';
    Exit;
  end;
  L := (Len - length(s)) div 2;
  if ((Len - length(s)) mod 2) <> 0 then
    Inc(L);
  while L > 0 do
  begin
    Str := Str + ' ';
    dec(L);
  end;
  for L := 1 to length(s) do
  begin
    Str := Str + s[L];
  end;
  Result := Str;
end;

function FullFill(Str: string; FLen: Byte; symb: char): string;
// Preenche o restante da string com um caractere especificado
var
  s: string;
  I: Byte;
begin
  s := Str;
  if length(s) >= FLen then
  begin
    Result := s;
    Exit;
  end;
  for I := length(s) to FLen do
  begin
    s := s + symb;
  end;
  Result := s;
end;

function Before(const Search, Find: string): string;
{ Retorna uma cadeia de caracteres antecedentes
  a uma parte da string selecionada }
const
  BlackSpace = [#33 .. #126];
var
  index: Byte;
begin
  index := Pos(Find, Search);
  if index = 0 then
    Result := Search
  else
    Result := Copy(Search, 1, index - 1);
end;

function after(const Search, Find: string): string;
{ Retorna uma cadeia de caracteres após a parte
  da string selecionada }
var
  index: Byte;
begin
  index := Pos(Find, Search);
  if index = 0 then
  begin
    Result := '';
  end
  else
  begin
    Result := Copy(Search, index + length(Find), 255);
  end;
end;

function MaskString(Valor: string): string;
begin
  // Result := FormatMaskText('!aaaaaaaaaaaaaa;0; ',(FormatFloat('#,##0.00',StrToFloat(valor))));
end;

function Encrypt(Senha: string): string;
{ Encripta uma String }
const
  Chave: string = 'pdvexkey';
var
  x, y: Integer;
  NovaSenha: string;
begin
  for x := 1 to length(Chave) do
  begin
    NovaSenha := '';
    for y := 1 to length(Senha) do
      NovaSenha := NovaSenha + chr((ord(Chave[x]) xor ord(Senha[y])));
    Senha := NovaSenha;
  end;
  Result := Senha;
end;

function ExisteInt(Texto: string): Boolean;
{ Testa se em uma string existe um numero inteiro valido ou não }
var
  I: Integer;
begin
  try
    I := StrToInt(Texto);
    Result := true;
  except
    Result := false;
  end;
end;

function IncrementaSerial(numInicial: string; qtd: Integer): string;
var
  Zeros, zero2, numSoma: Integer;
  numCalc, n1, n2: string;

  numfinal: Double;
begin

  numSoma := length(numInicial);
  Zeros := numSoma;

  if numSoma > 14 then
  begin
    n1 := Copy(numInicial, 1, (numSoma div 2));
    n2 := Copy(numInicial, ((numSoma div 2) + 1), numSoma);
    zero2 := length(n2);
    numfinal := StrToFloat(n2) + qtd - 1;

    numCalc := FloatToStr(numfinal);
    numCalc := StrZero(numCalc, zero2);

    numInicial := n1 + numCalc;
    Result := StrZero(numInicial, Zeros);
  end
  else
  begin
    Result := StrZero(FloatToStr(StrToFloat(numInicial) + (qtd - 1)), Zeros);
  end;

end;

function IncrementaSerialUm(numInicial: string): string;
var
  Zeros, zero2, numSoma: Integer;
  numCalc, n1, n2: string;

  numfinal: Double;
begin

  numSoma := length(numInicial);
  Zeros := numSoma;

  if numSoma > 14 then
  begin
    n1 := Copy(numInicial, 1, (numSoma div 2));
    n2 := Copy(numInicial, ((numSoma div 2) + 1), numSoma);
    zero2 := length(n2);
    numfinal := StrToFloat(n2) + 1;

    numCalc := FloatToStr(numfinal);
    numCalc := StrZero(numCalc, zero2);

    numInicial := n1 + numCalc;
    Result := StrZero(numInicial, Zeros);
  end
  else
  begin
    Result := StrZero(FloatToStr(StrToFloat(numInicial) + 1), Zeros);

  end;
end;

function VersaoDoSistema: string;
var
  s: string;
  n, Len: dword;
  Buf, Value: PChar;

begin
  s := Application.ExeName;
  n := GetFileVersionInfoSize(PChar(s), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    GetFileVersionInfo(PChar(s), 0, n, Buf);
    if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\FileVersion'),
      Pointer(Value), Len) then
      Result := Value;
    FreeMem(Buf, n);
  end
  else
    Result := '';
end;

end.
