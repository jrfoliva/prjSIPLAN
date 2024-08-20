unit Classe.Pessoa;

interface

uses
  System.SysUtils;

type
  TPessoa = class
  private
    FCodigo: string;
    FNome: string;
    FDados: string;
    FNascimento: TDateTime;

  public
    constructor Create(Codigo, Nome, Nascimento: String);
    property Codigo: String read FCodigo;
    property Nome: String read FNome;
    property Nascimento: TDateTime read FNascimento;
    property Dados: string read FDados write FDados;
    procedure SetNascimento(const Value: String);
    procedure SetNome(const Value: String);
    function CalcularSalario: String; virtual; abstract;
    function ImprimeInfo: string; virtual;
    function Idade: String;
  end;


implementation

{ TPessoa }

constructor TPessoa.Create(Codigo, Nome, Nascimento: String);
begin
  //FCodigo := (1000 + Random(10000)).ToString;
  FCodigo := Codigo;
  FNome := Nome;
  SetNascimento(Nascimento);
end;

function TPessoa.Idade: String;
begin
  Result := Trunc((now - FNascimento) / 365.25).ToString();
end;

function TPessoa.ImprimeInfo: string;
begin
  Dados := Format('Código: %s, Nome: %s, Nascimento: %s, Idade: %s anos.',
                   [FCodigo, FNome, DateToStr(FNascimento), Idade] );
  Result := Dados;
end;

procedure TPessoa.SetNascimento(const Value: String);
begin
  if not TryStrToDateTime(Value, FNascimento) then
    raise Exception.Create('Data inválida');
  FNascimento := StrToDateTime(Value);
end;

procedure TPessoa.SetNome(const Value: String);
begin
  if Value = '' then
    raise Exception.Create('Nome inválido.');
  FNome := Value;
end;

end.
