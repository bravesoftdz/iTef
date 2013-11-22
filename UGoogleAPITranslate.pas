program UGoogleAPITranslate;
//Author  : Rodrigo Ruz V. 2010-12-03  03;30 A.M

{$APPTYPE CONSOLE}
{$DEFINE USE_SUPER_OBJECT}
{$DEFINE USE_DBXJSON}
{$DEFINE USE_JSONLess}

uses
   msxml
  ,Activex
  ,HTTPApp
  ,Variants
  ,SysUtils
  {$IFDEF USE_JSONLess}
  ,StrUtils
  {$ENDIF}
  {$IFDEF USE_SUPER_OBJECT}
  ,superobject
  {$ENDIF}
  {$IFDEF USE_DBXJSON}
  ,DBXJSON
  {$ENDIF}
  ;

  type
  TGoogleLanguages=
  (Autodetect,Afrikaans,Albanian,Arabic,Basque,Belarusian,Bulgarian,Catalan,Chinese,Chinese_Traditional,
  Croatian,Czech,Danish,Dutch,English,Estonian,Filipino,Finnish,French,Galician,German,Greek,
  Haitian_Creole,Hebrew,Hindi,Hungarian,Icelandic,Indonesian,Irish,Italian,Japanese,Latvian,
  Lithuanian,Macedonian,Malay,Maltese,Norwegian,Persian,Polish,Portuguese,Romanian,Russian,
  Serbian,Slovak,Slovenian,Spanish,Swahili,Swedish,Thai,Turkish,Ukrainian,Vietnamese,Welsh,Yiddish);

  const
  GoogleLanguagesArr : array[TGoogleLanguages] of string =
  ( 'Autodetect','af','sq','ar','eu','be','bg','ca','zh-CN','zh-TW','hr','cs','da','nl','en','et','tl','fi','fr','gl',
    'de','el','ht','iw','hi','hu','is','id','ga','it','ja','lv','lt','mk','ms','mt','no','fa','pl','pt',
    'ro','ru','sr','sk','sl','es','sw','sv','th','tr','uk','vi','cy','yi');

  //¡¡¡¡¡¡Please be nice and create your own Google Api Key ¡¡¡¡¡¡¡
  GoogleLanguageApiKey   ='AIzaSyDb18pd1IfkYyupC2XUIANcRoB3f9J2DJg';
  GoogleTranslateUrl     ='https://www.googleapis.com/language/translate/v2?key=%s&q=%s&source=%s&target=%s';
  GoogleTranslateUrlAuto ='https://www.googleapis.com/language/translate/v2?key=%s&target=%s&q=%s';

{$IFDEF USE_DBXJSON}
function Translate_DBXJSON(const Text:string;Source,Dest:TGoogleLanguages):string;
var
  XMLHTTPRequest: IXMLHTTPRequest;
  EncodedRequest: string;
  json          : TJSONObject;
  jPair         : TJSONPair;
  jValue        : TJSONValue;
  Response      : string;
begin
  Result:='';
  if Source=Autodetect then
    EncodedRequest:=Format(GoogleTranslateUrlAuto,[GoogleLanguageApiKey,GoogleLanguagesArr[Dest],HTTPEncode(Text)])
  else
    EncodedRequest:=Format(GoogleTranslateUrl,[GoogleLanguageApiKey,HTTPEncode(Text),GoogleLanguagesArr[Source],GoogleLanguagesArr[Dest]]);

  XMLHTTPRequest := CoXMLHTTP.Create;
  XMLHTTPRequest.open('GET', EncodedRequest, False, EmptyParam, EmptyParam);
  XMLHTTPRequest.send('');
  Response:=XMLHTTPRequest.responseText;

  if Response<>'' then
  begin
      json    := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Response),0) as TJSONObject;
    try
      jPair   := json.Get(0);
      if jPair.JsonString.value='error' then
        //{"error":{"errors":[{"domain":"global","reason":"invalid","message":"Invalid Value"}],"code":400,"message":"Invalid Value"}}
        Result := Format('Error Code %s message %s',[TJSONObject(jPair.JsonValue).Get(1).JsonValue.Value,TJSONObject(jPair.JsonValue).Get(2).JsonValue.Value])
      else
      begin
        //{"data":{"translations":[{"translatedText":"Hola a todos","detectedSourceLanguage":"en"}]}}
        jValue := TJSONArray(TJSONObject(jPair.JsonValue).Get(0).JsonValue).Get(0);
        Result := TJSONObject(jValue).Get(0).JsonValue.Value;
      end;
    finally
       json.Free;
    end;

      Result:=HTMLDecode(Result);
  end;
end;
{$ENDIF}

{$IFDEF USE_SUPER_OBJECT}
function Translate_JSONsuperobject(const Text:string;Source,Dest:TGoogleLanguages):string;
var
  XMLHTTPRequest: IXMLHTTPRequest;
  EncodedRequest: string;
  Response      : string;
