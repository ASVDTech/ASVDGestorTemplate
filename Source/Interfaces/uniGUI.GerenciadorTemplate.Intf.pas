unit uniGUI.GerenciadorTemplate.Intf;

interface

uses
  SysUtils,
  Classes,
  Rtti,
  Generics.Collections,
  uniGUITypes,
  uniGUIForm;

type
  IGerenciadorTemplate = interface
    ['{66BCCCDF-8F06-42A2-A377-43C66B31B075}']

    function GetDiretorioTemplate: string;
    procedure SetDiretorioTemplate(const pValor: string);

    procedure InterpretarMetodos(const pNomeEvento: string; const pParams: TUniStrings);
    procedure RegistrarTemplate(const pNomeTemplate: string; const pForm: TUniForm);
    procedure RegistrarCallBack(const pNomeCallback: string; const pMetodo: TProc<TUniStrings>);

    property DiretorioTemplate: string read GetDiretorioTemplate write SetDiretorioTemplate;
  end;

  IGerenciadorTemplateFactory = interface
    ['{AEFC16E7-37A2-49BE-877A-73B48F5D93AE}']

    function Criar: IGerenciadorTemplate;
  end;

implementation

end.
