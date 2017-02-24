module BrNfe
	module Service
		module Fisslex
			module V1
				class CancelaNfse < BrNfe::Service::Fisslex::V1::Base
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs

					def id_attribute?
						false
					end
					
					def wsdl
						get_wsdl_by_city[:cancelar_nfse]
					end
					
					def xml_builder
						render_xml 'servico_cancelar_nfse_envio'
					end

					# Método é sobrescrito para atender o padrão do órgão emissor.
					def content_xml
						dados =  "<fiss:#{soap_body_root_tag}>"
						dados << 	"#{xml_builder.html_safe}".br_nfe_escape_html
						dados << "</fiss:#{soap_body_root_tag}>"
						dados
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'WS_CancelarNfse.Execute'
					end

				private

					def set_response
						@response = BrNfe::Service::Response::Build::Cancelamento.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:cancelar_nfse_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							codigo_cancelamento_path:    [:cancelar_nfse_result, :cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :codigo_cancelamento],
							data_hora_cancelamento_path: [:cancelar_nfse_result, :cancelamento, :confirmacao, :data_hora_cancelamento],
							numero_nfs_path:             [:cancelar_nfse_result, :cancelamento, :confirmacao, :pedido, :inf_pedido_cancelamento, :identificacao_nfse, :numero],
							message_errors_path:         [:cancelar_nfse_result, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end
				end
			end
		end
	end
end