module BrNfe
	module Service
		module SC
			module Gaspar
				class RecepcaoLoteRps < BrNfe::Service::Thema::V1::RecepcaoLoteRps
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl"
					end					
				end
			end
		end
	end
end