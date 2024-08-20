program PrjSIPLAN;

uses
  Vcl.Forms,
  View.Principal in 'view\View.Principal.pas' {frmCadPessoas},
  Classe.Pessoa in 'model\Classe.Pessoa.pas',
  Classe.Vendedor in 'model\Classe.Vendedor.pas',
  Classe.Administrativo in 'model\Classe.Administrativo.pas',
  Classe.Funcionario in 'model\Classe.Funcionario.pas',
  service.utils in 'services\service.utils.pas',
  uFormat in 'services\uFormat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadPessoas, frmCadPessoas);
  Application.Run;
end.
