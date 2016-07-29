module BrNfe
	module Service
		module Simpliss
			module V1
				module ResponsePaths
					module ServicoCancelarNfseResposta
						include BrNfe::Service::Response::Paths::Base
						
						# def message_alerts_path; [] end
						def message_errors_path
							[:cancelar_nfse_result, :lista_mensagem_retorno, :mensagem_retorno]
						end

						def cancelation_date_time_path
							[:cancelar_nfse_result, :cancelamento, :confirmacao, :data_hora_cancelamento]
						end
					end
				end
			end
		end
	end
end