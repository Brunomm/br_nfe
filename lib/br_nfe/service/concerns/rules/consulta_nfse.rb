module BrNfe
	module Service
		module Concerns
			module Rules
				module ConsultaNfse
					extend ActiveSupport::Concern

					included do
						include BrNfe::Association::HaveDestinatario
						include BrNfe::Service::Association::HaveIntermediario
					
						attr_accessor :nfe_number
						attr_accessor :start_date
						attr_accessor :end_date

						def start_date
							value_date(@start_date)
						end
						
						def end_date
							value_date(@end_date)
						end
						def destinatario_class
							BrNfe.destinatario_service_class
						end
					end

				end
			end
		end
	end
end