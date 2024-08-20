unit uAnimations;

interface

uses
  System.SysUtils, System.Classes, FMX.Forms, FMX.Controls, FMX.StdCtrls,
  FMX.Types, FMX.Controls.Presentation, Types,
  System.Skia, FMX.Skia, System.SyncObjs;

type
  TTypeAnimation = (Cancel, Information, Success, Warning, Waiting);

  TAnimation = record
    Filename: String;
    Msg: string;
    Time: Integer;
    constructor Create(const AFileName, AMsg: String; const ATime: Integer);
  end;

  TAnimations = class
  private
    FImage: TSkAnimatedImage;
    FMsg: string;
    FAnimation: TAnimation;
    FAnimationThread: TThread;
    FStopEvent: TEvent;
    FSkLabel: TSkLabel;
    function GetAbsolutePath(const Path: String): String;
    function BuildAnimation(ATypeAnimation: TTypeAnimation): TAnimation;
    procedure CloseAnimation;
  public
    constructor Create(ASkImage: TSkAnimatedImage; ASkLabel: TSkLabel; ATypeAnimation: TTypeAnimation);
    destructor Destroy; override;
    property Image: TSkAnimatedImage read FImage write FImage;
    property SkLabel: TSkLabel read FSkLabel write FSkLabel;
    property Animation: TAnimation read FAnimation write FAnimation;
    procedure ShowAnimation;
    procedure StopAnimation;
  end;

implementation

uses
  uCadCliente;

function TAnimations.GetAbsolutePath(const Path: String): String;
begin
  Result := ExpandFileName(ExtractFilePath(ParamStr(0)) + Path);
end;

procedure TAnimations.ShowAnimation;
begin
  try
    if FileExists(Animation.FileName) then
    begin
      FImage.LoadFromFile(Animation.Filename);
      FImage.Visible := True;
      FImage.Enabled := True;
      FImage.Animation.Enabled := True;
      FSklabel.Text := Animation.Msg;
      FStopEvent.ResetEvent;

      FAnimationThread := TThread.CreateAnonymousThread(
        procedure
        begin
          if Animation.Time = 0 then // Contínuo
          begin
            while FStopEvent.WaitFor(100) = wrTimeout do
            begin
              // Continua a animação até ser parada.
            end;
          end
          else
          begin
            Sleep(Animation.Time);
            CloseAnimation;
          end;       
        end);

        FAnimationThread.FreeOnTerminate := True;
        FAnimationThread.Start;
    end;
  except
    on E: Exception do
      raise Exception.Create('Falha ao ler o arquivo de animação. Erro: ' +
        E.Message);
  end;
end;

procedure TAnimations.StopAnimation;
begin
  FStopEvent.SetEvent;
  CloseAnimation;
end;

procedure TAnimations.CloseAnimation;
begin
  TThread.Queue(nil,
    procedure
    begin
      FImage.Visible := False;
      FImage.Enabled := False;
      FImage.Animation.Enabled := False;
      FSkLabel.Text := '';
    end);
end;

function TAnimations.BuildAnimation(ATypeAnimation: TTypeAnimation): TAnimation;
var
  AbsolutePath: String;
  RelativePath: String;
begin
  case ATypeAnimation of
    Success:
      begin
        RelativePath := '../../src/assets/SuccessAnimation.json';
        AbsolutePath := GetAbsolutePath(RelativePath);
        Result := TAnimation.Create(AbsolutePath, 'Sucesso.', 2000);
      end;
    Cancel:
      begin
        RelativePath := '../../src/assets/CancelAnimation.json';
        AbsolutePath := GetAbsolutePath(RelativePath);
        Result := TAnimation.Create(AbsolutePath,'Operação cancelada.', 2000);
      end;
    Warning:
      begin
        RelativePath := '../../src/assets/WarningAnimation.json';
        AbsolutePath := GetAbsolutePath(RelativePath);
        Result := TAnimation.Create(AbsolutePath,'Atenção!', 2000);
      end;
    Information:
      begin
        RelativePath := '../../src/assets/InformationAnimation.json';
        AbsolutePath := GetAbsolutePath(RelativePath);
        Result := TAnimation.Create(AbsolutePath,'Ação necessária!', 2000);
      end;
    Waiting:
      begin       
        RelativePath := '../../src/assets/WaitingAnimation.json';
        AbsolutePath := GetAbsolutePath(RelativePath);
        Result := TAnimation.Create(AbsolutePath, 'Processando.', 0);
      end;
  end;
end;

constructor TAnimations.Create(ASkImage: TSkAnimatedImage; ASkLabel: TSkLabel; ATypeAnimation: TTypeAnimation);
begin
  FImage := ASkImage;
  FSkLabel := ASkLabel;
  FSkLabel.Text := '';
  FAnimation := BuildAnimation(ATypeAnimation);
  FStopEvent := TEvent.Create(nil, True, False, '');
end;

destructor TAnimations.Destroy;
begin
  StopAnimation;
  FStopEvent.Free;
  inherited;
end;

{ TAnimation }

constructor TAnimation.Create(const AFileName, AMsg: String; const ATime: Integer);
begin
  Filename := AFileName;
  Msg := AMsg;
  Time := ATime;
end;

end.
