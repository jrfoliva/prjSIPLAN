object frmCadPessoas: TfrmCadPessoas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeToolWin
  Caption = 'Cadastro de Pessoas - Desenvolvido por Junior Freire Oliva'
  ClientHeight = 486
  ClientWidth = 486
  Color = clMenuHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Memo1: TMemo
    Left = 7
    Top = 361
    Width = 471
    Height = 81
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 5
    Visible = False
  end
  object btnSalvar: TButton
    Left = 8
    Top = 173
    Width = 75
    Height = 25
    Hint = 'Salvar um registro.'
    Caption = '&Salvar'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnSalvarClick
  end
  object btnExibirFolha: TButton
    Left = 320
    Top = 327
    Width = 158
    Height = 25
    Hint = 'Informa'#231#245'es e valor pr'#233'vio da folha de pagamento.'
    Caption = 'Pr'#233'via da &Folha'
    Enabled = False
    TabOrder = 4
    OnClick = btnExibirFolhaClick
  end
  object btnNovo: TButton
    Left = 8
    Top = 7
    Width = 75
    Height = 25
    Hint = 'Incluir uma nova pessoa.'
    Caption = '&Novo'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = btnNovoClick
  end
  object btnExcluir: TButton
    Left = 111
    Top = 327
    Width = 75
    Height = 25
    Hint = 'Excluir um registro.'
    Caption = 'E&xcluir'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = btnExcluirClick
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 455
    Width = 486
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    Padding.Top = 2
    Padding.Right = 20
    Padding.Bottom = 2
    TabOrder = 7
    ExplicitTop = 443
    ExplicitWidth = 478
    object lblRegistro: TLabel
      Left = 462
      Top = 2
      Width = 4
      Height = 27
      Align = alRight
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 21
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 212
    Width = 471
    Height = 109
    Hint = 'Selecione um registro para editar ou excluir.'
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'codigo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Title.Caption = 'C'#243'digo'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -12
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Width = 53
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Nome'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -12
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Width = 220
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Funcao'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Title.Caption = 'Fun'#231#227'o'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -12
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Width = 93
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'Salario'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Title.Alignment = taCenter
        Title.Caption = 'Sal'#225'rio'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -12
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Width = 60
        Visible = True
      end>
  end
  object btnEditar: TButton
    Left = 8
    Top = 327
    Width = 75
    Height = 25
    Hint = 'Editar um registro.'
    Caption = '&Editar'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = btnEditarClick
  end
  object btnCancelar: TButton
    Left = 110
    Top = 173
    Width = 75
    Height = 25
    Hint = 'Cancelar uma altera'#231#227'o.'
    Caption = '&Cancelar'
    Enabled = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = btnCancelarClick
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 34
    Width = 471
    Height = 135
    Caption = ' Informa'#231#245'es da Pessoa: '
    Color = clBtnFace
    Enabled = False
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 42
      Height = 15
      Caption = 'Fun'#231#227'o:'
    end
    object Label2: TLabel
      Left = 8
      Top = 65
      Width = 36
      Height = 15
      Caption = 'Nome:'
    end
    object Label3: TLabel
      Left = 159
      Top = 94
      Width = 38
      Height = 15
      Caption = 'Sal'#225'rio:'
    end
    object Label4: TLabel
      Left = 335
      Top = 94
      Width = 58
      Height = 15
      Caption = 'Valor Extra:'
    end
    object Label5: TLabel
      Left = 8
      Top = 94
      Width = 67
      Height = 15
      Caption = 'Nascimento:'
    end
    object cbbFuncao: TComboBox
      Left = 55
      Top = 28
      Width = 409
      Height = 23
      ItemIndex = 0
      TabOrder = 0
      Text = 'Administrativo'
      OnChange = cbbFuncaoChange
      OnExit = cbbFuncaoExit
      Items.Strings = (
        'Administrativo'
        'Vendedor'
        'Funcion'#225'rio')
    end
    object edtNome: TEdit
      Left = 56
      Top = 57
      Width = 408
      Height = 23
      TabOrder = 1
    end
    object edtSalario: TEdit
      Left = 207
      Top = 86
      Width = 65
      Height = 23
      MaxLength = 10
      TabOrder = 3
      OnExit = edtSalarioExit
      OnKeyPress = edtSalarioKeyPress
    end
    object edtExtras: TEdit
      Left = 400
      Top = 86
      Width = 64
      Height = 23
      MaxLength = 10
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnExit = edtExtrasExit
      OnKeyPress = edtExtrasKeyPress
    end
    object edtNascimento: TEdit
      Left = 79
      Top = 86
      Width = 65
      Height = 23
      TabOrder = 2
      OnExit = edtNascimentoExit
      OnKeyPress = edtNascimentoKeyPress
    end
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 496
    Top = 224
  end
  object DataSource1: TDataSource
    Left = 496
    Top = 280
  end
end
