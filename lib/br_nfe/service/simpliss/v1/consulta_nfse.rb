module BrNfe
	module Service
		module Simpliss
			module V1
				class ConsultaNfse < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfse

					def method_wsdl
						:consultar_nfse
					end
					
					def xml_builder
						render_xml 'servico_consultar_nfse_envio'
					end

					def response_path_module
						BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoConsultarNfseResposta
					end
					
					def response_root_path
						[:consultar_nfse_response]
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarNfse'
					end
				end
			end
		end
	end
end