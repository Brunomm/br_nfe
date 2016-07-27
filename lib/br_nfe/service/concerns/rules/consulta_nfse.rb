module BrNfe
	module Service
		module Concerns
			module Rules
				module ConsultaNfse
					extend ActiveSupport::Concern

					included do
						include BrNfe::Helper::HaveDestinatario
						include BrNfe::Helper::HaveIntermediario
					
						attr_accessor :nfe_number
						attr_accessor :start_date
						attr_accessor :end_date

						def start_date
							value_date(@start_date)
						end
						
						def end_date
							value_date(@end_date)
						end
					end

				end
			end
		end
	end
end