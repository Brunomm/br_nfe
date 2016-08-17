module BrNfe
	module Service
		module Simpliss
			module V1
				module ResponsePaths
					module ServicoEnviarLoteRpsResposta
						include BrNfe::Service::Response::Paths::Base

						# Caminho referente ao caminho do número do lote
						def response_lot_number_path
							[:recepcionar_lote_rps_result, :numero_lote] 
						end
						
						# Caminho para encontrar o número do protocolo
						def response_protocol_path
							[:recepcionar_lote_rps_result, :protocolo] 
						end
						
						# Caminho para encontrar a data de recebimento do lote/rps/nfe
						def response_received_date_path
							[:recepcionar_lote_rps_result, :data_recebimento] 
						end

						# def response_message_alerts_path; [] end
						def response_message_errors_path
							[:recepcionar_lote_rps_result, :lista_mensagem_retorno, :mensagem_retorno]
						end
						# def response_message_code_key;     :codigo   end
						# def response_message_msg_key;      :mensagem end
						# def response_message_solution_key; :correcao end						
					end
				end
			end
		end
	end
end