module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaSituacaoLoteRps < BrNfe::Service::Betha::V1::ConsultaLoteRps
					include BrNfe::Service::Response::Paths::V1::ServicoConsultarSituacaoLoteRpsResposta

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarSituacaoLoteRps?wsdl"
					end

					def method_wsdl
						:consultar_situacao_lote_rps_envio
					end
					
					def response_root_path
						[:consultar_situacao_lote_rps_envio_response]
					end

					def xml_builder
						render_xml 'servico_consultar_situacao_lote_rps_envio'
					end

				end
			end
		end
	end
end