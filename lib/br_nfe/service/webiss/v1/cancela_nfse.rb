module BrNfe
	module Service
		module Webiss
			module V1
				class CancelaNfse < BrNfe::Service::Webiss::V1::Base
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs
					
					def method_wsdl
						:cancelar_nfse
					end

					def xml_builder
						render_xml 'servico_cancelar_nfse_envio'
					end

					def id_attribute?
						false
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'CancelarNfse'
					end

				private

					def set_response
						@response = BrNfe::Service::Response::Build::Cancelamento.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [],
							body_xml_path:  [:cancelar_nfse_response, :cancelar_nfse_result],
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