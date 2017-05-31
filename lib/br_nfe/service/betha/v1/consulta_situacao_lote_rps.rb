module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaSituacaoLoteRps < BrNfe::Service::Betha::V1::ConsultaLoteRps
					def url_wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarSituacaoLoteRps?wsdl"
					end

					def method_wsdl
						:consultar_situacao_lote_rps_envio
					end
					
					def xml_builder
						render_xml 'servico_consultar_situacao_lote_rps_envio'
					end

				private

					def response_class
						BrNfe::Service::Response::ConsultaSituacaoLoteRps
					end

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaSituacaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:consultar_situacao_lote_rps_envio_response],
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
						).response
					end

				end
			end
		end
	end
end