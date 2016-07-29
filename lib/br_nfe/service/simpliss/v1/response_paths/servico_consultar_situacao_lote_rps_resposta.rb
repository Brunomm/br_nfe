module BrNfe
	module Service
		module Simpliss
			module V1
				module ResponsePaths
					module ServicoConsultarSituacaoLoteRpsResposta
						include BrNfe::Service::Response::Paths::Base

						# Caminho referente ao caminho do número do lote
						def lot_number_path
							[:consultar_situacao_lote_rps_result, :numero_lote] 
						end
						
						# Caminho para encontrar o número do protocolo
						def situation_path
							[:consultar_situacao_lote_rps_result, :situacao] 
						end
						
						# def message_alerts_path; [] end
						def message_errors_path
							[:consultar_situacao_lote_rps_result, :lista_mensagem_retorno, :mensagem_retorno]
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