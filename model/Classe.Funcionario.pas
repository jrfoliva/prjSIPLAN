unit Classe.Funcionario;

interface

uses
  System.SysUtils,
  Classe.Pessoa;

type
  TFuncionario = class(TPessoa)
    private
      FSalario: Double;
    public
      constructor Create(Codigo, Nome, Nascimento: String);
      function CalcularSalario: String; override;
      function ImprimeInfo: string; override;
      function getSalario: string;
      procedure setSalario(Value: Double);
  end;

implementation

{ TFuncionario }

function TFuncionario.CalcularSalario: String;
begin
  Result := FormatFloat('#,##0.00', FSalario);
end;

constructor TFuncionario.Create(Codigo, Nome, Nascimento: String);
begin
  inherited Create(Codigo, Nome, Nascimento);
  //FSalario := Salario;
end;

function TFuncionario.getSalario: string;
begin
  Result := FormatFloat('##0.00', FSalario);
end;

function TFuncionario.ImprimeInfo: string;
begin
  inherited;
  Result := Dados + ', Salário: R$ '+ CalcularSalario;
end;

procedure TFuncionario.setSalario(Value: Double);
begin
  FSalario := Value;
end;

end.
