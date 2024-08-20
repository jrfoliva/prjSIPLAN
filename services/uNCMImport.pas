unit uNCMImport;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Net.HttpClient,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.Net.HttpClientComponent;

type
  TNCMImport = class
    private
      procedure DownloadJSON(const AURL: string; const AFileName: string);
      procedure ParseJSON(const AFileName: string; var AJSONArray: TJSONArray);
      procedure InsertDataIntoDatabase(const AJSONArray: TJSONArray);
    public
      procedure ImportNCMData;
  end;


implementation

uses
  uDMConn,
  service.utils,
  uFunctions;


{ TNCMImport }

procedure TNCMImport.DownloadJSON(const AURL, AFileName: string);
var
  HttpClient: TNetHTTPClient;
  HttpResponse: IHTTPResponse;
  FileStream: TFileStream;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    HttpResponse := HttpClient.Get(AURL);
    if HttpResponse.StatusCode = 200 then
    begin
      FileStream := TFileStream.Create(AFileName, fmCreate);
      try
        FileStream.CopyFrom(HttpResponse.ContentStream, HttpResponse.ContentStream.Size);
      finally
        FileStream.Free;
      end;
    end
    else
      raise Exception.CreateFmt('Erro ao baixar o JSON: %d - %s', [HttpResponse.StatusCode, HttpResponse.StatusText]);
  finally
    HttpClient.Free;
  end;
end;

procedure TNCMImport.ParseJSON(const AFileName: string; var AJSONArray: TJSONArray);
var
  JSONString: TStringList;
  JSONObject: TJSONObject;
begin
  JSONString := TStringList.Create;
  try
    JSONString.LoadFromFile(AFileName, TEncoding.UTF8);
    JSONObject := TJSONObject.ParseJSONValue(JSONString.Text) as TJSONObject;
    if Assigned(JSONObject) then
    begin
      AJSONArray := JSONObject.GetValue('Nomenclaturas') as TJSONArray;
    end
    else
      raise Exception.Create('Erro ao parsear o JSON');
  finally
    JSONString.Free;
  end;
end;

procedure TNCMImport.InsertDataIntoDatabase(const AJSONArray: TJSONArray);
var
  I: Integer;
  JSONObject: TJSONObject;
  NCMCode: string;
  NCMDesc: String;
  FDQuery: TFDQuery;

begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := DMConn.Conn;
    FDQuery.SQL.Add('INSERT INTO ncm (codigo, descricao) Values (:codigo, :descricao) ');
    for I := 0 to AJSONArray.Count - 1 do
    begin
      JSONObject := AJSONArray.Items[I] as TJSONObject;
      NCMCode := JSONObject.GetValue('Codigo').Value;
      NCMDesc := JSONObject.GetValue('Descricao').Value;
      FDQuery.Params.ParamByName('codigo').AsString := TUtils.OnlyNumbers(NCMCode);
      if length(NCMDesc) > 99 then
        NCMDesc := Copy(NCMDesc, 1, 100);
      FDQuery.Params.ParamByName('descricao').AsString := RemoverCaracteresEspeciais(NCMDesc);
      FDQuery.ExecSQL;
    end;
  finally
    FDQuery.Free;
  end;
end;

procedure TNCMImport.ImportNCMData;
const
  URL = 'https://portalunico.siscomex.gov.br/classif/api/publico/nomenclatura/download/json';
  FileName = 'ncm.json';
var
  JSONArray: TJSONArray;
begin
  // Passo 1: Baixar o JSON
  DownloadJSON(URL, FileName);
  // Passo 2: Parsear o JSON
  JSONArray := nil;
  ParseJSON(FileName, JSONArray);
  if Assigned(JSONArray) then
  try
    // Passo 3: Inserir dados no banco de dados
    try
      InsertDataIntoDatabase(JSONArray);
    except on E: Exception do
      raise Exception.Create(E.Message);
    end;
  finally
    JSONArray.Free;
  end;
end;

end.
