module BrNfe
	module Servico
		module Betha
			class Gateway < BrNfe::Servico::Base
				def wsdl
					'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/nfseWS?wsdl'
				end

				def namespaces
					{
						"xmlns:e" => "http://www.betha.com.br/e-nota-contribuinte-ws"
					}
				end

				def request
					@response = client_wsdl.call(method_wsdl, message: {
						nfse_cabec_msg: '<cabecalho xmlns="http://www.betha.com.br/e-nota-contribuinte-ws" versao="2.02"><versaoDados>2.02</versaoDados></cabecalho>',
						nfse_dados_msg: xml_builder
					})
				end

			end
		end
	end
end