module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps
					
					def url_wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfsePorRps?wsdl"
					end

					def method_wsdl
						:consultar_nfse_por_rps_envio
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_rps_envio'
					end
				private

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaNfsPorRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:consultar_nfse_rps_envio_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
							nfe_xml_path:                '//*/*/*/*',
							invoice_url_nf_path: [:nfse, :inf_nfse, :outras_informacoes]
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