module BrNfe
	module Service
		module Simpliss
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps

					def method_wsdl
						:consultar_nfse_por_rps
					end

					def response_path_module
						BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoConsultarNfseRpsResposta
					end

					def xml_builder
						render_xml 'servico_consultar_nfse_rps_envio'
					end

					def response_root_path
						[:consultar_nfse_por_rps_response]
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarNfsePorRps'
					end

				end
			end
		end
	end
end