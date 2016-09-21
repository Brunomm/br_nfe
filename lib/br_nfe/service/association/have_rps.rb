module BrNfe
	module Service
		module Association
			module HaveRps
				def rps
					yield rps if block_given?
					@rps.is_a?(BrNfe.rps_class) ? @rps : @rps = BrNfe.rps_class.new
				end

				def rps=(value)
					if value.is_a?(BrNfe.rps_class) || value.nil? 
						@rps = value
					elsif value.is_a?(Hash)
						rps.assign_attributes(value)
					end
				end
				
			protected

				def validate_rps
					if rps.invalid?
						rps.errors.full_messages.map{|msg| errors.add(:rps, msg) }
					end
				end

				def valida_rps_recepcao
					rps.validar_recepcao_rps = true
					if rps.invalid?
						rps.errors.full_messages.map{|msg| errors.add(:base, "RPS: #{msg}") } 
					end
				end
				
			end
		end
	end
end