unit Classe.Vendedor;

interface

uses
  System.SysUtils,
  Classe.Pessoa;

type
  TVendedor = class(TPessoa)
  private
    //FCodigo: Integer;
    FComissao: Currency;
    FSalario: Currency;
  public
    constructor Create(Codigo, Nome, Nascimento: string);
    procedure SetSalario(Value: Double);
    function ImprimeInfo: String; override;
    function CalcularSalario: String; override;
    procedure SetComissao(ValuePerc: Double);
    function getSalario: String;
    function getComissao: String;
  end;


implementation

{ TVendedor }

function TVendedor.CalcularSalario: String;
begin
  Result := FormatFloat('#,##0.00', (FSalario + FComissao));
end;

constructor TVendedor.Create(Codigo, Nome, Nascimento: string);
begin
  inherited Create(Codigo, Nome, Nascimento);
  //FCodigo := Codigo; //(1000 + Random(10000));
  //FSalario := Salario;
end;

function TVendedor.getComissao: String;
begin
  Result := FormatFloat('#,##0.00', FComissao);
end;

function TVendedor.getSalario: String;
begin
  Result := FormatFloat('#,##0.00', FSalario);
end;

procedure TVendedor.SetComissao(ValuePerc: Double);
begin
   FComissao := FSalario * (ValuePerc/100);
end;

procedure TVendedor.SetSalario(Value: Double);
begin
  FSalario := Value;
end;

function TVendedor.ImprimeInfo: String;
begin
  inherited;
  Result := Dados + #13#10 +
            'Função: Vendedor, '+
            'Salário: R$ ' + getSalario +
            ', Comissão: R$ ' + getComissao + #13#10 +
            'Total a receber: R$ ' + CalcularSalario;
end;

end.
