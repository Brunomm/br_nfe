module BrNfe
	module Service
		module Govbr
			module V1
				class ConsultaSituacaoLoteRps < Base
					attr_accessor :protocolo
					validates :protocolo, presence: true

					def method_wsdl
						:consultar_situacao_lote_rps
					end

					def xml_builder
						render_xml 'servico_consultar_situacao_lote_rps_envio'
					end

					def soap_body_root_tag
						'ConsultarSituacaoLoteRps'
					end

					def message_namespaces
						super.merge({'xmlns:ns3' =>  "http://tempuri.org/servico_consultar_situacao_lote_rps_envio.xsd",})
					end
					
				private	
					def response_class
						BrNfe::Service::Response::ConsultaSituacaoLoteRps
					end

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaSituacaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							keys_root_path: [],
							body_xml_path:  [:consultar_situacao_lote_rps_response, :return],
							xml_encode:     response_encoding, # Codificação do xml de resposta
							lot_number_path:      [:consultar_situacao_lote_rps_result, :numero_lote] ,
							situation_path:       [:consultar_situacao_lote_rps_result, :situacao],
							message_errors_path:  [:consultar_situacao_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end

				end
			end
		end
	end
end