unit service.utils;

interface

uses
  FMX.Objects,  Classes, System.Types, {FMX.Types,} System.UITypes, System.SysUtils,
  UI.Edit; {FMX.DialogService;}

type
  TUtils = class
    private
    public
      class function OnlyNumbers(aValue: String): String;
      class procedure ResourceImage(Resource: String; Image: TImage); overload;
      //class procedure ResourceImage(Resource: String; Image: TFMXObject); overload;
      class function UpperCamelCase(value: String) : String;
      class procedure ImageColor(Image: TImage; Color: TAlphaColor);
      class function IsCPFValid(const aCPF: string): Boolean;
      class function IsCNPJValid(aCNPJ: string): Boolean;
      class function ConvertDateToMySQL(aDate: string): string;
      class function ConvertDateTimeToMySQL(aDateTime: string): string;
      class function ConvertDateToDelphi(aDate: string): string;
      class function ConvertDateTimeToDelphi(aDateTime: string): string;
      class function FormataTelefone(aNumero: String): String;
      class function FormataCPF_RG_CNPJ_CEP(aNumero: String): String;
      class function FormataNCM(aValue: String): String;
  end;

implementation

{ TUtils }

class procedure TUtils.ResourceImage(Resource: String; Image: TImage);
begin
  var lResource := TResourceStream.Create(HInstance, Resource, RT_RCDATA);
    try
      Image.Bitmap.LoadFromStream(lResource);
    finally
      lResource.Free;
    end;
end;

class function TUtils.ConvertDateToDelphi(aDate: string): string;
var
  day, month, year: String;
begin
  if aDate = '' then
  begin
    Result := '0';
    Exit;
  end;
  day   := Copy(aDate, 9, 2);
  month := Copy(aDate, 6, 2);
  year  := Copy(aDate, 1, 4);
  Result := day + '/' + month + '/' + year;
end;

class function TUtils.ConvertDateTimeToDelphi(aDateTime: string): string;
var
  day, month, year, hh, min, sec: String;
begin
  if aDateTime = '' then
  begin
    Result := '0';
    Exit;
  end;
  min   := Copy(aDateTime, 15, 2);
  sec   := Copy(aDateTime, 18, 2);
  Result := ConvertDateToDelphi(aDateTime) + ' ' +  hh + ':' + min + ':' + sec;
end;


class function TUtils.ConvertDateToMySQL(aDate: string): string;
var
  day, month, year: String;
begin
  if aDate = '' then
  begin
    Result := '0';
    Exit;
  end;
  day   := Copy(aDate, 1, 2);
  month := Copy(aDate, 4, 2);
  year  := Copy(aDate, 7, 4);
  Result := year + '-' + month + '-' + day;
end;

class function TUtils.FormataTelefone(aNumero: String): String;
begin
  aNumero := OnlyNumbers(aNumero);
  if Length(aNumero) = 11 then
    Result := Format('(%s) %s-%s', [Copy(aNumero, 1, 2), Copy(aNumero, 3, 5), Copy(aNumero, 8, 4)])
  else
    if Length(aNumero) = 10 then
      Result := Format('(%s) %s-%s', [Copy(aNumero, 1, 2), Copy(aNumero, 3, 4), Copy(aNumero, 7, 4)])
    else
      Result := aNumero;
end;
class function TUtils.FormataCPF_RG_CNPJ_CEP(aNumero: String): String;
begin
  aNumero := OnlyNumbers(aNumero);
  if Length(aNumero) = 11 then
    Result := Format('%s.%s.%s-%s', [Copy(aNumero, 1, 3), Copy(aNumero,4, 3), Copy(aNumero, 7, 3), Copy(aNumero, 10, 2 )])
  else
    if Length(aNumero) = 14 then
      Result := Format('%s.%s.%s/%s-%s', [Copy(aNumero, 1, 2), Copy(aNumero,3, 3), Copy(aNumero,6, 3), Copy(aNumero, 9, 4 ), Copy(aNumero, 13, 2 )])
    else
      if Length(aNumero) = 9 then
        Result := Format('%s.%s.%s-%s', [Copy(aNumero, 1, 2), Copy(aNumero,3, 3), Copy(aNumero,6, 3), Copy(aNumero, 9, 1 )])
      else
        if Length(aNumero) = 8 then
          Result := Format('%s-%s', [Copy(aNumero, 1, 5), Copy(aNumero,6, 3)])
        else
          Result := aNumero;
end;

