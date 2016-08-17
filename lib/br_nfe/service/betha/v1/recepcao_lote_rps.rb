module BrNfe
	module Service
		module Betha
			module V1
				class RecepcaoLoteRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
					include BrNfe::Service::Response::Paths::V1::ServicoEnviarLoteRpsResposta
					
					def certificado_obrigatorio?
						true
					end

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/recepcionarLoteRps?wsdl"
					end
					def method_wsdl
						:enviar_lote_rps_envio
					end

					def response_root_path
						[:enviar_lote_rps_envio_response]
					end

					def id_attribute?
						false
					end

					def xml_builder
						render_xml 'servico_enviar_lote_rps_envio'
					end
				end
			end
		end
	end
end