module BrNfe
	module Service
		module Simpliss
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps
					
					def method_wsdl
						:consultar_nfse_por_rps
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_rps_envio'
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarNfsePorRps'
					end

				private

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaNfsPorRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:consultar_nfse_por_rps_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							
							#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
							nfe_xml_path:                '//*/*/*/*',
							
							invoices_path:               [:consultar_nfse_por_rps_result, :comp_nfse],
							message_errors_path:         [:consultar_nfse_por_rps_result, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end
					def response_class
						BrNfe::Service::Response::ConsultaNfsPorRps
					end

				end
			end
		end
	end
end