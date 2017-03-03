module BrNfe
	module Service
		module RJ
			module RioDeJaneiro
				module V1
					class RecepcaoLoteRps < BrNfe::Service::RJ::RioDeJaneiro::V1::Base
						include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps

						def method_wsdl
							:recepcionar_lote_rps
						end

						# Tag root da requisição
						#
						def soap_body_root_tag
							'RecepcionarLoteRpsRequest'
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
								
								# Preencher essa informação quando tem apenas 1 xml com todas as informações
								keys_root_path: [],   # Caminho inicial da resposta / Chave pai principal

								# Preencher quando tem um XML dentro de outro
								body_xml_path:  [:recepcionar_lote_rps_response, :output_xml],  # Caminho inicial da resposta / Chave pai principal
								
								xml_encode:     response_encoding, # Codificação do xml de resposta
							).response
						end
					end
				end
			end
		end
	end
end