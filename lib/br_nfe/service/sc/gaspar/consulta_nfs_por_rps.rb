module BrNfe
	module Service
		module SC
			module Gaspar
				class ConsultaNfsPorRps < BrNfe::Service::Thema::V1::ConsultaNfsPorRps
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl"
					end
				end
			end
		end
	end
end