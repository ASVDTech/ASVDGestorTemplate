unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniPanel, uniURLFrame;

type
  TMainForm = class(TUniForm)
    procedure UniFormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure OnShowMessage(Params: TUniStrings);
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

procedure TMainForm.OnShowMessage(Params: TUniStrings);
begin
  ShowMessage('Seu Email: ' + Params['email'].AsString + 'Sua Senha: ' + Params['senha'].AsString);
end;

procedure TMainForm.UniFormCreate(Sender: TObject);
begin
  UniServerModule.FGerenciadorTemplate.RegistrarTemplate('index.html', Self, 'Principal');
  UniServerModule.FGerenciadorTemplate.RegistrarCallBack('signin', OnShowMessage);
end;

initialization
  RegisterAppFormClass(TMainForm);

end.
