module BrNfe
	module Service
		module SC
			module Gaspar
				class ConsultaLoteRps < BrNfe::Service::Thema::V1::ConsultaLoteRps
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl"
					end
				end
			end
		end
	end
end