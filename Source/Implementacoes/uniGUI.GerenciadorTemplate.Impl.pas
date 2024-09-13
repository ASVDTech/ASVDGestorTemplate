unit uniGUI.GerenciadorTemplate.Impl;

interface

uses
  SysUtils,
  Classes,
  Rtti,
  Generics.Collections,
  uniGUIForm,
  uniURLFrame,
  uniGUITypes,
  uniGUI.GerenciadorTemplate.Intf;

type
  TGerenciadorTemplate = class(TInterfacedObject, IGerenciadorTemplate)
  strict private
    FDicionarioProc: TDictionary<string, TProc<TUniStrings>>;
    FDiretorioTemplate: string;
    procedure ValidarCamposGerenciador(const pNomeTemplate: string; const pDiretorioTemplate: string);
  strict protected
    function GetDiretorioTemplate: string;
    procedure SetDiretorioTemplate(const pValor: string);

    procedure InterpretarMetodos(const pNomeEvento: string; const pParams: TUniStrings);
    procedure RegistrarTemplate(const pNomeTemplate: string; const pForm: TUniForm);
    procedure RegistrarCallBack(const pNomeCallback: string; const pMetodo: TProc<TUniStrings>);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TGerenciadorTemplateFactory = class(TInterfacedObject, IGerenciadorTemplateFactory)
  public
    function Criar: IGerenciadorTemplate;
  end;

implementation

uses
  Controls;

{ TGerenciadorTemplate }

constructor TGerenciadorTemplate.Create;
begin
  inherited;
  FDicionarioProc := TDictionary<string, TProc<TUniStrings>>.Create;
end;

destructor TGerenciadorTemplate.Destroy;
begin
  FDicionarioProc.Free;
  inherited;
end;

function TGerenciadorTemplate.GetDiretorioTemplate: string;
begin
  Result := FDiretorioTemplate;
end;

procedure TGerenciadorTemplate.InterpretarMetodos(const pNomeEvento: string; const pParams: TUniStrings);
var
  lProcedure: TProc<TUniStrings>;
begin
  if FDicionarioProc.TryGetValue(pNomeEvento, lProcedure) then
  begin
    lProcedure(pParams);
  end;
end;

procedure TGerenciadorTemplate.RegistrarCallBack(const pNomeCallback: string; const pMetodo: TProc<TUniStrings>);
begin
  FDicionarioProc.Add(pNomeCallback, pMetodo);
end;

procedure TGerenciadorTemplate.RegistrarTemplate(const pNomeTemplate: string; const pForm: TUniForm);
var
  lI: Integer;
  lHTMLFrame: TUniURLFrame;
begin
  ValidarCamposGerenciador(pNomeTemplate, FDiretorioTemplate);

  lHTMLFrame := nil;
  for lI := 0 to pForm.ComponentCount - 1 do
  begin
    if pForm.Components[lI] is TUniURLFrame then
    begin
      lHTMLFrame := TUniURLFrame(pForm.Components[lI]);
    end;
  end;

  if Assigned(lHTMLFrame) then
  begin
    lHTMLFrame.URL := FDiretorioTemplate + pNomeTemplate;
  end else
  begin
    lHTMLFrame := TUniURLFrame.Create(pForm);
    lHTMLFrame.Parent := pForm;
    lHTMLFrame.Align := alClient;
    lHTMLFrame.URL := FDiretorioTemplate + pNomeTemplate;
  end;
end;

procedure TGerenciadorTemplate.SetDiretorioTemplate(const pValor: string);
begin
  FDiretorioTemplate := pValor;
end;

procedure TGerenciadorTemplate.ValidarCamposGerenciador(const pNomeTemplate, pDiretorioTemplate: string);
begin
  if pDiretorioTemplate = string.Empty then
    raise Exception.Create('Preencha o Diretório do Template')
  else if not FileExists(pDiretorioTemplate + pNomeTemplate) then
    raise Exception.Create('Template não existe, verifique o diretório!');
end;

{ TGerenciadorTemplateFactory }

function TGerenciadorTemplateFactory.Criar: IGerenciadorTemplate;
begin
  Result := TGerenciadorTemplate.Create;
end;

end.
