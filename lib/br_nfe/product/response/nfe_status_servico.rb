module BrNfe
	module Product
		module Response
			class NfeStatusServico < Base

				attr_accessor :uf
				alias_attribute :cUF, :uf

				attr_accessor :average_time
				alias_attribute :tMed, :average_time

				attr_accessor :observation
				alias_attribute :xObs, :observation

				attr_accessor :return_prevision
				alias_attribute :dhRetorno, :return_prevision
				def return_prevision
					convert_to_time(@return_prevision)
				end

				def status
					if processing_status_code == '107'
						:online
					else
						:offline
					end
				end
			end
		end
	end
end