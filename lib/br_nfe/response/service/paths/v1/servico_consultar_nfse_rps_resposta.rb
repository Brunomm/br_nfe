module BrNfe
	module Service
		module Response
			module Paths
				module V1
					module ServicoConsultarNfseRpsResposta
						include BrNfe::Service::Response::Paths::Base
						include BrNfe::Service::Response::Paths::V1::TcNfse

						# def message_alerts_path; [] end
						def message_errors_path
							[:consultar_nfse_rps_resposta, :lista_mensagem_retorno, :mensagem_retorno]
						end

						# Caminho referente ao caminho onde se encontra as notas fiscais
						# poderá encontrar apenas uma ou várias
						def invoices_path
							[:consultar_nfse_rps_resposta, :comp_nfse]
						end
					end
				end
			end
		end
	end
end