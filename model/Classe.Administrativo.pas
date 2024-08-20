unit Classe.Administrativo;

interface

uses
  System.SysUtils,
  Classe.Pessoa;

type
  TAdministrativo = class(TPessoa)
  private
    FSalario: Currency;
    FBonus: Currency;
  public
    constructor Create(Codigo, Nome, Nascimento: String);
    procedure SetSalario(Value: Double);
    procedure SetBonus(Value: Double);
    function CalcularSalario: String; override;
    function getSalario: string;
    function getBonus: string;
    function ImprimeInfo: String; override;
  end;

implementation

{ TAdministrativo }

function TAdministrativo.CalcularSalario: String;
begin
  Result := FormatFloat('#,##0.00', (FSalario + FBonus));
end;

constructor TAdministrativo.Create(Codigo, Nome, Nascimento: String);
begin
  inherited Create(Codigo, Nome, Nascimento);
  //FSalario := Salario;
end;

function TAdministrativo.getBonus: string;
begin
  Result := FormatFloat('0.00', FBonus);
end;

function TAdministrativo.getSalario: string;
begin
  Result :=  FormatFloat('0.00', FSalario);
end;

procedure TAdministrativo.SetBonus(Value: Double);
begin
  FBonus := Value;
end;

procedure TAdministrativo.SetSalario(Value: Double);
begin
  FSalario := Value;
end;

function TAdministrativo.ImprimeInfo: String;
begin
  inherited;
  Result := Dados + #13#10 +
            'Função: Administrativo, ' +
            'Salário: R$ ' + getSalario +
            ', Bônus: R$ ' + getBonus + #13#10 +
            'Total a receber: R$ ' + CalcularSalario;
end;

end.
