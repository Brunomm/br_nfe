module BrNfe
	module Service
		module Response
			module Paths
				module V1
					module ServicoCancelarNfseResposta
						include BrNfe::Service::Response::Paths::Base
						
						# def message_alerts_path; [] end
						def response_message_errors_path
							[:cancelar_nfse_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						end

						def response_cancelation_date_time_path
							[:cancelar_nfse_resposta, :cancelamento, :confirmacao, :inf_confirmacao_cancelamento, :data_hora]
						end
					end
				end
			end
		end
	end
end