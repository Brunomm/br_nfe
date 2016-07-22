module BrNfe
	module Service
		module SC
			module Gaspar
				class ConsultaNfse < BrNfe::Service::Thema::V1::ConsultaNfse

					# É sério. Tudo isso é obrigatório. Pfff
					validates :destinatario, :nfe_number, :start_date, :end_date, presence: true
					
					def wsdl
						"http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl"
					end
				end
			end
		end
	end
end