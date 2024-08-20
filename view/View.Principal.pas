unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Data.DB, Vcl.DBGrids, Datasnap.DBClient,
  Classe.Pessoa,
  Classe.Funcionario,
  Classe.Vendedor,
  Classe.Administrativo;

type
  TEnumFuncao = (tpAdministrativo, tpVendedor, tpFuncionario);
  TOperacao = (tpIncluir, tpEditar, tpNull);

  TfrmCadPessoas = class(TForm)
    Memo1: TMemo;
    btnSalvar: TButton;
    btnExibirFolha: TButton;
    btnNovo: TButton;
    btnExcluir: TButton;
    pnlBottom: TPanel;
    lblRegistro: TLabel;
    CDS: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbbFuncao: TComboBox;
    edtNome: TEdit;
    edtSalario: TEdit;
    edtExtras: TEdit;
    edtNascimento: TEdit;
    btnEditar: TButton;
    btnCancelar: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSalarioExit(Sender: TObject);
    procedure btnExibirFolhaClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure cbbFuncaoChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cbbFuncaoExit(Sender: TObject);
    procedure edtNascimentoKeyPress(Sender: TObject; var Key: Char);
    procedure edtSalarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtExtrasKeyPress(Sender: TObject; var Key: Char);
    procedure edtExtrasExit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure edtNascimentoExit(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
  private
    FOperacao: TOperacao;
    FLista: TObjectList<TPessoa>;
    FNovoCodigo: Integer;
    procedure DefinirEstruturaCDS;
    procedure Cria_Administrativo;
    procedure Cria_Vendedor;
    procedure Cria_Funcionario;
    procedure LimparCampos;
    procedure PreencheForm(Registro: Integer);
    procedure AtualizaInfo;
    procedure AddToList(aPerson: TPessoa);
    procedure ChangeObjectOfList(Codigo: String);
    procedure PreencheCDS(aPerson: TPessoa);
    function FuncaoDaPessoa(aPerson: TPessoa): string;
    function SearchRegistro(Codigo: String): Integer;
    function ProximoCodigo: String;
  end;

var
  frmCadPessoas: TfrmCadPessoas;

implementation

uses
  uFormat;

{$R *.dfm}

procedure TfrmCadPessoas.btnSalvarClick(Sender: TObject);
begin
  try
    if FOperacao = tpIncluir then
    begin
      case TEnumFuncao(cbbFuncao.ItemIndex) of
        tpAdministrativo:
          Cria_Administrativo;
        tpVendedor:
          Cria_Vendedor;
        tpFuncionario:
          Cria_Funcionario;
      end;
    end
    else
      ChangeObjectOfList(CDS.FieldByName('Codigo').AsString);
    LimparCampos;
    btnSalvar.Enabled := False;
    btnNovo.Enabled := True;
    GroupBox1.Enabled := False;
    btnCancelar.Enabled := False;
    btnExcluir.Enabled := False;
    FOperacao := tpNull;
    AtualizaInfo;
  except
    On E: Exception do
      ShowMessage('Falha ao cadastrar o funcionário. Erro: ' + E.Message);
  end;
end;

procedure TfrmCadPessoas.cbbFuncaoChange(Sender: TObject);
begin
  if TEnumFuncao(cbbFuncao.ItemIndex) = tpFuncionario then
  begin
    Label4.Visible := False;
    edtExtras.Visible := False;
  end
  else
  begin
    Label4.Visible := True;
    edtExtras.Visible := True;
    Label4.Left := 340;
    Label4.Caption := 'Valor Extra:';
  end;

  if TEnumFuncao(cbbFuncao.ItemIndex) = tpVendedor then
  begin
    Label4.Left := 315;
    Label4.Caption := '% de Comissão:';
  end;
end;

procedure TfrmCadPessoas.cbbFuncaoExit(Sender: TObject);
begin
  cbbFuncaoChange(Sender);
end;

procedure TfrmCadPessoas.FormCreate(Sender: TObject);
begin
  LimparCampos;
  FLista := TObjectList<TPessoa>.Create;
  DefinirEstruturaCDS;
  FNovoCodigo := 0;
end;

procedure TfrmCadPessoas.FormDestroy(Sender: TObject);
begin
  FLista.Free;
end;

procedure TfrmCadPessoas.AtualizaInfo;
begin
  if FLista.Count > 0 then
  begin
    if not btnExibirFolha.Enabled then
      btnExibirFolha.Enabled := True;
    lblRegistro.Caption := 'Total de Registros: ' + FLista.Count.ToString();
  end
  else
  begin
    lblRegistro.Caption := 'Não há registros.';
    if btnExibirFolha.Enabled then
      btnExibirFolha.Enabled := False;
  end;
end;

procedure TfrmCadPessoas.LimparCampos;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TEdit then
      TEdit(Components[I]).Text := '';
  Memo1.Lines.Clear;
end;

procedure TfrmCadPessoas.PreencheForm(Registro: Integer);
begin
  edtNome.Text := FLista[Registro].Nome;
  edtNascimento.Text := DateTimeToStr(FLista[Registro].Nascimento);
  if FLista[Registro].ClassName = 'TAdministrativo' then
  begin
    cbbFuncao.ItemIndex := Integer(tpAdministrativo);
    edtSalario.Text := TAdministrativo(FLista[Registro]).getSalario;
    edtExtras.Text := TAdministrativo(FLista[Registro]).getBonus;
  end;
  if FLista[Registro].ClassName = 'TVendedor' then
  begin
    cbbFuncao.ItemIndex := Integer(tpVendedor);
    edtSalario.Text := TVendedor(FLista[Registro]).getSalario;
    edtExtras.Text := TVendedor(FLista[Registro]).getComissao;
  end;
  if FLista[Registro].ClassName = 'TFuncionario' then
  begin
    cbbFuncao.ItemIndex := Integer(tpFuncionario);
    edtSalario.Text := TFuncionario(FLista[Registro]).getSalario;
  end;
  btnSalvar.Enabled := True;
  btnNovo.Enabled := True;
  btnExcluir.Enabled := True;
end;

function TfrmCadPessoas.ProximoCodigo: String;
begin
  FNovoCodigo := FNovoCodigo + 1;
  Result := Format('%.4d', [FNovoCodigo]);
end;

function TfrmCadPessoas.FuncaoDaPessoa(aPerson: TPessoa): string;
var
  funcao: String;
begin
  funcao := 'Funcionário';
  if aPerson.ClassName = 'TAdministrativo' then
    funcao := 'Administrativo'
  else if aPerson.ClassName = 'TVendedor' then
    funcao := 'Vendedor';

  Result := funcao;
end;

procedure TfrmCadPessoas.PreencheCDS(aPerson: TPessoa);
var
  I: Integer;
  funcao: String;
begin
  funcao := FuncaoDaPessoa(aPerson);
  CDS.DisableControls;
  try
    if FOperacao = tpIncluir then
      CDS.Append
    else if CDS.Locate('Codigo', aPerson.Codigo, [loCaseInsensitive]) then
    begin
      if FOperacao = tpEditar then
        CDS.Edit
      else
      begin
        CDS.Delete;
        Exit;
      end;
    end;
    CDS.FieldByName('Codigo').AsString := aPerson.Codigo;
    CDS.FieldByName('Nome').AsString := aPerson.Nome;
    CDS.FieldByName('Salario').AsString := aPerson.CalcularSalario;
    CDS.FieldByName('Funcao').AsString := funcao;
    CDS.Post;
  finally
    CDS.EnableControls;
  end;
end;

procedure TfrmCadPessoas.AddToList(aPerson: TPessoa);
begin
  FLista.Add(aPerson);
  PreencheCDS(aPerson);
end;

function TfrmCadPessoas.SearchRegistro(Codigo: String): Integer;
var
  Registro: Integer;
begin
  Registro := -1;
  for var I := 0 to Pred(FLista.Count) do
  begin
    if Codigo = FLista[I].Codigo then
    begin
      Registro := I;
      Break;
    end;
  end;

  Result := Registro;
end;

procedure TfrmCadPessoas.btnCancelarClick(Sender: TObject);
begin
  LimparCampos;
  GroupBox1.Enabled := False;
  FOperacao := tpNull;
  btnCancelar.Enabled := False;
  btnSalvar.Enabled := False;
  btnExcluir.Enabled := False;
  btnNovo.Enabled := True;
end;

procedure TfrmCadPessoas.btnEditarClick(Sender: TObject);
var
  Codigo: String;
  Registro: Integer;
begin
  btnEditar.Enabled := False;
  btnCancelar.Enabled := True;
  btnExcluir.Enabled := False;
  btnNovo.Enabled := False;
  FOperacao := tpEditar;
  GroupBox1.Enabled := True;
  Codigo := CDS.FieldByName('Codigo').AsString;
  Registro := SearchRegistro(Codigo);
  if Registro > -1 then
  begin
    FOperacao := tpEditar;
    PreencheForm(Registro);
    cbbFuncao.SetFocus;
  end
  else
    raise Exception.Create('Falha ao alterar o registro.');
end;

procedure TfrmCadPessoas.btnExcluirClick(Sender: TObject);
var
  Codigo: String;
  Registro: Integer;
begin
  Codigo := CDS.FieldByName('Codigo').AsString;
  Registro := SearchRegistro(Codigo);
  if Registro > -1 then // Se encontrou
  begin
    PreencheForm(Registro);
    if MessageDlg('Confirma a exclusão deste registro?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      CDS.Delete;
      FLista.Delete(Registro);
      LimparCampos;
      btnExcluir.Enabled := False;
      btnSalvar.Enabled := False;
      btnEditar.Enabled := False;
    end;
  end
  else
    raise Exception.Create('Falha ao deletar o registro.');
end;

procedure TfrmCadPessoas.btnExibirFolhaClick(Sender: TObject);
var
  Total: Currency;
  StrAux: String;
begin
  if FLista.Count > 0 then
  begin
    Memo1.Visible := True;
    Memo1.Lines.Clear;
    for var Pessoa in FLista do
    begin
      if Pessoa.ClassName = 'TAdministrativo' then
        Memo1.Lines.Add(TAdministrativo(Pessoa).ImprimeInfo);
      if Pessoa.ClassName = 'TVendedor' then
        Memo1.Lines.Add(TVendedor(Pessoa).ImprimeInfo);
      if Pessoa.ClassName = 'TFuncionario' then
        Memo1.Lines.Add(TFuncionario(Pessoa).ImprimeInfo);
      Memo1.Lines.Add('-------------------------------------------------------');
    end;

    Total := 0.0;
    for var Pessoa in FLista do
    begin
      StrAux := StringReplace(Pessoa.CalcularSalario, '.', '', [rfReplaceAll]);
      Total := Total + StrToCurr(StrAux);
    end;
    lblRegistro.Caption := 'Total da Folha: R$ ' +
      FormatCurr('#,##0.00', Total);
  end;
end;

procedure TfrmCadPessoas.btnNovoClick(Sender: TObject);
begin
  GroupBox1.Enabled := True;
  LimparCampos;
  FOperacao := tpIncluir;
  btnNovo.Enabled := False;
  btnCancelar.Enabled := True;
  btnEditar.Enabled := False;
  btnExcluir.Enabled := False;
  btnExibirFolha.Enabled := False;
  cbbFuncao.SetFocus;
end;

procedure TfrmCadPessoas.ChangeObjectOfList(Codigo: String);
var
  Registro: Integer;
  Salario: Double;
  Extras: Double;
begin
  Registro := SearchRegistro(Codigo);
  if Registro = -1 then
    raise Exception.Create('Não há registro com este Código na lista.');

  if not TryStrToFloat(edtSalario.Text, Salario) then
    Salario := 0.00;

  FLista[Registro].SetNome(edtNome.Text);
  FLista[Registro].SetNascimento(edtNascimento.Text);

  if FLista[Registro].ClassName = 'TAdministrativo' then
  begin
    TAdministrativo(FLista[Registro]).SetSalario(Salario);
    if not TryStrToFloat(edtExtras.Text, Extras) then
      Extras := 0.0;
    TAdministrativo(FLista[Registro]).SetBonus(Extras);
  end
  else if FLista[Registro].ClassName = 'TVendedor' then
  begin
    TVendedor(FLista[Registro]).SetSalario(Salario);
    if not TryStrToFloat(edtExtras.Text, Extras) then
      Extras := 0.0;
    TVendedor(FLista[Registro]).SetComissao(Extras);
  end
  else
    TFuncionario(FLista[Registro]).SetSalario(Salario);

  PreencheCDS(FLista[Registro]);
end;

procedure TfrmCadPessoas.Cria_Administrativo;
var
  Adm: TAdministrativo;
  vlrExtras, vlrSalario: Double;
begin
  vlrExtras := 0.00;
  Adm := TAdministrativo.Create(ProximoCodigo, edtNome.Text,
    edtNascimento.Text);

  if not TryStrToFloat(edtSalario.Text, vlrSalario) then
    vlrSalario := 0.00;
  Adm.SetSalario(vlrSalario);

  if not TryStrToFloat(edtExtras.Text, vlrExtras) then
    vlrExtras := 0.00;
  Adm.SetBonus(vlrExtras);

  AddToList(Adm)
end;

procedure TfrmCadPessoas.Cria_Funcionario;
var
  Funcionario: TFuncionario;
  Salario: Double;
begin
  if not TryStrToFloat(edtSalario.Text, Salario) then
    Salario := 0.0;

  Funcionario := TFuncionario.Create(ProximoCodigo, edtNome.Text,
    edtNascimento.Text);
  Funcionario.SetSalario(Salario);
  AddToList(Funcionario);
end;

procedure TfrmCadPessoas.Cria_Vendedor;
var
  Vendedor: TVendedor;
  vlrExtras, vlrSalario: Double;
begin
  vlrExtras := 0.00;
  Vendedor := TVendedor.Create(ProximoCodigo, edtNome.Text, edtNascimento.Text);

  if not TryStrToFloat(edtSalario.Text, vlrSalario) then
    vlrSalario := 0.00;
  Vendedor.SetSalario(vlrSalario);

  if not TryStrToFloat(edtExtras.Text, vlrExtras) then
    vlrExtras := 0.00;
  Vendedor.SetComissao(vlrExtras);

  AddToList(Vendedor);
end;

procedure TfrmCadPessoas.DBGrid1CellClick(Column: TColumn);
begin
  if not CDS.IsEmpty then
  begin
    btnEditar.Enabled := True;
    btnExcluir.Enabled := True;
    btnCancelar.Enabled := True;
  end;
end;

procedure TfrmCadPessoas.DBGrid1TitleClick(Column: TColumn);
var
  FieldName: string;
  IndexName: string;
begin
  FieldName := Column.FieldName;
  if CDS.IndexFieldNames = '' then
  begin
    CDS.IndexFieldNames := FieldName;
    Exit;
  end;
  if (CDS.IndexFieldNames = FieldName) then
  begin
    CDS.IndexFieldNames := '';
    IndexName := FieldName + '_DESC';
    CDS.IndexDefs.Clear;
    CDS.AddIndex(IndexName, FieldName, [ixDescending]);
    CDS.IndexName := IndexName;
  end
  else
    CDS.IndexFieldNames := FieldName;
end;

procedure TfrmCadPessoas.DefinirEstruturaCDS;
begin
  with CDS do
  begin
    Close;
    FieldDefs.Clear;
    with FieldDefs do
    begin
      Add('Codigo', ftString, 20);
      Add('Nome', ftString, 60);
      Add('Funcao', ftString, 30);
      Add('Salario', ftString, 20);
    end;
    IndexFieldNames := 'Nome';
    CreateDataSet;
    EmptyDataSet;
  end;
  DataSource1.DataSet := CDS;
end;

procedure TfrmCadPessoas.edtExtrasExit(Sender: TObject);
var
  Value: Double;
begin
  if TryStrToFloat(StringReplace(TEdit(Sender).Text, ',',
    FormatSettings.DecimalSeparator, []), Value) then
    TEdit(Sender).Text := FormatFloat('0.00', Value)
end;

procedure TfrmCadPessoas.edtExtrasKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', ',', #8]) then
    Key := #0;

  if (Key = ',') and (Pos(',', TEdit(Sender).Text) > 0) then
    Key := #0;
end;

procedure TfrmCadPessoas.edtNascimentoExit(Sender: TObject);
var
  BirthDate: TDateTime;
  MinDate : TDateTime;
  IsFailed: Boolean;
begin
  MinDate := StrToDate('1/1/1900');
  IsFailed := False;
  if TryStrToDateTime(TEdit(Sender).Text, BirthDate) then
  begin
    if (BirthDate < MinDate) or (BirthDate > Now) then
      IsFailed := True;
  end
  else
    IsFailed := True;
  if IsFailed then
  begin
    TEdit(Sender).SelectAll;
    raise Exception.Create('Data inválida');
  end;
end;

procedure TfrmCadPessoas.edtNascimentoKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '/', #8]) then
    Key := #0;
  Formatar(edtNascimento, Dt);
end;

procedure TfrmCadPessoas.edtSalarioExit(Sender: TObject);
var
  Value: Double;
begin
  if TryStrToFloat(StringReplace(TEdit(Sender).Text, ',',
    FormatSettings.DecimalSeparator, []), Value) then
    TEdit(Sender).Text := FormatFloat('0.00', Value)
  else
    raise Exception.Create('Valor inválido!');

  if edtSalario.Text <> '' then
  begin
    btnSalvar.Enabled := True;
    if not edtExtras.Visible then
      btnSalvar.SetFocus;
  end
  else
    btnSalvar.Enabled := False;

end;

procedure TfrmCadPessoas.edtSalarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', ',', #8]) then
    Key := #0;

  if (Key = ',') and (Pos(',', TEdit(Sender).Text) > 0) then
    Key := #0;
end;

end.
