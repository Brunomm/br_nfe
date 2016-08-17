module BrNfe
	module Service
		module Response
			module Paths
				module V1
					module ServicoConsultarSituacaoLoteRpsResposta
						include BrNfe::Service::Response::Paths::Base

						# Caminho referente ao caminho do número do lote
						def response_lot_number_path
							[:consultar_situacao_lote_rps_resposta, :numero_lote] 
						end
						
						# Caminho para encontrar o número do protocolo
						def response_situation_path
							[:consultar_situacao_lote_rps_resposta, :situacao] 
						end
						
						# def response_message_alerts_path; [] end
						def response_message_errors_path
							[:consultar_situacao_lote_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						end
						# def message_code_key;     :codigo   end
						# def message_msg_key;      :mensagem end
						# def message_solution_key; :correcao end						
					end
				end
			end
		end
	end
end