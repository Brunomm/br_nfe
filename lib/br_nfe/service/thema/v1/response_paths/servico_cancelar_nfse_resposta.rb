module BrNfe
	module Service
		module Thema
			module V1
				module ResponsePaths
					module ServicoCancelarNfseResposta
						include BrNfe::Service::Response::Paths::V1::ServicoCancelarNfseResposta
						
						def response_cancelation_date_time_path
							[:cancelar_nfse_resposta, :cancelamento, :confirmacao, :data_hora_cancelamento]
						end
					end
				end
			end
		end
	end
end