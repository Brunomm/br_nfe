module BrNfe
	module Service
		module Thema
			module V1
				class CancelaNfse < BrNfe::Service::Thema::V1::Base
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs
					
					def url_wsdl
						get_wsdl_by_city[:cancel]
					end

					def method_wsdl
						:cancelar_nfse
					end

					def xml_builder
						xml = render_xml 'servico_cancelar_nfse_envio'
						sign_nodes = [
							{
								node_path: "//nf:CancelarNfseEnvio/nf:Pedido/nf:InfPedidoCancelamento", 
								node_namespaces: {nf: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'},
								node_ids: ["C#{id_cancelamento}"]
							}
						]
						sign_xml('<?xml version="1.0" encoding="ISO-8859-1"?>'+xml, sign_nodes)
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'cancelarNfse'
					end

				private

					# Não é utilizado o keys_root_path pois
					# esse órgão emissor trata o XML de forma diferente
					# e para instanciar a resposta adequadamente é utilizado o 
					# body_xml_path.
					# A resposta contém outro XML dentro do Body.
					#
					def set_response
						@response = BrNfe::Service::Response::Build::Cancelamento.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [], 
							body_xml_path:  [:cancelar_nfse_response, :return],
							xml_encode:     response_encoding, # Codificação do xml de resposta
							data_hora_cancelamento_path: [:cancelar_nfse_resposta, :cancelamento, :confirmacao, :data_hora_cancelamento],
							codigo_cancelamento_path:    [:cancelar_nfse_resposta, :cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :codigo_cancelamento],
							numero_nfs_path:             [:cancelar_nfse_resposta, :cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :numero],
							message_errors_path:         [:cancelar_nfse_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end

				end
			end
		end
	end
end