class function TUtils.FormataNCM(aValue: String): String;
begin
  aValue := OnlyNumbers(aValue);
  case Length(aValue) of
    2,4: Result := aValue;
      5: Result := format('%s.%s', [Copy(aValue, 1,4), Copy(aValue, 5,1)]);
      6: Result := format('%s.%s', [Copy(aValue, 1,4), Copy(aValue, 5,2)]);
      7: Result := format('%s.%s.%s', [Copy(aValue, 1,4), Copy(aValue, 5,2), Copy(aValue, 7,1)]);
      8: Result := format('%s.%s.%s', [Copy(aValue, 1,4), Copy(aValue, 5,2), Copy(aValue, 7,2)]);
    else
      Result := aValue;
  end;
end;

class function TUtils.ConvertDateTimeToMySQL(aDateTime: string): string;
var
  day, month, year, hh, min, sec: String;
begin
  if aDateTime = '' then
  begin
    Result := '0';
    Exit;
  end;
  hh    := Copy(aDateTime, 12, 2);
  min   := Copy(aDateTime, 15, 2);
  sec   := Copy(aDateTime, 18, 2);
  Result := ConvertDateToMySQL(aDateTime) + ' '+ hh + ':' + min + ':' + sec;
end;


class procedure TUtils.ImageColor(Image: TImage; Color: TAlphaColor);
begin
  Image.Bitmap.ReplaceOpaqueColor(Color);
end;

class function TUtils.IsCNPJValid(aCNPJ: string): Boolean;
var
  I, J, Sum, Digit: Integer;
  CleanCNPJ : String;

begin
  Result := False;

  // Remove caracteres não numéricos
  CleanCNPJ := OnlyNumbers(aCNPJ);

  // Verifica se o CNPJ possui 14 dígitos
  if Length(CleanCNPJ) <> 14 then
    Exit(False);

  // Inicializa os pesos
  var Weights1 := [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  var Weights2 := [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  // Calcula o primeiro dígito verificador
  Sum := 0;
  for I := 0 to 11 do
    Sum := Sum + StrToInt(CleanCNPJ[I+1]) * Weights1[I];

  Digit := 11 - (Sum mod 11);
  if Digit >= 10 then
    Digit := 0;

  if Digit <> StrToInt(CleanCNPJ[13]) then
    Exit(False);

  // Calcula o segundo dígito verificador
  Sum := 0;
  for I := 0 to 12 do
    Sum := Sum + StrToInt(CleanCNPJ[I+1]) * Weights2[I];

  Digit := 11 - (Sum mod 11);
  if Digit >= 10 then
    Digit := 0;

  Result := Digit = StrToInt(CleanCNPJ[14]);
end;

class function TUtils.IsCPFValid(const aCPF: string): Boolean;
var
  i, Sum, Digit: Integer;
  TempCPF: string;
begin
  Result := False;

  // Remove caracteres não numéricos
  TempCPF := OnlyNumbers(aCPF);

  // O CPF deve ter 11 dígitos
  if Length(TempCPF) <> 11 then
    Exit;

  // Verifica se todos os dígitos são iguais
  if (TempCPF = StringOfChar(TempCPF[1], 11)) then
    Exit;

  // Valida o primeiro dígito verificador
  Sum := 0;
  for i := 1 to 9 do
    Sum := Sum + StrToInt(TempCPF[i]) * (11 - i);
  Digit := (Sum * 10) mod 11;
  if Digit = 10 then
    Digit := 0;
  if Digit <> StrToInt(TempCPF[10]) then
    Exit;

  // Valida o segundo dígito verificador
  Sum := 0;
  for i := 1 to 10 do
    Sum := Sum + StrToInt(TempCPF[i]) * (12 - i);
  Digit := (Sum * 10) mod 11;
  if Digit = 10 then
    Digit := 0;
  if Digit <> StrToInt(TempCPF[11]) then
    Exit;

  Result := True;
end;

class function TUtils.OnlyNumbers(aValue: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := Low(aValue) to High(aValue) do
    if CharInSet(aValue[i], ['0' .. '9']) then
      Result := Result + aValue[i];
end;

{class procedure TUtils.ResourceImage(Resource: String; Image: TFMXObject);
begin
  var lResource := TResourceStream.Create(HInstance, Resource, RT_RCDATA);
    try
      TShape(Image).Fill.Bitmap.Bitmap.LoadFromStream(lResource);
    finally
      lResource.Free;
    end;
end;}

class function TUtils.UpperCamelCase(value: String): String;
begin
  Result := UpperCase(Copy(Value, 1, 1)) + LowerCase(Copy(Value, 2, Length(Value)));
end;

end.
