module BrNfe
	module Service
		module Simpliss
			module V1
				class CancelaNfse < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::CancelamentoNfs

					def method_wsdl
						:cancelar_nfse
					end

					def response_path_module
						BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoCancelarNfseResposta
					end

					def xml_builder
						render_xml 'servico_cancelar_nfse_envio'
					end

					def response_root_path
						[:cancelar_nfse_response]
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'CancelarNfse'
					end
				end
			end
		end
	end
end