module BrNfe
	module Service
		module Betha
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
					
					def certificado_obrigatorio?
						true
					end

					def url_wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/recepcionarLoteRps?wsdl"
					end
					def method_wsdl
						:enviar_lote_rps_envio
					end

					def id_attribute?
						false
					end

					def xml_builder
						render_xml 'servico_enviar_lote_rps_envio'
					end
				private
					def response_class
						BrNfe::Service::Response::RecepcaoLoteRps
					end

					def set_response
						@response = BrNfe::Service::Response::Build::RecepcaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [:enviar_lote_rps_envio_response],
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
						).response
					end
				end
			end
		end
	end
end