begin
  Result:='';
  if Source=Autodetect then
    EncodedRequest:=Format(GoogleTranslateUrlAuto,[GoogleLanguageApiKey,GoogleLanguagesArr[Dest],HTTPEncode(Text)])
  else
    EncodedRequest:=Format(GoogleTranslateUrl,[GoogleLanguageApiKey,HTTPEncode(Text),GoogleLanguagesArr[Source],GoogleLanguagesArr[Dest]]);

  XMLHTTPRequest := CoXMLHTTP.Create;
  XMLHTTPRequest.open('GET', EncodedRequest, False, EmptyParam, EmptyParam);
  XMLHTTPRequest.send('');
  Response:=XMLHTTPRequest.responseText;
  if Response<>'' then
  begin
  //{"data":{"translations":[{"translatedText":"Hola a todos","detectedSourceLanguage":"en"}]}}
    if SO(Response)['error']=nil then
     Result := SO(Response)['data.translations[0].translatedText'].AsString
    else
     //{"error":{"errors":[{"domain":"global","reason":"invalid","message":"Invalid Value"}],"code":400,"message":"Invalid Value"}}
     //{"error":{"errors":[{"domain":"global","reason":"badRequest","message":"Bad language pair: en|zh-TW"}],"code":400,"message":"Bad language pair: en|zh-TW"}}
     Result := Format('Error Code %d message %s',[SO(Response)['error.code'].AsInteger,SO(Response)['error.message'].AsString]);
     Result:=HTMLDecode(Result);
  end;

end;
{$ENDIF}

{$IFDEF USE_JSONLess}
function Translate_JSONLess(const Text:string;Source,Dest:TGoogleLanguages):string;
const
  TagIOk='{"data":{"translations":[{"translatedText":"';
  TagFOk='"}]}}';
  TagErr='{"error":{"errors":[{';
  TagAut=',"detectedSourceLanguage":"';
var
  XMLHTTPRequest: IXMLHTTPRequest;
  EncodedRequest: string;
  Response      : string;
begin
  Result:='';

  if Source=Autodetect then
    EncodedRequest:=Format(GoogleTranslateUrlAuto,[GoogleLanguageApiKey,GoogleLanguagesArr[Dest],HTTPEncode(Text)])
  else
    EncodedRequest:=Format(GoogleTranslateUrl,[GoogleLanguageApiKey,HTTPEncode(Text),GoogleLanguagesArr[Source],GoogleLanguagesArr[Dest]]);

  XMLHTTPRequest := CoXMLHTTP.Create;
  XMLHTTPRequest.open('GET', EncodedRequest, False, EmptyParam, EmptyParam);
  XMLHTTPRequest.send('');
  Response:=XMLHTTPRequest.responseText;
  if Response<>'' then
  begin
    if StartsStr(TagErr,(Response)) then  //Response  Error
    begin
      Result:='Error'
    end
    else
    begin  //Response Ok
      if Source=Autodetect then
      begin
        Result:=StringReplace(Response,TagIOk,'',[rfReplaceAll]);
        Result:=Copy(Result,1,Pos(TagAut,Result)-2);
      end
      else
      begin
        Result:=StringReplace(Response,TagIOk,'',[rfReplaceAll]);
        Result:=StringReplace(Result,TagFOk,'',[rfReplaceAll]);
      end;
    end;

    Result:=HTMLDecode(Result);
  end;
end;
{$ENDIF}

Const
 Text ='"Hello  World"';
Var
 TranslatedText : string;
begin
  try
    CoInitialize(nil);
    try
       {$IFDEF USE_JSONLess}
       Writeln('Without JSON (very ugly)');
       Writeln('');
       TranslatedText:=Translate_JSONLess(Text,Autodetect,Spanish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONLess(Text,English,Chinese_Traditional);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONLess(Text,English,German);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONLess(Text,English,Danish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONLess(Text,English,Portuguese);
       Writeln(TranslatedText);
       Writeln('');
       {$ENDIF}

       {$IFDEF USE_SUPER_OBJECT}
       Writeln('Using the superobject library');
       Writeln('');
       TranslatedText:=Translate_JSONsuperobject(Text,Autodetect,Spanish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONsuperobject(Text,English,Chinese_Traditional);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONsuperobject(Text,English,German);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONsuperobject(Text,English,Danish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_JSONsuperobject(Text,English,Portuguese);
       Writeln(TranslatedText);
       Writeln('');
       {$ENDIF}

       {$IFDEF USE_DBXJSON}
       Writeln('Using the DBXJSON unit');
       Writeln('');
       TranslatedText:=Translate_DBXJSON(Text,Autodetect,Spanish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_DBXJSON(Text,English,Chinese_Traditional);
       Writeln(TranslatedText);
       TranslatedText:=Translate_DBXJSON(Text,English,German);
       Writeln(TranslatedText);
       TranslatedText:=Translate_DBXJSON(Text,English,Danish);
       Writeln(TranslatedText);
       TranslatedText:=Translate_DBXJSON(Text,English,Portuguese);
       Writeln(TranslatedText);
       Writeln('');
       {$ENDIF}

    finally
     CoUninitialize;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
