module BrNfe
	module Service
		module Betha
			module V1
				module ResponsePaths
					module ServicoConsultarLoteRpsResposta
						include BrNfe::Service::Response::Paths::V1::ServicoConsultarLoteRpsResposta
						
						# Caminho referente ao caminho onde se encontra as notas fiscais
						# poderá encontrar apenas uma ou várias
						def invoices_path
							[:consultar_lote_rps_resposta, :lista_nfse, :compl_nfse]
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