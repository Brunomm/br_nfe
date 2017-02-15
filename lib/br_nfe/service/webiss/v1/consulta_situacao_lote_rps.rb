module BrNfe
	module Service
		module Webiss
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

					
				private	
					def response_class
						BrNfe::Service::Response::ConsultaSituacaoLoteRps
					end

					def set_response
						@response = BrNfe::Service::Response::Build::ConsultaSituacaoLoteRps.new(
							savon_response: @original_response, # Rsposta da requisição SOAP
							
							# Preencher essa informação quando tem apenas 1 xml com todas as informações
							keys_root_path: [], 
							
							# Preencher quando tem um XML dentro de outro
							body_xml_path:  [:consultar_situacao_lote_rps_response, :consultar_situacao_lote_rps_result],
							
							xml_encode:     response_encoding, # Codificação do xml de resposta
							# situation_key_values: Default,
							lot_number_path:      [:consultar_situacao_lote_rps_resposta, :numero_lote] ,
							situation_path:       [:consultar_situacao_lote_rps_resposta, :situacao],
							message_errors_path:  [:consultar_situacao_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						).response
					end
				end
			end
		end
	end
end