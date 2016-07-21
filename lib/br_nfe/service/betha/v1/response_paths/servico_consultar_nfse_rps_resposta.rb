module BrNfe
	module Service
		module Betha
			module V1
				module ResponsePaths
					module ServicoConsultarNfseRpsResposta
						include BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseRpsResposta
						
						def invoices_path
							[:consultar_nfse_rps_resposta, :compl_nfse]
						end
					end
				end
			end
		end
	end
end