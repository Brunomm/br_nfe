module BrNfe
	module Service
		module Fisslex
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Fisslex::V1::Base
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
										
					def wsdl
						get_wsdl_by_city[:recepcionar_lote_rps]
					end

					def xml_builder
						render_xml 'servico_enviar_lote_rps_envio'
					end

					# Método é sobrescrito para atender o padrão do órgão emissor.
					def content_xml
						dados =  "<fiss:#{soap_body_root_tag}>"
						dados << 	"<fiss:Enviarloterpsenvio>"
						dados << 		"#{xml_builder.html_safe}".br_nfe_escape_html
						dados << 	"</fiss:Enviarloterpsenvio>"
						dados << "</fiss:#{soap_body_root_tag}>"
						dados
					end
					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'WS_RecepcionarLoteRps.Execute'
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