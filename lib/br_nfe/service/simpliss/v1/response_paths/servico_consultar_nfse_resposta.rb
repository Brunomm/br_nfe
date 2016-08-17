module BrNfe
	module Service
		module Simpliss
			module V1
				module ResponsePaths
					module ServicoConsultarNfseResposta
						include BrNfe::Service::Response::Paths::Base
						include BrNfe::Service::Response::Paths::V1::TcNfse

						# def message_alerts_path; [] end
						def response_message_errors_path
							[:consultar_nfse_result, :lista_mensagem_retorno, :mensagem_retorno]
						end

						# Caminho referente ao caminho onde se encontra as notas fiscais
						# poderá encontrar apenas uma ou várias
						def response_invoices_path
							[:consultar_nfse_result, :lista_nfse, :comp_nfse]
						end
					end
				end
			end
		end
	end
end