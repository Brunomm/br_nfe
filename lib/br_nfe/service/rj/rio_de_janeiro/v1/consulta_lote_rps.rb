module BrNfe
	module Service
		module RJ
			module RioDeJaneiro
				module V1
					class ConsultaLoteRps < BrNfe::Service::RJ::RioDeJaneiro::V1::Base
						
						attr_accessor :protocolo
						validates :protocolo, presence: true

						def method_wsdl
							:consultar_lote_rps
						end

						def xml_builder
							render_xml 'servico_consultar_lote_rps_envio'
						end

						# Tag root da requisição
						#
						def soap_body_root_tag
							'ConsultarLoteRpsRequest'
						end
					private

						def set_response
							@response = BrNfe::Service::Response::Build::ConsultaLoteRps.new(
								savon_response: @original_response, # Rsposta da requisição SOAP
								keys_root_path: [], # Caminho inicial da resposta / Chave pai principal
								body_xml_path:  [:consultar_lote_rps_response, :output_xml],
								xml_encode:     response_encoding, # Codificação do xml de resposta
								nfe_xml_path:                '//*/*/*/*/*/*/*',
								# nfe_xml_path:                '//*',
								invoices_path:               [:consultar_lote_rps_resposta, :lista_nfse, :comp_nfse],
								message_errors_path:         [:consultar_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
							).response
						end
						def response_class
							BrNfe::Service::Response::ConsultaLoteRps
						end
					end
				end
			end
		end
	end
end