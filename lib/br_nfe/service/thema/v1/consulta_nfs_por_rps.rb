module BrNfe
	module Service
		module Thema
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Thema::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps
					
					def url_wsdl
						get_wsdl_by_city[:consult]
					end

					def method_wsdl
						:consultar_nfse_por_rps
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_rps_envio'
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'consultarNfsePorRps'
					end

				private

					# Não é utilizado o keys_root_path pois
					# esse órgão emissor trata o XML de forma diferente
					# e para instanciar a resposta adequadamente é utilizado o 
					# body_xml_path.
					# A resposta contém outro XML dentro do Body.
					#
					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaNfsPorRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [],
							body_xml_path:  [:consultar_nfse_por_rps_response, :return],
							xml_encode:     response_encoding, # Codificação do xml de resposta
							
							#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
							nfe_xml_path:                '//*',
							
							invoices_path:               [:consultar_nfse_rps_resposta, :lista_nfse, :comp_nfse],
							message_errors_path:         [:consultar_nfse_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
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