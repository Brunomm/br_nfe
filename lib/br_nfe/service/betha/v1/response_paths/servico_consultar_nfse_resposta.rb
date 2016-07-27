module BrNfe
	module Service
		module Betha
			module V1
				module ResponsePaths
					module ServicoConsultarNfseResposta
						include BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseResposta
						
						def invoices_path
							[:consultar_nfse_resposta, :lista_nfse, :compl_nfse]
						end
					end
				end
			end
		end
	end
end