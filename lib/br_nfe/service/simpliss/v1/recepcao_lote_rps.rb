module BrNfe
	module Service
		module Simpliss
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
					
					def certificado_obrigatorio?
						true
					end

					def method_wsdl
						:recepcionar_lote_rps
					end
					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'RecepcionarLoteRps'
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
							keys_root_path: [:recepcionar_lote_rps_response], # Caminho inicial da resposta / Chave pai principal
							body_xml_path:  nil,
							xml_encode:     response_encoding, # Codificação do xml de resposta
							lot_number_path:      [:recepcionar_lote_rps_result, :numero_lote],
							protocol_path:        [:recepcionar_lote_rps_result, :protocolo],
							received_date_path:   [:recepcionar_lote_rps_result, :data_recebimento],
							message_errors_path:  [:recepcionar_lote_rps_result, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end
				end
			end
		end
	end
end