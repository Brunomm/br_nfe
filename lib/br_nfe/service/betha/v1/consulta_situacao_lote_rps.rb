module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaSituacaoLoteRps < BrNfe::Service::Betha::V1::ConsultaLoteRps

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarSituacaoLoteRps?wsdl"
					end

					def method_wsdl
						:consultar_situacao_lote_rps
					end
				end
			end
		end
	end
end