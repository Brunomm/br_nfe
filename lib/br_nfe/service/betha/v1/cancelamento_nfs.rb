module BrNfe
	module Service
		module Betha
			module V1
				class CancelamentoNfs < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs

					def certificado_obrigatorio?
						true
					end

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/cancelarNfseV02?wsdl"
					end
					
					def method_wsdl
						:cancelar_nfse_envio
					end

					def response_path_module
						BrNfe::Service::Response::Paths::V1::ServicoCancelarNfseResposta
					end

					def response_root_path
						[:cancelar_nfse_envio_response]
					end

					def id_attribute?
						false
					end

					def xml_builder
						render_xml 'servico_cancelar_nfse_envio'
					end					
				end
			end
		end
	end
end