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

					# Caminho de hash através do body da resposta SOAP até encontrar
					# o XML correspondente na qual contém as informações necessárias 
					# para encontrar os valores para setar na resposta
					#
					def body_xml_path
						[:recepcionar_lote_rps_limitado_response, :return]						
					end
				end
			end
		end
	end
end