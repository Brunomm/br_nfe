module BrNfe
	module Service
		module SC
			module Gaspar
				class ConsultaSituacaoLoteDfs < BrNfe::Service::SC::Gaspar::Base

					attr_accessor :protocolo

					validates :protocolo, presence: true

					def wsdl
						"http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl"
					end

					def method_wsdl
						:consultar_lote_rps
					end

					def xml_builder
						render_xml 'servico_consultar_situacao_lote_rps_envio'
					end
				end
			end
		end
	end
end