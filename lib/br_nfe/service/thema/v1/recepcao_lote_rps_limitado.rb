module BrNfe
	module Service
		module Thema
			module V1
				class RecepcaoLoteRpsLimitado < BrNfe::Service::Thema::V1::RecepcaoLoteRps

					validates :lote_rps, length: { maximum: 3 }
					
					def method_wsdl
						:recepcionar_lote_rps_limitado
					end
					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'recepcionarLoteRpsLimitado'
					end

				private
					def set_response
						@response = BrNfe::Service::Response::Build::RecepcaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [],
							body_xml_path:  [:recepcionar_lote_rps_limitado_response, :return],
							xml_encode:     response_encoding, # Codificação do xml de resposta
						).response
					end
				end
			end
		end
	end
end