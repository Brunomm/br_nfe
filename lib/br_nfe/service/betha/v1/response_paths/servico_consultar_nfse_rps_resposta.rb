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

						def invoice_url_nf_path
							default_path_to_nf + [:outras_informacoes] 
						end
					end
				end
			end
		end
	end
end