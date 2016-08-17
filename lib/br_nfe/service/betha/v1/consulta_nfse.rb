module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaNfse < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::ConsultaNfse
					include BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarNfseResposta
					
					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfse?wsdl"
					end

					def method_wsdl
						:consultar_nfse_envio
					end
					
					def response_root_path
						[:consultar_nfse_envio_response]
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_envio'
					end

				end
			end
		end
	end
end