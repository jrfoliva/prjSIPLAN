unit UnitEdicao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Calendar,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Layouts, uFancyDialog;

type
  TTipoCampo = (Edit, Data, Senha, Memo, Valor, Inteiro);

  TExecuteOnClose = procedure(Sender: TObject) of Object;

  TFrmEdicao = class(TForm)
    rectToolbar: TRectangle;
    lblTitulo: TLabel;
    btnVoltar: TSpeedButton;
    Image4: TImage;
    btnSalvar: TSpeedButton;
    Image1: TImage;
    edtTexto: TEdit;
    edtSenha: TEdit;
    calendar: TCalendar;
    memo: TMemo;
    StyleBook1: TStyleBook;
    lytValor: TLayout;
    lblValor: TLabel;
    Layout1: TLayout;
    Label2: TLabel;
    Layout2: TLayout;
    Label3: TLabel;
    Layout3: TLayout;
    Label4: TLabel;
    Layout4: TLayout;
    Label5: TLabel;
    Layout5: TLayout;
    Label6: TLabel;
    Layout6: TLayout;
    Label7: TLabel;
    Layout7: TLayout;
    Label8: TLabel;
    Layout8: TLayout;
    Label9: TLabel;
    Layout9: TLayout;
    Label10: TLabel;
    Layout10: TLayout;
    Label11: TLabel;
    Layout11: TLayout;
    Label12: TLabel;
    Layout12: TLayout;
    imgBackspace: TImage;
    procedure btnSalvarClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure imgBackspaceClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fancy: TFancyDialog;
    objeto: TObject;
    ProcExecuteOnClose: TExecuteOnClose;
    obrigatorio: boolean;
    tipo: TTipoCampo;
    procedure TeclaNumero(lbl: TLabel);
    procedure TeclaBackspace;
  public
    procedure Editar(obj: TObject; tipo_campo: TTipoCampo; titulo, text_prompt,
                     texto_padrao: string; ind_obrigatorio: boolean; tam_maximo: integer;
                     ExecuteOnClose: TExecuteOnClose = nil);
  end;

var
  FrmEdicao: TFrmEdicao;

implementation

{$R *.fmx}

procedure TFrmEdicao.btnVoltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmEdicao.Editar(obj: TObject;
                            tipo_campo: TTipoCampo;
                            titulo, text_prompt, texto_padrao: string;
                            ind_obrigatorio: boolean;
                            tam_maximo: integer;
                            ExecuteOnClose: TExecuteOnClose = nil);
var
    dia, mes, ano: integer;
begin
    lblTitulo.Text := titulo;
    objeto := obj;
    ProcExecuteOnClose := ExecuteOnClose;
    obrigatorio := ind_obrigatorio;
    tipo := tipo_campo;

    edtTexto.Visible := tipo_campo = TTipoCampo.Edit;
    edtSenha.Visible := tipo_campo = TTipoCampo.Senha;
    calendar.Visible := tipo_campo = TTipoCampo.Data;
    memo.Visible := tipo_campo = TTipoCampo.Memo;
    lytValor.Visible := (tipo_campo = TTipoCampo.Valor) or (tipo_campo = TTipoCampo.Inteiro);


    if tipo_campo = TTipoCampo.Edit then
    begin
        edtTexto.TextPrompt := text_prompt;
        edtTexto.MaxLength := tam_maximo;
        edtTexto.Text := texto_padrao;
    end;

    if tipo_campo = TTipoCampo.Senha then
    begin
        edtSenha.TextPrompt := text_prompt;
        edtSenha.MaxLength := tam_maximo;
        edtSenha.Text := texto_padrao;
    end;

    if tipo_campo = TTipoCampo.Data then
    begin
        if texto_padrao <> '' then // dd/mm/yyyy
        begin
            dia := Copy(texto_padrao, 1, 2).ToInteger;
            mes := Copy(texto_padrao, 4, 2).ToInteger;
            ano := Copy(texto_padrao, 7, 4).ToInteger;

            calendar.Date := EncodeDate(ano, mes, dia);
        end
        else
            calendar.Date := Date;
    end;

    if tipo_campo = TTipoCampo.Memo then
    begin
        memo.MaxLength := tam_maximo;
        memo.Text := texto_padrao;
    end;

    if tipo_campo = TTipoCampo.Valor then
        lblValor.Text := texto_padrao;

    if tipo_campo = TTipoCampo.Inteiro then
        lblValor.Text := texto_padrao;

    FrmEdicao.Show;
end;

procedure TFrmEdicao.FormCreate(Sender: TObject);
begin
    fancy := TFancyDialog.Create(FrmEdicao);
end;

procedure TFrmEdicao.FormDestroy(Sender: TObject);
begin
    fancy.DisposeOf;
end;

procedure TFrmEdicao.imgBackspaceClick(Sender: TObject);
begin
    TeclaBackspace;
end;

procedure TFrmEdicao.TeclaNumero(lbl: TLabel);
var
    valor: string;
begin
    valor := lblValor.Text;  // 9.500,00
    valor := valor.Replace('.', '');  // 9500,00
    valor := valor.Replace(',', '');  // 950000

    valor := valor + lbl.Text;

    if tipo = TTipoCampo.Valor then
        lblValor.Text := FormatFloat('#,##0.00', valor.ToDouble / 100)
    else
        lblValor.Text := FormatFloat('#,##', valor.ToDouble);
end;

procedure TFrmEdicao.TeclaBackspace();
var
    valor: string;
begin
    valor := lblValor.Text;  // 9.500,00
    valor := valor.Replace('.', '');  // 9500,00
    valor := valor.Replace(',', '');  // 950000

    if Length(valor) > 1 then
        valor := Copy(valor, 1, length(valor) - 1)
    else
        valor := '0';

    if tipo = TTipoCampo.Valor then
        lblValor.Text := FormatFloat('#,##0.00', valor.ToDouble / 100)
    else
        lblValor.Text := FormatFloat('#,##0', valor.ToDouble);
end;

procedure TFrmEdicao.Label2Click(Sender: TObject);
begin
    TeclaNumero(TLabel(Sender));
end;

procedure TFrmEdicao.btnSalvarClick(Sender: TObject);
var
    ret: string;
begin
    if edtTexto.Visible then
        ret := edtTexto.Text
    else if edtSenha.Visible then
        ret := edtSenha.Text
    else if calendar.Visible then
        ret := FormatDateTime('dd/mm/yyyy', calendar.Date)
    else if memo.Visible then
        ret := memo.Text
    else if lytValor.Visible then
        ret := lblValor.Text;

    if (obrigatorio) and (ret = '') then
    begin
        fancy.Show(TIconDialog.Warning, 'Aviso', 'Esse campo é obrigatório', 'OK');
        exit;
    end;

    if objeto is TLabel then
        TLabel(objeto).Text := ret;

    if Assigned(ProcExecuteOnClose) then
        ProcExecuteOnClose(objeto);

    close;
end;

end.
