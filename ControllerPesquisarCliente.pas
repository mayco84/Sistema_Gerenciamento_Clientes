unit ControllerPesquisarCliente;

interface

uses
  System.SysUtils, ModelPesquisarCliente, Data.DB, IViewPesquisarCliente;  // Importa a interface

type
  TClienteController = class
  private
    FModel: TClienteModel;
    FView: IViewPesquisarClientes;  // Usa a interface, n�o a classe diretamente
  public
    constructor Create(AView: IViewPesquisarClientes);  // Recebe a interface da View
    destructor Destroy; override;
    procedure PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,EMail: Boolean);
  end;

implementation

constructor TClienteController.Create(AView: IViewPesquisarClientes);
begin
  FModel := TClienteModel.Create;  // Cria a Model
  FView := AView;  // Armazena a refer�ncia da View atrav�s da interface
end;

destructor TClienteController.Destroy;
begin
  FModel.Free;
  inherited;
end;

procedure TClienteController.PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,EMail: Boolean);
var
  Clientes: TDataSet;
begin
  // Chama a Model para realizar a pesquisa
  Clientes := FModel.PesquisarClientes(Filtro, PorCodigo, PorNome,EMail);

  // A View ser� respons�vel por chamar esse m�todo para atualizar a grid
  if Assigned(FView) then
    FView.AtualizarGrid(Clientes);  // Chama a fun��o de atualiza��o da Grid na View
end;

end.

