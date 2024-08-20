unit uFunctions;
interface
uses FMX.TextLayout, FMX.ListView.Types, System.Types, FMX.Graphics, Data.DB,
     System.Classes, System.SysUtils, System.Net.HttpClient,
     System.Net.HttpClientComponent, System.IOUtils, System.NetEncoding,
     DateUtils,
     System.Skia,
     FMX.Skia;

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
function StringToFloat(vl : string) : double;
function ObterUF(uf : string) : string;
function FormatarSenha(senha: string): string;
function StringToDate(str: string): TDate;
function FormataData(dt: string): string;
procedure LoadImageFromURL(img: TBitmap; url: string; token: string = '');
function SaveBlobToFile(field: TField; cod_produto_local: integer): string;
function StreamToBase64(FotoStream: TStream): string;
function StringUTCToDate(str: string): TDate;
Function CalcularPorcentagem(valor1, valor2 : Double): Double;
function RemoverPontos(const Str: string): string;
function RemoverAcentos(const Str: string): string;
function RemoverCaracteresEspeciais(const Str: string): string;
function CalcularIdade(dataNascimento: TDateTime): Integer;


implementation
(**
procedure ExibeAnimacao(AImage : TSkAnimatedImage; ATime:Integer=1500);
var
  t: TThread;}
begin
  //Ativar as animações
  AImage.Visible := true;
  AImage.Enabled := true;
  AImage.Animation.Enabled := true;

  //Sleep(ATime);
  AImage.Visible := False;
  AImage.Enabled := False;
  AImage.Animation.Enabled := False;

  {t := TThread.CreateAnonymousThread(procedure
  begin
     // Comunicação com o Banco de dados
	   // tudo que salvar ou consultar dentro dessa thread...
    sleep(3000);
  end);
    t.OnTerminate := ThreadSalvarCadastro;
    t.Start;
  }
end;
**)

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;
procedure LoadBitmapFromBlob(Bitmap: TBitmap; Blob: TBlobField);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Blob.SaveToStream(ms);
    ms.Position := 0;
    Bitmap.LoadFromStream(ms);
  finally
    ms.Free;
  end;
end;

function StringToFloat(vl : string) : double;
begin
    // R$ 5.800,00
    vl := StringReplace(vl, ',', '', [rfReplaceAll]); // R$ 5.80000
    vl := StringReplace(vl, '.', '', [rfReplaceAll]); // R$ 580000
    vl := StringReplace(vl, 'R$', '', [rfReplaceAll]); // 580000
    vl := StringReplace(vl, ' ', '', [rfReplaceAll]); // 580000
    try
        Result := StrToFloat(vl) / 100;
    except
        Result := 0;
    end;
end;

function ObterUF(uf : string) : string;
begin
    uf := LowerCase(uf);
    if uf = 'acre' then uf := 'AC' else
    if uf = 'alagoas' then uf := 'AL' else
    if uf = 'amapá' then uf := 'AP' else
    if uf = 'amazonas' then uf := 'AM' else
    if uf = 'bahia' then uf := 'BA' else
    if uf = 'ceará' then uf := 'CE' else
    if uf = 'distrito federal' then uf := 'DF' else
    if uf = 'espírito santo' then uf := 'ES' else
    if uf = 'goiás' then uf := 'GO' else
    if uf = 'maranhão' then uf := 'MA' else
    if uf = 'mato grosso' then uf := 'MT' else
    if uf = 'mato grosso do sul' then uf := 'MS' else
    if uf = 'minas gerais' then uf := 'MG' else
    if uf = 'pará' then uf := 'PA' else
    if uf = 'paraíba' then uf := 'PB' else
    if uf = 'paraná' then uf := 'PR' else
    if uf = 'pernambuco' then uf := 'PE' else
    if uf = 'piauí' then uf := 'PI' else
    if uf = 'rio de janeiro' then uf := 'RJ' else
    if uf = 'rio grande do norte' then uf := 'RN' else
    if uf = 'rio grande do sul' then uf := 'RS' else
    if uf = 'rondônia' then uf := 'RO' else
    if uf = 'roraima' then uf := 'RR' else
    if uf = 'santa catarina' then uf := 'SC' else
    if uf = 'são paulo' then uf := 'SP' else
    if uf = 'sergipe' then uf := 'SE' else
    if uf = 'tocantins' then uf := 'TO';
    Result := uf;
end;
function FormatarSenha(senha: string): string;
var
    i : integer;
begin
    Result := '';
    for i := 1 to Length(senha) do
        Result := Result + '*';
end;
function StringToDate(str: string): TDate;
var
    dia, mes, ano: integer;
