module BrNfe
	module Service
		module Simpliss
			module V1
				class ConsultaSituacaoLoteRps < BrNfe::Service::Simpliss::V1::ConsultaLoteRps
					include BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoConsultarSituacaoLoteRpsResposta

					def method_wsdl
						:consultar_situacao_lote_rps
					end

					def xml_builder
						render_xml 'servico_consultar_situacao_lote_rps_envio'
					end

					def response_root_path
						[:consultar_situacao_lote_rps_response]
					end

					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarSituacaoLoteRps'
					end
				end
			end
		end
	end
end