module BrNfe
	module Service
		module SC
			module Gaspar
				class CancelaNfse < BrNfe::Service::Thema::V1::CancelaNfse
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl"
					end
				end
			end
		end
	end
end