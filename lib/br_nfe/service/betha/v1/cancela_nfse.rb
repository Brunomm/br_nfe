module BrNfe
	module Service
		module Betha
			module V1
				class CancelaNfse < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs
					
					def certificado_obrigatorio?
						true
					end

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/cancelarNfse?wsdl"
					end
					
					def method_wsdl
						:cancelar_nfse_envio
					end

					def xml_builder
						render_xml 'servico_cancelar_nfse_envio'
					end

					def tag_id
						:Id
					end

				private

					def set_response
						@response = BrNfe::Service::Response::Build::Cancelamento.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:cancelar_nfse_envio_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							data_hora_cancelamento_path: [:cancelar_nfse_resposta, :cancelamento, :confirmacao, :inf_confirmacao_cancelamento, :data_hora],
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