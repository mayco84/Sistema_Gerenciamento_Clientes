unit ModelPesquisarCliente;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, uDM;

type
  TClienteModel = class
  public
    function PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,PorEMail: Boolean): TDataSet;
  end;

implementation

function TClienteModel.PesquisarClientes(const Filtro: string; const PorCodigo, PorNome,PorEMail: Boolean): TDataSet;
var
  Query: TFDQuery;
begin
 Query := TFDQuery.Create(nil);
  try
    Query.Connection := DM.Conexao;

    // Monta a consulta SQL inicial
    Query.SQL.Text := 'SELECT id, NomeCompleto, CPF, Telefone, Email FROM Cliente WHERE 1=1';

    // Adiciona condi��es baseadas nos filtros
    if PorCodigo then
      Query.SQL.Add('AND id LIKE :FiltroCodigo');
    if PorNome then
      Query.SQL.Add('AND NomeCompleto LIKE :FiltroNome');
    if PorEmail then
      Query.SQL.Add('AND Email LIKE :FiltroEmail');

    // Define os par�metros para cada filtro aplicado
    if PorCodigo then
      Query.ParamByName('FiltroCodigo').AsString := '%' + Filtro + '%';
    if PorNome then
      Query.ParamByName('FiltroNome').AsString := '%' + Filtro + '%';
    if PorEmail then
      Query.ParamByName('FiltroEmail').AsString := '%' + Filtro + '%';

    // Executa a consulta
    Query.Open;

    // Retorna o dataset com os dados
    Result := Query;
  except
    on E: Exception do
    begin
      Query.Free; // Libera a query somente em caso de erro
      raise;      // Relan�a a exce��o para tratamento externo
    end;
  end;
  {//*
   A destrui��o da Query ocorre apenas no bloco except se houver uma exce��o. Caso contr�rio,
    a Query � retornada como Result e sua responsabilidade de liberar passa para quem chamou a fun��o.
  *//}
end;

end.

