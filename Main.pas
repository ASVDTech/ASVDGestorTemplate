unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniPanel, uniURLFrame;

type
  TMainForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
  private
    { Private declarations }
    procedure OnShowMessage;
  public
    { Public declarations }
  end;

function MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uniGUIVars,
  MainModule,
  uniGUIApplication,
  ServerModule;

function MainForm: TMainForm;
begin
  Result := TMainForm(UniMainModule.GetFormInstance(TMainForm));
end;

procedure TMainForm.OnShowMessage;
begin
  ShowMessage('Teste');
end;

procedure TMainForm.UniFormAjaxEvent(Sender: TComponent; EventName: string; Params: TUniStrings);
begin
  UniServerModule.FGerenciadorTemplate.InterpretarMetodos(EventName, Params);
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  UniServerModule.FGerenciadorTemplate.RegistrarTemplate('index.html', Self);
  UniServerModule.FGerenciadorTemplate.RegistrarCallBack('move', OnShowMessage);
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
