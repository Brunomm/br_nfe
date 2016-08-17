module BrNfe
	module Service
		module Thema
			module V1
				module ResponsePaths
					module ServicoConsultarNfseRpsResposta
						include BrNfe::Service::Response::Paths::V1::ServicoConsultarNfseRpsResposta
						
						# Caminho referente ao caminho onde se encontra as notas fiscais
						# poderá encontrar apenas uma ou várias
						def response_invoices_path
							[:consultar_nfse_rps_resposta, :lista_nfse, :comp_nfse]
						end
					end
				end
			end
		end
	end
end