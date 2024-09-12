unit ServerModule;

interface

uses
  Classes,
  SysUtils,
  uniGUIServer,
  uniGUIMainModule,
  uniGUIApplication,
  uIdCustomHTTPServer,
  uniGUITypes,
  uniGUI.GerenciadorTemplate.Intf,
  uniGUI.GerenciadorTemplate.Impl;

type
  TUniServerModule = class(TUniGUIServerModule)
    procedure UniGUIServerModuleCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
    FGerenciadorTemplate: IGerenciadorTemplate;
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  UniGUIVars;

function UniServerModule: TUniServerModule;
begin
  Result := TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
begin
  InitServerModule(Self);
end;

procedure TUniServerModule.UniGUIServerModuleCreate(Sender: TObject);
var
  lFactory: IGerenciadorTemplateFactory;
begin
  lFactory := TGerenciadorTemplateFactory.Create;
  FGerenciadorTemplate := lFactory.Criar;
  FGerenciadorTemplate.DiretorioTemplate := '.\Template\TemplateUniGUI\';
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
