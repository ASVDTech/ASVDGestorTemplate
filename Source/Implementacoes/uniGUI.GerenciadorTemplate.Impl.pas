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
    procedure PreencherPlaceHolders(const pJSName: string; const pArquivo: string);
    procedure OnAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
  strict protected
    function GetDiretorioTemplate: string;
    procedure SetDiretorioTemplate(const pValor: string);

    procedure InterpretarMetodos(const pNomeEvento: string; const pParams: TUniStrings);
    procedure RegistrarTemplate(const pNomeTemplate: string; const pForm: TUniForm; const pNameTemplate: string);
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

procedure TGerenciadorTemplate.OnAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
begin
  InterpretarMetodos(EventName, Params);
end;

procedure TGerenciadorTemplate.PreencherPlaceHolders(const pJSName, pArquivo: string);
var
  lConteudo: TStringList;
begin
  lConteudo := TStringList.Create;
  try
    lConteudo.LoadFromFile(pArquivo);
    lConteudo.Text := StringReplace(lConteudo.Text, '<#JSNAME>', pJSName, [rfReplaceAll]);
    lConteudo.SaveToFile(pArquivo);
  finally
    lConteudo.Free;
  end;
end;

procedure TGerenciadorTemplate.RegistrarCallBack(const pNomeCallback: string; const pMetodo: TProc<TUniStrings>);
begin
  FDicionarioProc.Add(pNomeCallback, pMetodo);
end;

procedure TGerenciadorTemplate.RegistrarTemplate(const pNomeTemplate: string; const pForm: TUniForm; const pNameTemplate: string);
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
    PreencherPlaceHolders(lHTMLFrame.JSName, FDiretorioTemplate + pNomeTemplate);
    lHTMLFrame.OnAjaxEvent := OnAjaxEvent;
    lHTMLFrame.URL := FDiretorioTemplate + pNomeTemplate;
  end else
  begin
    lHTMLFrame := TUniURLFrame.Create(pForm);
    lHTMLFrame.Parent := pForm;
    lHTMLFrame.Align := alClient;
    lHTMLFrame.OnAjaxEvent := OnAjaxEvent;
    PreencherPlaceHolders(lHTMLFrame.JSName, FDiretorioTemplate + pNomeTemplate);
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
