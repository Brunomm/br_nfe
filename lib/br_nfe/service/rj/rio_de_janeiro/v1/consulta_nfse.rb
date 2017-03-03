module BrNfe
	module Service
		module RJ
			module RioDeJaneiro
				module V1
					class ConsultaNfse < BrNfe::Service::RJ::RioDeJaneiro::V1::Base
						include BrNfe::Service::Concerns::Rules::ConsultaNfse
						
						def method_wsdl
							:consultar_nfse
						end
						
						def xml_builder
							render_xml 'servico_consultar_nfse_envio'
						end

						# Tag root da requisição
						#
						def soap_body_root_tag
							'ConsultarNfseRequest'
						end
					private

						def set_response
							@response = BrNfe::Service::Response::Build::ConsultaNfse.new(
								savon_response: @original_response, # Rsposta da requisição SOAP
								keys_root_path: [], # Caminho inicial da resposta / Chave pai principal
								body_xml_path:  [:consultar_nfse_response, :output_xml],
								xml_encode:     response_encoding, # Codificação do xml de resposta
								
								#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
								nfe_xml_path:                '//*/*/*/*',
								
								invoices_path:               [:consultar_nfse_resposta, :lista_nfse, :comp_nfse],
								message_errors_path:         [:consultar_nfse_resposta, :lista_mensagem_retorno, :mensagem_retorno]
							).response
						end
						def response_class
							BrNfe::Service::Response::ConsultaNfse
						end
					end
				end
			end
		end
	end
end