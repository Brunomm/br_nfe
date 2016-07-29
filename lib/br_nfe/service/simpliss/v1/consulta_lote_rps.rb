module BrNfe
	module Service
		module Simpliss
			module V1
				class ConsultaLoteRps < BrNfe::Service::Simpliss::V1::Base

					attr_accessor :protocolo
					validates :protocolo, presence: true

					def method_wsdl
						:consultar_lote_rps
					end

					def xml_builder
						render_xml 'servico_consultar_lote_rps_envio'
					end

					def response_path_module
						BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoConsultarLoteRpsResposta
					end
					
					def response_root_path
						[:consultar_lote_rps_response]
					end

					def nfse_xml_path
						#//Envelope/Body/ConsultarLoteRpsResponse/ConsultarLoteRpsResult/ListaNfse/CompNfse/Nfse
						'//*/*/*/*/*/*/*'
					end

					
					# Tag root da requisição
					#
					def soap_body_root_tag
						'ConsultarLoteRps'
					end
				end
			end
		end
	end
end