begin
    // formato input: dd/mm/yyyy
    dia := Copy(str, 1, 2).ToInteger;
    mes := Copy(str, 4, 2).ToInteger;
    ano := Copy(str, 7, 4).ToInteger;
    Result := EncodeDate(ano, mes, dia);
end;
// Formato: 2021-10-09T14:11:28.877Z  -->  Date
function StringUTCToDate(str: string): TDate;
var
    ano, mes, dia, hora, minuto, seg: integer;
begin
    try
        ano := Copy(str, 1, 4).ToInteger;
        mes := Copy(str, 6, 2).ToInteger;
        dia := Copy(str, 9, 2).ToInteger;
        hora := Copy(str, 12, 2).ToInteger;
        minuto := Copy(str, 15, 2).ToInteger;
        seg := Copy(str, 18, 2).ToInteger;
        Result := EncodeDateTime(ano, mes, dia, hora, minuto, seg, 0);
    except
        Result := 0;
    end;
end;
// Formato: 2021-10-09T14:11:28.877Z  -->  2021-10-09 14:11:28
function FormataData(dt: string): string;
begin
    Result := Copy(dt, 1, 10) + ' ' + Copy(dt, 12, 8);
end;
procedure LoadImageFromURL(img: TBitmap; url: string; token: string = '');
var
    http : TNetHTTPClient;
    vStream : TMemoryStream;
begin
    try
        try
            http := TNetHTTPClient.Create(nil);
            if token <> '' then
                http.CustomHeaders['Authorization'] := 'Bearer ' + token;
            vStream :=  TMemoryStream.Create;
            if (Pos('https', LowerCase(url)) > 0) then
                  HTTP.SecureProtocols  := [THTTPSecureProtocol.TLS1,
                                            THTTPSecureProtocol.TLS11,
                                            THTTPSecureProtocol.TLS12];
            http.Get(url, vStream);
            vStream.Position  :=  0;

            img.LoadFromStream(vStream);
        except on ex:exception do
            //showmessage(ex.Message);
        end;
    finally
        vStream.DisposeOf;
        http.DisposeOf;
    end;
end;
function SaveBlobToFile(field: TField; cod_produto_local: integer): string;
var
    arq: string;
begin
    {$IFDEF MSWINDOWS}
    arq := System.SysUtils.GetCurrentDir + '\FotosTemp';
    if not TDirectory.Exists(arq) then
        TDirectory.CreateDirectory(arq);
    arq := arq + '\' + cod_produto_local.ToString + '.jpg';
    {$ELSE}
    arq := TPath.Combine(TPath.GetDocumentsPath, cod_produto_local.ToString + '.jpg');
    {$ENDIF}
    if FileExists(arq) then
        DeleteFile(arq);
    TBlobField(field).SaveToFile(arq);
    Result := arq;
end;
function StreamToBase64(FotoStream: TStream): string;
var
    StreamOut: TStringStream;
begin
    try
        StreamOut := TStringStream.Create;
        TNetEncoding.Base64.Encode(FotoStream, StreamOut);
        StreamOut.Position := 0;
        Result := StreamOut.DataString;
    finally
        FotoStream.DisposeOf;
        StreamOut.DisposeOf;
    end;
end;
Function CalcularPorcentagem(valor1, valor2 : Double): Double;
begin
  Result := (valor1/valor2) * 100;
end;
function RemoverCaracteresEspeciais(const Str: string): string;
const
  CaracteresEspeciais = '~`!@#$%^&*()-_+={}[]|:;"''<>,.?/ºª§¹²³£¢¬\';
var
  i: Integer;
begin
  Result := Str;
  for i := 1 to Length(CaracteresEspeciais) do
    Result := StringReplace(Result, CaracteresEspeciais[i], '', [rfReplaceAll]);
end;

function RemoverAcentos(const Str: string): string;
const
  ComAcento = 'àáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿ';
  SemAcento = 'aaaaaaaceeeeiiiidnoooooouuuuyy';
var
  i: Integer;
begin
  Result := Str;
  for i := 1 to Length(ComAcento) do
    Result := StringReplace(Result, ComAcento[i], SemAcento[i], [rfReplaceAll, rfIgnoreCase]);
end;
function RemoverPontos(const Str: string): string;
const
 CaracteresPontoTraco = '.-';
var
  i: Integer;
begin
  Result := Str;
  for i := 1 to Length(CaracteresPontoTraco) do
    Result := StringReplace(Result, CaracteresPontoTraco[i], '', [rfReplaceAll]);
end;
function CalcularIdade(dataNascimento: TDateTime): Integer;
var
  dataAtual: TDateTime;
begin
  dataAtual := Now; // Obtém a data atual
  Result := YearsBetween(dataAtual, dataNascimento); // Calcula a diferença em anos
end;


end.
