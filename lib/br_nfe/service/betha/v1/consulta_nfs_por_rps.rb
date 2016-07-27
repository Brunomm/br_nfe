module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfsePorRps?wsdl"
					end

					def method_wsdl
						:consultar_nfse_por_rps_envio
					end

					def response_path_module
						BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseRpsResposta
					end

					def response_root_path
						[:consultar_nfse_rps_envio_response]
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_rps_envio'
					end

				end
			end
		end
	end
end