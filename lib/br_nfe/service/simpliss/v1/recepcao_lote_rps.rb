module BrNfe
	module Service
		module Simpliss
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Simpliss::V1::Base
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps

					def certificado_obrigatorio?
						true
					end

					def method_wsdl
						:recepcionar_lote_rps
					end
					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'RecepcionarLoteRps'
					end

					def xml_builder
						render_xml 'servico_enviar_lote_rps_envio'
					end

					def response_path_module
						BrNfe::Service::Response::Paths::V1::ServicoEnviarLoteRpsResposta
					end

					def response_root_path
						[:recepcionar_lote_rps_response]
					end
				end
			end
		end
	end
end