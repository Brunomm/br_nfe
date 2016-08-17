module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaLoteRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Service::Betha::V1::ResponsePaths::ServicoConsultarLoteRpsResposta

					attr_accessor :protocolo

					validates :protocolo, presence: true

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarLoteRps?wsdl"
					end

					def method_wsdl
						:consultar_lote_rps_envio
					end

					def response_root_path
						[:consultar_lote_rps_envio_response]
					end

					def xml_builder
						render_xml 'servico_consultar_lote_rps_envio'
					end
				end
			end
		end
	end
end